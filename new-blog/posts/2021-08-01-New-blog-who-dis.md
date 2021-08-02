---
title: Standing up a Hakyll blog with Windows and Netlify
---

This is my second attempt at a static-site-gen blog. So far it's going a lot
better than the first, because I'm working with some technologies I really
like, but that's not to say everything was smooth sailing. _That_ means a
story, which means this blog post.

I got up yesterday morning and decided to start messing around with Haskell on
my personal desktop (I write Haskell for work, too, and this felt like a decent
chance to get better at it.) The first project that popped into my mind was
resurrecting my blog. I've been meaning to try Hakyll for a few years now, but
for [various reasons](https://twitter.com/arachnocapital2/status/1421898007021195268)
it hasn't happened.

### Context

This is a "what I tried and how I got things to work" story, not a tutorial.
You can probably guess from the look of the site that I'm not done yet. As such
this won't be a great reference for googling error messages, but it _just might_
help someone who's trying to do the same thing. I'll be happy if it entertains.

## Step one: WSL2

My desktop is built for gaming, a bit of digital art, and a lot of shitpoasting
on twitter, so it runs Windows 10. This isn't an operating system well-known for
supporting Haskell - before my new job, my tool of choice was F#. Fortunately,
Microsoft made 2019 the Year Of Linux On The Desktop with WSL2, so I installed
that. Two reboots later I had an ubuntu-flavoured bash prompt in front of me,
and I `apt-got` Haskell-Platform.

Work uses `cabal` so I figured I would too, but when I ran `cabal update` it
spat out an ominous warning about backward-compatibility and deprecation, and
scolded me to use the `new-` versions of various verbs. I figured I'd try that
with `cabal new-install hakyll`, and bounced off an error about not being able
to open a pipe. An hour of fucking around and several `rm -rf ~/.cabal`s later,
neither the old nor the new `cabal install`s would get properly through pulling
down Hakyll, so I gave up and uninstalled ubuntu. (This did leave WSL2 enabled,
which may be important later.)

## Step two: Visual Studio Code devcontainers

Well, I'm not gonna let myself feel ashamed of my gamer-oriented software. I'd
planned to work in VS Code _anyway_ - I use it for work, it's pretty good - and
went back to google, where I found an old friend: [Igal Tabachnik wrote up a
"Haskell on Windows in minutes!" tutorial using a Docker container and VS Code](https://hmemcpy.com/2020/02/setting-up-a-haskell-development-environment-in-minutes-in-vscode/).
Even better, a Haskell container had been officially adopted by the VS Code
devcontainers crew, a mere nine days (fresh! relevant!) before I'd looked.

So I followed the [VS Code tutorial](https://code.visualstudio.com/docs/remote/containers)
and downloaded Docker Desktop. That tutorial is very clear that you need to give
Docker Desktop permission to access your filesystem, at least where your code
lives. Unfortunately, there's no **Resources > File Sharing** option available,
as referenced by the tutorial.

Well, I got this far by dint of a "let's keep going and see what happens"
attitude, and I wasn't going to let this slow me down. I tried the Node
container suggested in the tutorial and then went looking for that Haskell
container.

I found a note on [Igal's github](https://github.com/hmemcpy/haskell-hie-devcontainer)
to the effect of "don't use this, use theirs!" Well. As far as I can tell there
isn't a list on a web page.

With a bit of digging through other platforms' tutorials I discovered the magic
sauce:

1. Open a project directory
2. Open the VS Code command palette
3. Select "Remote-Containers: Add Development Container Configuration Files"
4. Start typing "Hask..." until something pops up

I guess one interpretation of ✨_The Magic Of Containers_✨ is that they serve
as configuration files? Whatever. I'm up and running in a container with ghc
installed!

## Step three: `stack`, jacked

The [Hakyll tutorials](https://jaspervdj.be/hakyll/tutorials.html) largely use
`stack` over `cabal`, and I remembered getting bitten by `cabal` only an hour or
two earlier, so I figured I'd try `stack`. Alas, `stack install hakyll` ran into
three sets of version incompatibilities for Hakyll's dependencies, and even
though `stack`'s errors helpfully told me how to add exceptions for those
particular package versions, two of them asked me to satisfy _mutually exclusive_
version bounds.

Fortunately, `stack` also told me where the "YOLO" setting was for version
constraints, and after enabling that and waiting approximately a week and a half
for Pandoc to compile, I had a working install of Hakyll 4.14.

The great virtue of Haskell is that "if it compiles, it runs", right? On to the
next step, building a site skeleton. That went off without a hitch and led me to
the meat of the Hakyll workflow, building and running the site generator.

### A brief digression on why I'm doing all this

> It's been about four years since I blogged with Jekyll. One of my strongest
> impressions of _that_ tool is its configuration-orientedness - plugins and yaml
> files and other activities that are at best programming-_adjacent_. Hakyll,
> however, promises to let you _write code_ to change how you want your static
> site generated. It's more of a framework for writing an SSG than a stanndalone
> SSG in itself. That's why I have to build it here, but it's also why I'm on
> this path in the first place.

Building the site generator is as simple as `stack build`. Except, `stack` can't
figure out how to build my site generator, because it can't find version 4.14 of
Hakyll on any of the resolvers it knows about.

You know, the package I just laboriously built locally, from which I generated
this haskell project.

After half an hour of fruitless fucking around, I gave up on `stack` and went
back to `cabal`, meticulously prefixing everything with `new-`. That took
another week and a half to compile Pandoc, but worked fine in the end.

Magically, I now have a static site!

## Step four: Nifty Netlify

Now that I have some HTML, CSS, and a lambda-looking image, I just need a place
to put it. My old blog was hosted on `github.io`, but since then I acquired the
`audax-labs.com` vanity domain and I haven't really done anything with it. Time
to pop into my AWS account, where the domain's hosted...

...and remember which authenticator app I used for the admin account...

...and remember that it was the same thing I used for $oldjob, which I deleted
in a fit of digital cleanliness after I quit...

..._fuck!_

Fortunately, AWS has a _great_ account recovery process if you've kept access
to your root account's email. Five minutes later I was logged in as root and
setting up MFA devices once again, by far the fastest problem I overcame in
this whole saga.

I did all that so I could hook up Netlify to the domain. For my purposes here,
at least, Netlify is a hosting company with a CI back-end that hooks into a
git repository (github, in my case). Push to `main`, Netlify picks that up, and
files get copied over. Once AWS negotiated the DNS transfer and
`blog.audax-labs.com` went live, they even provisioned an SSL cert for me. The
AWS account recovery might've been the _fastest_ problem I solved, but that's
because Netlify didn't present _any_ problems.

I'm using their free tier, which offers one build agent and 300 CI minutes per
month. Building static HTML locally, pushing it to a branch, and copying it out
costs approximately zero CI minutes per deploy, so I think I'll be good for a
while.

## Step five: tailwind

Now that I had a site and a public place to put it, I wanted to make it look
better. That means CSS, and an excuse to play around with [Tailwind CSS](https://tailwindcss.com)
which I've been aware of for a little while.

Unfortunately, I don't know shit-all about CSS, and Tailwind's docs are written
for people who do this stuff for a living. It took me a few minutes to generate
a Tailwind CSS file and start seeing _some_ change in the rendered result, and
several _hours_ to figure out how to actually get it to work _properly_.

In particular, most of the instructions for integrating Tailwind assume that
you're adding it to an existing toolset rather than YOLO'ing it from the
command line. This combined with my lack of CSS knowledge - turns out you can't
just magic up `@`-directives - and Firefox's cheerful willingness to render as
much malformed CSS as it can rather than spit out error messages. Eventually I
figured out that I needed to combine Tailwind with Hakyll's default CSS and run
it all through `nvx tailwindcss` to build a style sheet that'd do what I want.
In retrospect, the [tailwind CLI docs](https://tailwindcss.com/docs/installation#using-tailwind-cli)
told me what I needed to know but assumed I knew what workflow to use, which I
didn't.

This is perhaps not a great use for Tailwind - which gives you fine control
over laying out and rendering individual components, where Hakyll generates a
bunch of bulk HTML for you out of markdown - but screw it, I'm having fun.

## Step six: conclusions?

I'm not entirely sure how to end this post. I got an awful lot done just by
beating my head against it, but by the same token the barriers to entry for
setting up a blog like this one are shockingly low in this year of our lord
two thousand and twenty-one. I clearly have a lot of work to do, but at the
same time what I've done on this blog kinda kicks ass.

Also, this was all inspired by quinoa. Stay frosty for that.