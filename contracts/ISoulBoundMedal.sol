// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ISoulBound.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ISoulBoundMedal is ISoulBound {
    /**
     * @dev Add medals to current DAO
     * @param medalsname array of medal description
     * @param medalsuri array of medal uri
     */
    function addMedals(
        string[] calldata medalsname,
        string[] calldata medalsuri
    ) external;

    struct MedalPanel {
        uint256 _request;
        uint256 _approved;
        uint256 _rejected;
        uint256 _genesis;
    }

    /**
     * @dev get medals
     * @return array of medals
     */
    function getMedals()
        external
        view
        returns (
            string[] memory,
            string[] memory,
            MedalPanel[] memory
        );

    /**
     * @dev get medals count
     * @return uint256
     */
    function countMedals() external view returns (uint256);

    /**
     * @dev get medalIndex by tokenid
     */
    function getMedalIndexByTokenid(uint256 tokenid)
        external
        view
        returns (uint256);

    /**
     * @dev get cliam status by key
     */
    function getCliamStatusByBytes32Key(bytes32 key)
        external
        view
        returns (uint8);

    function getCliamRequestSize() external view returns (uint256);

    struct CliamRequest {
        address _address; // request address
        uint256 _medalIndex; // medal index
        uint256 _timestamp; // timestamp
        uint8 _status; // status of the cliam,  0: rejected , 1: pending, 2: approved
    }

    function getCliamRequest(uint256 _index)
        external
        view
        returns (CliamRequest memory);

    /**
     * @dev get Cliam Request Approved count
     * @param _medalIndex medal index
     * @return uint256
     */
    function countCliamRequestApproved(uint256 _medalIndex)
        external
        view
        returns (uint256);

    /**
     * @dev get Cliam Request Approved index by medal index
     * @param _medalIndex medal index
     * @return uint256[] CliamRequest index arrary of Cliam Request Approved
     */
    function listCliamRequestApproved(uint256 _medalIndex)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev update medal by index
     * @param medalIndex index of medal
     * @param name new name of medal
     * @param uri new uri of medal
     */
    function updateMedal(
        uint256 medalIndex,
        string calldata name,
        string calldata uri
    ) external;

    /**
     * @dev  Approved cliam
     * @param cliamId the index of the cliam id
     * Emits a {Transfer} event.
     */
    function cliamApproved(uint256 cliamId) external;

    /**
     * @dev  Rejected cliam
     * @param cliamId the index of the cliam id
     */
    function cliamRejected(uint256 cliamId) external;

    /**
     * @dev Users apply for mint medal
     * @param medalIndex the index of the medal
     */
    function cliamRequest(uint256 medalIndex) external;
}
