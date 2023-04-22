// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IZauktion {
    struct BidInfo {
        uint256 bid;
        uint256 winningCommitment;
    }

    function setAuction(
        uint256 _auctionId,
        uint256 _entraceStake,
        uint256 _bidDue,
        uint256 _revealDue,
        address _auctionVerifier,
        address _idVerifier,
        address _vault
    ) external;

    function bid(
        uint256 _y,
        uint256 _nullifier,
        uint256 _idCommitment,
        uint256 _winningCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external payable;

    function revealBid(
        uint256 _y,
        uint256 _nullifier,
        uint256 _idCommitment,
        uint256 _winningCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external;

    function revealWinner() external;

    function claimPrize(
        uint256 _idCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external payable;
}
