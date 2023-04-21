// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IZauktion {
  struct BidInfo {
    address bidder;
    uint256 bid;
  }

  function setAuction(
    uint256 _auctionId,
    uint256 _entraceStake,
    uint256 _bidDue,
    uint256 _revealDue,
    address _verifier,
    address _vault
  ) external;

  function bid(
    uint256 _y,
    uint256 _nullifier,
    uint256[2] memory _proof_a,
    uint256[2][2] memory _proof_b,
    uint256[2] memory _proof_c
  ) external payable;

  function revealBid(
    uint256 _y,
    uint256 _nullifier,
    uint256[2] memory _proof_a,
    uint256[2][2] memory _proof_b,
    uint256[2] memory _proof_c
  ) external;

  function revealWinner() external;

  function claimPrize() external payable;

  function claimStake() external;
}
