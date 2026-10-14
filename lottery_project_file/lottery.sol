// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;
    
    constructor() {
        manager=msg.sender; //global variable
    }

    receive() external payable { 
        require(msg.value == 2 ether, "Send exactly 2 ETH");
        participants.push(payable(msg.sender));
    }
    function getBalance() public view returns(uint){
        require(msg.sender == manager, "Only manager");
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,participants.length)));
    }
  function selectWinner() public returns (address) {
    require(msg.sender == manager, "Only manager");
    require(participants.length >= 3, "Need at least 3 players");
    uint r = random();
    address payable winner;
    uint index = r % participants.length;
    winner = participants[index];

    uint prize = getBalance() / 2;   // half of the total money

    (bool success, ) = winner.call{value: prize}("");
    require(success, "Transfer failed");

    participants = new address payable[](0);
    return winner;
    }
}