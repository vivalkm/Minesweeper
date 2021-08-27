require "colorize"

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
        @flagged = false
        @face_up = true
    end

    def flag()
        @flagged = !@flagged if !@face_up
    end

    def render()
        if @face_up
            if @value == :❂
                print @value.to_s.colorize(:red)
            elsif @value == 0
                print @value
            elsif @value == 1
                print @value.to_s.colorize(:green)
            elsif @value == 2
                print @value.to_s.colorize(:yellow)
            elsif @value == 3
                print @value.to_s.colorize(:light_blue)
            elsif @value >= 4
                print @value.to_s.colorize(:magenta)
            end
        elsif @flagged
            print FLAG_VAL.to_s.colorize(:red)
        else
            print BACK_VAL
        end
        print " "
    end

    def reset_value(val)
        @value = val
    end
end