// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IEventsFactory {
    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _maxTickets,
        uint256 _maxCoupons
    ) external;
}
