---
title: "In Defence of Waste"
---

I think "waste" gets a bad rap in software development.

More to the point, I think the atavistic, fearful drive by software leaders to
"eliminate waste" is harmful in itself. It gets far worse when combined with
"Agile" principles -- note the scare-quotes before you tab over to Twitter to
yell at me, although do that anyway -- and in combination they form one stout
pillar of the violently incompetent state of software development management
that is presently fucking over millions of smart, hard-working people and
lighting trillions of dollars of value on fire.

Are you mad yet? Let's proceed.

## What is "waste"?

In the sense in which it's usually discussed in dev management, "waste" derives
from "Lean" -- usually "Lean Management" -- which itself comes from Toyota's
manufacturing principles ("TPS", "The Toyota Way", etc). Quoting [Mary and Tom
Poppendieck](https://www.goodreads.com/book/show/194338.Lean_Software_Development)
-- and no, I'm not here to slander their work, I like it and I'm mad that people
stopped reading after 20 pages -- waste is defined thus:

> [...]anything that does not create value for the customer is waste.
> -- Lean Software Development (2003)

Later:

> If there is a way to do without it, it is waste.

Toyota's patriarch Taiichi Ohno, who either coined or at least is credit for
this lens on manufacturing, defined seven categories of wasteful processes in
manufacturing. The Poppendiecks translated those to software development. I'm
not going to go over them here, because my problem is not with people who study
Lean and carefully think about its applications to software businesses. My beef
is with people who scribble down those definitions of "waste" in the margins of
their Agile Certification In Two Days course notes and come back to their teams
determined to apply "the first principle" of Lean management:
**Eliminate Waste**.

### Hold up! Those aren't equivalent!

Aha. Yeah, if you're paying attention, the two definitions:

> Anything that does not create customer value is waste
>
> If there is a way to do without it, it is waste

aren't quite the same, are they. There are things your company can't do without
that don't create customer value -- keeping the bathrooms stocked with toilet
paper, say -- that Lean consultants have spent an awful lot of effort trying to
finesse. The usual method is to break it down into "necessary waste", which is
stuff that doesn't deliver customer value but can't be done without, and
"unnecessary waste", which is what they usually talk about simply as "waste".

Again, I'm not upset with anyone who's careful enough to make this distinction
consistently. Unfortunately, most people who aren't deep into the weeds of Lean
Manufacturing -- because they're busy software managers and need to increase
output to hit their deadlines -- aren't that kind of careful.

## What is "value"?

Go back to that first definition of waste:

> Anything that does not create value for the customer is waste.

Look how it book-ends with this other principle, strongly hinted at in the
[Agile Manifesto](https://agilemanifesto.org/principles.html)'s authors and made
more concrete and explicit by the Continuous Delivery folks:

> Code doesn't provide value until it's running for customers in production.

The agilists wrote it as:

> Our highest priority is to satisfy the customer through early and continuous
> delivery of valuable software.

There's a lot of sympathy between these principles, isn't there? They _vibe_
together. You could -- and many do -- write it out as a syllogism:

> Software isn't valuable unless it's delivered for the customer.
>
> Anything that doesn't provide value for the customer is waste.
>
> _Therefore, anything that isn't delivered software is waste._

(Did you spot the error? Pretend you're a type-checker.)

Now, here's where it all comes together and goes horribly wrong:

## What is gonna save my ass from all these deadlines?

Consider how Agile is marketed: _it's a productivity transformation._ [Twice
the Work in Half the Time](https://www.goodreads.com/en/book/show/19288230-scrum)
and all that. (The Agile Manifesto, notably, makes no such claims: it only
claims that its principles are "uncovering better ways of developing software".)

Think a bit about who's looking for a productivity transformation.

There's a few people building software, or building software _companies_, who
latch onto stuff like that reflexively and use it to turn good into great. I
hope you get to work for one. But most successful teams, orgs, companies aren't
looking for an agile transformation because _they are alredy successful._

Where the Scrum book and other "Lean management" or "Agile" methodologies are
going to grow most vibrantly are _teams that are in trouble and under a lot of
pressure_, because they're _desperate_ for something to turn the tide. Managers
and directors and CTOs who're _scared_ because they need to do something to
stem the tide of outages and attrition, and still hit impossible targets set by
Sales and Product (who are _themselves_ scared because clients are churning
over all the downtime and the pipeline is empty because barely anything ever
ships).

And into this you drop a single, simple, precept:

> Eliminate waste. All else follows from this principle. You'll be Toyota in no
> time!

Fantastic! How do I do that?

> Anything that isn't delivered software is waste.

[And. Here. We. Go!](https://media.giphy.com/media/2GjgvS5vA6y08/giphy.gif)

### What is the point of... continuous delivery?

The first time I recognized this particularly narrow focus on waste, a manager
was telling me that feature-flagged dark deploys was waste, and he didn't
approve. After all, code running in prod behind a feature flag isn't delivering
value to the customer, and deploys take nonzero effort and carry a nonzero risk
of degradation or downtime.

### What is the point of... unit tests?

The first time I _remember_ running across this view on waste, although I didn't
recognize it as such at the time, an enterprise architect was telling me about
the uselessness of unit tests. After all, acceptance tests suffice to show that
the features required by the customer -- actually the product manager, but this
language is instructive -- are working, and at the code level unit tests just
get in your way when you're refactoring (_sic._). Therefore, acceptance tests
deliver value in the very agile-aligned way of demonstrating progress to the
customer, while unit tests deliver no customer value.

### What is the point of... not setting money on fire?

This one's my favourite. One company I worked for signed a contract with a
couple new clients, which involved implementing a new feature. Following the
agile principles of not doing too much design up front and responding to change
over following a plan, and the unfortunate consequences of the dev org working
mostly all the way to the right of the timeline, that feature was guessed to be
"pretty self-contained" and approved.

Friends, it was not. It got _everywhere._

By the time we'd delivered that feature, we had spent more than three times as
much in developer effort as those two clients were predicted to earn us in a
year. That's not counting effort outside the development org, or the opportunity
cost of what those people could've built instead, or the broken integrations our
narrow ("agile!") view of the problem inflicted on clients _on another continent
altogether._

## What, then, is the problem?

The problem is enthusiastic and narrow focus on eliminating anything that isn't
shipping features, driven by optimistic reductionism, driven by (usually)
[Westrum bureaucratic culture](https://cloud.google.com/architecture/devops/devops-culture-westrum-organizational-culture),
driven by... well, [I'm not going to go Five Whys on you](https://qualitysafety.bmj.com/content/26/8/671).
There's a lot of attractive nuisance to this permutation of "eliminate waste".

Look at the faulty consequent we ended up with:

> Anything that isn't delivered software is waste.

That looks great to scared people in Sales and in Product. Eliminate the waste,
and there's more room for shipping features. That's great! Sales can sell new
features, and Product can burn down their Gantt charts... er, Gantt their
burndown charts... ah, you know, _progress through their roadmaps_ and build the
_cool shit_ that got them excited about product management in the first place.

It also looks great to scared people in Dev. "Eliminate the waste" is an easy
and incontrovertible prescription, and "Anything that isn't shipping feature
code is waste" is a pretty clear-cut discriminator.

And yet....

The _other_ problem is the focus on the customer. [MoviePass](https://www.theverge.com/2019/9/19/20872984/moviepass-shutdown-subscription-movies-helios-matheson-ted-farnsworth-explainer)
famously delivered an _awful lot_ of value to the customer in their last year or
two, until they didn't. At some point, you need to deliver value to the
_company_. Often that's by delivering value to the customer, but as in my third
example, sometime's it's by deciding not to do that.

## What is missing?

The Poppendiecks don't fall into this trap, incidentally, and I'm willing to bet
that Taiichi Ohno didn't either. "Delivers value" isn't a purely binary,
either/or thing: It's a probability, on a timeline. You don't type code into
your editor because each character delivers a little bit of customer value; you
expect that code-typing to pay off when you ship the feature. Nobody objects to
this simple-minded triviality, but it needs to generalize.

Dark deploys are a bet that you'll deliver more value faster by catching some
bugs in production that didn't manifest earlier _before_ exposing them to
customer traffic (in this case, by not stepping on a negative-value rake and
incurring downtime). They're also a bet that your devs will get better at
deploys by doing more of them, and learn more about how their software
behaves in prod by deploying it there more often _and looking at what it does_.
Combined, that might permit you to swing that axe you've been playing with all
blog post and cut some of the more onerous go/no-go checks that fear of the
ghosts of outages past has baked into your process.

Unit tests are a bet that you'll deliver more value faster by taking smaller
confident steps with a well-defined blast radius than by occasionally running a
ponderous end-to-end test suite and having only a vague sense of what fucked up
when the build goes red. They're also a bet that designing code to be easily
tested in isolation produces code that's easier to change, which may let you
deliver more value faster when circumstances demand it.

A couple days of whiteboarding with the Architecture team and a few tech leads,
accompanied by some design sketches and decision logs, might help you decide to
avoid a project that'll deliver negative expected value and build something
that'll deliver value instead. Or, it might get the people who know the right
things to discover each other, and start emphasizing their Individual
Interactions over the Process Tool of "eliminate waste" narrowly applied.

## What else do you have to rant about?

Getting an underwater ops team out of firefighting mode is a classic example of
undermining the glib interpretation of "only shipped features are valuable" for
_actual_ value. As [\@Paul_IPV6 reminds us](https://twitter.com/Paul_IPv6/status/1442595907745112071),
uptime might not sell but it sure forestalls churn. (And consider the
opportunity cost of having dev-shaped people getting paged at 3am to reboot
servers, and eventually quitting, versus using that conscientiousness to build
cool shit.) Fixing your broken autoscaling rules or tearing out and replacing
the library that OOMs every other day might not seem like "delivers customer
value" when it's not tagged to an epic with story points attached, but it's
probably more impactful than any equivalent amount of work.

Keeping in an ops-ish mindset, _slack_ is a bet that's utterly at odds with the
practice of ruthlessly eliminating waste. If you run your team at its limit of
workload, you'll have no extra capacity to adapt when the unexpected inevitably
smacks you in the face. Deliberately taking on less work might _seem_ like it's
going to have negative payoff, but once you get out of the "only feature code
running in prod matters" mindset you can significantly increase your
adaptability.

> I think one reason this confusion pops up regularly in software is that it's
> less institutionally obvious what to optimize for. I remember running through
> some contrived kanban exercises -- build paper planes as a team, each making
> one fold -- and even though the results were pretty clear about the longest
> step determining throughput, a lot of people insisted that maximizing each
> individual's output was the way to go.
>
> "We want to ship more features" translated into "only shipped feature code
> matters" often leads to "the only behaviour we want to see out of our devs is
> stuff that looks like shipping features". But _that_ deserves to be a whole
> 'nother blog post.

Training is another big beneficiary of this improved framework. Sending an
individual developer to a conference has, at n=1, a pretty low expected
payoff. (This is especially true if the team is focused on Shipping Features To
Prod because that's the only thing that matters, and the dev in question isn't
given an opportunity to cement anything they learned or spread it around.) I
once ran a Pluralsight installation for my dev org, and the number of people
who signed up enthusiastically and _disappeared_ once they realized they'd asked
for homework vastly exceeded the number of people who stuck with it past a few
weeks.

But you don't send people to conferences or let them expense books or buy them
courseware licenses because you expect an immediate, concrete payoff, do you?
(Well....) At best, you do it because you're trying to encourage your people to
grow, and build an organization and a culture where [all of your smart problem
solvers have the leverage](https://blog.pragmaticengineer.com/what-silicon-valley-gets-right-on-software-engineers/)
to, what was that phrase again?

Oh yeah

Deliver just a _shit-ton_ of value to the customer.

## What's your takeaway?

"Eliminate waste" doesn't operate in a vacuum.

Shipping feature code is not the only thing that matters.

This language can lead you to narrow your focus and bury your team in technical
debt. It can lead you to write off your team's culture and your own (and your
colleagues's) growth and career development as secondary. Don't do it.

> "But Matt, that's obvious! People don't really behave in such ludicrously
> reductive ways!"
>
> Oh yeah they do, even people you'd least expect, when under pressure. Think
> about this ahead of time so you don't have to ad-lib your values.

Think in bets ("how much value is this likely to deliver?") and timelines
("when is this likely to pay off?") and, ideally, both at once.

And for god's sake stop trying to maximize immediate efficiency and utilization
when you really want to ship more over time. Play for area under the curve, not
a short-term high.
