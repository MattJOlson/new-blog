---
title: Previewing a post in Hakyll
---

I still don't have a great idea of what I want to do, aesthetically, with
this blog. That's not so bad, it gives me room to mess around and try things,
and one of the things I wanted to try is a fairly compact front page with a
preview of the latest post, a few links to recent posts, and pointers into
the archives. I implemented the first this afternoon, and I thought I'd
write about it.

> Yes, I'm aware that Hakyll supports `teaser` text with `<!-- more -->` 
> comments. Where's the fun in that?

My first stop was [Rebecca Skinner's blog repo](https://github.com/rebeccaskinner/rebeccaskinner.github.io),
because I browsed it while I was first trying to figure out Hakyll and
remembered that she'd done something similar. I started with her approach of
decorating each post with a field holding the preview. Here's where I ended
up, which isn't far off from what she wrote:

```haskell
postCtx :: Context String
postCtx = mconcat
    [ dateField "date" "%B %e, %Y"
    , field "description" previewBody
    , defaultContext
    ]

previewBody :: Item String -> Compiler String
previewBody Item {..} = do
    rawBody <- loadSnapshotBody itemIdentifier "postPreTemplate"
    pure $ unwords . take 100 . words $ rawBody
```

I'm a bit fuzzy yet about how intermediate results are organized, but here
we've taken a snapshot of each post mid-compliation - this one's called
`"postPreTemplate"` - and we're pulling it off an `Item` (such as a blog post)
and taking the first hundred words. Well, we're telling Hakyll how to do that
to make a field named `"description"`, given an `Item`, by providing a function
`previewBody` to do that.

That snapshot gets taken while we're compiling the posts:

```haskell
match "posts/*" $ do
    route $ setExtension "html"
    compile $ pandocCompiler'
        >>= saveSnapshot "postPreTemplate"
        >>= loadAndApplyTemplate "templates/post.html"    postCtx
        >>= saveSnapshot "content"
        >>= loadAndApplyTemplate "templates/default.html" postCtx
        >>= relativizeUrls
```

Actually we have a couple of snapshots here: One right after running the
Pandoc compiler (where we get our post's text) and one after applying the
`post.html` template (which we pipe to an RSS feed later - did you know this
blog has an RSS feed now? check the footer). That gives us different
intermediate representations of the final page for different contexts.

So this is all well and good, but how does it get used? I made a number of
different attempts at pulling the first post off the list when compiling the
index page, pulling _this_ attribute off and putting it over _here_ while
_that_ attribute had to go over _there_, and generally playing type tetris.
In the process I learned a fair bit about Hakyll. I also had a couple of the
promised moments where it didn't _matter_ what `Compiler` or `Item` meant,
I just needed the `String` inside and `fmap` works just fine.

In the end, though, I'm not showing you any of that code because I threw it all
away. I decided it was better to make processing the preview post and the other
listed posts as similar as possible. So I did this in the `index` path:

```haskell
match "index.markdown" $ do
    route $ setExtension "html"
    compile $ do
        posts <- recentFirst =<< loadAll "posts/*"

        let indexCtx = mconcat
                [ listField "posts" postCtx
                    (pure $ tail posts)
                , listField "firstPosts" postCtx 
                    (pure $ take 1 posts)
                , defaultContext
                ]

        pandocCompiler'
            >>= applyAsTemplate indexCtx
            >>= loadAndApplyTemplate "templates/default.html"
                    indexCtx
            >>= relativizeUrls
```

Pretty good, although the names might need work. Believe me when I say this
looks a _lot_ cleaner than some of my intermediate attempts.

All that's left is to do something with that `"firstPosts"` list. My index
markdown now has a couple partial templates in it:

```markdown
## Latest:
$partial("templates/post-preview.html")$

## Other Posts
$partial("templates/post-list.html")$
```

The last piece of the puzzle is the `post-preview.html` partial, which works
a lot like `post-list.html` except it uses the `"description"` field and adds
the "read more" link

```html
$for(firstPosts)$
<div class="post-summary pl-8">
<h2><a href="$url$">$title$</a></h2>
<div class="postDescription">
  $description$ ...<a href="$url$"><strong><em>read more</em></strong></a>
</div>
</div>
$endfor$
```

For a finishing touch, I struggled a bit getting Pandoc's syntax highlighting
to play nicely with Tailwind before borrowing from [Leo Orpilla III's](https://github.com/ldgrp/ldgrp.github.io)
Hakyll repo - another source of reference and inspiration since he's also
using Tailwind.

Next, I'll probably play around with the colour scheme, and add tags as I post
more. Longer-term I'd like to add short-name linking (e.g. linking to this post
as `"previewing-a-post"` rather than the full path).

Writing code for a Hakyll blog is half the fun!