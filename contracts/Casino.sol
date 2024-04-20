// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "hardhat/console.sol";

contract Casino {
    mapping(address => uint256) public gameEthValues;
    mapping(address => uint256) public blockNumbersToBeUsedMapping;

    function playGame() external payable {
        uint256 blockNumberToBeUsed = blockNumbersToBeUsedMapping[msg.sender];
        console.log("blockNumberToBeUsed", blockNumberToBeUsed);
        if (blockNumberToBeUsed == 0) {
            // first run, determine block number to be used
            console.log("Block Number", block.number);
            blockNumbersToBeUsedMapping[msg.sender] = block.number + 2;
            gameEthValues[msg.sender] = msg.value;
            console.log("gameEthValues[msg.sender]", gameEthValues[msg.sender]);
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
    }
}
