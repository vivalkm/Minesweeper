require_relative "tile"

class Board
    def initialize(size, mode)
        @size = size
        @grid = Array.new(size) { Array.new(size) }
        @hit_bomb = false
        
        # Set the number of bombs based on mode
        case mode
        when 'easy'
            @bomb_count = [@size * @size / 10, 1].max
        when 'medium'
            @bomb_count = [@size * @size / 6, 1].max
        when 'hard'
            @bomb_count = [@size * @size / 3, 1].max
        end

        # tracker of unrevealed non-bomb tiles
        @remain = @size * @size - @bomb_count
        populate()
    end

    def populate()
        # Place bombs tiles randomly.
        bomb_pos_index = (0...@size * @size).to_a.sample(@bomb_count)
        bomb_pos = Set.new()
        bomb_pos_index.each { |i| bomb_pos << [i / @size, i % @size] }
        bomb_pos.each { |pos| @grid[pos[0]][pos[1]] = Tile.new(true) }
        
        # Update safe tile values based on bombs nearby.
        (0...@size).each do |row|
            (0...@size).each do |col|
                pos = [row, col]
                if !bomb_pos.include?(pos)
                    @grid[row][col] = Tile.new(false)
                    count = neighbor(pos).count { |tile| tile.is_bomb if tile != nil }
                    self[pos].reset_value(count)
                end
            end
        end
    end

    def render()
        (0...@size).each do |row|
            (0...@size).each do |col|
                pos = [row, col]
                self[pos].render()
            end
            puts
        end
    end

    def reveal(pos)
        if valid_pos?(pos)
            self[pos].reveal()
            @hit_bomb = true if self[pos].is_bomb
            @remain -= 1 if !@hit_bomb
        end
    end

    def reveal_all()
        (0...@size).each do |row|
            (0...@size).each do |col|
                pos = [row, col]
                reveal(pos)
            end
        end
    end

    def flag(pos)
        self[pos].flag()
    end

    def win?()
        @remain == 0
    end

    def lost?()
        @hit_bomb
    end

    def end?()
        win?() || lost?()
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end

    def neighbor(pos)
        neighbors = []
        up_pos =  [pos[0] - 1, pos[1]]
        neighbors << self[up_pos] if valid_pos?(up_pos)

        down_pos =  [pos[0] + 1, pos[1]]
        neighbors << self[down_pos] if valid_pos?(down_pos)

        left_pos =  [pos[0], pos[1] - 1]
        neighbors << self[left_pos] if valid_pos?(left_pos)

        right_pos =  [pos[0], pos[1] + 1]
        neighbors << self[right_pos] if valid_pos?(right_pos)

        return neighbors
    end

    def valid_pos?(pos)
        pos.all? { |i| (0...@size).include?(i) }
    end
end

if __FILE__ == $PROGRAM_NAME
    b = Board.new(9)
end