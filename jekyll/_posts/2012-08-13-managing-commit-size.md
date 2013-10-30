---
layout: blog_entry
title: Managing Commit Size
description: Two git commands to aid committing individual ideas
---
A minor challenge with using version control is maintaining appropriately-sized commits. I have been aiming to keep my commits to a size where each encapsulates one and only one idea. This allows multiple tests to be written to shape a method implementing this idea. This also means that multiple, related changes are being committed. As long as each change is being described in the commit message, there will likely be no problems with this.

On the other hand, I have found myself in situations where I end up with too many changes to commit at one time. This is often due to an idea that splits as I'm developing it, leaving two separate ideas which each deserve their own commits. On these few occasions, there are a pair of git commands which come in handy.

{% highlight ruby %}
git add --patch
{% endhighlight %}

{% highlight ruby %}
git stash -k
{% endhighlight %}

The *add* command with the patch flag will enter an interactive mode for manually splitting changes into smaller "hunks" to include or exclude with the commit.

The *stash* command with the keep-index flag will temporarily save your existing changes and clean the working directory to match the HEAD commit. However, with the keep-index flag set, any changes previously added to the index will remain in place for the commit. At this time, it is a good idea to run tests to confirm that splitting the changes has not caused any functionality to break.

Pending passing tests, the first commit can be made. After that, stashed changes can be unstashed with the pop flag. If further splitting is needed before committing, the same steps can be followed.
