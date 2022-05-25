// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;

// import "./IDataStorage.sol";

// contract DataStorage is IDataStorage {
//     mapping(address => mapping(bytes4 => string)) public storageStrings;
//     mapping(address => mapping(bytes4 => mapping(address => uint256)))
//         public storageEnumerableAddressMap;
//     mapping(address => mapping(bytes4 => address[]))
//         public storageEnumerableAddressArr;

//     function saveString(bytes4 k, string calldata v) public override {
//         storageStrings[msg.sender][k] = v;
//     }

//     function getString(address a, bytes4 k)
//         public
//         view
//         override
//         returns (string memory)
//     {
//         return storageStrings[a][k];
//     }

//     function saveStrings(bytes4[] calldata k, string[] calldata v)
//         public
//         override
//     {
//         for (uint256 i = 0; i < k.length; i++) {
//             storageStrings[msg.sender][k[i]] = v[i];
//         }
//     }

//     function getStrings(address a, bytes4[] calldata k)
//         public
//         view
//         override
//         returns (string[] memory)
//     {
//         string[] memory result = new string[](k.length);
//         for (uint256 i = 0; i < k.length; i++) {
//             result[i] = storageStrings[a][k[i]];
//         }
//         return result;
//     }

//     function addToAddressArrary(bytes4 k, address v) public override {
//         if (storageEnumerableAddressMap[msg.sender][k][v] == 0) {
//             storageEnumerableAddressArr[msg.sender][k].push(v);
//             storageEnumerableAddressMap[msg.sender][k][
//                 v
//             ] = storageEnumerableAddressArr[msg.sender][k].length;
//         }
//     }

//     function removeFromAddressArrary(bytes4 k, address v) public override {
//         uint256 index = storageEnumerableAddressMap[msg.sender][k][v];
//         if (index > 0) {
//             delete storageEnumerableAddressArr[msg.sender][k][index - 1];
//             storageEnumerableAddressMap[msg.sender][k][v] = 0;
//         }
//     }

//     function getAddressArraryIndex(
//         address a,
//         bytes4 k,
//         address addr
//     ) public view override returns (uint256) {
//         return storageEnumerableAddressMap[a][k][addr];
//     }

//     function getAddressArrary(address a, bytes4 k)
//         public
//         view
//         override
//         returns (address[] memory)
//     {
//         return storageEnumerableAddressArr[a][k];
//     }
// }
