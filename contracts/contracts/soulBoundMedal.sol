// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./ISoulBoundMedal.sol";
import "./IDataStorage.sol";
import "./ISoulBoundBridge.sol";

contract SoulBoundMedal is ERC721, Ownable, ISoulBoundMedal {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    address public _daoBridge;
    string _baseUri = "";
    string[] private _medalnameArr;
    string[] private _medaluriArr;

    // Mapping from token ID to medal
    mapping(uint256 => uint256) private _medalMap;

    /**
     *  bytes32 :   address + medalIndex
     *  uint8 :   status of the cliam,  1:pending,2:rejected ,>2 tokenid
     */
    mapping(bytes32 => uint256) private _cliamStatus;

    ISoulBoundMedal.CliamRequest[] private _cliamRequestList;

    mapping(uint256 => uint256[]) private _cliamRequestListApprovedIndex; // key:medalIndex, value:index in _cliamRequestList

    ISoulBoundMedal.MedalPanel[] private _medalPanel;

    constructor(
        string memory _name, // NFT Collection Name
        string memory _symbol, // NFT Collection Symbol
        string[] memory _medalname, // Medal Name Arrary , length must be equal to _medaluri
        string[] memory _medaluri, // Medal Image Url Arrary , length must be equal to _medalname
        address _daoBridgeAddress // DAO Bridge Address, used to get cliam status
    ) ERC721(_name, _symbol) {
        _medalnameArr = _medalname;
        _medaluriArr = _medaluri;
        _daoBridge = _daoBridgeAddress;
        for (uint256 i = 0; i < _medalnameArr.length; i++) {
            _medalPanel.push(MedalPanel(0, 0, 0, block.timestamp));
        }
        _tokenIdCounter.set(9);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    function setBaseURI(string memory baseUri) public onlyOwner {
        _baseUri = baseUri;
    }

    /**
     * @dev if the token is soulbound
     * @return true if the token is soulbound
     */
    function soulbound() public pure override returns (bool) {
        return true;
    }

    function setDAOBridge(address _daoBridgeAddress) public onlyOwner {
        _daoBridge = _daoBridgeAddress;
    }

    modifier DataStorageCheck() {
        require(_daoBridge != address(0), "dataStorage is not set");
        _;
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        super.transferOwnership(newOwner);

        ISoulBoundBridge soulBoundBridge = ISoulBoundBridge(_daoBridge);
        try soulBoundBridge.onOwnerChage(address(this)) {} catch {}
    }

    /**
     * @dev save string to storage
     * @param k key
     * @param v value
     */
    function saveString(bytes4 k, string calldata v)
        public
        onlyOwner
        DataStorageCheck
    {
        IDataStorage dataStorageInstance = IDataStorage(_daoBridge);
        dataStorageInstance.saveString(k, v);
    }

    /**
     * @dev save multiple string to storage
     * @param k key arrary
     * @param v value arrary
     */
    function saveStrings(bytes4[] calldata k, string[] calldata v)
        public
        onlyOwner
        DataStorageCheck
    {
        IDataStorage dataStorageInstance = IDataStorage(_daoBridge);
        return dataStorageInstance.saveStrings(k, v);
    }

    /**
     * @dev Add medals to current DAO
     * @param medalsname array of medal name
     * @param medalsuri array of medal image url
     */
    function addMedals(
        string[] calldata medalsname,
        string[] calldata medalsuri
    ) public override onlyOwner {
        require(medalsname.length > 0 && medalsname.length == medalsuri.length);
        for (uint256 i = 0; i < medalsname.length; i++) {
            _medalnameArr.push(medalsname[i]);
            _medaluriArr.push(medalsuri[i]);
            _medalPanel.push(MedalPanel(0, 0, 0, block.timestamp));
        }
    }

    /**
     * @dev get medals count
     * @return uint256 the count of medals
     */
    function countMedals() public view override returns (uint256) {
        return _medalnameArr.length;
    }

    /**
     * @dev get medals
     * @return array of medals
     */
    function getMedals()
        public
        view
        override
        returns (
            string[] memory,
            string[] memory,
            ISoulBoundMedal.MedalPanel[] memory
        )
    {
        return (_medalnameArr, _medaluriArr, _medalPanel);
    }

    /**
     * @dev get medalIndex by tokenid
     * @param tokenid token id
     * @return uint256 the medal index
     */
    function getMedalIndexByTokenid(uint256 tokenid)
        public
        view
        override
        returns (uint256)
    {
        return _medalMap[tokenid];
    }

    /**
     * @dev get cliam status by key
     * @param key key, bytes32 : request user address + medalIndex
     * @return uint256 the cliam status,  1:pending,2:rejected ,>2 tokenid
     */
    function getCliamStatusByBytes32Key(bytes32 key)
        public
        view
        override
        returns (uint256)
    {
        return _cliamStatus[key];
    }

    /**
     * @dev get size of cliam request list
     * @return uint256 the size of cliam request list
     */
    function getCliamRequestSize() public view override returns (uint256) {
        return _cliamRequestList.length;
    }

    /**
     * @dev get cliam request item by index
     * @return ISoulBoundMedal.CliamRequest
     */
    function getCliamRequest(uint256 _index)
        public
        view
        override
        returns (ISoulBoundMedal.CliamRequest memory)
    {
        require(_index < _cliamRequestList.length);
        return _cliamRequestList[_index];
    }

    /**
     * @dev get the size of cliam request approved list by medal index
     * @param _medalIndex medal index
     * @return uint256 the size of cliam request approved list
     */
    function countCliamRequestApproved(uint256 _medalIndex)
        public
        view
        override
        returns (uint256)
    {
        return _cliamRequestListApprovedIndex[_medalIndex].length;
    }

    /**
     * @dev get Approved CliamRequest list index arrary by medal index
     * @param _medalIndex medal index
     * @return uint256[] CliamRequest index arrary of Cliam Request Approved
     */
    function listCliamRequestApproved(uint256 _medalIndex)
        public
        view
        override
        returns (uint256[] memory)
    {
        return _cliamRequestListApprovedIndex[_medalIndex];
    }

    /**
     * @dev update medal by medal index
     * @param medalIndex index of medal
     * @param name new name of medal
     * @param uri new image url of medal
     */
    function updateMedal(
        uint256 medalIndex,
        string calldata name,
        string calldata uri
    ) public override onlyOwner {
        require(medalIndex < _medalnameArr.length);
        _medalnameArr[medalIndex] = name;
        _medaluriArr[medalIndex] = uri;
    }

    /**
     * @dev  Approved cliam
     * @param cliamId the index of the cliam request id
     * Emits a {Transfer} event.
     */
    function cliamApproved(uint256 cliamId) public override onlyOwner {
        require(cliamId < _cliamRequestList.length);
        ISoulBoundMedal.CliamRequest memory request = _cliamRequestList[
            cliamId
        ];
        require(request._status == 1, "cliam request is not pending");//1:pending,2:rejected ,>2 tokenid
        bytes32 k = keccak256(
            abi.encodePacked(request._address, request._medalIndex)
        );
        uint256 cliamStatus = _cliamStatus[k]; //1:pending,2:rejected ,>2 tokenid
        require(
            cliamStatus < 3,
            "cliam request of the medal index is already approved before"
        );
        _cliamRequestListApprovedIndex[request._medalIndex].push(cliamId);
        unchecked {
            _medalPanel[request._medalIndex]._approved++;
            _medalPanel[request._medalIndex]._request--;
        }
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _medalMap[tokenId] = request._medalIndex;

        _cliamStatus[k] = tokenId;
        _cliamRequestList[cliamId]._status = tokenId; //1:pending,2:rejected ,>2 tokenid

        _mint(request._address, tokenId);
    }

    /**
     * @dev  Rejected cliam
     * @param cliamId the index of the cliam request id
     */
    function cliamRejected(uint256 cliamId) public override onlyOwner {
        require(cliamId < _cliamRequestList.length);
        ISoulBoundMedal.CliamRequest memory request = _cliamRequestList[
            cliamId
        ];
        require(request._status == 1, "cliam request is not pending"); //1:pending,2:rejected ,>2 tokenid
        bytes32 k = keccak256(
            abi.encodePacked(request._address, request._medalIndex)
        );
        uint256 cliamStatus = _cliamStatus[k]; //1:pending,2:rejected ,>2 tokenid
        _cliamRequestList[cliamId]._status = 2;
        if (cliamStatus < 3) {
            _cliamStatus[k] = 2;
        }
        unchecked {
            _medalPanel[request._medalIndex]._rejected++;
            _medalPanel[request._medalIndex]._request--;
        }
    }

    /**
     * @dev Users apply for mint medal
     * @param medalIndex the index of the medal
     */
    function cliamRequest(uint256 medalIndex) public override {
        require(medalIndex < _medalnameArr.length);
        require(msg.sender.code.length == 0, "contract address not supported");
        bytes32 k = keccak256(abi.encodePacked(msg.sender, medalIndex));

        require(_cliamStatus[k] < 3, "already approved");///1:pending,2:rejected ,>2 tokenid

        _cliamStatus[k] = 1;
        _cliamRequestList.push(
            ISoulBoundMedal.CliamRequest(
                msg.sender,
                medalIndex,
                block.timestamp,
                1
            )
        );

        unchecked {
            _medalPanel[medalIndex]._request++;
        }
        ISoulBoundBridge soulBoundBridge = ISoulBoundBridge(_daoBridge);
        soulBoundBridge.onCliamRequest(msg.sender, address(this), medalIndex);
    }

    /**
     * @dev  RFC 3986 compliant URL:base64://{json encoded with base64} ,json {"name":"base64(medal name)","image":"base64(medal uri)"}
     * @param tokenId  tokenid
     * @return string  the base64 uri of the Token
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory baseURI = _baseURI();
        string memory medalName = _medalnameArr[_medalMap[tokenId]];
        string memory medalURI = string(
            abi.encodePacked(baseURI, _medaluriArr[_medalMap[tokenId]])
        );
        string memory json = string(
            abi.encodePacked(
                "base64://",
                Base64.encode(
                    abi.encodePacked(
                        '{"owner":"',
                        Strings.toHexString(uint256(uint160(ownerOf(tokenId)))),
                        '","name":"',
                        Base64.encode(bytes(medalName)),
                        '","image":"',
                        Base64.encode(bytes(medalURI)),
                        '"}'
                    )
                )
            )
        );
        return json;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(ISoulBound).interfaceId ||
            interfaceId == type(ISoulBoundMedal).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    modifier SoulBoundToken() {
        require(soulbound() == false, "SoulBound token cannot be transferred.");
        _;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(IERC721, ERC721) SoulBoundToken {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(IERC721, ERC721) SoulBoundToken {}

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override(IERC721, ERC721) SoulBoundToken {}
}
