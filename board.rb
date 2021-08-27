require_relative "tile"

class Board
    def initialize(size)
        @size = size
        @grid = Array.new(size) { Array.new(size) }
        @bomb_count = size
        @non_bomb_count = size * (size - 1)
        @lost = false
        populate()
        self.render()
    end

    def populate
        tile_values = [true] * @bomb_count + [false] * @non_bomb_count
        tile_values.shuffle!
        i = 0
        (0...@size).each do |row|
            (0...@size).each do |col|
                @grid[row][col] = Tile.new(tile_values[i])
                i += 1
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
        @lost = self[pos].reveal ? true : false
        render
    end

    def flag(pos)
        self[pos].flag
        render
    end

    def win?()

    end

    def lost?()
        @lost
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end

    def neighbor(pos)
        neighbors = []
        up_pos =  [pos[0] - 1, pos[1]]
        neighbors << self[up_pos] if valid?(up_pos)

        down_pos =  [pos[0] + 1, pos[1]]
        neighbors << self[down_pos] if valid?(down_pos)

        left_pos =  [pos[0], pos[1] - 1]
        neighbors << self[left_pos] if valid?(left_pos)

        right_pos =  [pos[0], pos[1] + 1]
        neighbors << self[right_pos] if valid?(right_pos)

        return neighbors
    end

    def valid?(pos)
        pos.all? { |i| (0...@size).include?(i) }
    end
end

if __FILE__ == $PROGRAM_NAME
    b = Board.new(9)
end