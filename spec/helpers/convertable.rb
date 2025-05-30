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
end
