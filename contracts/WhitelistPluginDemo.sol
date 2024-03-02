// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.4;

import {AlgebraPlugin, IAlgebraPlugin} from './base/AlgebraPlugin.sol';
import {IAlgebraPool} from '@cryptoalgebra/integral-core/contracts/interfaces/IAlgebraPool.sol';
import {PoolInteraction} from './libraries/PoolInteraction.sol';
import {PluginConfig, Plugins} from './types/PluginConfig.sol';

contract DummyPlugin is AlgebraPlugin {
    error onlyPoolAllowed();
    error notVerifiedAddress();

    PluginConfig private constant _defaultPluginConfig = PluginConfig.wrap(0); // does nothing

    IAlgebraPool public immutable pool;

    mapping(address => bool) private verifiedAddresses;

    modifier onlyVerified() {
        require(verifiedAddresses[msg.sender], "Caller is not a verified address");
        _;
    }

    modifier onlyPool() {
        _checkOnlyPool();
        _;
    }

    constructor(address _pool) {
        pool = IAlgebraPool(_pool);
    }

    function defaultPluginConfig() external pure override returns (uint8 pluginConfig) {
        return _defaultPluginConfig.unwrap();
    }

    function addToWhitelist(address _address) external onlyPool {
        verifiedAddresses[_address] = true;
    }

    function removeFromWhitelist(address _address) external onlyPool {
        verifiedAddresses[_address] = false;
    }

    function isAddressVerified(address _address) external view returns (bool) {
        return verifiedAddresses[_address];
    }

    function beforeInitialize(address sender, uint160 sqrtPriceX96) external onlyVerified returns (bytes4) {
        sender; // suppress warning
        sqrtPriceX96; //suppress warning

        PoolInteraction.changePluginConfigIfNeeded(pool, _defaultPluginConfig);
        return IAlgebraPlugin.beforeInitialize.selector;
    }

    function _checkOnlyPool() internal view {
        if (msg.sender != address(pool)) revert onlyPoolAllowed();
    }
}
