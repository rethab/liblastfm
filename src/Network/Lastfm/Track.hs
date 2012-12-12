{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}
-- | Lastfm track API
--
-- This module is intended to be imported qualified:
--
-- @
-- import qualified Network.Lastfm.Track as Track
-- @
module Network.Lastfm.Track
  ( addTags, ban, getBuyLinks, getBuyLinks_mbid, getCorrection, getFingerprintMetadata
  , getInfo, getInfo_mbid, getShouts, getShouts_mbid, getSimilar
  , getSimilar_mbid, getTags, getTags_mbid, getTopFans, getTopFans_mbid
  , getTopTags, getTopTags_mbid, love, removeTag, scrobble
  , search, share, unban, unlove, updateNowPlaying
  ) where

import Data.Monoid ((<>))

import Network.Lastfm.Request


-- | Tag a track using a list of user supplied tags.
--
-- <http://www.last.fm/api/show/track.addTags>
addTags ∷ Artist → Track → [Tag] → Request RequireSign f
addTags a t ts = api "track.addTags" <> artist a <> track t <> tags ts <> post


-- | Ban a track for a given user profile.
--
-- <http://www.last.fm/api/show/track.ban>
ban ∷ Artist → Track → Request RequireSign f
ban a t = api "track.ban" <> artist a <> track t <> post


getBuyLinks ∷ Artist → Track → Country → Request Ready f
getBuyLinks a t c = api "track.getBuyLinks" <> artist a <> track t <> country c

-- | Get a list of Buy Links for a particular track.
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/track.getBuylinks>
getBuyLinks_mbid ∷ MBID → Country → Request Ready f
getBuyLinks_mbid m c = api "track.getBuyLinks" <> mbid m <> country c


-- | Use the last.fm corrections data to check whether
-- the supplied track has a correction to a canonical track.
--
-- <http://www.last.fm/api/show/track.getCorrection>
getCorrection ∷ Artist → Track → Request Ready f
getCorrection a t = api "track.getCorrection" <> artist a <> track t


-- | Retrieve track metadata associated with a fingerprint id
-- generated by the Last.fm Fingerprinter. Returns track
-- elements, along with a 'rank' value between 0 and 1 reflecting the confidence for each match.
--
-- <http://www.last.fm/api/show/track.getFingerprintMetadata>
getFingerprintMetadata ∷ Fingerprint → Request Ready f
getFingerprintMetadata f = api "track.getFingerprintMetadata" <> fingerprint f


getInfo ∷ Artist → Track → Request Ready f
getInfo a t = api "track.getInfo" <> artist a <> track t

-- | Get the metadata for a track on Last.fm.
--
-- Optional: 'autocorrect', 'username'
--
-- <http://www.last.fm/api/show/track.getInfo>
getInfo_mbid ∷ MBID → Request Ready f
getInfo_mbid m = api "track.getInfo" <> mbid m


getShouts ∷ Artist → Track → Request Ready f
getShouts a t = api "track.getShouts" <> artist a <> track t

-- | Get shouts for this track. Also available as an rss feed.
--
-- Optional: 'autocorrect', 'limit', 'page'
--
-- <http://www.last.fm/api/show/track.getShouts>
getShouts_mbid ∷ MBID → Request Ready f
getShouts_mbid m = api "track.getShouts" <> mbid m


getSimilar ∷ Artist → Track → Request Ready f
getSimilar a t = api "track.getSimilar" <> artist a <> track t

-- | Get the similar tracks for this track on Last.fm, based on listening data.
--
-- Optional: 'autocorrect', 'limit'
--
-- <http://www.last.fm/api/show/track.getSimilar>
getSimilar_mbid ∷ MBID → Request Ready f
getSimilar_mbid m = api "track.getSimilar" <> mbid m


getTags ∷ Artist → Track → User → Request Ready f
getTags a t u = api "track.getTags" <> artist a <> track t <> user u

-- | Get the tags applied by an individual user to a track on Last.fm.
--
-- Optional: 'autocorrect', 'user'
--
-- <http://www.last.fm/api/show/track.getTags>
getTags_mbid ∷ MBID → User → Request Ready f
getTags_mbid m u = api "track.getTags" <> mbid m <> user u


getTopFans ∷ Artist → Track → Request Ready f
getTopFans a t = api "track.getTopFans" <> artist a <> track t

-- | Get the top fans for this track on Last.fm, based on listening data.
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/track.getTopFans>
getTopFans_mbid ∷ MBID → Request Ready f
getTopFans_mbid m = api "track.getTopFans" <> mbid m


getTopTags ∷ Artist → Track → Request Ready f
getTopTags a t = api "track.getTopTags" <> artist a <> track t

-- | Get the top tags for this track on Last.fm, ordered by tag count.
--
-- Optional: 'autocorrect'
--
-- <http://www.last.fm/api/show/track.getTopTags>
getTopTags_mbid ∷ MBID → Request Ready f
getTopTags_mbid m = api "track.getTopTags" <> mbid m


-- | Love a track for a user profile.
--
-- <http://www.last.fm/api/show/track.love>
love ∷ Artist → Track → Request RequireSign f
love a t = api "track.love" <> artist a <> track t <> post


-- | Remove a user's tag from a track.
--
-- <http://www.last.fm/api/show/track.removeTag>
removeTag ∷ Artist → Track → Tag → Request RequireSign f
removeTag a tr t = api "track.removeTag" <> artist a <> track tr <> tag t <> post


-- | Used to add a track-play to a user's profile.
--
-- Optional: 'album', 'albumArtist', 'chosenByUser', 'context',
-- 'duration', 'mbid', 'streamId', 'trackNumber'
--
-- <http://www.last.fm/api/show/track.scrobble>
scrobble ∷ Artist → Track → Timestamp → Request RequireSign f
scrobble a tr ts = api "track.scrobble" <> artist a <> track tr <> timestamp ts <> post


-- | Search for a track by track name. Returns track matches sorted by relevance.
--
-- Optional: 'artist', 'limit', 'page'
--
-- <http://www.last.fm/api/show/track.search>
search ∷ Track → Request Ready f
search t = api "track.search" <> track t


-- | Share a track twith one or more Last.fm users or other friends.
--
-- Optional: 'public', 'message', 'recipient'
--
-- <http://www.last.fm/api/show/track.share>
share ∷ Artist → Track → Recipient → Request RequireSign f
share a t r = api "track.share" <> artist a <> track t <> recipient r <> post


-- | Unban a track for a user profile.
--
-- <http://www.last.fm/api/show/track.unban>
unban ∷ Artist → Track → Request RequireSign f
unban a t = api "track.unban" <> artist a <> track t <> post


-- | Unlove a track for a user profile.
--
-- <http://www.last.fm/api/show/track.unlove>
unlove ∷ Artist → Track → Request RequireSign f
unlove a t = api "track.unlove" <> artist a <> track t <> post


-- | Used to notify Last.fm that a user has started listening
-- to a track. Parameter names are case sensitive.
--
-- Optional: 'album', 'albumArtist', 'context',
-- 'duration', 'mbid', 'trackNumber'
--
-- <http://www.last.fm/api/show/track.updateNowPlaying>
updateNowPlaying ∷ Artist → Track → Request RequireSign f
updateNowPlaying a t = api "track.updateNowPlaying" <> artist a <> track t <> post