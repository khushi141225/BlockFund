// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BlockFund {
    address public owner;
    uint public goalAmount;
    uint public deadline;
    uint public totalContributed;

    mapping(address => uint) public contributions;
    bool public goalReached;
    bool public fundsWithdrawn;

    constructor() {
        owner = msg.sender;
        goalAmount = 10 ether;           // Default goal: 10 ETH
        uint durationInDays = 7;         // Default duration: 7 days
        deadline = block.timestamp + (durationInDays * 1 days);
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed");
        require(msg.value > 0, "Must send ETH");

        contributions[msg.sender] += msg.value;
        totalContributed += msg.value;

        if (totalContributed >= goalAmount) {
            goalReached = true;
        }
    }

    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(goalReached, "Funding goal not reached");
        require(!fundsWithdrawn, "Funds already withdrawn");

        fundsWithdrawn = true;
        payable(owner).transfer(address(this).balance);
    }

    function refund() public {
        require(block.timestamp > deadline, "Deadline not yet reached");
        require(!goalReached, "Goal was reached");

        uint amount = contributions[msg.sender];
        require(amount > 0, "Nothing to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
