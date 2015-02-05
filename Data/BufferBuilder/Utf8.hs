{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Data.BufferBuilder.Utf8 where

import           Control.Applicative
import           Data.ByteString (ByteString)
import           Data.BufferBuilder (BufferBuilder)
import qualified Data.BufferBuilder as BB
import           Data.Text (Text)
import           Data.Text.Encoding (encodeUtf8)

newtype Utf8Builder a = Utf8Builder { unBuilder :: BufferBuilder a }
    deriving (Functor, Monad)

instance Applicative Utf8Builder where
    pure = return
    left <*> right = do
        f <- left
        a <- right
        return (f a)

runUtf8Builder :: Utf8Builder () -> ByteString
runUtf8Builder a = BB.runBufferBuilder $ unBuilder a
{-# INLINE runUtf8Builder #-}

unsafeAppendBS :: ByteString -> Utf8Builder ()
unsafeAppendBS a = Utf8Builder $ BB.appendBS a
{-# INLINE unsafeAppendBS #-}

appendText :: Text -> Utf8Builder ()
appendText a = Utf8Builder $ BB.appendBS $ encodeUtf8 a
{-# INLINE appendText #-}

appendChar8 :: Char -> Utf8Builder ()
appendChar8 a = Utf8Builder $ BB.appendChar8 a
{-# INLINE appendChar8 #-}

appendEscapedJson :: ByteString -> Utf8Builder ()
appendEscapedJson a = Utf8Builder $ BB.appendEscapedJson a
{-# INLINE appendEscapedJson #-}

appendDecimalSignedInt :: Int -> Utf8Builder ()
appendDecimalSignedInt a = Utf8Builder $ BB.appendDecimalSignedInt a
{-# INLINE appendDecimalSignedInt #-}

appendDecimalDouble :: Double -> Utf8Builder ()
appendDecimalDouble d = Utf8Builder $ BB.appendDecimalDouble d
{-# INLINE appendDecimalDouble #-}