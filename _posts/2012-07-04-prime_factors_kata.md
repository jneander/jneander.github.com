---
layout: blog_entry
title: Prime Factors Kata
description: The rough first result of my first real assignment
---
The requirements are fairly straightforward. We should have a 'PrimeFactors' module with one method 'of' to return our prime factors. This method should take an integer argument representing the number to factorize and return an array containing the prime factors. For any arguments below the lowest prime (2), an empty array should be returned.

To begin, we will start the spec file. This will test the module we'll write in the following step.
{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  it "should factor 1" do
    PrimeFactors.of(1).should == []
  end
end
{% endhighlight %}

When we run 'rspec' on our spec file, the test will fail. The reason, of course, is that we haven't written the PrimeFactors class, which we'll do now.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    []
  end
end
{% endhighlight %}

Running 'rspec' again, our test will pass. Since there are no prime factors of the number 1, the test is expecting an empty array. We explicitly state an empty array inside the method. Though, this won't be of much use for us in the next test.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  it "should factor 1" do
    PrimeFactors.of(1).should == []
  end

  it "should factor 2" do
    PrimeFactors.of(2).should == [2]
  end
end
{% endhighlight %}
To solve this test, we will introduce a simple conditional statement.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    if n>1
      factors << 2
    end
    factors
  end
end
{% endhighlight %}
This will give us an array with either the factors of 1 (of which there are none) or the factors of 2. Before we move on to writing the next test, let's see what we can refactor.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
  it "should factor 1" do
    PrimeFactors.of(1).should == []
  end

  it "should factor 2" do
    PrimeFactors.of(2).should == [2]
  end
end
{% endhighlight %}
We had some code duplication, which will only get worse with additional tests. Since they all take the same general form (an input and the output resulting from processing the input), we can combine those variables into a list of arguments for a single test structure. Of course, we should only try to implement one change at a time, then see if it will work. In this case, we give ourselves one additional passing test which can be expanded for all foreseeable test cases.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
After merging our second test into the new structure, we ensure it passes, then remove the redundant tests. Let's move on to our next case.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
Our new test will fail. Looking at the code, we can see that any value except 1 will receive a single factor of 2 in the resulting array. Let's make a change to get this test passing.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    if n > 1
      factors << n
    end
    factors
  end
end
{% endhighlight %}
For the second and third test (2 and 3), those numbers are prime, which means the only factors we'll find for them are the numbers themselves. We can make the small change shown above to get the results we want. There's nothing to refactor, so we move on to the next test case.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
This is the first number that can be factored into smaller values. Our method doesn't account for this, so we'll need to make some changes.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    if n > 1
      factors << 2 and n /= 2 if n % 2 == 0
      factors << n if n > 1
    end
    factors
  end
end
{% endhighlight %}
Our tests now pass, but our code is starting to be questionable. With the solution above, some conditional statements are merged into single, more idiomatic statements. This reduces the line count, but also reduces readability for those not accustomed to some of Ruby's coding styles. For the moment, none of that matters much.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
For the next three test cases, our current solution gives the expected results. This tells us that we're getting closer to the final algorithm we seek. Let's add our next test case.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
    [8, [2]*3],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
We have another failing test. Observing the failure message, we can see that our algorithm is moving on to storing the reduced input before it has accounted for how many times it can divide by 2. Let's fix this.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    if n > 1
      factors << 2 and n /= 2 while n % 2 == 0
      factors << n if n > 1
    end
    factors
  end
end
{% endhighlight %}
That was easy! When we can make a test pass and keep the rest passing while only changing one element in our method, we can be confident in knowing that we're on the right track. There's no refactoring to do, so let's write our next test.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
    [8, [2]*3],
    [9, [3,3]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
We have another failing test. Looking at our failure message, we see that 9 simply isn't being factored. The reason is that it isn't divisible by 2. It's odd, and so it is bypassed and added to the resulting array without being factored. We can see that we want all inputs to reach that stage in the algorithm, so we must generalize it.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    if n > 1
      divisor = 2
      factors << divisor and n /= divisor while n % divisor == 0
      factors << divisor if divisor > 1
    end
    factors
  end
end
{% endhighlight %}
We now have a variable we can increment for each factor we'll use to break down the input. Though, we still need to increment our divisor until we've completely factored each input.

{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    divisor = 1
    while n > 1 and divisor += 1
      factors << divisor and n /= divisor while n % divisor == 0
    end
    factors
  end
end
{% endhighlight %}
We now have a loop where the divisor is being incremented and used to factor the input over and over. We moved the initialization of the divisor out of the loop so that we never reset the value. We reduced that value to 1 at the start, since the increment with each loop takes place before the body of the loop. We also removed the last line in the loop, since it would never be reached. Our tests now pass! That's it for the first few values. Let's try some larger numbers.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
    [8, [2]*3],
    [9, [3,3]],
    [2*3*5*7*11*13*13, [2,3,5,7,11,13,13]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
It looks like we've got it. Though, we should still check some larger known primes, just to be sure.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
    [8, [2]*3],
    [9, [3,3]],
    [2*3*5*7*11*13*13, [2,3,5,7,11,13,13]],
    [8191*131071, [8191,131071]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
Well, it looks like we're in good shape. We're done, right? ...perhaps not. Let's see how this algorithm performs with a really, really big number.

{% highlight ruby %}
# spec/prime_factors_spec.rb

describe PrimeFactors do
  [
    [1, []],
    [2, [2]],
    [3, [3]],
    [4, [2,2]],
    [5, [5]],
    [6, [2,3]],
    [7, [7]],
    [8, [2]*3],
    [9, [3,3]],
    [2*3*5*7*11*13*13, [2,3,5,7,11,13,13]],
    [8191*131071, [8191,131071]],
    [2**19-1, [2**19-1]],
  ].each do |num,factors|
    it "should factor #{num}" do
      PrimeFactors.of(num).should == factors
    end
  end
end
{% endhighlight %}
Our test passes, but what are we testing? The number is called a Mersenne Prime, which is defined as being a positive prime integer that is one less than a power of two. To confirm that this number in fact is only factorable by itself, our algorithm will need to test it against every number between 2 and 2\*\*19-1. That's a LOT of numbers to check. Our test times tell us that this is a bad idea. We can do better.

One of the tricks to checking primes is to use square roots. As the divisor used against a prime increases, the complementing quotient will decrease. If those values are equal, you have the square root. If the quotient is less than the divisor, any additional increments and checks with the divisor will be pointless, as these values will have already been checked. At that point, if we haven't found a factor, we should stop trying - we've got a prime.

Let's implement this idea.
{% highlight ruby %}
# lib/prime_factors.rb

module PrimeFactors
  def self.of(n)
    factors = []
    divisor = 1
    while n > 1 and divisor += 1
      factors << divisor and n /= divisor while n % divisor == 0
      divisor = n - 1 if divisor > Math.sqrt(n)
    end
    factors
  end
end
{% endhighlight %}
The tests still pass. However, look at the execution times. They've decreased dramatically. Is there anything more we can do to improve our algorithm? In an everyday computing sense, we're probably doing more than we need to do. We can factor really, really large numbers in a short period of time. If performance was really an issue, there are other approaches we could take to further optimize this code. This solution is more than sufficient for our needs.

I hope this is of value for you. While the muscle memory of performing this kata over and over again will be of great value to you in development, the thought process also has significant value when seeking solutions to other interesting and challenging tasks.
