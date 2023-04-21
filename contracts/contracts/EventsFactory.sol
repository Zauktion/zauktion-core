// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "./Ticket.sol";
import "./ZKoupon.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IEventsFactory.sol";
import "./interfaces/ITicket.sol";
import "./interfaces/IZKoupon.sol";

// constants and types
import {EventsFactoryStorage} from "./storage/EventsFactory.sol";

contract EventsFactory is Ownable, IEventsFactory, EventsFactoryStorage {

    function setVerifier(address _verifier) external onlyOwner {
        verifier = _verifier;
    }

    function createEvent(
        string memory _name,
        string memory _description,
        uint256 _maxTickets,
        uint256 _maxCoupons
    ) external override {
        // create Ticket contract
        Ticket ticket = new Ticket(_maxTickets);
        // create ZKoupon contract, pass Ticket address in constructor
        ZKoupon coupon = new ZKoupon(verifier, address(ticket), _maxCoupons);
        // transferOwnership() to event owner
        coupon.transferOwnership(msg.sender);
        ticket.transferOwnership(msg.sender);
        // write Tickets.sol address to ZKoupon
        ticket.setCoupon(address(coupon));
    }
}
