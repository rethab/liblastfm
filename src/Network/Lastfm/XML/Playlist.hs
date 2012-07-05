{-# LANGUAGE TemplateHaskell #-}
-- | Playlist API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.XML.Playlist
  ( addTrack, create
  ) where

#include "playlist.docs"

import Network.Lastfm.Internal
import qualified Network.Lastfm.API.Playlist as API

$(xml ["addTrack", "create"])

__addTrack__
addTrack ∷ Playlist → Artist → Track → APIKey → SessionKey → Secret → Lastfm Response

__create__
create ∷ Maybe Title → Maybe Description → APIKey → SessionKey → Secret → Lastfm Response
