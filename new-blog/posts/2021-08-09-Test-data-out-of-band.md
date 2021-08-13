---
title: "Test data semiotics: pull it \"out of band\""
---

One of the nice things about the standard sum types is that they can give you a
lot of explicitness. In a `Maybe String`, `Nothing` is pretty unambiguous;
there ain't no string there. By comparison, `Just ""` is also unambiguous; it's
an empty string, not (for example) the default value a JSON parser spat out to
populate a missing field. The `Maybe` part is in a sense out of band of the
`String` part, and that makes it easier to reason about it separately.

By contrast, in a language without sum types you're often forced to carve off
part of a type's values to represent things like "not there". For example, in C
the `printf` function returns the number of characters printed, or a negative
integer to represent failure. An uninitialized `int` in C# will be `0`, just the
same as an `int` you deliberately initialized to `0`. (You could make it a
nullable `int` if you wanted, I suppose.)

There's a parallel problem with test data: Often only some of it is germane to
the test you're writing. Most of us aren't testing a delightfully expressive
algebra that lets us construct a precise probe of the logic we want to nail
down -- most of us have to write some boilerplate. _Make that boilerplate
obviously irrelevant._ Do what you can to pull it mentally "out of band".

An example is in order. Suppose I'm testing some functionality on widgets, and
a widget looks like this:

```haskell
data Widget = Widget
  { modelNumber :: Integer
  , modelName :: Text
  , colour :: Colour
  , ignitionTemperature :: Integer -- degrees Fahrenheit
  , cheeseCapacity :: Integer -- cubic inches
  }
```

In particular, suppose I'm writing some tests around error handling when a
widget runs out of cheese. _Everything else is irrelevant._ I know this, as I'm
writing the tests, but you, dear reader, who might need to reference my tests
when I'm on vacation, might _not._

So what I can do here is create a test data template with obviously nonsensical
values, which'll tell you that they're only there to satisfy the compiler and
aren't relevant to the test you're reading. For example:

```haskell
dummyWidget :: Widget
dummyWidget = Widget
  { modelNumber = -31337
  , modelName = "I'm a model name!"
  , colour = CornflowerBlue -- uh oh! We'll come back to this
  , ignitionTemperature = -451 -- uh oh! This too
  , cheeseCapacity = -0xDECAFBAD
  }
```

Text fields are easiest to deal with. I like a convention of `"I'm a (name of
the text field)!"` because it a) tells you what you're looking at in console
output and b) probably isn't remotely representative of anything you're likely
to stuff into that field in production. `Lorem ipsum` is another good pattern,
as is basically anything that's likely to be instantly recognized as a meme by
your colleagues. (Recall that you might hire new colleagues who aren't familiar
with your meme canon, and plan appropriately.)

Numeric fields are a bit trickier, but there are some patterns you can reach
for. In the above example I've made them all negative, on the theory that you
will probably never have a negative model number. I've also made them memetic,
most recognizably `0xDECAFBAD` for `cheeseCapacity`. (For the record, I believe
that decaf has its place.) If you were an online teenager when I was, you've
probably already parsed `31337` as "elite".

Now, that `-451` for `ignitionTemperature` is just a _biiiit_ sketchy. The
intended connection was to Ray Bradbury's "Fahrenheit 451", but negated to make
it "clearly nonsensical". There's just one problem: -451F is a few degrees
above absolute zero, which makes it a (very theoretically) admissible ignition
temperature for your dummy widget. Someone reading my code who's just come from
the company's Hypercooled Computation division might look at that and wonder if
I'm testing special cases of cheese exhaustion under a liquid nitrogen blanket.
Better to use a different value.

The last field is `colour`, and while I'm making a to-me obvious _Fight Club_
reference it's entirely likely that we build and ship cornflower blue widgets.
If the `Colour` type is a union of, say, paint colours, it might not _have_ a
nonsensical value we can use here. I've never tried this and it would probably
be controversial, but you might design that `Colour` type with a built-in
nonsensical value, like `Octarine`, just for tests. Probably good to use as a
default in your ordering templates, too; if your automation runs off the rails
and orders ten million drums of Octarine paint from Dupli-Color you're going to
get a puzzled email, not an invoice.

Anyway, the theory is that I'll build a `dummyWidget` and then set whatever
fields I care about before I run it through the code I'm testing. In Haskell and
F# this can look like

```haskell
let sut = dummyWidget { cheeseCapacity = 50 }
-- ...
```

In C# I might have a fluent builder for it:

```C#
var sut = widget.With(() => cheeseCapacity(50));
```

That lets whoever's reading my test focus on the relevant bit.