-- | Interact with the wallet over CIP-30 interface
-- | description: https://cips.cardano.org/cip/CIP-0030
-- |
-- | Code works by inspection of `window.cardano` object which should be
-- | injected by the wallet to the window.
module Cardano.Wallet.Cip30
  ( Bytes
  , Cbor
  , Api
  , DataSignature
  , Extension
  , NetworkId
  , Paginate
  , WalletName
  , enable
  , getApiVersion
  , getAvailableWallets
  , getBalance
  , getChangeAddress
  , getCollateral
  , getExtensions
  , getIcon
  , getName
  , getNetworkId
  , getRewardAddresses
  , getSupportedExtensions
  , getUnusedAddresses
  , getUsedAddresses
  , getUtxos
  , isEnabled
  , isWalletAvailable
  , signData
  , signTx
  , submitTx
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Data.Array (filterA)
import Data.Maybe (Maybe, maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Aff (Aff)
import Literals.Undefined (undefined)
import Untagged.Union (UndefinedOr, asOneOf)

-- | A datatype representing a CIP-30 connection object.
foreign import data Api :: Type

type Bytes = String
type Cbor = String
type NetworkId = Int
type WalletName = String
type Extension = { cip :: Int }

type Paginate =
  { limit :: Int
  , page :: Int
  }

type DataSignature =
  { key :: Cbor
  , signature :: Cbor
  }

-- | Enables wallet and reads Cip30 wallet API if wallet is available
enable :: WalletName -> Array Extension -> Aff Api
enable walletName exts = toAffE (_getWalletApi walletName exts)

getExtensions :: Api -> Aff (Array Extension)
getExtensions api = toAffE (_getExtensions api)

getNetworkId :: Api -> Aff NetworkId
getNetworkId api = toAffE (_getNetworkId api)

getUtxos :: Api -> Maybe Cbor -> Maybe Paginate -> Aff (Maybe (Array Cbor))
getUtxos api mAmount mPaginate =
  Nullable.toMaybe
    <$> toAffE (_getUtxos api amount paginate)
  where
    amount = maybe (asOneOf undefined) asOneOf mAmount
    paginate = (maybe (asOneOf undefined) asOneOf mPaginate)

getCollateral :: Api -> Cbor -> Aff (Maybe (Array Cbor))
getCollateral api amount =
  Nullable.toMaybe <$> toAffE (_getCollateral api amount)

getBalance :: Api -> Aff Cbor
getBalance api = toAffE (_getBalance api)

getUsedAddresses :: Api -> Maybe Paginate -> Aff (Array Cbor)
getUsedAddresses api paginate =
  toAffE (_getUsedAddresses api (maybe (asOneOf undefined) asOneOf paginate))

getUnusedAddresses :: Api -> Aff (Array Cbor)
getUnusedAddresses api = toAffE (_getUnusedAddresses api)

getChangeAddress :: Api -> Aff Cbor
getChangeAddress api = toAffE (_getChangeAddress api)

getRewardAddresses :: Api -> Aff (Array Cbor)
getRewardAddresses api = toAffE (_getRewardAddresses api)

signTx :: Api -> Cbor -> Boolean -> Aff Cbor
signTx api tx isPartialSign = toAffE (_signTx api tx isPartialSign)

signData :: Api -> Cbor -> Bytes -> Aff DataSignature
signData api addr payload = toAffE (_signData api addr payload)

submitTx :: Api -> Cbor -> Aff String
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

foreign import _getExtensions :: Api -> Effect (Promise (Array Extension))
foreign import _getBalance :: Api -> Effect (Promise Cbor)
foreign import _getChangeAddress :: Api -> Effect (Promise Cbor)
foreign import _getCollateral :: Api -> Cbor -> Effect (Promise (Nullable (Array Cbor)))
foreign import _getNetworkId :: Api -> Effect (Promise NetworkId)
foreign import _getRewardAddresses :: Api -> Effect (Promise (Array Cbor))
foreign import _getUnusedAddresses :: Api -> Effect (Promise (Array Cbor))
foreign import _getUsedAddresses :: Api -> UndefinedOr Paginate -> Effect (Promise (Array Cbor))
foreign import _getUtxos :: Api -> UndefinedOr Cbor -> UndefinedOr Paginate -> Effect (Promise (Nullable (Array Cbor)))
foreign import _signTx :: Api -> Cbor -> Boolean -> Effect (Promise Cbor)
foreign import _signData :: Api -> Cbor -> Bytes -> Effect (Promise DataSignature)
foreign import _isEnabled :: WalletName -> Effect (Promise Boolean)
foreign import _submitTx :: Api -> Cbor -> Effect (Promise String)
foreign import _getWalletApi :: WalletName -> Array Extension -> Effect (Promise Api)
foreign import getApiVersion :: WalletName -> Effect String
foreign import getName :: WalletName -> Effect String
foreign import getIcon :: WalletName -> Effect String
foreign import getSupportedExtensions :: WalletName -> Effect (Array Extension)
foreign import isWalletAvailable :: WalletName -> Effect Boolean
foreign import allWalletTags :: Effect (Array WalletName)
