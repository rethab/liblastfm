{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Network.Lastfm.Venue
  ( Venue(..), FestivalsOnly(..), Page(..), Limit(..), Country(..)
  , getEvents, getPastEvents, search
  ) where

import Network.Lastfm.Auth (APIKey)
import Network.Lastfm.Core

newtype Venue = Venue String deriving (Show, LastfmValue)
newtype FestivalsOnly = FestivalsOnly Bool deriving (Show, LastfmValue)
newtype Page = Page Int deriving (Show, LastfmValue)
newtype Limit = Limit Int deriving (Show, LastfmValue)
newtype Country = Country String deriving (Show, LastfmValue)

getEvents :: Venue -> Maybe FestivalsOnly -> APIKey -> IO Response
getEvents venue festivalsOnly apiKey = callAPI "venue.getEvents" $
  [ "venue" ?< venue
  , "api_key" ?< apiKey
  ] ++ optional
    [ "festivalsonly" ?<< festivalsOnly
    ]

getPastEvents :: Venue -> Maybe FestivalsOnly -> Maybe Page -> Maybe Limit -> APIKey -> IO Response
getPastEvents venue festivalsOnly page limit apiKey = callAPI "venue.getPastEvents" $
  [ "venue" ?< venue
  , "api_key" ?< apiKey
  ] ++ optional
    [ "festivalsonly" ?<< festivalsOnly
    , "page" ?<< page
    , "limit" ?<< limit
    ]

search :: Venue -> Maybe Page -> Maybe Limit -> Maybe Country -> APIKey -> IO Response
search venue page limit country apiKey = callAPI "venue.search" $
  [ "venue" ?< venue
  , "api_key" ?< apiKey
  ] ++ optional
    [ "page" ?<< page
    , "limit" ?<< limit
    , "country" ?<< country
    ]
