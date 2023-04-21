// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IZauktion.sol";
import "./interfaces/IVault.sol";

// constants and types
import { ZauktionStorage } from "./storage/Zauktion.sol";

interface IAuctionVerifier {
  function verify(
    uint256[2] memory,
    uint256[2][2] memory,
    uint256[2] memory,
    uint256[5] memory
  ) external view returns (bool);
}

contract Zauktion is Ownable, IZauktion, ZauktionStorage {
  function setAuction(
    uint256 _auctionId,
    uint256 _entraceStake,
    uint256 _bidDue,
    uint256 _revealDue,
    address _verifier,
    address _vault
  ) external override onlyOwner {
    auctionId = _auctionId;
    bidDue = _bidDue;
    revealDue = _revealDue;
    verifier = _verifier;
    entraceStake = _entraceStake;
    prizeVault = _vault;
  }

  function bid(
    uint256 _y,
    uint256 _nullifier,
    uint256[2] memory _proof_a,
    uint256[2][2] memory _proof_b,
    uint256[2] memory _proof_c
  ) external payable override {
    if (block.timestamp > bidDue) revert();

    if (msg.value < entraceStake) revert();

    if (
      !IAuctionVerifier(verifier).verify(
        _proof_a,
        _proof_b,
        _proof_c,
        [uint256(uint160(address(msg.sender))), auctionId, 1, _y, _nullifier]
      )
    ) {
      revert();
    }
    yList[msg.sender] = _y;
  }

  function revealBid(
    uint256 _y,
    uint256 _nullifier,
    uint256[2] memory _proof_a,
    uint256[2][2] memory _proof_b,
    uint256[2] memory _proof_c
  ) external override {
    if (block.timestamp > revealDue) revert();

    if (
      !IAuctionVerifier(verifier).verify(
        _proof_a,
        _proof_b,
        _proof_c,
        [uint256(uint160(address(msg.sender))), auctionId, 2, _y, _nullifier]
      )
    ) {
      revert();
    }
    uint256 prevY = yList[msg.sender];
    uint256 a1 = _y - prevY;
    uint256 a0 = prevY - a1;
    // store everyones bid;
    revealedBid.push(BidInfo(msg.sender, a0));
    revealed[msg.sender] = true;
  }

  function revealWinner() external override {
    if (block.timestamp < revealDue) revert();
    uint256 _max;
    address _winner;
    for (uint256 i = 0; i < revealedBid.length; ) {
      if (revealedBid[i].bid > _max) {
        _max = revealedBid[i].bid;
        _winner = revealedBid[i].bidder;
      }
      unchecked {
        i++;
      }
    }
    finalBid = _max;
    winner = _winner;
    winnerRevealed = true;
  }

  function claimPrize() external payable override {
    if (!winnerRevealed) revert();
    // check if winner is revealed
    if (winner == address(0)) revert();
    // check if winner is msg.sender
    if (msg.sender != winner) revert();
    // check if msg.value is bigger than finalBid
    if (msg.value < finalBid) revert();
    // transfer money
    IVault(prizeVault).transferOwnership(msg.sender);
    prizeClaimed = true;
  }

  function claimStake() external override {
    if (!prizeClaimed) revert();
    // check if winner
    if (msg.sender != winner) revert();
    if (!revealed[msg.sender]) revert();
    // transfer the stake back
    (bool success, ) = msg.sender.call{ value: entraceStake }("");
    require(success, "Transfer failed.");
  }
}
