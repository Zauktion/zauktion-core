# ZauKtion
An on-chain auction system with privacy by implementing zero-knowledge proofs. In this system, bidders and their bid prices will be hidden, ensuring that only the winning bidder and their bid amount will be revealed after the end of the valid bidding period.

---

## Reproduction
### Prerequisites

* Install rust and [circom2](https://docs.circom.io/getting-started/installation/)

### Getting started

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

### Run tests
1. Test contracts with Proofs
    ```shell
    cd contracts/
    yarn hardhat test test/Proof.test.ts
    ```

## We Built
```
├── circuits
│   ├── zauktion.circom
│   ├── idcheck.circom
├── contracts
│   ├── IdcheckVerifier.sol
│   ├── ZauktionVerifier.sol
│   ├── Vault.sol
│   ├── PepeCoin.sol
│   ├── EventsFactory.sol
│   ├── Zauktion.sol
```

## Contract Flow
### Auction Host
1. To create an auction, call `createAuction()` in `EventsFactory.sol`. This deploys a new `Zauktion.sol` contract, with each contract representing a new auction.<br>
2. To set the parameters of the auction, call `setAuction()` in `Zauktion.sol`. These parameters include the bid due time, reveal due time, auction ID, auctionVerifier address, ID verifier address, and vault address.

### Auction Bidders
1. To participate in the auction, users can call the bid() function in Zauktion.sol. They must also submit proof information and earnest money to the contract. The contract will verify the proof and store the "y1" value, which will later be used to calculate the secret bid price. This process is inspired by RLN, which uses a polynomial to hide a secret and reveal it after a certain time. <br><br> **Checks:** <br> 1. Check if the bid due time has passed. <br> 2. Verify that the earnest money meets the entrance stake criteria. <br> 3. Verify that the proof is valid. <br><br>
2. After the bid due time, the user must submit another proof to reveal their secret bid price. The contract will verify the proof and use the "y2" value to calculate the secret bid price. <br><br> **Checks:** <br> 1. If the due time has passed, reveal the time limit. <br> 2. If the proof is valid <br><br>
3. Once the reveal period has ended, we will determine the winner by calling `revealWinner()` in `Zauktion.sol`. <br><br> **Checks:** <br> 1. If the time has passed reveal due time <br><br> 
4. Once we determine the winner, each bidder can reclaim their earnest money by calling `claimPrize()`. <br><br> **Checks:** <br> 1. If the winner has been decided <br> 2. If the user has submit the reveal proof <br> 3. Whether the user has not claimed the prize yet <br><br>

## Deployed Addresses
[EventsFactory.sol: 0x77E4c192b6ab081584aBB7d71E795663587f7324](https://blockscout.com/gnosis/chiado/address/0x77E4c192b6ab081584aBB7d71E795663587f7324#code) <br>
[IdcheckVerifier.sol: 0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e](https://blockscout.com/gnosis/chiado/address/0x1F63A23BedC45EE169166Ff2fB3c484EF845D03e#code) <br>
[PepeCoin.sol: 0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a](https://blockscout.com/gnosis/chiado/address/0x96332840c5Aa2F2F52C5ad60EeAaa9f72D795a0a#code) <br>
[Vault.sol: 0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39](https://blockscout.com/gnosis/chiado/address/0x2Fa4e52a9D72f329958a555bc5edE5a360Df1c39#code) <br>
[ZauktionVerifier.sol: 0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57](https://blockscout.com/gnosis/chiado/address/0xB6Ed48cf9f1EDf5298cd6FE5257c92B28bC22f57#code) <br>
[Zauktion.sol: 0x6134fB1B9BDf76596F05851686F19c2c0A85CEe8](https://blockscout.com/gnosis/chiado/address/0x6134fB1B9BDf76596F05851686F19c2c0A85CEe8#code) <br>
