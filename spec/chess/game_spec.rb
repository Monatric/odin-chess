# frozen_string_literal: true

describe Chess::Game do
  let(:player_one) { instance_double(Player, color: :white) }
  let(:player_two) { instance_double(Player, color: :black) }
  let(:chessboard) { instance_double(Chess::Chessboard) }
  let(:repetition_tracker) { instance_double(Chess::ThreefoldRepetitionTracker) }
  let(:fen) { instance_double(Chess::FEN) }
  subject(:game) { described_class.new(player_white: player_one, player_black: player_two) }

  describe '::load' do
    context 'when the program wants to load the saved game' do
      let(:saved_game) { double('saved_game.yml') }
      let(:hash_data) do
        { player_white: player_one,
          player_black: player_two,
          fen: 'fen_string',
          repetition_tracker: repetition_tracker }
      end
      let(:saved_chessboard) { double('chessboard') }

      before do
        allow(YAML).to receive(:load_file).and_return(saved_game)
        allow(Chess::Game).to receive(:saved_game_data_to_hash).with(saved_game).and_return(hash_data)
        allow(Chess::Chessboard).to receive(:from_fen).with(hash_data[:fen]).and_return(saved_chessboard)
        allow(Chess::Game).to receive(:new)
      end

      it 'returns attributes required to initialize a game' do
        data_player_white = hash_data[:player_white]
        data_player_black = hash_data[:player_black]
        data_fen = hash_data[:fen]
        data_repetition_tracker = hash_data[:repetition_tracker]

        Chess::Game.load
        expect(YAML).to have_received(:load_file).with('saved_game.yml',
                                                       permitted_classes: [Player, Chess::FEN, Symbol])
        expect(Chess::Chessboard).to have_received(:from_fen).with(hash_data[:fen])
        expect(Chess::Game).to have_received(:saved_game_data_to_hash).with(saved_game)
        expect(Chess::Game).to have_received(:new).with(chessboard: saved_chessboard,
                                                        player_white: data_player_white,
                                                        player_black: data_player_black,
                                                        fen: data_fen,
                                                        repetition_tracker: data_repetition_tracker)
      end
    end
  end

  describe '#save_game' do
    context 'when the program tries to save the game' do
      let(:yaml_string) { '---' }
      let(:fen_string) { '---' }

      before do
        allow(game.fen).to receive(:notation).and_return(fen_string)
        allow(YAML).to receive(:dump).and_return(yaml_string)
        allow(File).to receive(:write)
      end

      it 'dumps data to YAML' do
        game.save_game
        expect(game.fen).to have_received(:notation)
        expect(YAML).to have_received(:dump).with(
          hash_including(
            player_white: player_one,
            player_black: player_two,
            fen: fen_string
          )
        )
      end
    end
  end

  describe '#update_fen' do
    let(:new_fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }
    let(:fen_spy) { instance_double(Chess::FEN) }

    before do
      allow(Chess::FEN).to receive(:new).and_return(fen_spy)
      allow(fen_spy).to receive(:notation).and_return(new_fen_string)
    end

    subject(:game_update_fen) { described_class.new }

    it 'sends generate_fen to fen' do
      expect(fen_spy).to receive(:generate_fen).and_return(new_fen_string)
      game_update_fen.update_fen
    end
  end

  describe '#move_piece' do
    context 'when moving a piece on the board' do
      let(:source) { double }
      let(:dest) { double }
      let(:piece) { double }
      let(:move_validator) { instance_double(Chess::MoveValidator) }

      before do
        allow(chessboard).to receive(:find_piece_by_coordinate).with(source).and_return(piece)
        allow(Chess::MoveValidator).to receive(:new).and_return(move_validator)
      end

      context 'when the move is castling' do
        before do
          allow(move_validator).to receive(:move_is_castling?).with(source, dest).and_return(true)
        end

        it 'should send #castle to piece' do
          expect(piece).to receive(:castle)
          game.move_piece(source, dest, chessboard)
        end
      end

      context 'when the move is promotion' do
        before do
          allow(move_validator).to receive(:move_is_castling?).with(source, dest).and_return(false)
          allow(move_validator).to receive(:move_is_promotion?).with(piece, dest).and_return(true)
        end

        it 'should send #promotion to piece' do
          expect(piece).to receive(:promote)
          game.move_piece(source, dest, chessboard)
        end
      end

      context 'when the move is normal' do
        before do
          allow(move_validator).to receive(:move_is_castling?).with(source, dest).and_return(false)
          allow(move_validator).to receive(:move_is_promotion?).with(piece, dest).and_return(false)
        end

        it 'should send #promotion to piece' do
          expect(piece).to receive(:move)
          game.move_piece(source, dest, chessboard)
        end
      end
    end
  end

  describe '#switch_player!' do
    let(:player_one) { double('Player white') }
    let(:player_two) { double('Player black') }

    subject(:game_switch_turn) do
      described_class.new(player_white: player_one, player_black: player_two, fen: fen)
    end

    before do
      allow(Chess::FEN).to receive(:new).and_return(fen)
    end

    context 'when the player is white' do
      let(:fen_active_color) { 'w' }

      before do
        allow(fen).to receive(:notation).and_return(fen_active_color)
        allow(game_switch_turn).to receive(:current_turn).and_return(player_one)
        allow(player_one).to receive(:color)
      end

      it 'switches the player to black' do
        player = game_switch_turn.switch_player!
        expect(player).to eq player_two
      end
    end

    context 'when the player is black' do
      let(:fen_active_color) { 'b' }

      before do
        allow(fen).to receive(:notation).and_return(fen_active_color)
        allow(game_switch_turn).to receive(:current_turn).and_return(player_two)
        allow(player_two).to receive(:color)
      end

      it 'switches the player to black' do
        player = game_switch_turn.switch_player!
        expect(player).to eq player_one
      end
    end
  end

  describe '#current_turn_color' do
    let(:player_one) { double('player one', color: :white) }
    let(:player_two) { double('player_two', color: :black) }

    context 'when the current turn is white' do
      let(:fen_white) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
      subject(:game_player_color) do
        described_class.new(player_white: player_one, player_black: player_two, fen: fen_white)
      end

      it 'returns :white' do
        color = game_player_color.current_turn_color
        expect(color).to eq :white
      end
    end

    context 'when the current turn is black' do
      let(:fen_black) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ b KQkq - 0 1' }
      subject(:game_player_color) do
        described_class.new(player_white: player_one, player_black: player_two, fen: fen_black)
      end

      it 'returns :black' do
        color = game_player_color.current_turn_color
        expect(color).to eq :black
      end
    end
  end

  describe '#other_turn_color' do
    context 'when the current turn is white' do
      let(:fen_white) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ w KQkq - 0 1' }
      subject(:game_player_color) do
        described_class.new(player_white: player_one, player_black: player_two, fen: fen_white)
      end

      it 'returns :black' do
        color = game_player_color.other_turn_color
        expect(color).to eq :black
      end
    end

    context 'when the current turn is black' do
      let(:fen_black) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/ b KQkq - 0 1' }
      subject(:game_player_color) do
        described_class.new(player_white: player_one, player_black: player_two, fen: fen_black)
      end

      it 'returns :white' do
        color = game_player_color.other_turn_color
        expect(color).to eq :white
      end
    end
  end

  # NOTE: new methods added that are not tested: status, game_over?, and draw_by_fifty_moves?
end
