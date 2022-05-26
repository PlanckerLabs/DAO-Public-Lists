// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IDataStorage {
    function saveString(bytes4 k, string calldata v) external;

    function getString(address a, bytes4 k)
        external
        view
        returns (string memory);

    function saveStrings(bytes4[] calldata k, string[] calldata v) external;

    function getStrings(address a, bytes4[] calldata k)
        external
        view
        returns (string[] memory);

    // function addToAddressArrary(bytes4 k, address v) external;

    // function removeFromAddressArrary(bytes4 k, address v) external;

    // function getAddressArrary(address a, bytes4 k)
    //     external
    //     view
    //     returns (address[] memory);

    // function getAddressArraryIndex(
    //     address a,
    //     bytes4 k,
    //     address addr
    // ) external view returns (uint256);
}
