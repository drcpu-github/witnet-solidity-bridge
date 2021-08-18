// SPDX-License-Identifier: MIT

/* solhint-disable var-name-mixedcase */

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

// Inherits from:
import "./WitnetRequestBoardTrustableBase.sol";

// Uses:
import "../../interfaces/IERC20.sol";

/// @title Witnet Request Board OVM-compatible (Optimism) "trustable" implementation.
/// @notice Contract to bridge requests to Witnet Decentralized Oracle Network.
/// @dev This contract enables posting requests that Witnet bridges will insert into the Witnet network.
/// The result of the requests will be posted back to this contract by the bridge nodes too.
/// @author The Witnet Foundation
contract WitnetRequestBoardTrustableOVM
    is
        Payable,
        WitnetRequestBoardTrustableBase
{
    uint256 internal lastBalance;
    uint256 internal immutable _OVM_GAS_PRICE;

    modifier ovmPayable {
        _;
        lastBalance = balanceOf(address(this));
    }
            
    constructor(
            bool _upgradable,
            bytes32 _versionTag,
            uint256 _layer2GasPrice,
            address _oETH
        )
        WitnetRequestBoardTrustableBase(_upgradable, _versionTag, _oETH)
    {
        require(address(_oETH) != address(0), "WitnetRequestBoardTrustableOVM: null currency");
        _OVM_GAS_PRICE = _layer2GasPrice;
    }


    // ================================================================================================================
    // --- Overrides 'Payable' ----------------------------------------------------------------------------------------

    /// Gets lastBalance of given address.
    function balanceOf(address _from)
        public view
        override
        returns (uint256)
    {
        return currency.balanceOf(_from);
    }

    /// Gets current transaction price.
    function _getGasPrice()
        internal view
        override
        returns (uint256)
    {
        return _OVM_GAS_PRICE;
    }

    /// Calculates `msg.value` equivalent OVM_ETH value. 
    /// @dev Based on `lastBalance` value.
    function _getMsgValue()
        internal view
        override
        returns (uint256)
    {
        uint256 _newBalance = balanceOf(address(this));
        assert(_newBalance >= lastBalance);
        return _newBalance - lastBalance;
    }

    /// Transfers oETHs to given address.
    /// @dev Updates `lastBalance` value.
    /// @param _to OVM_ETH recipient account.
    /// @param _amount Amount of oETHs to transfer.
    function _safeTransferTo(address payable _to, uint256 _amount)
        internal
        override
    {
        uint256 _lastBalance = balanceOf(address(this));
        require(_amount <= _lastBalance, "WitnetRequestBoardTrustableOVM: insufficient funds");
        lastBalance = _lastBalance - _amount;
        currency.transfer(_to, _amount);
    }
    

    // ================================================================================================================
    // --- Overrides implementation of 'IWitnetRequestBoardView' -------------------------------------------------------------

    /// @dev Estimate the minimal amount of reward we need to insert for a given gas price.
    /// @return The minimal reward to be included for the given gas price.
    function estimateReward(uint256)
        external view
        virtual override
        returns (uint256)
    {
        return _OVM_GAS_PRICE * _ESTIMATED_REPORT_RESULT_GAS;
    }

        
    // ================================================================================================================
    // --- Overrides implementation of 'IWitnetRequestBoardRequestor' --------------------------------------------------------

    function postRequest(IWitnetRadon _script)
        public payable
        ovmPayable
        override
        returns (uint256)
    {
        return super.postRequest(_script);
    }
}
