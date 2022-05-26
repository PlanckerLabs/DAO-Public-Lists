// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ISoulBoundBridge {
    function onOwnerChage(address _dao) external;

    /**
    * @dev on user request a medal
    * @param _address address of user
    * @param _dao  address of dao
    * @param _medalIndex tokenid of medal
     */
    function onCliamRequest(
        address _address,
        address _dao,
        uint256 _medalIndex
    ) external;

}
