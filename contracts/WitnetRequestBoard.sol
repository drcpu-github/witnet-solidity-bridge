// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./interfaces/IWitnetRequestBoardEvents.sol";
import "./interfaces/IWitnetRequestBoardReporter.sol";
import "./interfaces/IWitnetRequestBoardRequestor.sol";
import "./interfaces/IWitnetRequestBoardView.sol";

/// @title Witnet Request Board functionality base contract.
/// @author The Witnet Foundation.
abstract contract WitnetRequestBoard is
    IWitnetRequestBoardEvents,
    IWitnetRequestBoardReporter,
    IWitnetRequestBoardRequestor,
    IWitnetRequestBoardView
{
    receive() external payable {
        revert("WitnetRequestBoard: no transfers accepted");
    }
}
