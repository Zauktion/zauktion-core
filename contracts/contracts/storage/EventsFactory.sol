// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// interfaces
import "../interfaces/IEventsFactory.sol";

abstract contract EventsFactoryStorage {
  address internal verifier;
  mapping(string => IEventsFactory.EventInfo) internal events;
}
