---
title: "Programming Aesthetics: I. The Missing Skill"
---

One of the most important skills for a builder of computer systems is a sense
of aesthetics for those systems. And yet, it's often lacking and even more
often underappreciated or scorned.

Let me explain.

Let me _start_ to explain.

## Preliminaries: Frames for viewing computer systems

There's plenty of precedent for looking at programming as an art, the prime
example being Knuth's [The Art of Computer Programming](https://dl.acm.org/doi/10.5555/1984890)
books. Building computer systems offers implementers a staggering array of
choices and tradeoffs, from which a path must be selected, and framing it as an
"art" is one reasonable way to approach that. Inevitably, if I'm going to be
writing about programming "aesthetics", it's going to be with this lens in mind.

Of course, a lot of us write code and build systems professionally, and the
companies employing us have a different view: This is software as work product.
This has maybe sharpened in recent decades with the influence of Lean (derived
from Lean Manufacturing and the Toyota Production System) on the Agile movement.
People steeped in the software-as-work-product perspective are prone to viewing
software aesthetics as counterproductive gold-plating; my goal here is to show
that it's actually vitally important.

> The software-as-work-product frame isn't exclusive to product managers or
> business executives -- "people who tell us what to do" -- either. Software
> development is an attractive profession, and it's a lot more accessible than
> many jobs that pay as well. This is a profoundly good thing!

Both of these frames coexist with a third, which Reid McKenzie described to me
as "software as working conditions". The systems we build today are the systems
we work in tomorrow. When we focus narrowly on client-facing deliverables, we
ignore cluttered workspaces littered with hazards and the computer-systems
equivalent of [Fordite](https://web.archive.org/web/20080216011855/http://www.fordite.com/forditehistory.htm).
Much of this dangerous clutter is far harder to spot than an assembly-line trip
hazard, which is where aesthetics comes back into play.

We have evocative names for systems clogged by these hazards. "Legacy code" is
one. "[Big ball of Mud](http://www.laputan.org/mud/mud.html)" is another.

## Big-ball-of-mud legacy systems don't just _happen?_

Well, that's kind of the problem, they _do_ "just happen". I suppose there are
a few shops that set out to simmer up a big pot of feature soup ("move fast and
find product-market fit!") but most development orgs don't deliberately create
massive unmaintainable entanglements of load-bearing features. It just sort of
ends up happening.

A few years ago I worked on a system that would calculate prices for short-term
rentals. One of the first things we built was a linear rate calculator: if it
costs $`n` to rent a widget for an hour, and you want to rent it for `k` hours,
this would multiply `n` by `k` to give you a cost for that rental period. We
fully intended to layer more complexity on top, but had a design for that to
live further up the structure of the code. This calculator was strictly `y=mx`,
not even a fully-featured line equation.

Things happened, years passed, I got "promoted" to manager, and two and a half
years later I came back to that line equation it had _eight parameters._

_Eight!_

Nobody looked at this pure, virtuous function and decided it needed seven extra
parameters. They got added, one at a time, over years. They got added as a few
more green lines among dozens or hundreds of other green lines in the pull
request. At least two got added by automated refactorings.

We didn't _design_ eight parameters into that line equation, it _evolved_ eight
parameters over the course of two and a half years of feature development. And
it's not like we were exploring uncharted space -- this was the _fourth rewrite_
of that particular business feature (or third, depending on how you count it).

Nobody looked at that code and thought "wait, this is just a line equation,
isn't it _unseemly_ that it takes so many parameters?"

And that's just a single function on a single class with what you would hope is
a single responsibility. The evolution of large complex systems is far worse.

## Mindset tools we want to work that don't

This is, of course, not what we've been promised by decades of software craft.
But the tools that decades of software craft have given us are, by and large,
tools that are easy to articulate rather than effective ones.

### Coding style guidelines

When I was a young programmer, I spent an _awful_ lot of time poring over coding
style guides from all sorts of authorities, evaluating and forming and refining
opinions about bracing style and variable naming conventions and tabs versus
spaces. It might've raised the bar a bit, but not by much; in the end I might
have learned to write better code just by writing _more_ code, even if I didn't
know better than to call a variable `bbbbb` because `bbbb` was taken.

Fast-forward a couple decades and I once again ran headfirst into coding style
arguments, this time because tooling made it easy to automate a consistent style
across the team, and that style must of course be agreed upon. Automation, you
are probably aware, will do what it's told regardless of whether it _ought to_,
so our team's coding-style champion issued an open request for code samples that
autoformatted to something hideous rather than expressive (in order to amend the
styling rules).

This is, on its face, toweringly insufficient to prevent the sorts of
evolutionary catastrophes we're talking about.

### "Clean code" and tactical refactorings

On that team where we put eight parameters on `y=mx`, we all had ReSharper
licenses, and boy did we _use_ them. _Extract Method_ was a favourite on code
reviews; we'd hound after loop bodies or mildly complex lambdas in LINQ blocks
and suggest, ever so helpfully, "can we pull this out into a separate function
with a meaningful name?" And damn, did we ever end up with a bunch of small
methods calling other methods with meaningful names.

Now the problem with that is that you end up with like _thirty_ of them in the
same class. And they're private methods, which means they're only under test by
accident - try to expose them otherwise and there's someone on the team who'll
argue that it's worse to make implementation details visible than to leave them
untested. (This sort of OO dogma counts under "coding style guidelines" for the
purposes of this blog post, although I have more of a problem with it than I do
with "don't abbreviate names unnecessarily", or, say, Allman-style bracing.)

This is a pattern that keeps coming back: Emphasis on detail-level solutions
(replacing three lines of `for` loop with a function call, a meaningful name,
and a six-line private method) eventually creates problems at a class level. We
needed people to have the mental space to take the time to _look_ at a class
with thirty private methods and pull the metaphorical andon cord: "Hey, team?
This class has thirty fucking private methods, I think it needs refactoring. And
so does this other parallel class, and this one here too, and... yo, we have a
problem."

The thing is, it's _easy_ to identify an _Extract Method_ refactoring, so those
get suggested a lot. It's _hard_ to extract a subtype from a class that suddenly
has thirty fucking private methods, and ReSharper doesn't help you (or didn't in
2016, maybe Machine Learning has solved this problem now). So guess where the
buck stops, when the backlog's a year long and the product manager's livid over
tickets getting pushed out weeks past where they were expected to ship.

### SOLID and friends

When I interviewed for the job where we eventually put eight params on `y=mx`, I
got grilled on the SOLID principles. (I faceplanted on the Interface Segregation
Principle, which I confused with inversion of control somehow, but that didn't
stop them from hiring me.) I can't say they helped us make good decisions.

You'd think that, say, the Single Responsibility Principle would be a good guide
to prevent you from adding an eighth, or maybe even a fifth or a sixth, param to
your "calculate `y=mx` function. But it can just as easily be taken the other
way: "This function's responsibility is to calculate this rate, so it needs all
the parameters necessary to do that calculation! Building up a bigger framework
to have those _implicitly_ available, perhaps by injecting context into a bunch
of class constructors, is a waste of time!"

Similarly, things like the Open-Closed Principle and Don't Repeat Yourself are
usually crystallized too quickly ("oh, we need code generation" is mostly a pipe
dream if you don't have access to template haskell, and a pain in the ass if you
do) rather than held in mind and used as constraints. Liskov's Substitution
Principle is a perfect example of software engineering advice that looks like a
shitpost ("A rectangle is a kind of square? What the _fuck_").

This is all good, well-meaning advice that's utterly useless on a practical
level unless you've already solved the problem it was meant to address (that is,
thinking hard and somewhat abstractly about your implementation, and being
willing to delay gratification - that is, shipping - for better abstractions).

And we're still only talking about software at the classes-and-functions level.
It goes way beyond that!

### Microservices and Domain-Driven Design

Monoliths are making a comeback, but for a few years microservices were the peak
of fashion and the "obvious" best-practice architecture for webapps. Like OOP,
the idea sounds compelling: Small, independent services that do one thing well
and can be rewritten in a tiny fraction of the time it'd take to rebuild that
crusty old monolith if you get one of them wrong. Sounds great!

The problem is, [Conway's Law](https://www.melconway.com/Home/Conways_Law.html)
(briefly: "You ship your org chart") doesn't go away just because you've put an
event bus between everything. Your monolith was an unmaintainable nightmare
because it wasn't clear which responsibilities lived where, and so the causal
graph of changes over _here_ having unwanted side effects over _there_ was
impossible to know except by trial and error. You can make the same mistake with
microservices, only instead of sorting it out with a debugger you're going to be
poring over event logs and Terraform configs. But at least you introduced a
network layer in between, so you have to consider a much larger set of failures!

Domain-Driven Design is another popular mental tool for software design, and it
often comes along with microservices. One of DDD's great strengths is its
insistence on talking to domain experts, and building your software in terms of
their language and their workflows (hence the name); this in fact has a lot of
coherence with Conway's Law. Unfortunately, that part can be a hard sell, either
because the domain-expert parts of the org haven't bought in or because it
sounds to the dev org like a lot of work, and _that_ can turn defining bounded
contexts and mappings between them into a purely technical exercise. DDD's more
tactical patterns can still help, but once again they're narrowly focused on a
small part of the larger problem.

> Would work-as-imagined DDD suffice to prevent the kind of legacy systems we
> love to complain about? Probably not! It definitely helps, but doesn't have
> enough to say about the operations side of the system.
>
> If you're interested in learning more, I recommend Vaughn Vernon's book
> [Domain-Driven Design Distilled](https://www.oreilly.com/library/view/domain-driven-design-distilled/9780134434964/).

But all of these tools, from strong opinions about Hungarian notation to strong
opinions about pub-sub integration, redeem themselves by _getting people to care
about the code._

## The first principle is giving a shit about the little things

When I say I think developers should have an aesthetic sense about code, it
starts with _having an opinion about what good systems look like._ It matters a
lot less to me whether they prefer brutalist code while the project's more Art
Nouveau. If ethics is what you do when nobody's watching, aesthetics is what you
make when nobody's focused on it - that line equation I keep coming back to grew
its eight parameters in a series of small diffs when the real meat of the pull
request was elsewhere.

A lot of the kind of bad code I'm complaining about accretes in rushed changes
at the margins of a piece of work. You may not know quite how to use the
adjacent library or subsystem you need to talk to, so you copy existing code and
insert your hooks where it seems reasonable. Then the compiler complains, so you
make the smallest change you can to satisfy it: maybe you cast an argument to a
type that's not _quite_ right but close enough. Then a test fails, so you add a
conditional to shut it up. Your reviewer doesn't know much about that library,
either, and it's not central to the feature you're working on, so your changes
don't get a lot of scrutiny.

And the graveyard gets a bit more haunted.

> It's worth mentioning that code varies in how aesthetic it can reasonably be.
> Some code has to conform to an ossified interface -- or it _has become_ the
> ossified interface, and breaking it even to fix that one sharp edge that
> everyone complains about would require too many downstream changes to
> contemplate. Other code is deeply embedded in its capricious and arbitrary
> domain -- maybe it's dealing with regulations that have accreted over more
> than a century -- and is better served by isolating it from the rest of the
> system's concerns than trying to make it "nice".
>
> That's okay, good poetry has constraints too.

Slowing down to better understand the library and its interface, refactor or
wrap it to do what you need, and cover your changes with tests feels like a
waste of time or extra effort, although it's usually more practical than it
appears. Refactoring, especially off a feature's critical path, is something a
lot of devs feel they have to ask permission for, and when you give someone a
chance to say "no" to unplanned, unanticipated work they'll usually take it. In
this environment, devs don't have the chance to develop their sense of code
aesthetics, or actively suppress it because it keeps getting them in trouble.

That sucks. That's how legacy code "just happens".

### So what can you do?

The first step is having and honing that sense of aesthetics. If you've been
reading along a little puzzled and aren't sure what the fuss is about ("if it
needs eight parameters then pass eight parameters, what's the problem?"), think
back to the code that's bitten you in the ass: that simple behaviour change that
took two and a half sprints; that new feature that's impossible to test without
bringing in the whole world as dependencies; that simple API change that brought
down the site for four hours the Sunday after it was deployed. Think about what
it looked like, which parts sucked, where and how it failed. You're developing a
sense for _code smells_, which I don't hear talked about very much any more but
is a great metaphor.

One thing I like about the "code smells" metaphor over the tools I mentioned
above is that it's not an all-or-nothing concept; you can tolerate a mild stink
for a little while until you finish something more important. Even if you can't
fix an issue on the spot, you can at least recognize it -- and document it.
Leave a comment above that sketchy typecast explaining that you don't like it,
but you aren't aware of a better way and everyone who worked on that part of the
codebase has left the company. Keep a collection of sketchy things you've found
on your Confluence page. Even something temporary, like a warning in a pull
request, is better than nothing. (Yes, pull requests live on past approval, but
they're _rarely_ referred back to.)

Documenting sketchy or smelly code makes it easier to notice patterns. It also
makes it more likely that you'll be able to triage a bug that falls out of the
code that caught your disfavour, or you may be able to help someone else's
investigation take minutes instead of days.

This is easier at some jobs than others, of course. If you happen to work for
[a company that asks its devs to generate value wherever they can](https://blog.pragmaticengineer.com/what-silicon-valley-gets-right-on-software-engineers/),
you might be encouraged to chase down these connections; if you work somewhere
that treats its devs as lines-of-code generators, your efforts are less likely
to be appreciated. (This can take many forms, from being praised but not
rewarded to being labelled a troublemaker and actively discouraged.)

### Why even bother?

Well, for one thing, you'll be less likely to write bad code inadvertently and
have to maintain it later.

On a longer timeline, writing better and more thoughtful code, and being able to
make and articulate tradeoffs between quick-but-ugly and robust-but-broader
implementations is going to make you a more effective, more valuable developer.
[Companies buy our time but rent our expertise](https://cate.blog/2021/10/12/the-rent-versus-buy-of-career-growth/),
so while being more thoughtful about your system's aesthetics might not drive
your career at your current job, it's likely to pay off when you move on.

## Great. I'm sold. *How?*

"Try to notice things that work and things that don't" is maddeningly vague
advice, I know, particularly for something as studied (by analogy, at least) as
aesthetics. This first post is just supposed to _motivate_ the idea; in the next
one I'll start looking at a number of pattern languages and how they inform
aesthetics, to get more specific.

Look, I'm not going to change the world here; I can't just dash off a few blog
posts (even longreads) about software aesthetics and solve legacy systems. All I
expect to do is offer an interesting way to look at how the people who build
systems look at them, based on what I've seen.

## Acknowledegments

I'm grateful to these folks from Twitter for reading and commenting on a draft
of this post, for which the one I published is much improved:

- [\@crankycatcoder](https://twitter.com/crankycatcoder)
- [Daniel Pritchett](https://twitter.com/DPritchett)
- [RedBearded Buddha](https://twitter.com/RedbeardedB)

In particular, a discussion with [Reid D. "arrdem" McKenzie](https://arrdem.com)
gave me a combination of encouragement and thoughtful critique that changed my
plan for the series. Thanks, Reid, I really appreciate it.