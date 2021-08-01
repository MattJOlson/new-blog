---
title: Flexible Code
---

# 1.

Last week, another team lead asked me to take on one of his team's
products. It's not an unreasonable request; his team's overworked and
oddly understaffed, and this particular product is closer to my team's
domain than to his. Given some of the work we'll be doing in the future,
having that product in our domain could be quite convenient.

What's interesting is how he sold it.

"This shouldn't impose much work on you guys, if any. The service has
been running in production for years, now, and hasn't changed in a
while. It hasn't crashed, hasn't broken any integrations, hasn't gotten
anyone paged at 3am. It's fairly clean, decoupled from most everything
else, and hasn't needed fixes. It should be just fine."

Great!

Right?

# 2.

> If you want your software to be flexible, you have to flex it.
>
> - Uncle Bob, _The Clean Coder_

We've been working on a "from-scratch" rewrite against horrid legacy
systems nobody dares to touch. It sounds like a classic software horror
story, the second-system effect (this is actually the _fifth_ system by
my count), but it's coming along fairly well (if at a slog). The
previous systems were written to specific contracts (and then maladapted
to others); this one's intended from the ground up as a proper product.

One of the newer developers on the team claims it's the best code he's
ever seen. And honestly, I'm pretty damn proud of what we've done in a
complex domain in which even the customers often don't know what they
want.

We're constantly comparing the new system against the olds, looking for
discrepancies between the two (some of which matter, some of which are
the olds being absurd). We're looking for a minimal subset of features
needed to migrate the next chunk of clients from the olds to the new.

_We're constantly in the codebase, changing shit, often making major
refactorings._

# 3.

I dug up the code for the service I'll be inheriting. True to claim, it
hasn't been touched in a _while._

It's not that it's _bad_ code. It's not a three-thousand-line VB.NET
monstrosity with a single thousand-line god method in the middle. (Given
the context, that god's probably Azathoth.) It's well-factored into your
usual layer-cake architecture. The names mean things.

But, well... it's obvious that it hasn't benefitted from what the
company's collectively learned in the years since it was architected.

For example, it relies on reflection, and ORM, and other tools that
seemed so promising until we found that they were great ways to turn
compile-time type errors into runtime exceptions. Not in monstrous ways;
as advertised, its uptime record is stellar. And I expect it will be, as
long as nothing changes. When it does, we'll hope the NHibernate
mappings are adequately tested.

None of this is to disparage the system's authors; they're people I
respect and admire. I respect and admire them because, among other
things,  they _never stop learning how to write better code._

# 4.

If you're constantly in a service's codebase, you're _constantly_
finding opportunities to make it a little bit better. "Leave the
campsite cleaner than you found it." (Praise that in code reviews, by
the way, don't shit on people who make "unnecessary" changes that
improve the whole.)

You're constantly in a position to look at a gnarly piece of code and
shout "aha!" as you get an idea of how to improve it. Maybe that idea
doesn't work out, but it plants a seed in your mind. Maybe you jot down
some notes on your idea in the company wiki. Maybe your colleague reads
those notes.

You're constantly bothered by the parts of the code that are full of
pain and suck and fail. You're constantly spending emotional effort
trying to be patient because they're not part of the ticket you're
working on. One day you run out of patience and fix the fucking thing.
(Make a painful task frequent enough and it will be made less painful,
with a baseball bat if nothing else. "HP LOAD LETTER"? What the _fuck._)

Slowly, slowly, the codebase is incorporating everything that you're
learning about the domain, everything that you're learning about where
the business wants the domain to go in the future, and everything that
you're learning about how to write great code.

# 5.

We have services, in production, that we don't even know how to _build_
any more. At least, not at a company level. The guy who knows is on
vacation.

But they're stable! They almost _never_ cause trouble!

Hmm.

# 6.

I came across a thought experiment (which I can't find in a quick
google) in which every feature branch you opened deleted itself after
twenty-four hours.

"Oh fuck, that's horrible! So much time spent in re-work!"

Really? If I spent a day working on a feature branch, it would probably
take me an hour or two to reiterate the previous day's work. Okay, "time
wasted", but I'd probably do a better job along the way because I'd be
seeing the problem for a second time. That gives me four or five hours
to do _new_ work; more, if my company's not obnoxious about meetings.

Not really that much of a difference, is it?

People often see refactoring as re-work, but that ignores the benefit of
reviewing - re- _viewing_ - the code with fresh eyes and more knowledge.
Of having the opportunity to incorporate that new knowledge into the
codebase, be it a better understanding of the domain or just a better
understanding of that one library we're using.

# 7.

I'd like to say we've all heard of the Last Responsible Moment, but
experience dictates otherwise. Handwaving enormously, it suggests that
the longer we can wait before making a decision, and gather knowledge
relevant to that decision, the better a decision we'll make.

But we're always gathering knowledge. Often our customers are gathering
knowledge that makes them realize how different their requirements are
than what they put in the RFP. How do you know if your system is
flexible enough to accommodate their new understanding of what they
need?

Well, if you've been flexing it hard, up to your elbows in its guts, on
a regular basis, you probably have some idea.

Your product manager will be glad to hear that.
