// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "./Zauktion.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IEventsFactory.sol";
import "./interfaces/ITicket.sol";

// constants and types
import {EventsFactoryStorage} from "./storage/EventsFactory.sol";

contract EventsFactory is Ownable, IEventsFactory, EventsFactoryStorage {
    function createAuction() external override {
        // create Auction contract
        Zauktion auction = new Zauktion();
        // transferOwnership() to event owner
        auction.transferOwnership(msg.sender);
        emit CreateAuction(address(auction));
    }
}
