// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "./WitnetBoardData.sol";

/// @title Witnet Access Control Lists storage layout, for Witnet-trusted request boards.
/// @author The Witnet Foundation.
abstract contract WitnetBoardDataACLs is WitnetBoardData {

    bytes32 internal constant WITNET_BOARD_ACLS_SLOTHASH =
        /* keccak256("io.witnet.board.data.acls") */
        0xcd72f56a6985e636b405ff061ec7e64e5428b269bdf2efabdd134b36b111d605;

    struct WitnetBoardACLs {
        mapping (address => bool) isReporter_;
    }

    constructor() {
        _acls().isReporter_[msg.sender] = true;
    }

    modifier onlyReporters {
        require(
            _acls().isReporter_[msg.sender],
            "WitnetBoardDataACLs: unauthorized reporter"
        );
        _;
    } 

    // ================================================================================================================
    // --- Internal functions -----------------------------------------------------------------------------------------

    function _acls() internal pure returns (WitnetBoardACLs storage _struct) {
        assembly {
            _struct.slot := WITNET_BOARD_ACLS_SLOTHASH
        }
    }
}
