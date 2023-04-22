# Zauktion

## Pre requisites

* Install rust and [circom2](https://docs.circom.io/getting-started/installation/)

## Getting started

1. Clone or fork this template repository.
    ```shell
    git clone https://github.com/wanseob/zkp-app-boilerplate
    ```
2. Install packages
    ```shell
    yarn
    ```
3. Build: this compiles the circuits and exports artifacts. Then compiles the contracts and generate typescript clients.
    ```shell
    yarn build
    ```
4. Run a demo app using a localhost private network.
    ```shell
    yarn demo
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

3. Test your app
    ```shell
    yarn workspace app test
    ```


## Deployed Addresses
[EventsFactory.sol: 0x77E4c192b6ab081584aBB7d71E795663587f7324](https://blockscout.com/gnosis/chiado/address/0x77E4c192b6ab081584aBB7d71E795663587f7324#code)
[IdcheckVerifier.sol: 0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e](https://blockscout.com/gnosis/chiado/address/0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e#code)
[PepeCoin.sol: 0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a](https://blockscout.com/gnosis/chiado/address/0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a#code)
[Vault.sol: 0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39](https://blockscout.com/gnosis/chiado/address/0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39#code)
[ZauktionVerifier.sol: 0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57](https://blockscout.com/gnosis/chiado/address/0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57#code)
[Zauktion.sol: 0xA041E720821Fd1b89A645cE6f90cb29B9F4a3dC4](https://blockscout.com/gnosis/chiado/address/0xA041E720821Fd1b89A645cE6f90cb29B9F4a3dC4#code)