# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and we follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Fixed

### Removed

## [v1.0.0]

First tagged version after the fork from [the original repo](https://github.com/anton-k/purescript-cip30/).

### Added

- Newly introduced to CIP-30 `getExtensions` / `getSupportedExtensions`

### Changed

- Made `WalletName` a type synonym instead of newtype

### Fixed

### Removed

- Removed all mentions of particular wallets in the library. Any string can be passed for connection. There is no point in keeping the list of popular wallets within the library
