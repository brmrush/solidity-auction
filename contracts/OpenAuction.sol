// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract OpenAuction {
    address payable public owner;
    uint public auctionStartTime;
    uint public auctionEndTime;
    
    struct Bid {
        address bidder;
        uint bidAmount;
    }

    Bid highestBid;

    Bid[] allBids;


    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    modifier auctionNotEnded() {
        require(block.timestamp < auctionEndTime, "Auction is over or not started.");
        _;
    }

    modifier higherThanHighestBid() {
        require(msg.value > highestBid.bidAmount, "There's a higher bidder.");
        _;
    }


    constructor() payable {
        owner = payable(msg.sender);
    }

    event AuctionStarted(uint startTime, uint endTime);
    event AuctionEnded(uint endTime);
    event NewBid(address bidder, uint amount);

    function startAuction(uint _auctionDuration) onlyOwner() external {

        auctionStartTime = block.timestamp;
        auctionEndTime = block.timestamp + _auctionDuration;
        emit AuctionStarted(block.timestamp, block.timestamp + _auctionDuration);

    }


    function bid() public payable auctionNotEnded() higherThanHighestBid() {
        // Modifiers make sure that auction is currently live and
        // bid amount is higher than the highest bid
        // So we write the rest of the logic

        Bid memory newBid = Bid(msg.sender, msg.value);
        allBids.push(newBid);
        highestBid = newBid;
        emit NewBid(msg.sender, msg.value);
    }


    //lower gas
    function getHighestBidIndex() internal view returns(uint highestBidIndex) {
        Bid memory _highestBid = highestBid;
        Bid[] memory _allBids = allBids;
        for (uint256 i = 0; i < _allBids.length; ) {
            if (_allBids[i].bidder == _highestBid.bidder && _allBids[i].bidAmount == highestBid.bidAmount) {
                return i;
            }
            ++i;
        }
    }

    function highGasgetHighestBidIndex() internal view returns(uint highestBidIndex) {

        for (uint256 i = 0; i < allBids.length; ) {
            if (allBids[i].bidder == highestBid.bidder && allBids[i].bidAmount == highestBid.bidAmount) {
                return i;
            }
            ++i;
        }
    }

    function endAuction() external onlyOwner() {
        require(block.timestamp > auctionEndTime, "Auction duration is not over.");
        delete allBids[getHighestBidIndex()];
        Bid[] memory _allBids = allBids;
        for (uint256 i = 0; i < _allBids.length; ) {
            require(address(this).balance >= _allBids[i].bidAmount, "Not enough ether");
            payable(_allBids[i].bidder).transfer(_allBids[i].bidAmount);
            ++i;
        }
    }

    function timeLeftForAuction() external view returns(uint) {
        return auctionEndTime - block.timestamp;
    }






    function getContractBalance() external view returns(uint) {
        return address(this).balance;
    }



}