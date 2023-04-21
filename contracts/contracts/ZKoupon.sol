// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface IVerifier{
    function verify(uint256[2] memory, uint256[2][2] memory, uint256[2] memory, uint256[2] memory) external view returns (bool);
}

contract Zkoupon is ERC721A, Ownable {
    
    IVerifier verifier;
    address ticket;
    
    constructor(address _verifier, address _ticket) ERC721A("Zkoupon", "ZPon") {
        verifier = IVerifier(_verifier);
        ticket = _ticket;
    }
    
    // tokenID to commitment
    mapping(uint256 => uint256) tokenIdToCommitment;
    // commitment to info map
    mapping(uint256 => CouponInfo) couponList;
    mapping(uint256 => bool) nullifierCheck; 

    enum DiscountType {
        Percentage,
        Amount
    }

    struct CouponInfo {
        uint256 maxAmount;
        string reason;
        DiscountType discountType;
        uint256 discountPerc;
        uint256 expiryDate;
        bool transferable;
        uint256 redeemed; // TBD
    }

    function issueCoupon(
        uint256 _commitment, 
        uint256 _max,
        string memory _reason,
        DiscountType _discountType,
        uint256 _discountPerc,
        uint256 _expiryDate,
        bool _transferrable) public onlyOwner {
            couponList[_commitment] = CouponInfo(
                _max,
                _reason,
                _discountType,
                _discountPerc,
                _expiryDate,
                _transferrable,
                0
            );
        }
    
    function redeemCoupon(
        uint256 _commitment,
        uint256 _nullifier,
        uint256[2] memory proof_a,
        uint256[2][2] memory proof_b,
        uint256[2] memory proof_c
    ) public {
        require(!nullifierCheck[_nullifier], "The Coupon is used");
        require(couponList[_commitment].maxAmount>0, "The Coupon doesn't exist");
        require(couponList[_commitment].redeemed<=couponList[_commitment].maxAmount, "The coupon maxed out");
        require(verifier.verify(proof_a, proof_b, proof_c, [_commitment, _nullifier]), "The Coupon is not valid");
        nullifierCheck[_nullifier] = true;
        couponList[_commitment].redeemed++;
        tokenIdToCommitment[_nextTokenId()] = _commitment;
        _safeMint(msg.sender, 1);
    }
    
    function _beforeTokenTransfers(
        address from, 
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override {
        if(to!=address(0) && !couponList[firstTokenId].transferable){
            revert("The Coupon can not be transfered.");
        }
    }

    function burnFromTicket(uint256 tokenId) external virtual{
        require(msg.sender==ticket, "Only ticket could burn the coupon.");
        _burn(tokenId);
    }

}
