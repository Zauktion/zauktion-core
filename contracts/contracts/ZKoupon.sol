// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IZKoupon.sol";

// constants and types
import {ZKouponStorage} from "./storage/ZKoupon.sol";

interface ICouponVerifier {
    function verify(
        uint256[2] memory,
        uint256[2][2] memory,
        uint256[2] memory,
        uint256[2] memory
    ) external view returns (bool);
}

contract ZKoupon is ERC721A, Ownable, IZKoupon, ZKouponStorage {
    constructor(
        address _verifier,
        address _ticket,
        uint256 _maxCoupon
    ) ERC721A("ZKoupon", "ZKPON") {
        verifier = _verifier;
        ticket = _ticket;
        maxCoupon = _maxCoupon;
    }

    function issueCoupon(
        uint256 _commitment,
        uint256 _max,
        string memory _reason,
        DiscountType _discountType,
        uint256 _discountPerc,
        uint256 _expiryDate,
        bool _transferrable
    ) public override onlyOwner {
        couponList[_commitment] = CouponInfo(
            _max,
            _reason,
            _discountType,
            _discountPerc,
            _expiryDate,
            _transferrable,
            0
        );
    }

    function redeemCoupon(
        uint256 _commitment,
        uint256 _nullifier,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) public override {
        require(!nullifierCheck[_nullifier], "The Coupon is used");
        require(
            couponList[_commitment].maxAmount > 0,
            "The Coupon doesn't exist"
        );
        require(
            couponList[_commitment].redeemed <=
                couponList[_commitment].maxAmount,
            "The coupon maxed out"
        );
        require(
            ICouponVerifier(verifier).verify(
                _proof_a,
                _proof_b,
                _proof_c,
                [_commitment, _nullifier]
            ),
            "The Coupon is not valid"
        );
        nullifierCheck[_nullifier] = true;
        couponList[_commitment].redeemed++;
        tokenIdToCommitment[_nextTokenId()] = _commitment;
        _safeMint(msg.sender, 1);
    }

    function burnFromTicket(uint256 tokenId) external virtual override {
        if (msg.sender != ticket) {
            revert("Only ticket could burn the coupon.");
        }
        _burn(tokenId);
    }

    function getCommitmentFromTokenId(
        uint256 _tokenId
    ) external view override returns (uint256) {
        return tokenIdToCommitment[_tokenId];
    }

    function getCouponInfoWithCommitment(
        uint256 _commitment
    ) external view override returns (CouponInfo memory) {
        return couponList[_commitment];
    }

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override {
        uint256 couponCommitment = tokenIdToCommitment[startTokenId];
        if (to != address(0) && !couponList[couponCommitment].transferable) {
            revert("The Coupon can not be transfered.");
        }
    }
}
