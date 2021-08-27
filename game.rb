require_relative "board"
require 'set'
require "byebug"

class Game
    def initialize()
        @board = Board.new(get_size, get_mode)  
    end

    def get_size()
        range = (5..20).to_a
        puts "Please choose a number between 5 to 20 for the game size."
        size = gets.chomp.to_i
        while size < range[0] || size > range[-1]
            puts "Size out of range. Please enter a size between 5 and 20."
            size = gets.chomp.to_i
        end
        size
    end

    def get_mode()
        modes = ['easy', 'medium', 'hard']
        options = Set.new()
        modes.each { |mode| options << mode }
        puts "Please choose a mode from #{modes}"
        mode = gets.chomp
        while !options.include?(mode)
            puts "Not a valid mode. Please choose one from the given options: #{modes}"
            mode = gets.chomp
        end
        mode
    end

    def play()
        @board.render
        action = get_action()
        pos = get_pos(action)

    end

    def get_action()
        actions = ["reveal", "flag"]
        puts "What do you want to do? #{actions}"
        action = gets.chomp
        while !actions.include?(action)
            puts "Not a valid action. Please choose one from the given actions: #{actions}"
            action = gets.chomp
        end
        action
    end

    def get_pos(action)
        pos = nil
        first_time = true
        until pos && pos.length == 2 && @board.valid_pos?(pos)
            if first_time
                puts "Which tile do you want to #{action}? (e.g., '3,4')"
            else
                puts "Invalid position. Which tile do you want to #{action}? (e.g., '3,4')"
            end
            print "> "
            begin
                pos = parse_pos(gets.chomp)
                first_time = false
            rescue
                first_time = false
            end
        end
        pos
    end

    def parse_pos(string)
        string.split(",").map { |char| Integer(char) }
    end

    def run()
        while !@board.end?()
            play()
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new()
    g.run
end