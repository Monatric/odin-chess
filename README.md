# Ruby Final Project: Chess

This is the final project in the Ruby course of The Odin Project from the Rails path.

Chess is a classical board game that is played since the ancient times until now. This is composed of a 8x8 dimension board, with 16 pieces each from both players.

## Features

1. Enter `ruby main.rb` to run the game.
2. The game can be played by two players via command line.
3. To make a move, the player must enter the origin and destination coordinates e.g. "e2e4"
4. The game consists of a save and load feature.
5. The game uses FEN to manage the states of the board, pieces, etc.
6. The game follows the standard chess rules.

## Specific instructions

### Movement

The game follows the Smith notation for moving the pieces. Smith notation is a straightforward chess notation designed to be reversible and represent any move without ambiguity. The notation encodes the source square, destination square, and what piece was captured, if any.

For example, enter the coordinate of the piece you want to move, such as "e2", and enter the coordinate where you want the piece to move, such as "e4". Thus, the movements look as follows:

- e2e4
- b8c6
- c1h6

For castling, simply enter the destination of the king where it should be castled. It is like moving two squares to that destination. Example:

To castle short as white:

- e1g1

To castle long as black:

- e8c8

To promote a pawn:

- f7f8
- This will prompt the user to select between 1-4, indicating each piece corresponding to the number.

For captures and and checks, it is all the same. No additional symbols; just the source and destination coordinates.

### Game options

When the program runs, you have two options to choose from.

1. New Game - This creates a new game.
2. Load Game - This loads your last saved game.

After that, there are three options you may want to use.

1. "i" - Provides the instructions for moving a piece
2. "save" - Saves the game
3. "exit" - Exits the game

## Learning Outcome

- OOP fundamentals. Encapsulation was my first issue; I allowed other classes to manipulate other classes' data. Apparently we shouldn't even let the classes know much about other classes in the first place.
- Abstraction. I may have completed the project but I am quite unsatisfied with my abstraction here. The worst issue here of them all is manipulating the board positions, and I should not have relied on a simple hash data for managing this.
- Too much parameters for a single class, such as Game and FEN. There might be a better way to handle this.
- Found out about circular dependencies. Like, I initialized class Chessboard in Game, and initialized both of these classes in Piece. This would've made my code even more complex.
- Testing, testing, testing. Suffice to say I at least got a little used to using RSpec. I might've developed an idea on which methods should be stubbed, how doubles work, and which methods should be tested in isolation or integration. But the overall concepts are still tough to digest.
- Namespacing, modules, keyword arguments, class methods, inheritance, separation of concerns, and spying in tests are some of the concepts I learned along the way that I can think of on top of my head.
- There's still a lot of refactoring opportunities I can dive in here. But I'll probably leave this for now.

## Time Spent

- Took me about 8+ months to _kind of_ finish the project, while managing my final year of college. I say _kind of_ because of potential minor issues, and with a lot of refactoring I can consider.

## Special Thanks

To Roli, josh, rlmoser, X AJ X, and everyone else from the The Odin Project discord server for guiding me on this Chess project.
