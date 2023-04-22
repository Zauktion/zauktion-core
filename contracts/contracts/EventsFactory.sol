// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "./Ticket.sol";
import "./ZKoupon.sol";
import "./Zauktion.sol";
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
        if (events[_name].ticket != address(0)) revert("Event already exists");
        // create Ticket contract
        Ticket ticket = new Ticket(_maxTickets);
        // create ZKoupon contract, pass Ticket address in constructor
        ZKoupon coupon = new ZKoupon(verifier, address(ticket), _maxCoupons);
        // transferOwnership() to event owner
        coupon.transferOwnership(msg.sender);
        ticket.transferOwnership(msg.sender);
        // write Tickets.sol address to ZKoupon
        ticket.setCoupon(address(coupon));
        events[_name] = EventInfo(
            _description,
            _maxTickets,
            _maxCoupons,
            address(ticket),
            address(coupon)
        );
        emit CreateEvent(address(ticket), address(coupon));
    }

    function createAuction() external override {
        // create Auction contract
        Zauktion auction = new Zauktion();
        // transferOwnership() to event owner
        auction.transferOwnership(msg.sender);
        emit CreateAuction(address(auction));
    }
}
