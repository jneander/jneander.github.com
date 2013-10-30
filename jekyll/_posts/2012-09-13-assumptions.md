---
layout: blog_entry
title: Assumptions
description: A narrative about mistakes and the assumptions which led to them
---
***"Assumption is the mother of all mistakes."*** 
<br> - *Eugene Lewis Fordsworthe*

Up until a short while ago, I had been facing a bug which seemed impervious to all debugging efforts. It turns out that I was misleading myself. The real bug was in my thinking.

I was using Heroku to deploy the app which my team is developing. Everything performed as expected when run locally, but would mysteriously fail when run on Heroku. Multiple efforts to get it up and running were fruitless, leading to a number of issues which were taking more time than was acceptable. I had to set it down and carry on until more time was available.

**Assumption: All things are equal.**

To avoid committing debug statements and other changes made with the intention of exposing the problem, all Heroku activity was moved to a separate git branch. I continued to push changes using the same command:

{% highlight bash %}
git push heroku *branchname*
{% endhighlight %}

**Mistake: Heroku responds only to master.**

For a whole week, no change I made seemed to clarify the problem. Something was wrong; but I had no idea what it was. My first clue came from a line in the stacktrace indicating a problem with our authentication checking function. I decided to remove all references to it and see what happened. I pushed to Heroku and checked the application. No change; same error; same cause. "How could it be breaking on code that no longer exists?"

I checked the activity log on Heroku and made a discovery. The last commit made on the server was eight days ago! "Well, either Heroku is wrong or I am." I performed a Google search for *"heroku not updating"* and learned that [Heroku runs the server only from its master branch](https://devcenter.heroku.com/articles/git#deploying_code).

*"Branches pushed to Heroku other than master will be ignored ... If you’re working out of another branch locally, you can either merge to master before pushing, or specify that you want to push your local branch to a remote master. To push a branch other than master, use this syntax:"*

{% highlight bash %}
git push heroku *branchname:master*
{% endhighlight %}

This command succeeded in sending the source and restarting the Heroku instance. The results were readily apparent; everything worked. The mistake which precipitated this whole misadventure was in assuming that Heroku operated in the same way as any other git repo. Pushing a non-master branch yielded no errors, but was still incorrect. The assumption that it was working shielded me from the real problem and sent me on a wild goose chase.

Making an assumption like this can lead to lost time, as it did in this case. A better approach would have been to read deeper into the documentation and have a more complete understanding of the tools I was using, and referring back to them if and when things went wrong.

The best way to correct or avoid a problem is to understand as much as one can about the elements which factor into it. In each and every case, one of those factors will always be the user.
