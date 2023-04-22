// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// interfaces
import "../interfaces/IZauktion.sol";

abstract contract ZauktionStorage {
    uint256 internal auctionId;
    uint256 internal entraceStake;
    uint256 internal bidDue;
    uint256 internal revealDue;
    address internal auctionVerifier;
    address internal idVerifier;
    address internal prizeVault;

    uint256 internal finalBid;
    uint256 internal winnerCommitment;

    mapping(uint256 => uint256) public idCommitmentToWinnerCommitment;
    mapping(address => uint256) public yList;
    IZauktion.BidInfo[] public revealedBid;
}
