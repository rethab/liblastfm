-- | Track API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.Track
  ( addTags, ban, getBuyLinks, getCorrection, getFingerprintMetadata
  , getInfo, getShouts, getSimilar, getTags, getTopFans, getTopTags
  , love, removeTag, scrobble, search, share, unban, unlove, updateNowPlaying
  ) where

import Control.Arrow ((|||))
import Control.Exception (throw)
import Control.Monad (void)

import Network.Lastfm.Response
import Network.Lastfm.Types ( (?<), Album, AlbumArtist, APIKey, Artist, Autocorrect, ChosenByUser, Context, Country
                            , Duration, Fingerprint, Limit, Mbid, Message, Page, Public, Recipient, SessionKey
                            , StreamId, Tag, Timestamp, Track, TrackNumber, User
                            )

-- | Tag a track using a list of user supplied tags.
--
-- More: <http://www.lastfm.ru/api/show/track.addTags>
addTags :: Artist -> Track -> [Tag] -> APIKey -> SessionKey -> Lastfm ()
addTags artist track tags apiKey sessionKey = dispatch go
  where go
          | null tags        = throw $ WrapperCallError method "empty tag list."
          | length tags > 10 = throw $ WrapperCallError method "tag list length has exceeded maximum."
          | otherwise        = void $ callAPI method
            [ "artist" ?< artist
            , "track" ?< track
            , "tags" ?< tags
            , "api_key" ?< apiKey
            , "sk" ?< sessionKey
            ]
            where method = "track.addTags"

-- | Ban a track for a given user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.ban>
ban :: Artist -> Track -> APIKey -> SessionKey -> Lastfm ()
ban artist track apiKey sessionKey = dispatch . void . callAPI "track.ban" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Get a list of Buy Links for a particular track.
--
-- More: <http://www.lastfm.ru/api/show/track.getBuylinks>
getBuyLinks :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Country -> APIKey -> Lastfm Response
getBuyLinks a autocorrect country apiKey = dispatch . callAPI "track.getBuyLinks" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "country" ?< country
  , "api_key" ?< apiKey
  ]

-- | Use the last.fm corrections data to check whether the supplied track has a correction to a canonical track.
--
-- More: <http://www.lastfm.ru/api/show/track.getCorrection>
getCorrection :: Artist -> Track -> APIKey -> Lastfm Response
getCorrection artist track apiKey = dispatch . callAPI "track.getCorrection" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  ]

-- | Retrieve track metadata associated with a fingerprint id generated by the Last.fm Fingerprinter. Returns track elements, along with a 'rank' value between 0 and 1 reflecting the confidence for each match.
--
-- More: <http://www.lastfm.ru/api/show/track.getFingerprintMetadata>
getFingerprintMetadata :: Fingerprint -> APIKey -> Lastfm Response
getFingerprintMetadata fingerprint apiKey = dispatch . callAPI "track.getFingerprintMetadata" $
  [ "fingerprintid" ?< fingerprint
  , "api_key" ?< apiKey
  ]

-- | Get the metadata for a track on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/track.getInfo>
getInfo :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe User -> APIKey -> Lastfm Response
getInfo a autocorrect username apiKey = dispatch . callAPI "track.getInfo" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "username" ?< username
  , "api_key" ?< apiKey
  ]

-- | Get shouts for this track. Also available as an rss feed.
--
-- More: <http://www.lastfm.ru/api/show/track.getShouts>
getShouts :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getShouts a autocorrect page limit apiKey = dispatch . callAPI "track.getShouts" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "page" ?< page
  , "limit" ?< limit
  , "api_key" ?< apiKey
  ]

-- | Get the similar tracks for this track on Last.fm, based on listening data.
--
-- More: <http://www.lastfm.ru/api/show/track.getSimilar>
getSimilar :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe Limit -> APIKey -> Lastfm Response
getSimilar a autocorrect limit apiKey = dispatch . callAPI "track.getSimilar" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "limit" ?< limit
  , "api_key" ?< apiKey
  ]

-- | Get the tags applied by an individual user to a track on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/track.getTags>
getTags :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Either User SessionKey -> APIKey -> Lastfm Response
getTags a autocorrect b apiKey = dispatch . callAPI "track.getTags" $
  target a ++
  auth b ++
  [ "autocorrect" ?< autocorrect
  , "api_key" ?< apiKey
  ]

-- | Get the top fans for this track on Last.fm, based on listening data.
--
-- More: <http://www.lastfm.ru/api/show/track.getTopFans>
getTopFans :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> APIKey -> Lastfm Response
getTopFans a autocorrect apiKey = dispatch . callAPI "track.getTopFans" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "api_key" ?< apiKey
  ]

-- | Get the top tags for this track on Last.fm, ordered by tag count.
--
-- More: <http://www.lastfm.ru/api/show/track.getTopTags>
getTopTags :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> APIKey -> Lastfm Response
getTopTags a autocorrect apiKey = dispatch . callAPI "track.getTopTags" $
  target a ++
  [ "autocorrect" ?< autocorrect
  , "api_key" ?< apiKey
  ]

-- | Love a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.love>
love :: Artist -> Track -> APIKey -> SessionKey -> Lastfm ()
love artist track apiKey sessionKey = dispatch . void . callAPI "track.love" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Remove a user's tag from a track.
--
-- More: <http://www.lastfm.ru/api/show/track.removeTag>
removeTag :: Artist -> Track -> Tag -> APIKey -> SessionKey -> Lastfm ()
removeTag artist track tag apiKey sessionKey = dispatch . void . callAPI "track.removeTag" $
  [ "artist" ?< artist
  , "track" ?< track
  , "tag" ?< tag
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Used to add a track-play to a user's profile.
--
-- More; <http://www.lastfm.ru/api/show/track.scrobble>
scrobble :: ( Timestamp, Maybe Album, Artist, Track, Maybe AlbumArtist
           , Maybe Duration, Maybe StreamId, Maybe ChosenByUser
           , Maybe Context, Maybe TrackNumber, Maybe Mbid )
         -> APIKey
         -> SessionKey
         -> Lastfm ()
scrobble (timestamp, album, artist, track, albumArtist, duration, streamId, chosenByUser, context, trackNumber, mbid) apiKey sessionKey = dispatch . void . callAPI "track.scrobble" $
  [ "timestamp" ?< timestamp
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  , "album" ?< album
  , "albumArtist" ?< albumArtist
  , "duration" ?< duration
  , "streamId" ?< streamId
  , "chosenByUser" ?< chosenByUser
  , "context" ?< context
  , "trackNumber" ?< trackNumber
  , "mbid" ?< mbid
  ]

-- | Search for a track by track name. Returns track matches sorted by relevance.
--
-- More: <http://www.lastfm.ru/api/show/track.search>
search :: Track -> Maybe Page -> Maybe Limit -> Maybe Artist -> APIKey -> Lastfm Response
search limit page track artist apiKey = dispatch . callAPI "track.search" $
  [ "track" ?< track
  , "page" ?< page
  , "limit" ?< limit
  , "artist" ?< artist
  , "api_key" ?< apiKey
  ]

-- | Share a track twith one or more Last.fm users or other friends.
--
-- More: <http://www.lastfm.ru/api/show/track.share>
share :: Artist -> Track -> [Recipient] -> Maybe Message -> Maybe Public -> APIKey -> SessionKey -> Lastfm ()
share artist track recipients message public apiKey sessionKey = dispatch go
  where go
          | null recipients        = throw $ WrapperCallError method "empty recipient list."
          | length recipients > 10 = throw $ WrapperCallError method "recipient list length has exceeded maximum."
          | otherwise              = void $ callAPI method
            [ "artist" ?< artist
            , "track" ?< track
            , "recipient" ?< recipients
            , "api_key" ?< apiKey
            , "sk" ?< sessionKey
            , "public" ?< public
            , "message" ?< message
            ]
            where method = "track.share"

-- | Unban a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.unban>
unban :: Artist -> Track -> APIKey -> SessionKey -> Lastfm ()
unban artist track apiKey sessionKey = dispatch . void . callAPI "track.unban" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Unlove a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.unlove>
unlove :: Artist -> Track -> APIKey -> SessionKey -> Lastfm ()
unlove artist track apiKey sessionKey = dispatch . void . callAPI "track.unlove" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]


-- | Used to notify Last.fm that a user has started listening to a track. Parameter names are case sensitive.
--
-- More: <http://www.lastfm.ru/api/show/track.updateNowPlaying>
updateNowPlaying :: Artist
                 -> Track
                 -> Maybe Album
                 -> Maybe AlbumArtist
                 -> Maybe Context
                 -> Maybe TrackNumber
                 -> Maybe Mbid
                 -> Maybe Duration
                 -> APIKey
                 -> SessionKey
                 -> Lastfm ()
updateNowPlaying artist track album albumArtist context trackNumber mbid duration apiKey sessionKey = dispatch . void . callAPI "track.updateNowPlaying" $
  [ "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  , "album" ?< album
  , "albumArtist" ?< albumArtist
  , "context" ?< context
  , "trackNumber" ?< trackNumber
  , "mbid" ?< mbid
  , "duration" ?< duration
  ]

target :: Either (Artist, Track) Mbid -> [(String, String)]
target = (\(artist, track) -> ["artist" ?< artist, "track" ?< track]) ||| return . ("mbid" ?<)

auth :: Either User SessionKey -> [(String, String)]
auth = return . ("user" ?<) ||| return . ("sessionKey" ?<)
