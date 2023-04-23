// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IZauktion.sol";
import "./interfaces/IVault.sol";

// constants and types
import {ZauktionStorage} from "./storage/Zauktion.sol";

interface IIdVerifier {
    function verifyProof(
        uint256[2] memory,
        uint256[2][2] memory,
        uint256[2] memory,
        uint256[2] memory
    ) external view returns (bool);
}

interface IAuctionVerifier {
    function verifyProof(
        uint256[2] memory,
        uint256[2][2] memory,
        uint256[2] memory,
        uint256[6] memory
    ) external view returns (bool);
}

contract Zauktion is Ownable, IZauktion, ZauktionStorage {
    function setAuction(
        uint256 _auctionId,
        uint256 _entraceStake,
        uint256 _bidDue,
        uint256 _revealDue,
        address _auctionVerifier,
        address _idVerifier,
        address _vault
    ) external override onlyOwner {
        auctionId = _auctionId;
        bidDue = _bidDue;
        revealDue = _revealDue;
        auctionVerifier = _auctionVerifier;
        idVerifier = _idVerifier;
        entraceStake = _entraceStake;
        prizeVault = _vault;
    }

    function bid(
        uint256 _y,
        uint256 _nullifier,
        uint256 _idCommitment,
        uint256 _winningCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external payable override {
        if (block.timestamp > bidDue) revert("Overdue");

        if (msg.value < entraceStake) revert("Not Enough Stake");

        if (
            !IAuctionVerifier(auctionVerifier).verifyProof(
                _proof_a,
                _proof_b,
                _proof_c,
                [
                    1,
                    auctionId,
                    _y,
                    _nullifier,
                    _idCommitment,
                    _winningCommitment
                ]
            )
        ) {
            revert("Proof Failed");
        }
        yList[_idCommitment] = _y;
    }

    function revealBid(
        uint256 _y,
        uint256 _nullifier,
        uint256 _idCommitment,
        uint256 _winningCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external override {
        if (block.timestamp > revealDue) revert("Overdue");
        if (
            !IAuctionVerifier(auctionVerifier).verifyProof(
                _proof_a,
                _proof_b,
                _proof_c,
                [
                    2,
                    auctionId,
                    _y,
                    _nullifier,
                    _idCommitment,
                    _winningCommitment
                ]
            )
        ) {
            revert("Proof Failed");
        }

        uint256 prevY = yList[_idCommitment];
        uint256 a1 = _y - prevY;
        uint256 a0 = prevY - a1;
        // store everyones bid;
        revealedBid.push(BidInfo(a0, _winningCommitment));
        idCommitmentToWinnerCommitment[_idCommitment] = _winningCommitment;
    }

    function revealWinner() external override {
        if (block.timestamp < revealDue) revert();
        uint256 _max;
        uint256 _winner;
        for (uint256 i = 0; i < revealedBid.length; ) {
            if (revealedBid[i].bid > _max) {
                _max = revealedBid[i].bid;
                _winner = revealedBid[i].winningCommitment;
            }
            unchecked {
                i++;
            }
        }
        finalBid = _max;
        winnerCommitment = _winner;
    }

    function claimPrize(
        uint256 _idCommitment,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external payable override {
        if (winnerCommitment == 0) revert("Winner Not Revealed Yet");
        if (idCommitmentClaimed[_idCommitment]) revert("Already Claimed");
        uint256 _winnerCommitment = idCommitmentToWinnerCommitment[
            _idCommitment
        ];
        if (
            !IIdVerifier(idVerifier).verifyProof(
                _proof_a,
                _proof_b,
                _proof_c,
                [_idCommitment, _winnerCommitment]
            )
        ) {
            revert("Proof Failed");
        }

        if (_winnerCommitment == winnerCommitment) {
            // check if msg.value is bigger than finalBid
            if (msg.value < finalBid) revert("You Should Pay More");
            // transfer money
            IVault(prizeVault).transferOwnership(msg.sender);
        }
        idCommitmentClaimed[_idCommitment] = true;

        // transfer the stake back
        (bool success, ) = msg.sender.call{value: entraceStake}("");
        require(success, "Transfer failed.");
    }
}
