---
layout: blog_entry
title: Bowling Game Kata in Clojure
description: An approach to the bowling game kata using Clojure
---
To begin, we will set up our project directory. For testing, I prefer to use a library called speclj, along with leiningen for project management. For information on how to use these tools, please refer to the [leiningen](https://github.com/technomancy/leiningen) and [speclj](http://speclj.com) project sites.

Use the following command in a directory of your choice to create a simple leiningen + speclj project.

{% highlight bash %}
lein new speclj bowling-game
{% endhighlight %}

This command will generate, among a few other things, a 'src' and 'spec' directory, each containing a clojure source file for our use.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(ns bowling-game.core)
{% endhighlight %}

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
(ns bowling-game.core-spec  (:require [speclj.core :refer :all]
            [examp.core :refer :all]))

(describe "a test"
  (it "FIXME, I fail."
    (should= 0 1)))
{% endhighlight %}

In a separate terminal, navigate to the project directory we just created and run the following command.

{% highlight bash %}
lein spec -a
{% endhighlight %}

This command executes a leiningen process which runs all tests in the spec directory of our project. The '-a' flag keeps it running, automatically re-running tests when file contents have changed.

###Gutterballs
The example test provided isn't very useful. We'll replace that with our own test. We shall test that a complete game of gutter balls results in a score of zero.

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
(describe "score"
  (it "gutter game results in a score of zero"
    (should= 0 (score (repeat 0)))))
{% endhighlight %}

Without a 'score' function in the source, this test will generate an error. We need to create this function.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn score [rolls] 0)
{% endhighlight %}

In keeping with the practice of test-driven development, we write the minimum amount of code to make our tests pass. In this case, we expect that a "gutter game" in bowling will result in a score of zero. Without any other concerns, we explicitly return a value of zero.

###One Pin Frames
For our next step, we will test that a game of one-pin rolls results in a score of twenty.

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
  (it "one-pin frames game results in a score of twenty"
    (should= 20 (score (repeat 1))))
{% endhighlight %}

Now, we have two sequences of rolls that both should yield a score equal to their sum. We can change our 'score' function to match that expectation.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn score [rolls]
  (reduce + (take 20 rolls)))
{% endhighlight %}

The 'score' function now sums the first twenty values in the supplied sequences, yielding the appropriate values for both the gutter game and one-pin rolls game.

No significant changes were made, leaving nothing to refactor.

###Spares
The next step is to test a game with a spare.

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
  (it "spare frame adds next roll to score"
    (should= 16 (score (concat [5 5 3] (repeat 0)))))
{% endhighlight %}

Given that the first two rolls total ten pins, this spare should be scored as the sum of these two rolls plus the next roll for a total of thirteen. The score for the next frame is the roll of three plus the next roll of zero. The total so far is sixteen, which should also be the final score after all other rolls are zero.

This test relies on some logic in the 'score' function, so we must write that in.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn- to-frames [rolls]
  (lazy-seq (cons (if (= 10 (reduce + (take 2 rolls)))
                    (take 3 rolls)
                    (take 2 rolls))
                  (to-frames (drop 2 rolls)))))

(defn score [rolls]
  (reduce + (map #(reduce + %)
                 (take 10 (to-frames rolls)))))
{% endhighlight %}

The function 'score' now retrieves a sequence of lists from the function 'to-frames'. Each of these inner lists represents a frame, holding the rolls that contribute to each frame's score. In addition to the two rolls of a frame, the next roll in the sequence is included if the sum of the first two rolls is ten, indicating a spare.

When receiving the lazy sequence from 'to-frames', function 'score' takes the first ten "frames" and maps them using the sum of their rolls. The resulting list is then reduced to a single sum as before.

With our tests passing, it's time to consider refactoring the source. Without an explanation, it's difficult to follow what the algorithm is doing. Let's extract some helper functions.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn- spare? [rolls]
  (= 10 (reduce + (take 2 rolls))))

(defn- rest-rolls [rolls]
  (drop 2 rolls))

(defn- to-frames [rolls]
  (lazy-seq (cons (if (spare? rolls)
                    (take 3 rolls)
                    (take 2 rolls))
                  (to-frames (rest-rolls rolls)))))

(defn score [rolls]
  (reduce + (map #(reduce + %)
                 (take 10 (to-frames rolls)))))
{% endhighlight %}

We have created two helper functions, 'spare?' and 'rest-rolls', to clarify what our 'to-frames' function is doing. Function 'spare?' evaluates the next two rolls in a sequence and compares their sum to a value of ten. True is returned if the sum qualifies as a spare, false otherwise.

Function 'rest-rolls' removes the first two rolls from a sequence so that the sequence now begins with the first roll of the next frame.

We're not done, yet. Our two original functions are still a little unclear. We can extract another pair of functions.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn- sum [rolls]
  (reduce + rolls))

(defn- spare? [rolls]
  (= 10 (sum (take 2 rolls))))

(defn- rolls-for-frame [rolls]
  (if (spare? rolls)
    (take 3 rolls)
    (take 2 rolls)))

(defn- rest-rolls [rolls]
  (drop 2 rolls))

(defn- to-frames [rolls]
  (lazy-seq (cons (rolls-for-frame rolls)
                  (to-frames (rest-rolls rolls)))))

(defn score [rolls]
  (sum (map sum (take 10 (to-frames rolls)))))
{% endhighlight %}

Function 'sum' simply adds together the values in a sequence, rolls in this case, and returns that sum. Function 'rolls-for-frame' returns the first two rolls in the sequence, or the first three if the result of the first two is a spare. These are the rolls which contribute to a given frame's score.

###Strikes
The next step is to write a test for scoring strikes.

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
  (it "strike game adds next two rolls to score"
    (should= 26 (score (concat [10 5 3] (repeat 0)))))
{% endhighlight %}

A strike is scored by taking ten (the number of pins knocked down) plus the total of the next two rolls. We currently check for spares. We need to do the same for strikes.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn- sum [rolls]
  (reduce + rolls))

(defn- spare? [rolls]
  (= 10 (sum (take 2 rolls))))

(defn- rolls-for-frame [rolls]
  (if (or (= 10 (first rolls)) (spare? rolls))
    (take 3 rolls)
    (take 2 rolls)))

(defn- rest-rolls [rolls]
  (if (= 10 (first rolls))
    (drop 1 rolls)
    (drop 2 rolls)))

(defn- to-frames [rolls]
  (lazy-seq (cons (rolls-for-frame rolls)
                  (to-frames (rest-rolls rolls)))))

(defn score [rolls]
  (sum (map sum (take 10 (to-frames rolls)))))
{% endhighlight %}

With the tests passing, we have a chance to refactor again. There's some duplication we can eliminate by extracting another helper function.

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(defn- sum [rolls]
  (reduce + rolls))

(defn- spare? [rolls]
  (= 10 (sum (take 2 rolls))))

(defn- strike? [rolls]
  (= 10 (first rolls)))

(defn- rolls-for-frame [rolls]
  (if (or (strike? rolls) (spare? rolls))
    (take 3 rolls)
    (take 2 rolls)))
(defn- rest-rolls [rolls]
  (if (= 10 (first rolls))
    (drop 1 rolls)
    (drop 2 rolls)))

(defn- to-frames [rolls]
  (lazy-seq (cons (rolls-for-frame rolls)
                  (to-frames (rest-rolls rolls)))))

(defn score [rolls]
  (sum (map sum (take 10 (to-frames rolls)))))
{% endhighlight %}

Function 'strike?' is very similar to function 'spare?'. They are both used when grouping rolls together in 'rolls-for-frame', since both a strike and a spare use three consecutive rolls in the sequence. Additionally, 'strike?' is used to determine whether the next frame begins with the next roll or the one after that.

###The Perfect Game
There is one final test to write. This one will confirm that a perfect game (all strikes) evaluates with a score of three hundred.

#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
  (it "perfect game results in a score of three hundred"
    (should= 300 (score (repeat 10)))))
{% endhighlight %}

Without making any changes, all of our tests are passing. We now have a function to score a game of bowling.

###The Complete Source
#####*spec/bowling_game/core_spec.clj*
{% highlight clojure %}
(ns bowling-game.core-spec
  (:require [speclj.core :refer :all]
            [bowling_game_clojure.core :refer :all]))

(describe "score"
  (it "gutter game results in a score of zero"
    (should= 0 (score (repeat 0))))

  (it "one-pin frames game results in a score of twenty"
    (should= 20 (score (repeat 1))))

  (it "spare frame adds next roll to score"
    (should= 16 (score (concat [5 5 3] (repeat 0)))))

  (it "strike game adds next two rolls to score"
    (should= 26 (score (concat [10 5 3] (repeat 0)))))

  (it "perfect game results in a score of three hundred"
    (should= 300 (score (repeat 10))))
{% endhighlight %}

#####*src/bowling_game/core.clj*
{% highlight clojure %}
(ns bowling-game.core)

(defn- score-frame [rolls]
  (reduce + rolls))

(defn- spare? [rolls]
  (= 10 (sum (take 2 rolls))))

(defn- strike? [rolls]
  (= 10 (first rolls)))

(defn- rolls-for-frame [rolls]
  (if (or (strike? rolls) (spare? rolls))
    (take 3 rolls)
    (take 2 rolls)))

(defn- rest-rolls [rolls]
  (if (= 10 (first rolls))
    (drop 1 rolls)
    (drop 2 rolls)))

(defn- to-frames [rolls]
  (lazy-seq (cons (rolls-for-frame rolls)
                  (to-frames (rest-rolls rolls)))))
(defn score [rolls]
  (sum (map sum (take 10 (to-frames rolls)))))

{% endhighlight %}
