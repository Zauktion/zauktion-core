# ZauKtion
ZauKtion is our hackathon project with the purpose of making an on-chain auction process where the bids and bidders remain unknown and the auction is carried out in a trustless process.

## Pre requisites

* Install rust and [circom2](https://docs.circom.io/getting-started/installation/)

## Getting started

1. Clone or fork this template repository.
    ```shell
    git clone https://github.com/Zauktion/zauktion-core
    ```
2. Install packages
    ```shell
    yarn
    ```
3. Build: this compiles the circuits and exports artifacts. Then compiles the contracts and generate typescript clients.
    ```shell
    yarn build
    ```

## Run tests
1. Test contracts
    ```shell
    yarn workspace contracts test
    ```

2. Test your circuits
    ```shell
    yarn workspace circuits test
    ```

## Deployed Addresses
[EventsFactory.sol: 0x77E4c192b6ab081584aBB7d71E795663587f7324](https://blockscout.com/gnosis/chiado/address/0x77E4c192b6ab081584aBB7d71E795663587f7324#code)
[IdcheckVerifier.sol: 0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e](https://blockscout.com/gnosis/chiado/address/0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e#code)
[PepeCoin.sol: 0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a](https://blockscout.com/gnosis/chiado/address/0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a#code)
[Vault.sol: 0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39](https://blockscout.com/gnosis/chiado/address/0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39#code)
[ZauktionVerifier.sol: 0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57](https://blockscout.com/gnosis/chiado/address/0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57#code)
[Zauktion.sol: 0xF03A8aeFA07f342231BEDc4A798035C5B65d8Fc0](https://blockscout.com/gnosis/chiado/address/0xF03A8aeFA07f342231BEDc4A798035C5B65d8Fc0#code)
