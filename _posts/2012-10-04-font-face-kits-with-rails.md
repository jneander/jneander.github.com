---
layout: blog_entry
title: Font-face Kits with Rails
description: Using font-face kits with a Rails 3.2 project
---
Sometimes, the standard fonts just aren't going to support the look and feel that a site needs. Fortunately, there are some great resources available for allowing non-standard fonts to be used with any Rails project. Courtesy of the folks at [Font Squirrel](http://www.fontsquirrel.com/), you can create custom font-face kits and use them locally on your site. There's no need to pull fonts from other sites, risking downtime if the resource is at any time inaccessible. A local kit is available for as long as your site it.

When looking to use custom or non-standard fonts on a Rails site, there's a tiny amount of setup required to make everything work.

First, add your font files into the *app/assets/fonts* path of your Rails project directory. If the directory is not already present, create it.

Next, add this line to the *config/application.rb* file in your Rails project:
{% highlight ruby %}
config.assets.paths << "#{Rails.root}/app/assets/fonts"
{% endhighlight %}

This entry makes Rails aware of the 'fonts' directory on the assets path. As Rails will precompile all assets by default, you do not need to explicitly request Rails to do so with your fonts.

Finally, you need to describe the font-face in a stylesheet.
{% highlight css %}
@font-face {
  font-family: 'CustomFontName';
  src: url('FontABC.eot');
  src: url('FontABC.eot?#iefix') format('embedded-opentype'),
       url('FontABC.woff') format('woff'),
       url('FontABC.ttf') format('truetype'),
       url('FontABC.svg#FontABCRegular') format('svg');
  font-weight: normal;
  font-style: normal;
}
{% endhighlight %}

Now, you can assign the font to a style as you would any standard font.
{% highlight css %}
font-family: CustomFontName;
{% endhighlight %}
