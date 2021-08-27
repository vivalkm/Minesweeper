require_relative "board"
require 'set'
require "byebug"

class Game
    def initialize()
        @board = Board.new(get_size, get_mode)  
    end

    def get_size
        range = (5..20).to_a
        puts "Please choose a number between 5 to 20 for the game size."
        size = gets.chomp.to_i
        while size < range[0] || size > range[-1]
            puts "Size out of range. Please enter a size between 5 and 20."
            size = gets.chomp.to_i
        end
        size
    end

    def get_mode
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
end

if __FILE__ == $PROGRAM_NAME
    g = Game.new()
end