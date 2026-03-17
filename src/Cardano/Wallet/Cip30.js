"use strict";

export const _getWalletApi = walletName => extensions => () =>
  window.cardano[walletName].enable({ extensions: extensions.slice() });

export const _isEnabled = walletName => () =>
  window.cardano[walletName].isEnabled();

export const getApiVersion = walletName => () =>
  window.cardano[walletName].apiVersion;

export const getName = walletName => () => window.cardano[walletName].name;

export const getIcon = walletName => () => window.cardano[walletName].icon;

export const getSupportedExtensions = walletName => () =>
  window.cardano[walletName].supportedExtensions;

export const _getExtensions = api => () => api.getExtensions();
export const _getBalance = api => () => api.getBalance();
export const _getChangeAddress = api => () => api.getChangeAddress();
export const _getCollateral = api => amount => () => {
  amount = typeof amount === "undefined" ? undefined : { amount };
  if (typeof api.getCollateral === "function") {
    return api.getCollateral(amount);
  } else if (typeof api.experimental.getCollateral === "function") {
    // nami provides getCollateral under `experimental`
    return api.experimental.getCollateral(amount);
  } else {
    throw "CIP-30 getCollateral not supported!";
  }
};
export const _getNetworkId = api => () => api.getNetworkId();
export const _getRewardAddresses = api => () => api.getRewardAddresses();
export const _getUnusedAddresses = api => () => api.getUnusedAddresses();
export const _getUsedAddresses = api => page => () =>
  api.getUsedAddresses(page);
export const _signTx = api => tx => partial => () => api.signTx(tx, partial);
export const _getUtxos = api => amount => paginate => () =>
  api.getUtxos(amount, paginate);
export const _signData = api => addr => payload => () =>
  api.signData(addr, payload);
export const _submitTx = api => tx => () => api.submitTx(tx);

export const isWalletAvailable = walletName => () =>
  typeof window.cardano != "undefined" &&
  typeof window.cardano[walletName] != "undefined" &&
  typeof window.cardano[walletName].apiVersion != "undefined" &&
  typeof window.cardano[walletName].enable == "function";

export const allWalletTags = () =>
  typeof window.cardano != "undefined"
    ? Object.keys(window.cardano).filter(
        tag => typeof window.cardano[tag] == "object"
      )
    : [];
