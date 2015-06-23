#!/usr/bin/env ruby

require 'pry-byebug'

class Crossword
  CELL_WIDTH = 6 
  CELL_HEIGHT = 4

  attr_accessor :cell_width, :cell_height
  attr_reader :file
  
  def initialize(file)
    @file = file
    @cell_width = CELL_WIDTH
    @cell_height = CELL_HEIGHT
    build_puzzle
  end

  def render
    # each cell should be an array of arrays within itself
    # loop through each adjacent cell in a row by line and retrieve the characters
    full_render = Array.new

    @numbered_grid.each_with_index do |row, i|
      row.each_with_index do |data, j|
        # Without @cell_width-1, the borders are duplicated 
        # overlay(cell: cell(data), full_render: full_render, x: j*(@cell_width), y: i*(@cell_height))
        overlay(cell: cell(data), full_render: full_render, x: j*(@cell_width-1), y: i*(@cell_height-1))
      end
    end

    full_render.collect! { |row| row.join }.join("\n")
  end

  private

  def cell(data)
    c = []
    case data
    when 'X'
      @cell_height.times { c << ['#'] * @cell_width }
    when ' '
      @cell_height.times { c << [' '] * @cell_width }
    when /\d/
      border = ['#'] * @cell_width 
      # sprintf allows left justification with a set width.
      # see http://ruby-doc.org/core-2.2.0/Kernel.html#method-i-sprintf
      num = sprintf("#%-#{@cell_width-2}s#", data).split(//) 
      mid = sprintf("#%-#{@cell_width-2}s#", ' ').split(//) 
      c << border << num 
      (@cell_height-3).times { c << mid }
      c << border      
    when '_'
      border = ['#'] * @cell_width
      mid = ['#'] + [' ']*(@cell_width-2) + ['#']
      c << border 
      (@cell_height-2).times { c << mid }
      c << border
    end
    c
  end

  def overlay(cell:, full_render:, x:, y:)
    cell.each_with_index do |row, i|
      row.each_with_index do |data, j|
        full_render[y+i] ||= []
        # a space should not overwrite a wall
        full_render[y+i][x+j] = data unless full_render[y+i][x+j] == '#'
      end
    end
  end

  def build_puzzle
    parse_file 
    drop_outer_filled_boxes
    create_numbered_grid
  end

  def parse_file
    # store as an array of arrays
    @grid = []
    file.each_line do |line|
      @grid << line.split(/\s+/)
    end
  end

  def drop_outer_filled_boxes
    # use Array.transpose
    # outer filled box is any box on the outside or beside a space
    loop do
      changed = drop_outer_x(@grid)
      changed += drop_outer_x(t = @grid.transpose)
      @grid = t.transpose
      # loop until no more changes made
      break if changed == 0
    end  
    # binding.pry
  end

  def drop_outer_x(ary)
    # replace outer X with space
    changed = 0
    ary.collect! do |row|
      r = row.join
      changed += 1 unless r.gsub!(/^X|X$/, ' ').nil?
      changed += 1 unless r.gsub!(/X | X/, '  ').nil?
      r.split(//)
    end
    changed
  end

  def create_numbered_grid
    # look for two or more consecutive underscores
    mark_boxes(@grid)
    mark_boxes(t = @grid.transpose)
    @grid = t.transpose 
    count = '0'
    @numbered_grid = []
    @grid.each do |row|
      r = []
      row.each do |col|
        # return a number by succeeding the count if it's marked
        num = (col == '#') ? count.succ!.dup : col
        r << num
      end
      @numbered_grid << r
    end
    # binding.pry
  end

  def mark_boxes(ary)
    changed = 0
    ary.collect! do |row|
      r = row.join 
      # after an X or space, there must be a row of 2 or more
      r.gsub!(/([X ])([#_]{2,})/) { "#{$1}##{$2[1..-1]}" }
      # at the start
      r.gsub!(/^([#_]{2,})/) { |m| m[0] = "#"; m }
      r.split(//)
    end
    changed
  end
end

unless (ARGV.length == 1 && File.exist?(ARGV[0]))
  puts "Usage: #{$0} layout.txt" 
  exit 
end

crossword = Crossword.new(ARGF)

print crossword.render