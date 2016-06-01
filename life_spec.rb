require_relative('life')

describe Game do
  let(:game) { game = Game.new({size: 9}) }
  it "has a board size that dictates the number of nested arrays within" do
    expect(game.board.length).to eq(9)
  end
  describe '#make_life' do
    it 'changes the center cell life state to true' do
      game.make_life
      expect(game.board[4][5]).to be_alive
    end
  end
  describe '#neighbors_of' do
    it 'returns an array of 8 neighboring cells' do
      expect(game.neighbors_of(4, 5).length).to eq(8)
    end
    it 'does not include the original cell' do
      expect(game.neighbors_of(4, 5)).to_not include(game.board[4][5])
    end
    it 'checks edges on the opposite side of the board if the current cell is on the top right of the board' do
      expect(game.neighbors_of(8, 8)).to include(game.board[0][0])
    end
     it 'checks edges on the opposite side of the board if the current cell is on the top left of the board' do
      expect(game.neighbors_of(0, 0)).to include(game.board[8][8])
    end
  end
  describe '#next_generation' do
    before(:each) do
      game.make_life
      game.next_generation
    end
    it 'evolves the board throughout one tick per cell' do
      expect(game.board[4][3]).to be_alive
    end
    it 'will kill cells with too many neighbors' do
      expect(game.board[4][4].alive?).to be(false)
    end
    it 'brings dead cells to life with 3 live neighbors' do
      expect(game.board[3][5]).to be_alive
    end
  end
  describe '#print_board' do
    it 'displays the board visually' do
      game.make_life
      game.next_generation
      expect{game.print_board}.to output{"...o.o..."}.to_stdout
    end
  end
  describe '#build' do
    it 'assembles a board for the new generation' do
      game.make_life
      cell = game.board[4][4]
      game.next_generation
      expect(game.board[4][4]).to_not be_alive
    end
  end
end

describe Cell do
  describe '#tick' do
    let(:living_cell) { Cell.new(true) }
    let(:dead_cell) { Cell.new(false) }
    it 'sets cell death to true if cell neighbors are fewer than 2' do
      living_cell.tick(1)
      expect(living_cell.death).to eq(true)
    end
    it 'sets cell death to true if cell neighbors are greater than 3' do
      living_cell.tick(4)
      expect(living_cell.death).to eq(true)
    end
    it 'will continue to live if with two or three neighbors' do
      living_cell.tick(2)
      expect(living_cell.alive?).to eq(true)
    end
    it 'sets cell birth to true if cell has exactly 3 neighbors' do
      dead_cell.tick(3)
      expect(dead_cell.birth).to eq(true)
    end
  end
end
