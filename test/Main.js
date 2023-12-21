export const getWallet = () => {
    return prompt("which wallet to connect to? e.g. 'nami', 'gerowallet'") ||
        (() => { throw "Failed to get wallet name"; })();
};
