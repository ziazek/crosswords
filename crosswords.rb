#!/usr/bin/env ruby

require 'pry-byebug'

$grid = []

class Square
  attr_accessor :x, :y

  def initialize(x: x_pos, y: y_pos)
    @x = x 
    @y = y
  end

  def render_line_0
    str = "#####"
    str += "#" if is_right_edge?
    print str
  end

  def render_line_1
    str =  "#    "
    str += "#" if is_right_edge?
    print str
  end

  def render_line_2
    str =  "#    "
    str += "#" if is_right_edge?
    print str
  end

  def render_line_3
    str = "#####"
    str += "#" if is_right_edge?
    print str
  end

  def is_right_edge?
    # binding.pry
    ($grid[y].length - 1) == self.x
  end

  def is_upper_edge?
    self.y == 0
  end

  def is_left_edge?
    self.x == 0
  end

  def left_neighbour?
    new_x = self.x - 1 
    return false unless (0..($grid[y].length - 1)) === new_x
    return $grid[y][new_x].instance_of? LetterSquare
  end

  def connected_to_edge?
    
  end
end

class LetterSquare < Square 

end

class FilledSquare < Square

  def render_line_0
    str = "#####"
    str = "     " if is_upper_edge?
    str[0] = "#" if left_neighbour?
    str += " " if is_right_edge?
    print str
  end

  def render_line_1
    str = is_left_edge? ? "     " : "#    "
    str += " " if is_right_edge?
    print str
  end

  def render_line_2
    str = is_left_edge? ? "     " : "#    "
    str += " " if is_right_edge?
    print str
  end

  def render_line_3
    str = is_left_edge? ? "     " : "#    "
    str += "" if is_right_edge?
    print str
  end
end

class Crossword
  attr_accessor :curr_line, :curr_char
  def initialize
    @curr_line = 0
    @curr_char = 0
  end

  def build_square(char)
    $grid[self.curr_line] ||= []
    if char == "_"
      $grid[self.curr_line] << LetterSquare.new(x: self.curr_char, y: self.curr_line )
    else 
      $grid[self.curr_line] << FilledSquare.new(x: self.curr_char, y: self.curr_line )
    end
    self.curr_char += 1
  end

  def incr_line
    self.curr_line += 1
    self.curr_char = 0
  end

  def render
    $grid[0...-1].each do |line|
      3.times do |n|
        line.each do |square|
          square.public_send("render_line_#{n}")
        end
        puts
      end
    end

    4.times do |n|
      $grid.last.each do |square|
        square.public_send("render_line_#{n}")
      end
      puts
    end
  end
end

unless (ARGV.length == 1 && File.exist?(ARGV[0]))
  puts "Usage: #{$0} layout.txt" 
  exit 
end

crossword = Crossword.new

ARGF.each_line do |line|
  line.chomp.gsub(/\s+/, "").each_char do |char|
    crossword.build_square(char)
  end
  crossword.incr_line
end

# binding.pry
crossword.render