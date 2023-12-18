-- | Interact with the wallet over CIP-30 interface
-- | description: https://cips.cardano.org/cips/cip30/
-- |
-- | Code works by inspection of `window.cardano` object which should be
-- | injected by the wallet to the window.
module Cardano.Wallet.Cip30
  ( Bytes
  , Cbor
  , Cip30Connection
  , Cip30DataSignature
  , NetworkId
  , Paginate
  , WalletName
  , enable
  , getApiVersion
  , getName
  , getIcon
  , isEnabled
  , isWalletAvailable
  , getBalance
  , getChangeAddress
  , getCollateral
  , getNetworkId
  , getRewardAddresses
  , getUnusedAddresses
  , getUsedAddresses
  , getUtxos
  , signTx
  , signData
  , submitTx
  , getAvailableWallets
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Array (filterA)
import Data.Maybe (Maybe, fromMaybe, maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Aff (Aff)
import Literals.Undefined (undefined)
import Untagged.Union (UndefinedOr, asOneOf)

type Bytes = String
type Cbor = String
type NetworkId = Int
type WalletName = String

type Paginate =
  { limit :: Int
  , page :: Int
  }

foreign import data Cip30Connection :: Type

type Cip30DataSignature =
  { key :: Cbor
  , signature :: Cbor
  }

-- | Enables wallet and reads Cip30 wallet API if wallet is available
enable :: WalletName -> Aff Cip30Connection
enable walletName = toAffE (_getWalletApi walletName)

getBalance :: Cip30Connection -> Aff Cbor
getBalance api = toAffE (_getBalance api)

getChangeAddress :: Cip30Connection -> Aff Cbor
getChangeAddress api = toAffE (_getChangeAddress api)

getCollateral :: Cip30Connection -> Cbor -> Aff (Maybe (Array Cbor))
getCollateral api amount =
  Nullable.toMaybe <$> toAffE (_getCollateral api amount)

getNetworkId :: Cip30Connection -> Aff NetworkId
getNetworkId api = toAffE (_getNetworkId api)

getRewardAddresses :: Cip30Connection -> Aff (Array Cbor)
getRewardAddresses api = toAffE (_getRewardAddresses api)

getUnusedAddresses :: Cip30Connection -> Aff (Array Cbor)
getUnusedAddresses api = toAffE (_getUnusedAddresses api)

getUsedAddresses :: Cip30Connection -> Maybe Paginate -> Aff (Array Cbor)
getUsedAddresses api paginate =
  toAffE (_getUsedAddresses api (maybe (asOneOf undefined) asOneOf paginate))

getUtxos :: Cip30Connection -> Maybe Paginate -> Aff (Array Cbor)
getUtxos api mPaginate =
  fromMaybe [] <<< Nullable.toMaybe
    <$> toAffE (_getUtxos api (maybe (asOneOf undefined) asOneOf mPaginate))

signTx :: Cip30Connection -> Cbor -> Boolean -> Aff Cbor
signTx api tx isPartialSign = toAffE (_signTx api tx isPartialSign)

signData :: Cip30Connection -> Cbor -> Bytes -> Aff Cip30DataSignature
signData api addr payload = toAffE (_signData api addr payload)

submitTx :: Cip30Connection -> Cbor -> Aff String
submitTx api tx = toAffE (_submitTx api tx)

-- | Checks weather wallet is enabled.
isEnabled :: WalletName -> Aff Boolean
isEnabled = toAffE <<< _isEnabled

------------------------------------------------------------------------------------
-- common wallet names

-- | Reads all wallets that are available in the browser.
getAvailableWallets :: Effect (Array WalletName)
getAvailableWallets =
  allWallets >>= \wallets -> filterA isWalletAvailable wallets

-- | Get all available wallets.
allWallets :: Effect (Array WalletName)
allWallets = allWalletTags

------------------------------------------------------------------------------------
-- FFI

foreign import _getBalance :: Cip30Connection -> Effect (Promise Cbor)
foreign import _getChangeAddress :: Cip30Connection -> Effect (Promise Cbor)
foreign import _getCollateral :: Cip30Connection -> Cbor -> Effect (Promise (Nullable (Array Cbor)))
foreign import _getNetworkId :: Cip30Connection -> Effect (Promise NetworkId)
foreign import _getRewardAddresses :: Cip30Connection -> Effect (Promise (Array Cbor))
foreign import _getUnusedAddresses :: Cip30Connection -> Effect (Promise (Array Cbor))
foreign import _getUsedAddresses :: Cip30Connection -> UndefinedOr Paginate -> Effect (Promise (Array Cbor))
foreign import _getUtxos :: Cip30Connection -> UndefinedOr Paginate -> Effect (Promise (Nullable (Array Cbor)))
foreign import _signTx :: Cip30Connection -> Cbor -> Boolean -> Effect (Promise Cbor)
foreign import _signData :: Cip30Connection -> Cbor -> Bytes -> Effect (Promise Cip30DataSignature)
foreign import _isEnabled :: WalletName -> Effect (Promise Boolean)
foreign import _submitTx :: Cip30Connection -> Cbor -> Effect (Promise String)
foreign import _getWalletApi :: WalletName -> Effect (Promise Cip30Connection)
foreign import getApiVersion :: WalletName -> Effect String
foreign import getName :: WalletName -> Effect String
foreign import getIcon :: WalletName -> Effect String
foreign import isWalletAvailable :: WalletName -> Effect Boolean
foreign import allWalletTags :: Effect (Array WalletName)
