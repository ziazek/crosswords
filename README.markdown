# Crosswords

## About

Best of Ruby Quiz, Chapter 12

The quiz is to lay out crossword puzzles. A puzzle layout will be provided in a file, with the file name passed as a command-line argument. The layout will be formatted as such:

```
X _ _ _ _ X X
_ _ X _ _ _ _
_ _ _ _ X _ _
_ X _ _ X X X
_ _ _ X _ _ _
X _ _ _ _ _ X
```

Xs denote filled in squares and _s are where a puzzle worker would enter letters. Each row of the puzzle is on a new line. The spaces are a readability tool and should be ignored by your program. In the final layout, these squares should look like this:

```
######  Filled in square
######
######
######

######  Letter square
#    #
#    #
######
```

Now, when we combine these squares, we don't want to double up on borders, so:

```
_ _
X _
```
should become:
```
###########
#    #    #
#    #    #
###########
######    #
######    #
###########
```
As a style point, many crosswords drop filled squares on the outer edges...
```
X _ X
_ _ _
```
Would render as:
```
     ######     
     #    #     
     #    #     
################
#    #    #    #
#    #    #    #
################
```

The final step of laying out a crossword puzzle is to number the squares for word placement. A square is numbered if it is the first square in a word going left to right or top to bottom. Numbers start at 1 and count up left to right, row by row going down.

Putting all that together, here is a sample layout. 
```
     #####################          
     #1   #    #2   #3   #          
     #    #    #    #    #          
####################################
#4   #    ######5   #    #6   #7   #
#    #    ######    #    #    #    #
####################################
#8   #    #9   #    #    #10  #    #
#    #    #    #    #    #    #    #
#####################    ###########
#    ######11  #    #               
#    ######    #    #               
####################################
#12  #13  #    ######14  #15  #    #
#    #    #    ######    #    #    #
####################################
     #16  #    #    #    #    #     
     #    #    #    #    #    #     
     ##########################     
```
Solutions should output (only) the finished crossword to STDOUT.

## Requirements

Ruby 2.2.2

## Notes

## Usage

run `bundle install`

## Understanding the Question

## Results

## Review

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT)


