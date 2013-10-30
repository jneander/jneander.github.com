---
layout: blog_entry
title: Expanding on the Single-Responsibility Principle
description: Thoughts on applying SRP to methods as well as classes
---
Towards the end of last week, my coworker Ginny gave an informal talk about the SOLID Principles. I cannot stress enough just how important it is and will continue to be to keep these principles fresh in my mind and always at my fingertips. I'm still working on that.

Among the many great ideas she discussed, she presented an interesting notion about the Single-Responsibility Principle that I don't recall having heard or seen mentioned before. The Single-Responsibility Principle states that "every class should have a single responsibility, and that responsibility should be entirely encapsulated by the class. All its services should be narrowly aligned with that responsibility." This encourages lean class designs and is the first step towards independent, decoupled classes.

The idea that she planted in my brain was that of every SRP-bound class having one and only one responsibility for each of its methods. What this means is that individual ideas are executed by only one method, and that individual methods encapsulate only one idea. Taking it a step further, to encourage slimmer and easier testing, each method should either make one change to the state of one object or return one result. Having multiple changes written into a method indicates that the idea which it encapsulates can be broken down into simpler, individually-testable ideas.

As I was working on a major refactoring of my Tic Tac Toe, this concept was invaluable to the pace and direction of that effort.
