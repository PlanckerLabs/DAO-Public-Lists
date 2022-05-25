// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./ISoulBoundMedal.sol";
import "./IDataStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./ISoulBoundBridge.sol";

interface IOwnable {
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() external view returns (address);

    function name() external view returns (string memory);

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() external view returns (string memory);
}

contract SoulBoundBridge is IDataStorage, ISoulBoundBridge {
    // region variables

    address[] public storageEnumerableUserArr;

    mapping(address => uint256[]) public storageEnumerableUserMap;

    mapping(bytes32 => uint8) public userDAOMapping;

    mapping(address => uint256) public storageEnumerableDAOMap;

    address[] public storageEnumerableDAOArr;

    mapping(address => mapping(bytes4 => string)) public storageStrings;

    mapping(address => uint256[]) public userDaoMedalsDaoIndexMap; // key: user address,value:index-1 is the dao in the storageEnumerableDAOArr
    mapping(bytes32 => uint256[]) public userDaoMedalsMapIndex; // key: user address+ dao address,value:value:user climbed the index of medal

    mapping(address => address[]) public contractOwnerMap; // key:user address,value: dao address array
    mapping(bytes32 => uint256) public contractOwnerMapIndex; // key: user address+ dao address,value -1 is the index of the contractOwnerMap -> value

    // endregion

    constructor() {}

    // region functional

    /**
     * @dev save a string to the storage
     * @param k key
     */
    function saveString(bytes4 k, string calldata v) public override {
        storageStrings[msg.sender][k] = v;
    }

    /**
     * @dev get a string from the storage
     * @param a address
     * @param k key
     * @return string memory value
     */
    function getString(address a, bytes4 k)
        public
        view
        override
        returns (string memory)
    {
        return storageStrings[a][k];
    }

    /**
     * @dev save multiple string to the storage
     * @param k key array
     * @param v value array
     */
    function saveStrings(bytes4[] calldata k, string[] calldata v)
        public
        override
    {
        for (uint256 i = 0; i < k.length; i++) {
            storageStrings[msg.sender][k[i]] = v[i];
        }
    }

    /**
     * @dev get multiple string from the storage
     * @param a address
     * @param k key array
     * @return string[] memory value array
     */
    function getStrings(address a, bytes4[] calldata k)
        public
        view
        override
        returns (string[] memory)
    {
        string[] memory result = new string[](k.length);
        for (uint256 i = 0; i < k.length; i++) {
            result[i] = storageStrings[a][k[i]];
        }
        return result;
    }

    /**
     * @dev get multiple address & multiple string from the storage
     * @param a key
     * @param k value
     * @return string[][] memory value array
     */
    function getStrings(address[] calldata a, bytes4[] calldata k)
        public
        view
        returns (string[][] memory)
    {
        string[][] memory result = new string[][](a.length);
        for (uint256 i = 0; i < a.length; i++) {
            result[i] = getStrings(a[i], k);
        }
        return result;
    }

    modifier onlySoulBoundMedalAddress(address _soulBoundMedalAddress) {
        require(
            _soulBoundMedalAddress.code.length > 0,
            "given address is not a valid contract"
        );
        require(
            IERC165(_soulBoundMedalAddress).supportsInterface(
                type(ISoulBoundMedal).interfaceId
            ),
            "given address is not a valid soul bound medal contract"
        );

        _;
    }

    /**
     * @dev  call on DAO owner change
     * @param _dao address
     */
    function onOwnerChage(address _dao)
        public
        override
        onlySoulBoundMedalAddress(_dao)
    {
        _changeOwner(_dao);
    }

    /**
     * @dev  get the owner of the contract
     * @param _dao address
     * @return address
     */
    function getOwner(address _dao) private view returns (address) {
        IOwnable ownable = IOwnable(_dao);
        try ownable.owner() returns (address _owner) {
            return _owner;
        } catch {}
        return address(0);
    }

    /**
     * @dev  get the name of the contract
     * @param _dao address
     * @return string
     */
    function getName(address _dao) private view returns (string memory) {
        IOwnable ownable = IOwnable(_dao);
        try ownable.name() returns (string memory _name) {
            return _name;
        } catch {}
        return "";
    }

    function _changeOwner(address _dao) private {
        address owner = getOwner(_dao);
        bytes32 key = keccak256(abi.encodePacked(owner, _dao));
        if (contractOwnerMapIndex[key] == 0) {
            contractOwnerMap[owner].push(_dao);
            contractOwnerMapIndex[key] = contractOwnerMap[owner].length;
        }
    }

    /**
     * @dev  register a DAO contract
     * @param _address user address
     * @param _dao address  DAO contract address
     */
    function register(address _address, address _dao) public override {
        if (storageEnumerableDAOMap[_dao] == 0) {
            require(
                _dao.code.length > 0,
                "given address is not a valid contract"
            );
            require(
                IERC165(_dao).supportsInterface(
                    type(ISoulBoundMedal).interfaceId
                ),
                "given address is not a valid soul bound medal contract"
            );
            storageEnumerableDAOArr.push(_dao);
            storageEnumerableDAOMap[_dao] = storageEnumerableDAOArr.length;

            // register owner
            _changeOwner(_dao);
        }
        bytes32 userDAOMappingKey = keccak256(abi.encodePacked(_address, _dao));
        if (userDAOMapping[userDAOMappingKey] == 0) {
            userDAOMapping[userDAOMappingKey] = 1;
            if (storageEnumerableUserMap[_address].length == 0) {
                storageEnumerableUserArr.push(_address);
            }
            storageEnumerableUserMap[_address].push(
                storageEnumerableDAOMap[_dao]
            );
        }
    }

    /**
     * @dev  DAO contract call this function on medal minted
     * @param _address user address
     * @param _dao address  DAO contract address
     * @param _medalIndex uint256   medal index
     */
    function medalMint(
        address _address,
        address _dao,
        uint256 _medalIndex
    ) public override onlySoulBoundMedalAddress(_dao) {
        bytes32 userDAOMappingKey = keccak256(abi.encodePacked(_address, _dao));
        uint256[] memory keyIndex = userDaoMedalsMapIndex[userDAOMappingKey];
        if (keyIndex.length == 0) {
            userDaoMedalsDaoIndexMap[_address].push(
                storageEnumerableDAOMap[_dao]
            );
        }
        userDaoMedalsMapIndex[userDAOMappingKey].push(_medalIndex);
    }

    // endregion

    // region DAO

    /**
     * @dev  count DAO
     * @return uint256 DAO count
     */
    function countDAO() public view returns (uint256) {
        return storageEnumerableDAOArr.length;
    }

    /**
     * @dev list DAO
     * @param offset uint256 query offset
     * @param limit uint256 query limit
     * @param medals_offset uint256 medal offset
     * @param medals_limit uint256 medal limit,no medals fetched if 0
     * @return string memory  json string
     */
    function listDAO(
        uint256 offset,
        uint256 limit,
        uint256 medals_offset,
        uint256 medals_limit // no medals fetched if 0
    ) public view returns (string memory) {
        /* 
        {
           "address": [
                            '0x1',
                            '0x2'
                        ],
            "medals": [
                        {"total":1,"medals":[
                                                    {
                                                        "index":0,
                                                        "name":"base64 string",
                                                        "uri":"base64 string",
                                                        "request":0,
                                                        "approved":0,
                                                        "rejected":0,
                                                        "genesis":1539098983
                                                    }
                                            ]
                        }
                    ]
        } 
         */
        string memory result_address = "[";
        string memory result_medals = "[";
        for (uint256 i = offset; i < offset + limit; i++) {
            if (i >= storageEnumerableDAOArr.length) {
                break;
            }
            if (i > offset) {
                result_address = string(abi.encodePacked(result_address, ","));
            }
            result_address = string(
                abi.encodePacked(
                    result_address,
                    '"',
                    Strings.toHexString(
                        uint256(uint160(storageEnumerableDAOArr[i]))
                    ),
                    '"'
                )
            );
            if (medals_limit > 0) {
                if (i > offset) {
                    result_medals = string(
                        abi.encodePacked(result_medals, ",")
                    );
                }
                result_medals = string(
                    abi.encodePacked(
                        result_medals,
                        listDAOMedals(
                            storageEnumerableDAOArr[i],
                            medals_offset,
                            medals_limit
                        )
                    )
                );
            }
        }
        result_address = string(abi.encodePacked(result_address, "]"));
        result_medals = string(abi.encodePacked(result_medals, "]"));
        return
            string(
                abi.encodePacked(
                    '{"address":',
                    result_address,
                    ',"medals":',
                    result_medals,
                    "}"
                )
            );
    }

    // endregion

    // region CliamRequest

    /**
     * @dev  count CliamRequest by DAO
     * @param _dao address DAO contract address
     * @return uint256 CliamRequest count
     */
    function countCliamRequest(address _dao) public view returns (uint256) {
        ISoulBoundMedal soulBoundMedal = ISoulBoundMedal(_dao);
        try soulBoundMedal.getCliamRequestSize() returns (uint256 _size) {
            return _size;
        } catch {
            return 0;
        }
    }

    /**
     * @dev  count approved CliamRequest by DAO
     * @param _dao address DAO contract address
     * @return string memory  json string
     */
    function countCliamRequestApproved(address _dao)
        public
        view
        returns (uint256)
    {
        ISoulBoundMedal soulBoundMedal = ISoulBoundMedal(_dao);
        uint256 count = 0;
        try soulBoundMedal.countMedals() returns (uint256 _size) {
            for (uint256 i = 0; i < _size; i++) {
                count += countCliamRequestApproved(_dao, i);
            }
        } catch {}
        return count;
    }

    /**
     * @dev  count Approved CliamRequest by DAO and medal index
     * @param _dao address DAO contract address
     * @return string memory  json string
     */
    function countCliamRequestApproved(address _dao, uint256 _madalIndex)
        public
        view
        returns (uint256)
    {
        ISoulBoundMedal soulBoundMedal = ISoulBoundMedal(_dao);
        try soulBoundMedal.countCliamRequestApproved(_madalIndex) returns (
            uint256 _size
        ) {
            return _size;
        } catch {}
        return 0;
    }

    /**
     * @dev get CliamRequest by DAO
     * @param medalContract  address  medal contract address instance
     * @param _index  uint256  CliamRequest index
     * @return string memory  json string
     */
    function getCliamRequest(ISoulBoundMedal medalContract, uint256 _index)
        private
        view
        returns (string memory)
    {
        try medalContract.getCliamRequest(_index) returns (
            ISoulBoundMedal.CliamRequest memory cr
        ) {
            /* 
        {
            "index":0,
            "address":"0x",
            "medalindex":0,
            "timestamp":0,
            "status":0 //// status of the cliam,  0: rejected , 1: pending, 2: approved
        }
         */
            return
                string(
                    abi.encodePacked(
                        '{"index":',
                        Strings.toString(_index),
                        ',"address":"',
                        Strings.toHexString(uint256(uint160(cr._address))),
                        '","medalindex":',
                        Strings.toString(cr._medalIndex),
                        ',"timestamp":',
                        Strings.toString(cr._timestamp),
                        ',"status":',
                        Strings.toString(cr._status),
                        "}"
                    )
                );
        } catch {}
        return "{}";
    }

    /**
     * @dev get CliamRequest list by DAO
     * @param _dao address DAO contract address
     * @param _offset uint256 query offset
     * @param _limit uint256 query limit
     * @return string memory  json string
     */
    function getCliamRequest(
        address _dao,
        uint256 _offset,
        uint256 _limit
    ) public view returns (string memory) {
        string memory result = "[";
        ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
        uint256 c = countCliamRequest(_dao);
        for (uint256 i = _offset; i < _offset + _limit; i++) {
            if (i >= c) {
                break;
            }
            if (i > _offset) {
                result = string(abi.encodePacked(result, ","));
            }
            result = string(
                abi.encodePacked(result, getCliamRequest(medalContract, i))
            );
        }
        return string(abi.encodePacked(result, "]"));
    }

    /**
     * @dev get CliamRequest Approved list by DAO
     * @param _dao address DAO contract address
     * @param _offset uint256 query offset
     * @param _limit uint256 query limit
     * @return string memory  json string
     */
    function getCliamRequestApproved(
        address _dao,
        uint256 _offset, // offset of each medal
        uint256 _limit // limit of each medal
    ) public view returns (string memory) {
        /* 

[
    {
        "medalindex":0,
        "list":[
            {
                "index":0,
                "address":"0x",
                "timestamp":0,
                "status":0 //// status of the cliam,  0: rejected , 1: pending, 2: approved
            }
        ]
    }
]
*/
        string memory result = "[";
        ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
        uint256 c = 0;
        try medalContract.countMedals() returns (uint256 _size) {
            c = _size;
        } catch {}
        for (uint256 j = 0; j < c; j++) {
            if (j > 0) {
                result = string(abi.encodePacked(result, ","));
            }
            result = string(
                abi.encodePacked(
                    result,
                    '{"medalindex":',
                    Strings.toString(j),
                    ',"list":',
                    getCliamRequestApproved(_dao, _offset, _limit, j),
                    "}"
                )
            );
        }

        return string(abi.encodePacked(result, "]"));
    }


    /**
     * @dev get CliamRequest Approved list by DAO and medal index
     * @param _dao address DAO contract address
     * @param _offset uint256 query offset
     * @param _limit uint256 query limit
     * @param _medalIndex uint256 medal index
     * @return string memory  json string
     */
    function getCliamRequestApproved(
        address _dao,
        uint256 _offset,
        uint256 _limit,
        uint256 _medalIndex
    ) public view returns (string memory) {
        string memory result = "[";
        ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
        uint256 c = countCliamRequestApproved(_dao, _medalIndex);
        for (uint256 i = _offset; i < _offset + _limit; i++) {
            if (i >= c) {
                break;
            }
            if (i > _offset) {
                result = string(abi.encodePacked(result, ","));
            }
            result = string(
                abi.encodePacked(result, getCliamRequest(medalContract, i))
            );
        }
        return string(abi.encodePacked(result, "]"));
    }

    // endregion

    // region medals

    /**
     * @dev list medals of DAO
     * @param offset the offset, from 0
     * @param limit the limit, minimum 1
     * @return string json string of query result
     */
    function listDAOMedals(
        address _address,
        uint256 offset,
        uint256 limit
    ) public view onlySoulBoundMedalAddress(_address) returns (string memory) {
        /*
        {
            "name":"base64",
            "owner":"0x",
            "total":1,"medals":[
                {
                    "index":0,
                    "name":"base64 string",
                    "uri":"base64 string",
                    "request":0,
                    "approved":0,
                    "rejected":0,
                    "genesis":1539098983
                }
            
            ]
        }
         */
        ISoulBoundMedal medalContract = ISoulBoundMedal(_address);
        string[] memory _medalnameArr;
        string[] memory _medaluriArr;
        ISoulBoundMedal.MedalPanel[] memory _medalPanel;
        try medalContract.getMedals() returns (
            string[] memory __medalnameArr,
            string[] memory __medaluriArr,
            ISoulBoundMedal.MedalPanel[] memory __medalPanel
        ) {
            _medalnameArr = __medalnameArr;
            _medaluriArr = __medaluriArr;
            _medalPanel = __medalPanel;
        } catch {}
        string memory daoName = getName(_address);
        address daoOwner = getOwner(_address);
        string memory result = string(
            abi.encodePacked(
                '{"name":"',
                Base64.encode(bytes(daoName)),
                '","owner":"',
                Strings.toHexString(uint256(uint160(daoOwner))),
                '","total":'
            )
        );
        //string memory result = '{"total":';
        result = string(
            abi.encodePacked(
                result,
                Strings.toString(_medalnameArr.length),
                ',"medals":['
            )
        );
        unchecked {
            for (uint256 i = offset; i < offset + limit; i++) {
                if (i >= _medalnameArr.length) {
                    break;
                }
                if (i > offset) {
                    result = string(abi.encodePacked(result, ","));
                }
                result = string(
                    abi.encodePacked(
                        result,
                        "{",
                        '"index":',
                        Strings.toString(i),
                        ',"name":"',
                        Base64.encode(bytes(_medalnameArr[i])),
                        '","uri":"',
                        Base64.encode(bytes(_medaluriArr[i])),
                        '","request":',
                        Strings.toString(_medalPanel[i]._request),
                        ',"approved":',
                        Strings.toString(_medalPanel[i]._approved),
                        ',"rejected":',
                        Strings.toString(_medalPanel[i]._rejected),
                        ',"genesis":',
                        Strings.toString(_medalPanel[i]._genesis),
                        "}"
                    )
                );
            }
        }
        result = string(abi.encodePacked(result, "]}"));

        return result;
    }

    // endregion

    // region user

    /**
     * @dev get user info
     * @param _address address user address
     * @return string json string of user info
     */
    function userDetail(address _address) public view returns (string memory) {
        /* 
{
    "owner": [
        "0x1",
        "0x2"
    ],
    "medals": [
        {
            "dao": "0x1",
            "owned": [
                {
                    "index": 0,
                    "name": "base64 string",
                    "uri": "base64 string",
                    "request": 0,
                    "approved": 0,
                    "rejected": 0,
                    "genesis": 1539098983
                }
            ]
        }
    ]
}
         */
        string memory result = '{"owner":[';
        address[] memory _ownerArr = contractOwnerMap[_address];
        uint256 _i = 0;
        for (uint256 i = 0; i < _ownerArr.length; i++) {
            address _dao = _ownerArr[i];
            IOwnable ownable = IOwnable(_dao);
            address owner = ownable.owner();
            if (owner != _address) {
                continue;
            }
            if (_i > 0) {
                result = string(abi.encodePacked(result, ","));
            }
            result = string(
                abi.encodePacked(
                    result,
                    '"',
                    Strings.toHexString(uint256(uint160(_dao))),
                    '"'
                )
            );
            _i++;
        }
        result = string(abi.encodePacked(result, '],"medals":['));
        uint256[] memory userDaoMedals = userDaoMedalsDaoIndexMap[_address];
        for (uint256 i = 0; i < userDaoMedals.length; i++) {
            if (i > 0) {
                result = string(abi.encodePacked(result, ","));
            }
            address _dao = storageEnumerableDAOArr[userDaoMedals[i] - 1];
            result = string(
                abi.encodePacked(
                    result,
                    '{"dao":"',
                    Strings.toHexString(uint256(uint160(_dao))),
                    '","owned":['
                )
            );
            ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
            string[] memory _medalnameArr;
            string[] memory _medaluriArr;
            ISoulBoundMedal.MedalPanel[] memory _medalPanel;
            try medalContract.getMedals() returns (
                string[] memory __medalnameArr,
                string[] memory __medaluriArr,
                ISoulBoundMedal.MedalPanel[] memory __medalPanel
            ) {
                _medalnameArr = __medalnameArr;
                _medaluriArr = __medaluriArr;
                _medalPanel = __medalPanel;
            } catch {}
            bytes32 userDAOMappingKey = keccak256(
                abi.encodePacked(_address, _dao)
            );
            uint256[] memory ownedMedalsIndex = userDaoMedalsMapIndex[
                userDAOMappingKey
            ];
            for (uint256 j = 0; j < ownedMedalsIndex.length; j++) {
                if (j > 0) {
                    result = string(abi.encodePacked(result, ","));
                }
                uint256 medalIndex = ownedMedalsIndex[j];

                result = string(
                    abi.encodePacked(
                        result,
                        '{"index":',
                        Strings.toString(medalIndex),
                        ',"name":"',
                        Base64.encode(bytes(_medalnameArr[medalIndex])),
                        '","uri":"',
                        Base64.encode(bytes(_medaluriArr[medalIndex])),
                        '","request":',
                        Strings.toString(_medalPanel[medalIndex]._request),
                        ',"approved":',
                        Strings.toString(_medalPanel[medalIndex]._approved),
                        ',"rejected":',
                        Strings.toString(_medalPanel[medalIndex]._rejected),
                        ',"genesis":',
                        Strings.toString(_medalPanel[medalIndex]._genesis),
                        "}"
                    )
                );
            }
            result = string(abi.encodePacked(result, "]}"));
        }
        result = string(abi.encodePacked(result, "]}"));

        return result;
    }

    // endregion
}
