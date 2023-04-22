// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IZKoupon {
    enum DiscountType {
        Percentage,
        Amount
    }
    struct CouponInfo {
        uint256 maxAmount;
        string reason;
        DiscountType discountType;
        uint256 discountPerc;
        uint256 expiryDate;
        bool transferable;
        uint256 redeemed; // TBD
    }

    function issueCoupon(
        uint256 _commitment,
        uint256 _max,
        string memory _reason,
        DiscountType _discountType,
        uint256 _discountPerc,
        uint256 _expiryDate,
        bool _transferrable
    ) external;

    function redeemCoupon(
        uint256 _commitment,
        uint256 _nullifier,
        uint256[2] memory _proof_a,
        uint256[2][2] memory _proof_b,
        uint256[2] memory _proof_c
    ) external;

    function getCommitmentFromTokenId(
        uint256 _tokenId
    ) external view returns (uint256);

    function getCouponInfoWithCommitment(
        uint256 _commitment
    ) external view returns (CouponInfo memory);

    function burnFromTicket(uint256 _tokenId) external;
}
