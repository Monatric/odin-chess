# frozen_string_literal: true

describe Chess::Game do
  let(:player_one) { instance_double(Player, color: :white) }
  let(:player_two) { instance_double(Player, color: :black) }
  let(:chessboard) { instance_double(Chess::Chessboard) }
  let(:fen) { instance_double(Chess::FEN) }
  subject(:game) { described_class.new(player_white: player_one, player_black: player_two, current_turn: player_one) }

  describe '#save_game' do
    # seems there's no need to test as it is well tested
  end

  describe '#update_fen' do
    context 'when updating the string of FEN' do
      let(:new_fen_string) { 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1' }

      subject(:game_update_fen) do
        described_class.new(chessboard: chessboard,
                            player_white: player_one,
                            player_black: player_two,
                            current_turn: player_one,
                            fen: new_fen_string)
      end
      before do
        allow(Chess::FEN).to receive(:new).and_return(fen)
      end

      it 'sends generate_fen to fen' do
        expect(fen).to receive(:generate_fen).and_return(new_fen_string)
        game_update_fen.update_fen
      end
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

    context 'when the player is white' do
      subject(:game_switch_turn) do
        described_class.new(player_white: player_one, player_black: player_two, current_turn: player_one, fen: fen)
      end

      before do
        allow(player_one).to receive(:color)
      end

      it 'switches the player to black' do
        player = game_switch_turn.switch_player!
        expect(player).to eq player_two
      end
    end

    context 'when the player is black' do
      subject(:game_switch_turn) do
        described_class.new(player_white: player_one, player_black: player_two, current_turn: player_two, fen: fen)
      end

      before do
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
      subject(:game_player_color) { described_class.new(current_turn: player_one) }

      it 'returns :white' do
        color = game_player_color.current_turn_color
        expect(color).to eq :white
      end
    end

    context 'when the current turn is black' do
      subject(:game_player_color) { described_class.new(current_turn: player_two) }

      it 'returns :black' do
        color = game_player_color.current_turn_color
        expect(color).to eq :black
      end
    end
  end

  describe '#other_turn_color' do
    context 'when the current turn is white' do
      it 'returns :black' do
        color = game.other_turn_color
        expect(color).to eq :black
      end
    end

    context 'when the current turn is black' do
      subject(:game) do
        described_class.new(player_white: player_one, player_black: player_two, current_turn: player_two)
      end

      it 'returns :white' do
        color = game.other_turn_color
        expect(color).to eq :white
      end
    end
  end
end
