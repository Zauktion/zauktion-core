// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../interfaces/IZKoupon.sol";

abstract contract ZKouponStorage {
    address internal verifier;
    address internal ticket;
    uint256 internal maxCoupon;
    // tokenID to commitment
    mapping(uint256 => uint256) internal tokenIdToCommitment;
    // commitment to info map
    mapping(uint256 => IZKoupon.CouponInfo) internal couponList;
    mapping(uint256 => bool) internal nullifierCheck;
}
