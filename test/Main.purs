module Test.Main where

import Prelude

import Cardano.Wallet.Cip30 (WalletName, enable, getUsedAddresses, getUtxos)
import Data.Maybe (Maybe(Just, Nothing))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (log)

-- | This test suite must be bundled and run in the browser.
main :: Effect Unit
main = launchAff_ do
  walletName <- liftEffect getWallet
  api <- enable walletName []
  do
    utxos <- getUtxos api Nothing Nothing
    log $ "getUtxos(): " <> show utxos
  do
    utxos <- getUtxos api Nothing (Just { limit: 3, page: 0 })
    log $ "getUtxos(undefined, { limit: 3, page: 0}): " <> show utxos
  do
    -- 182a = hex(value of 42 lovelace)
    utxos <- getUtxos api (Just "182a") Nothing
    log $ "getUtxos(\"182a\", { limit: 3, page: 0}): " <> show utxos
  do
    -- 182a = hex(value of 42 lovelace)
    utxos <- getUtxos api (Just "182a") (Just { limit: 3, page: 0 })
    log $ "getUtxos(\"182a\", { limit: 3, page: 0}): " <> show utxos
  do
    addrs <- getUsedAddresses api Nothing
    log $ "getUsedAddresses(): " <> show addrs
  do
    addrs <- getUsedAddresses api $ Just { limit: 3, page: 0 }
    log $ "getUsedAddresses({ limit: 3, page: 0 }): " <> show addrs
  pure unit

foreign import getWallet :: Effect WalletName
