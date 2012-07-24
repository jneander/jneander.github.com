---
layout: blog_entry
title: Quick and Dirty TDD
description: Carrying game development ideas over into test-driven development
---
###What is TDD?
TDD (Test-Driven Development) is the an approach to software development which allows for the production of clean and thoroughly-tested code. In practice, it reduces or altogether eliminates the waste and risk associated with debugging and breaking/repairing of code that goes along with other approaches.

###The Three Phases
TDD consists of a repeated cycle of three linked steps:
 - **RED**: Write a failing unit test for a class, method, etc. that does not yet exist or perform as expected.
 - **GREEN**: Write just enough code in the component being tested to make all unit tests pass.
 - **REFACTOR**: If needed, rewrite and simplify the existing code to reduce or eliminate complexity and duplication.

Performing each step supplies the conditions needed for the following step. The result of each cycle is a new element of code, be it a class, method, or other such component, which has a passing test confirming that all functionality performs as expected and/or required.

###The Three Rules
In his [post]({http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd}) on the subject, Uncle Bob discusses some of the many advantages to TDD. He focuses on outlining the three rules which give TDD its structure:
 - "You are not allowed to write any production code unless it is to make a failing unit test pass."
 - "You are not allowed to write any more of a unit test than is sufficient to fail; and compilation failures are failures."
 - "You are not allowed to write any more production code than is sufficient to pass the one failing unit test."

So far, on simple projects with very short requirements lists and simple designs, this process is great practice. As successive projects begin to complicate the design, however, it is becoming increasingly difficult to ensure that the design elements are solid and adaptable as the requirements list grows between iterations. The design must support the process, or the process itself will grind to a halt. But that's a discussion for a future post.

###Quick and Dirty Development
Having spent time developing games, I sense some familiarity with the ideas present in TDD. While not directly transposable to or from TDD, the design cycle of "[quick and dirty prototyping]({http://www.gamasutra.com/view/feature/132702/quick_and_dirty_prototyping_a_.php?print=1})" has some value to offer.
 - Build prototypes as fast as possible.
 - Keep things ugly until the last possible second.
 - Revise or scrap until the game is fun.

The process is described exactly as it is titled. It is quick, getting a workable prototype (a test product) up and running as soon as possible. It is dirty, potentially having little regard for design patterns or proven elements, and focused on having something that can be changed and improved. It is also effective, generating a product with each cycle that can then be polished, improved, and optimized (for enjoyability).

It's not difficult to see the translation to the test-driven process:
 - Prototype the usage of some code you want, fulfilling some idea you want implemented.
 - Get the thing working, not being concerned about the quality of the code.
 - Clean it up, so that both the business value and development footprint of this code is optimized in every way possible.

Developers with no game background might prefer to stick with pure TDD. I find value in both.
