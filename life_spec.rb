require_relative('life')
# Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by over-population.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

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
  end
end

describe Cell do
  describe '#tick' do
    let(:living_cell) { Cell.new(true) }
    let(:dead_cell) { Cell.new(false) }
    it 'kills cell if neighbors are fewer than 2' do
      living_cell.tick(1)
      expect(living_cell.alive?).to eq(false)
    end
    it 'kills cell if neighbors are greater than 3' do
      living_cell.tick(4)
      expect(living_cell.alive?).to eq(false)
    end
    it 'will continue to live if with two or three neighbors' do
      living_cell.tick(2)
      expect(living_cell.alive?).to eq(true)
    end
    it 'will bring a dead cell to life with exactly three neighbors' do
      dead_cell.tick(3)
      expect(dead_cell.alive?).to eq(true)
    end
  end
end
