// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IEventsFactory {
  struct EventInfo {
    string description;
    uint256 maxTickets;
    uint256 maxCoupons;
    address ticket;
    address coupon;
  }

  function createEvent(
    string memory _name,
    string memory _description,
    uint256 _maxTickets,
    uint256 _maxCoupons
  ) external;

  function createAuction() external;

  event CreateEvent(address ticket, address coupon);
  event CreateAuction(address auction);
}
