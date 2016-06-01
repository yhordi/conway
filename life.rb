# Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by over-population.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

print "\e[H\e[2J"

class Cell
  def initialize(alive)
    @alive = alive
  end

  def alive?
    @alive == true
  end

  def tick(neighbors)
    if neighbors < 2
      self.die!
    elsif neighbors > 3
      self.die!
    elsif !self.alive? && neighbors == 3
      self.live!
    end
  end

  def live!
    @alive = true
  end

  def die!
    @alive = false
  end
end

class Game
  attr_reader :board
  def initialize(options)
    @size = options[:size]
    @board = []
    build_board
  end

  def make_life
    @board[3][4].live!
    @board[4][4].live!
    @board[5][4].live!
    @board[4][3].live!
    @board[4][5].live!
  end

  def next_generation
    @board.map do |array|
      x = @board.index(array)
      array.map do |cell|
        y = array.index(cell)
        cell.tick(neighbors_of(x, y))
      end
    end
  end

  def neighbors_of(x, y)
    neighbors = []
    i = x - 1
    j = y + 1
    counter = 1
    9.times do |cell|
      edge_check(i, j, neighbors)
      if counter % 3 == 0
        j -= 1
        i = x - 1
      else
        i += 1
      end
      counter += 1
    end
    neighbors.delete_if{ |cell| cell == self.board[x][y]}
    living_neighbors(neighbors)
  end

  private

  def living_neighbors(neighbors)
    neighbors.delete_if { |cell| !cell.alive? }
    neighbors.length
  end

  def edge_check(x, y, neighbors)
    if edge?(x)
      x = wrap!(x)
    end
    if edge?(y)
      y = wrap!(y)
    end
    neighbors << self.board[x][y]
  end

  def wrap!(coordinate)
    return 0 if coordinate > 8
    return 8 if coordinate < 0
  end

  def edge?(coordinate)
    return true if coordinate > 8
    return true if coordinate < 0
  end

  def build_board
    @size.times do
      @board << Array.new(@size) { Cell.new(false) }
    end
    @board
  end

  def neighbors_loop(x, y, neighbors)

  end
end

