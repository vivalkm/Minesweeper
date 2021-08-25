class Tile
    BACK_VAL = :□
    FLAG_VAL = :⚑
    BOMB_VAL = :❂
    NON_BOMB_VAL = :_

    attr_reader :is_bomb, :face_up

    def initialize(is_bomb)
        @face_up = false
        @flagged = false
        @is_bomb = is_bomb
        @value = @is_bomb ? BOMB_VAL : NON_BOMB_VAL
    end

    def reveal()
        @face_up = true
        return @is_bomb
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
end