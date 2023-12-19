Purescript interface to Cardano Wallets over CIP-30
=========================================================

Implements PureScript FFI wrappers to the [CIP-30 wallet interface](https://cips.cardano.org/cip/CIP-0030).

CIP-30 defines an interface for the `cardano` object that is injected into the browser `window`.

Note that it takes some time for wallet extensions to inject the object so it might be beneficial to add a small delay before your first function invocation to interact with the wallet.

Use this library in pair with [`cardano-serialisation-lib`](https://github.com/Emurgo/cardano-serialization-lib/) (use `to_hex`/`from_hex` methods). PureScript wrapper is also available [here](github.com/mlabs-haskell/purescript-cardano-serialization-lib).

This repo is a fork of the library [originally written by Anton Kholomiov](https://github.com/anton-k/purescript-cip30/).
