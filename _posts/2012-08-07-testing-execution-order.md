---
layout: blog_entry
title: Testing Execution Order
description: Accounting for order-dependent expectations in unit tests
---
I continue to work on tightening my tests and accounting for all behavior on which the success of my code depends. One concept mentioned by my mentor today is that of order-of-execution. Currently, many of my tests are actually brittle in respect to what exactly is being tested. The appropriate method calls may be made, but not necessarily in the correct order.

{% highlight=ruby %}
class MyClass
  def run
    do_first
    do_second
  end

  def do_first
    ...
  end

  def do_second
    ...
  end
end

describe MyClass do
  it "#run calls methods #foo and #bar" do
    obj = MyClass.new
    obj.should_receive(:do_first)
    obj.should_receive(:do_second)
    obj.run
  end
end
{% endhighlight %}

This test should pass, confirming that methods #do_first and #do_second are indeed both called by the #run method. However, as can likely be inferred by the example names given, there is a requirement for execution order that is not being tested. We reveal the problem by swapping the call order inside the #run method.

{% highlight=ruby %}
...
  def run
    do_second
    do_first
  end
...
{% endhighlight %}

We've changed the call order, but the tests still pass! If method #do_second is dependent upon the effect #do_first, the behavior will have changed without our test warning us about it. If we would prefer to stick with this type of test, we need to account for the execution order requirement.

###Ordered Method Expectations
As concisely illustrated in [this post](http://openmonkey.com/blog/2009/07/02/rspec-ordered-message-expectations/) by [Tim Riley](http://openmonkey.com/), RSpec provides a method for expectations to fail if messages to objects are received out of order.

{% highlight=ruby %}
...
    obj = MyClass.new
    obj.should_receive(:do_first).ordered
    obj.should_receive(:do_second).ordered
    obj.run
...
{% endhighlight %}

Making this addition to the expectations in this test ensures that the methods are called in the correct order.

###Other Thoughts
There are many different ways to test the ideas implemented in code. Some are more effective than others. Though, there doesn't appear to be magic bullet that slims down tests while both increasing coverage and decreasing brittleness.
