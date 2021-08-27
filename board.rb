require_relative "tile"

class Board
    def initialize(size, mode)
        @size = size
        @grid = Array.new(size) { Array.new(size) }
        @hit_bomb = false
        @visited = Set.new()
        
        # Set the number of bombs based on mode
        total_tiles = @size * @size
        easy_bombs = total_tiles / 10
        medium_bombs = total_tiles / 6
        hard_bombs = total_tiles / 3
        min_mine = 1
        case mode
        when 'easy'
            @bomb_count = [easy_bombs, min_mine].max
        when 'medium'
            @bomb_count = [medium_bombs, min_mine].max
        when 'hard'
            @bomb_count = [hard_bombs, min_mine].max
        end

        # tracker of unrevealed non-bomb tiles
        @remain = total_tiles - @bomb_count
        populate()
    end

    def populate()
        # Place bombs tiles randomly.
        bomb_pos_index = (0...@size * @size).to_a.sample(@bomb_count)
        bomb_pos = Set.new()
        bomb_pos_index.each { |i| bomb_pos << [i / @size, i % @size] }
        bomb_pos.each { |pos| @grid[pos[0]][pos[1]] = Tile.new(true, bomb_pos) }
        
        # Update safe tile values based on bombs nearby.
        (0...@size).each do |row|
            (0...@size).each do |col|
                pos = [row, col]
                if !bomb_pos.include?(pos)
                    @grid[row][col] = Tile.new(false, pos)
                    count = neighbor(pos).count { |tile| tile.is_bomb if tile != nil }
                    self[pos].set_value(count)
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
        if valid_pos?(pos) && !@visited.include?(self[pos])
            self[pos].reveal()
            @visited << self[pos]
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

        up_left_pos =  [pos[0] - 1, pos[1] - 1]
        neighbors << self[up_left_pos] if valid_pos?(up_left_pos)

        down_left_pos =  [pos[0] + 1, pos[1] - 1]
        neighbors << self[down_left_pos] if valid_pos?(down_left_pos)

        up_right_pos =  [pos[0] - 1, pos[1] + 1]
        neighbors << self[up_right_pos] if valid_pos?(up_right_pos)

        down_right_pos =  [pos[0] + 1, pos[1] + 1]
        neighbors << self[down_right_pos] if valid_pos?(down_right_pos)

        return neighbors
    end

    def reveal_safe_neighbors(pos)
        bfs_queue = []
        bfs_queue << self[pos]
        while bfs_queue.length > 0
            tile = bfs_queue.shift
            if !tile.is_bomb
                reveal(tile.pos)
                if tile.value == 0
                    bfs_queue += neighbor(tile.pos).reject { |tile| @visited.include?(tile) }
                end
            end
            @visited << tile
        end
    end
                
    def valid_pos?(pos)
        pos.all? { |i| (0...@size).include?(i) }
    end
end

if __FILE__ == $PROGRAM_NAME
    b = Board.new(9)
end