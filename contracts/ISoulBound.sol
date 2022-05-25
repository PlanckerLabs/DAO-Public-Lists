// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; 

interface ISoulBound is IERC721 {
    /**
     * @dev if the token is soulbound
     * @return true if the token is soulbound
     */
    function soulbound() external view returns (bool);
}