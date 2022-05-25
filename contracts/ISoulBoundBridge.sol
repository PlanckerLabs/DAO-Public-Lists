// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ISoulBoundBridge {
    function register(address _address, address _dao) external;

    function onOwnerChage(address _dao) external;

    function medalMint(
        address _address,
        address _dao,
        uint256 _medalIndex
    ) external;
}
