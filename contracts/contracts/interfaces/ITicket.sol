// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ITicket {
  function setCoupon(address _coupon) external;

  function mintWithoutCoupon() external payable;

  function mintWithCoupon(uint256 _couponTokenId) external payable;
}
