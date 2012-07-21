---
layout: blog_entry
title: == vs. eql vs. equals
---
It was suggested to me that it is common for Ruby developers to default to *==* when testing comparisons in their spec tests. This seemed odd to me, but it merited a little research in any case.

The operators act as follows
 - **==** returns true if two objects are equivalent, without regard for type or identity.
 - **.eql?** returns true if two objects have both equivalent value and type, regardless of identity
 - **.equals?** returns true if two objects are the same instance, having the same identity

In testing, the operators differ only visually
 - **==** defers to the *==* method
 - **eql** uses the *.eql?* method
 - **equals** uses the *.equals?* method

As a rule of thumb: the longer the operator, the more restrictive the test it performs.

It may be true that programmers tend to use the *==* operator. For me, the information being compared - not personal style or preference - should be the deciding factor for the choice between one operator or another. After all, I want to be absolutely certain that my tests are passing for the right reasons.
