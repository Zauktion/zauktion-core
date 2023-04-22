// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// interfaces
import "../interfaces/IZauktion.sol";

abstract contract ZauktionStorage {
    uint256 public auctionId;
    uint256 public entraceStake;
    uint256 public bidDue;
    uint256 public revealDue;
    address public auctionVerifier;
    address public idVerifier;
    address public prizeVault;

    uint256 public finalBid;
    uint256 public winnerCommitment;

    mapping(uint256 => uint256) public idCommitmentToWinnerCommitment;
    mapping(uint256 => uint256) public yList;
    IZauktion.BidInfo[] public revealedBid;
}
