# frozen_string_literal: true

describe Convertable do
  let(:dummy_class) { Class.new { include Convertable } }
  subject(:converter) { dummy_class.new }

  describe '#notation_to_piece' do
    context 'when a notation is passed for conversion' do
      piece_notations = {
        'r' => [Chess::Rook, :black],
        'n' => [Chess::Knight, :black],
        'b' => [Chess::Bishop, :black],
        'q' => [Chess::Queen, :black],
        'k' => [Chess::King, :black],
        'p' => [Chess::Pawn, :black],
        'R' => [Chess::Rook, :white],
        'N' => [Chess::Knight, :white],
        'B' => [Chess::Bishop, :white],
        'Q' => [Chess::Queen, :white],
        'K' => [Chess::King, :white],
        'P' => [Chess::Pawn, :white]
      }

      piece_notations.each do |notation, expected_object|
        expected_piece = expected_object[0]
        expected_color = expected_object[1]
        filtered_piece_name = expected_piece.to_s.split('::')[1]
        it "returns a #{expected_color} #{filtered_piece_name} for #{notation}" do
          piece = converter.notation_to_piece(notation)
          expect(piece).to be_a(expected_piece)
          expect(piece.color).to eq(expected_color)
        end
      end

      it 'returns nil for invalid notations' do
        nonexistent_piece = converter.notation_to_piece('x')
        expect(nonexistent_piece).to be nil
      end
    end
  end

  describe '#coordinate_string_to_symbol' do
    context 'when the offsets are positive' do
      context 'when a coordinate :e2 is passed with 0 file offset, 2 rank offsets' do
        it 'returns :e4' do
          coordinate = :e2
          rank_offset = 2
          expect(converter.coordinate_string_to_symbol(coordinate, rank_offset: rank_offset)).to eq :e4
        end
      end

      context 'when a coordinate :b5 is passed with 3 file offsets, 0 rank offset' do
        it 'returns :e5' do
          coordinate = :b5
          file_offset = 3
          expect(converter.coordinate_string_to_symbol(coordinate, file_offset: file_offset)).to eq :e5
        end
      end

      context 'when a coordinate :f1 is passed with 1 file offset, 5 rank offsets' do
        it 'returns :g6' do
          coordinate = :f1
          file_offset = 1
          rank_offset = 5
          expect(converter.coordinate_string_to_symbol(coordinate,
                                                       file_offset: file_offset,
                                                       rank_offset: rank_offset)).to eq :g6
        end
      end
    end

    context 'when offsets are negative' do
      context 'when a coordinate :e4 is passed with 0 file offset, -2 rank offset' do
        it 'returns :e2' do
          coordinate = :e4
          rank_offset = -2
          expect(converter.coordinate_string_to_symbol(coordinate, rank_offset: rank_offset)).to eq :e2
        end
      end

      context 'when a coordinate :e5 is passed with -3 file offset, 0 rank offset' do
        it 'returns :b5' do
          coordinate = :e5
          file_offset = -3
          expect(converter.coordinate_string_to_symbol(coordinate, file_offset: file_offset)).to eq :b5
        end
      end

      context 'when a coordinate :g6 is passed with -1 file offset, -5 rank offset' do
        it 'returns :f1' do
          coordinate = :g6
          file_offset = -1
          rank_offset = -5
          expect(converter.coordinate_string_to_symbol(coordinate,
                                                       file_offset: file_offset,
                                                       rank_offset: rank_offset)).to eq :f1
        end
      end
    end
  end
end
