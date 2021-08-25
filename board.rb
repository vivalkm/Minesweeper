require_relative "tile"

class Board
    def initialize(size)
        @size = size
        @grid = Array.new(size) { Array.new(size) }
        populate()
        self.render()
    end

    def populate
        (0...@size).each do |row|
            (0...@size).each do |col|
                @grid[row][col] = Tile.new(:_)
            end
        end
    end

    def render
        (0...@size).each do |row|
            (0...@size).each do |col|
                @grid[row][col].render
            end
            puts
        end
    end

    def reveal(pos)
        self[pos].reveal
        render
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end
end

if __FILE__ == $PROGRAM_NAME
    b = Board.new(9)
end