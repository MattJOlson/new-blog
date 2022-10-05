------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
import Data.Monoid (mappend)
import Hakyll
import Text.Pandoc.Highlighting (Style, styleToCss)
import Text.Pandoc.Options (ReaderOptions (..), WriterOptions (..))

------------------------------------------------------------------------

pandocCompiler' :: Compiler (Item String)
pandocCompiler' =
  pandocCompilerWith
    defaultHakyllReaderOptions
    defaultHakyllWriterOptions

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler'
            >>= loadAndApplyTemplate "templates/default.html" 
                defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler'
            >>= saveSnapshot "postPreTemplate"
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx = mconcat
                    [ listField "posts" postCtx (return posts)
                    , constField "title" "Archives"
                    , defaultContext
                    ]

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" 
                    archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" 
                    archiveCtx
                >>= relativizeUrls


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

    match "templates/*" $ compile templateBodyCompiler

    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx <> bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderRss feedConfig feedCtx posts


------------------------------------------------------------------------
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

feedConfig :: FeedConfiguration
feedConfig = FeedConfiguration
    { feedTitle = "Audax Labs"
    , feedDescription =
        "A short sturdy weblog, fond of food and industry"
    , feedAuthorName = "Matt Olson"
    , feedRoot = "https://blog.audax-labs.com"
    }