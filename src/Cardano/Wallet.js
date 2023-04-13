"use strict";

exports._getWalletApi = walletName => () => 
  window.cardano[walletName].enable();

exports._isEnabled = walletName => () => 
  window.cardano[walletName].isEnabled();

exports._getBalance = api => () => api.getBalance();
exports._getChangeAddress = api => () => api.getChangeAddress();
exports._getCollateral = api => params => () => api.getCollateral(params);
exports._getNetworkId = api => () => api.getNetworkId();
exports._getRewardAddresses = api => () => api.getRewardAddresses();
exports._getUnusedAddresses = api => () => api.getUnusedAddresses();
exports._getUsedAddresses = api => page => () => api.getUsedAddresses(page);
exports._signTx = api => tx => partial => () => api.signTx(tx, partial);
exports._signData = api => addr => payload => () => api.signData(addr, payload);
exports._getUtxos = api => paginate => () => api.getUtxos(paginate);
exports._submitTx = api => tx => () => api.submitTx(tx.to_hex());

exports.isWalletAvailable = walletName => () =>
   typeof window.cardano != "undefined" &&
   typeof window.cardano[walletName] != "undefined" &&
   typeof window.cardano[walletName].enable == "function";
