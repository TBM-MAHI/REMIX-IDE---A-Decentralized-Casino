// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "hardhat/console.sol";

import {VRFV2WrapperConsumerBase } from "@chainlink/contracts/src/v0.8/vrf/VRFV2WrapperConsumerBase.sol";

contract Casino is VRFV2WrapperConsumerBase {
    mapping(address => uint256) public gameEthValues;
    mapping(address => uint256) public blockNumbersToBeUsedMapping;
    address LINK_Token = 0x779877A7B0D9E8603169DdbD7836e478b4624789;
    address wrapper = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;

constructor()VRFV2WrapperConsumerBase(LINK_Token,wrapper){

}
    function fundBank() payable external {

    }

    function playGame() external payable {
        console.log("Block Number", block.number);
        uint256 blockNumberToBeUsed = blockNumbersToBeUsedMapping[msg.sender]; //  blockNumbersToBeUsedMapping[address];
        console.log("blockNumberToBeUsed", blockNumberToBeUsed);
        if (blockNumberToBeUsed == 0) {
            // first run, determine block number to be used
            console.log("Block Number, WHEN blockNumberToBeUsed == 0", block.number);
            blockNumbersToBeUsedMapping[msg.sender] = block.number + 128;
            gameEthValues[msg.sender] = msg.value;
            console.log("gameEthValues[msg.sender], WHEN blockNumberToBeUsed == 0", gameEthValues[msg.sender]);
            return;
        }

        require(block.number == blockNumberToBeUsed, "INCORRECT BLOCK");

        uint256 RANDOM_NUMBER = block.prevrandao;
        console.log("RANDOM_NUMBER", RANDOM_NUMBER);
        if (RANDOM_NUMBER % 2 == 0) {
            uint256 winningAmount = gameEthValues[msg.sender] * 2; //gameEthValues[address]
            (bool sucess, ) = msg.sender.call{value: winningAmount}("");
            require(sucess, "Transfer Failed");
        }
        
       // console.log("ENDING balance", );
    }
}
