// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// imported contracts and libraries
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/IERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// interfaces
import "./interfaces/IZKoupon.sol";
import "./interfaces/ITicket.sol";

// constants and types
import {TicketStorage} from "./storage/Ticket.sol";

contract Ticket is ERC721A, Ownable, ITicket, TicketStorage {
    constructor(uint256 _maxTicket) ERC721A("Ticket", "TICKET") {
        maxTicket = _maxTicket;
    }

    function setCoupon(address _coupon) external override onlyOwner {
        coupon = _coupon;
    }

    function mintWithoutCoupon() public payable override {
        if (totalSupply() + 1 > maxTicket) {
            revert("Max ticket reached");
        }
        if (msg.value < price) {
            revert("Incorrect price");
        }
        _safeMint(msg.sender, 1);
    }

    function mintWithCoupon(uint256 _couponTokenId) public payable override {
        // check if max exceed
        if (totalSupply() + 1 > maxTicket) {
            revert("Max ticket reached");
        }
        // check if own specific coupon token
        if (msg.sender != IERC721A(coupon).ownerOf(_couponTokenId)) {
            revert("Not owner of coupon");
        }
        // calculate discount
        uint256 couponCommitment = IZKoupon(coupon).getCommitmentFromTokenId(
            _couponTokenId
        );
        // get coupon info with couponCommitment
        IZKoupon.CouponInfo memory couponInfo = IZKoupon(coupon)
            .getCouponInfoWithCommitment(couponCommitment);
        // calculate the discount
        uint256 discount = couponInfo.discountPerc;
        uint256 calPrice = price;
        if (couponInfo.discountType == IZKoupon.DiscountType.Percentage) {
            calPrice = (price * (100 - discount)) / 100;
        } else if (couponInfo.discountType == IZKoupon.DiscountType.Amount) {
            calPrice = price - discount;
        }
        if (msg.value < calPrice) {
            revert("Incorrect price");
        }
        // burn coupon
        IZKoupon(coupon).burnFromTicket(_couponTokenId);
        // mint
        _safeMint(msg.sender, 1);
    }
}
