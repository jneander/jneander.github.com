---
layout: blog_entry
title: A Few More Things Learned About Testing
description: Behavior over implementation; extracted classes; and wet assertions
---
###Testing the Behavior, Not the Implementation
A class and its tests, as with any two classes in an application, should follow a very simple guideline: they can know about each other and how to interact with each other, but should not know how other classes fulfill their public expectations. This is a core idea behind Java interfaces, which is a strength not found in most other languages. Ruby, in particular, makes it dangerously easy to see inside classes that should otherwise remain opaque.

In my tests, I have found myself tending towards some bad habits. Namely, my tests occasionally become aware of some implementation details. The more I learn about proper testing, the more I recognize when this occurs and the more able I am to write resilient tests. This steers my tests and their classes away from dependencies that build fragility into my test suite.

*"A good design is independent design."*

###Helper Method or Prisoner Class
As I was building a class to serve as a command line interface, my mentor noticed a small group of helper methods. Each was serving a purpose similar to the others, converting data from an unrelated class into an ascii-printed visual element. There were two problems with these methods. The first was that they were difficult to test. They had too much responsibility. The second was that they were fulfilling a purpose tangental to that of the class in which they resided.

It was expressed to me that this is an indication of a class trying to escape. The most apparent solution was to extract these methods into a new class responsible for converting data structures to visual ascii structures. To be more precise, the conversion was extracted to the new class. The display of these elements remained in the original command line interface class. This eased the testing, as the methods in the new class only had return values to test. It also slimmed down the original class file, both in size and in responsibility.

###One Assertion Per Test?
I am a fan of thorough test coverage. However, testing can easily become overwhelming as the individual aspects of a method become more numerous, even when the responsibility of the method is singular. For example, the Prime Factors Kata illustrates how a set of tests can easily become unnecessarily lengthy despite how reduced the tested method is. To avoid test bloat, the input/output matches are packaged into an array and sent in pairs to a single assertion statement. As a result, there is only one test for this method.

The reason this works is that this particular method has a single idea to test. The output may change according to the input, the many varieties of which should all be accounted for. However, the idea itself is singular. Given an input, expect a corresponding output, which shares the form of all other possible outputs.

As I have been practicing TDD, I have written tests which mirror the structure of others. The only difference ends up being one or two lines for executions and assertions. Test bloat ensues. An annoyance, and perhaps a problem, with these tests is that they are all testing the same idea. Testing that '2' factors into '2' and '5' factors into '5' is not the testing of separate ideas. They can be placed together in the same test, even fed into the same assertion. This makes for a rather wet refactoring strategy.
