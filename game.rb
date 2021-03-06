require_relative "board"
require "set"
require "yaml"

class Game
    ACTIONS = {"r" => "reveal", "f" => "flag", "s" => "save"}
    @@modes = ['easy', 'medium', 'hard']

    def initialize()
        @options = Set.new()
        @@modes.each { |mode| @options << mode }
        @board = Board.new(get_size, get_mode)
    end

    def get_size()
        range = (2..20).to_a
        puts "Please choose a number between 5 to 20 for the game size."
        print "> "
        size = gets.chomp.to_i
        while size < range[0] || size > range[-1]
            puts "Size out of range. Please enter a size between 5 and 20."
            print "> "
            size = gets.chomp.to_i
        end
        size
    end

    def get_mode()
        puts "Please choose a mode from #{@@modes}"
        print "> "
        mode = gets.chomp
        while !@options.include?(mode)
            puts "Not a valid mode. Please choose one from the given options: #{@@modes}"
            print "> "
            mode = gets.chomp
        end
        mode
    end

    def play()
        system("clear")
        @board.render
        action = get_action()
        pos = get_pos(action) if action != "s"
        case action
        when "r"
            @board.reveal(pos)
            @board.reveal_safe_neighbors(pos) if @board[pos].value == 0
        when "f"
            @board.flag(pos)
        when "s"
            save()
        end
    end

    def get_action()
        puts "What do you want to do? #{ACTIONS}"
        print "> "
        action = gets.chomp
        while !ACTIONS.include?(action)
            puts "Not a valid action. Please choose one from the given actions: #{ACTIONS}"
            print "> "
            action = gets.chomp
        end
        action
    end

    def get_pos(action)
        pos = nil
        first_time = true
        until pos && pos.length == 2 && @board.valid_pos?(pos)
            if first_time
                puts "Which tile do you want to #{ACTIONS[action]}? (e.g., '3,4')"
            else
                puts "Invalid position. Which tile do you want to #{ACTIONS[action]}? (e.g., '3,4')"
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

        @board.reveal_all()
        system("clear")
        @board.render()
        if @board.win?
            puts "\nCongratulations! You win!!"
        else
            puts "\nBOOOOOM! You lose!"
        end
    end

    def save()
        puts "Enter a filename to save:"
        print "> "
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
    end
end

if __FILE__ == $PROGRAM_NAME
    case ARGV.count
    when 0
        Game.new().run
    when 1
        YAML.load_file(ARGV.shift).run
    end
end