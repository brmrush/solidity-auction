// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract OpenAuction {
    address payable public owner;
    uint public auctionStartTime;
    uint public auctionEndTime;
    uint private highestBid;
    bool public isAuctionLive;
    
    struct Bid {
        address bidder;
        uint bidAmount;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
    
    modifier auctionIsLive() {
        require(isAuctionLive  == true, "Auction is not live");
        _;
    }

    modifier auctionNotEnded() {
        require(block.timestamp > auctionEndTime, "Auction is over.");
        _;
    }

    modifier higherThanHighestBid() {
        require(msg.value > highestBid, "There's a higher bidder.");
        _;
    }


    constructor() payable {
        owner = payable(msg.sender);
        isAuctionLive = false;
    }

    event AuctionStarted(uint startTime, uint endTime);
    event AuctionEnded(uint endTime);
    event Bidded(address bidder, uint amount);

    function startAuction(uint _auctionDuration) onlyOwner() external {
        require(auctionEndTime != 0, "Auction end time is not set.");
        require(isAuctionLive == false, "Another auction is ongoing.");

        auctionStartTime = block.timestamp;
        auctionEndTime = block.timestamp + _auctionDuration;
        emit AuctionStarted(block.timestamp, block.timestamp + _auctionDuration);
        isAuctionLive = true;

    }
    //Getters
    //Not really needed because state variables are declared as public
    function getAuctionEndTime() auctionIsLive() external view returns(uint) {
        return auctionEndTime;
    }

    function getAuctionStartTime() auctionIsLive() external view returns(uint) {
        return auctionStartTime;
    }

    function getOwner() external view returns(address) {
        return owner;
    }
    //-----

    function bid() public payable auctionIsLive() auctionNotEnded() higherThanHighestBid() {
        
    }


}