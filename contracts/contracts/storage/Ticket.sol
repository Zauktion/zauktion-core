// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

abstract contract TicketStorage {
  address internal coupon;
  uint256 internal maxTicket;
  uint256 internal price;
}
