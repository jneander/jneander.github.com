---
layout: blog_entry
title: do...while vs. {...}
description: Visual consistency with regard to code block delimiters
---
Consistency in style is an important part of readable source. It can be jarring when reading one structural style, then being confronted with a stylistic shift, especially if it is only momentary. Even if the functions of two different visual styles are identical, the inconsistency can be falsely indicative of varying intent or purpose.

For example, Ruby developers have the option to use either do...end or {...} to block out code which has a single overall purpose. Both forms are essentially synonymous, but are visually distinct enough to suggest distinct functions or intentions. Either way is fine, as long as usage is consistent.

However, an idea that has been circulated is to use the do...end delimiters when the value resulting from the contained statements will not be used, and to use the {...} delimiters when the value will be used in some way. To put it another way, use do...end when the contained code is producing a side effect, and use {...} when producing a value or object.

The argument for this is purely for visual consistency and readability. There are occasions when using this approach verbatim will not produce the desired results. Those instances, described in [this stackoverflow discussion]({http://stackoverflow.com/questions/5587264/do-end-vs-curly-braces-for-blocks-in-ruby}) can be easily avoided through the use of parentheses or ignoring the consistency for the rare special case.

Of course, like any debatable programming practice, these are simply guidelines.
