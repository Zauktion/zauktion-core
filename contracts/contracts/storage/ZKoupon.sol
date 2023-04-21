// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract ZKouponStorage {
    address internal verifier;
    address internal ticket;
    uint256 internal maxCoupon;
}
