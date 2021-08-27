class Tile
    BACK_VAL = :□
    FLAG_VAL = :⚑
    BOMB_VAL = :❂

    attr_reader :is_bomb, :face_up

    def initialize(is_bomb)
        @face_up = false
        @flagged = false
        @is_bomb = is_bomb
        @value = BOMB_VAL if @is_bomb
    end

    def reveal()
        @face_up = true
    end

    def flag()
        @flagged = !@flagged if !@face_up
    end

    def render()
        if @face_up
            print @value
        elsif @flagged
            print FLAG_VAL
        else
            print BACK_VAL
        end
        print " "
    end

    def reset_value(val)
        @value = val
    end
end