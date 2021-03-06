class Cell
  attr_reader :death, :birth
  def initialize(alive)
    @alive = alive
    @death = false
    @birth = false
  end

  def death!
    @death = true
  end

  def birth!
    @birth = true
  end

  def reset
    @birth = false
    @death = false
  end

  def alive?
    @alive == true
  end

  def tick(neighbors)
    if neighbors < 2 && self.alive?
      self.death!
    elsif neighbors > 3
      self.death!
    elsif !self.alive? && neighbors == 3
      self.birth!
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
        cell.tick(living_neighbors(neighbors_of(x, y)))
      end
    end
    build
  end

  def build
    @board.map do |array|
      array.map do |cell|
        cycle(cell)
      end
    end
    @board
  end

  def neighbors_of(x, y)
    neighbors = []
    i = x - 1
    j = y + 1
    decrement_y_axis(i, j, x, neighbors)
    neighbors.delete_if{ |cell| cell == self.board[x][y]}
  end


  def print_board
    print "\e[H\e[2J"
    @board.each do |array|
      puts
      array.each do |cell|
        if cell.alive?
          print "o"
        else
          print "."
        end
      end
    end
  end


  private

  def cycle(cell)
    if cell.death
      cell.die!
    elsif cell.birth
      cell.live!
    end
    cell.reset
  end

  def decrement_y_axis(i, j, x, neighbors)
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
  end

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

end

