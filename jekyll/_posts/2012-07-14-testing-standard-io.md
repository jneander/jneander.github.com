---
layout: blog_entry
title: Testing by Mocking Standard I/O
description: Thoughts on thorough testing using mocks and the console
---
My current assignment at 8th Light, a Ruby-based game of unbeatable Tic Tac Toe, depends on some approaches which I have never used before. All user interaction with the game is taking place through a command-line interface. To receive input from the user and to display visual elements, Ruby standard input and output are used. The part of this with which I was previously unfamiliar is how to test it. Performing tests on an interface, especially one as simple as this, should occur without requiring periodic user input or useless printing of visual game elements. Some questions needed to be asked and answered.

What is being tested? A user can enter characters into a prompt, submit them to the game for interpretation, then receive visual feedback for the results of that interaction.

What is the concern? The game relies on $stdin and $stdout, respectively, for processing user input and printing the visual elements of the game. While testing interactions, the game must neither pause for input nor print to the output. To ensure that game logic is being tested without these problematic byproducts, all requests for input and calls to print must be redirected to mock objects.

With some brief research, I learned that a StringIO object can be written to $stdin and $stdout. These "pseudo I/O" objects can then instructed to listen for commands and return values, just like any ordinary mock object. The result is that canned input from the "user" can be established in tests, the effect of which is entirely predictable and testable. This also allows print commands to be effectively hidden during tests.

