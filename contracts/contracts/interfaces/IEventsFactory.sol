// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IEventsFactory {
    function createAuction() external;

    event CreateAuction(address auction);
}
