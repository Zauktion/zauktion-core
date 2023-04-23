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
1. Test contracts with Proofs
    ```shell
    cd contracts/
    yarn hardhat test test/Proof.test.ts
    ```

## Deployed Addresses
[EventsFactory.sol: 0x77E4c192b6ab081584aBB7d71E795663587f7324](https://blockscout.com/gnosis/chiado/address/0x77E4c192b6ab081584aBB7d71E795663587f7324#code) <br>
[IdcheckVerifier.sol: 0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e](https://blockscout.com/gnosis/chiado/address/0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e#code) <br>
[PepeCoin.sol: 0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a](https://blockscout.com/gnosis/chiado/address/0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a#code) <br>
[Vault.sol: 0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39](https://blockscout.com/gnosis/chiado/address/0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39#code) <br>
[ZauktionVerifier.sol: 0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57](https://blockscout.com/gnosis/chiado/address/0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57#code) <br>
[Zauktion.sol: 0xA041E720821Fd1b89A645cE6f90cb29B9F4a3dC4](https://blockscout.com/gnosis/chiado/address/0xA041E720821Fd1b89A645cE6f90cb29B9F4a3dC4#code) <br>