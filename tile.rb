class Tile
    def initialize(value)
        @face_up = false
        @value = value
        @back_value = :□
    end

    def reveal()
        @face_up = true
    end

    def render()
        if @face_up == true
            print @value
        else
            print @back_value
        end
        print " "
    end
end