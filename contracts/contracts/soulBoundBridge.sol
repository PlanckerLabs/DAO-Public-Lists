// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./ISoulBoundMedal.sol";
import "./IDataStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "./ISoulBoundBridge.sol";

interface ITokenInfo {
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() external view returns (address);

    function name() external view returns (string memory);
}

contract SoulBoundBridge is IDataStorage, ISoulBoundBridge {
    // region variables

    address[] private storageEnumerableUserArr;

    mapping(address => uint256[]) private storageEnumerableUserMap;

    mapping(bytes32 => bool) private userDAOMapping;

    mapping(address => uint256) private storageEnumerableDAOMap;

    address[] private storageEnumerableDAOArr;

    mapping(address => mapping(bytes4 => string)) private storageStrings;

    mapping(address => uint256[]) private userDaoMedalsDaoIndexMap; // key: user address,value:index-1 is the dao in the storageEnumerableDAOArr
    mapping(bytes32 => uint256[]) private userDaoMedalIndexMapIndex; // key: user address+ dao address,value:medalIndex
    mapping(bytes32 => bool) private userDaoMedalIndexMapUnique; // key: user address+ dao address+ medalIndex,value: true:has set
    mapping(address => address[]) private contractOwnerMap; // key:user address,value: dao address array
    mapping(bytes32 => uint256) private contractOwnerMapIndex; // key: user address+ dao address,value -1 is the index of the contractOwnerMap -> value
    mapping(address => address) private DAOOwner; // key:dao address,value:owner address

    // endregion

    // region functional
    constructor() {}

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
        require(_soulBoundMedalAddress.code.length > 0);
        require(
            IERC165(_soulBoundMedalAddress).supportsInterface(
                type(ISoulBoundMedal).interfaceId
            )
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
        ITokenInfo ownable = ITokenInfo(_dao);
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
        ITokenInfo ownable = ITokenInfo(_dao);
        try ownable.name() returns (string memory _name) {
            return _name;
        } catch {}
        return "";
    }

    function _changeOwner(address _dao) private {
        address owner_before = DAOOwner[_dao];
        address owner_after = getOwner(_dao);
        if (owner_before != owner_after) {
            bytes32 key_before = keccak256(
                abi.encodePacked(_dao, owner_before)
            );
            bytes32 key_after = keccak256(abi.encodePacked(_dao, owner_after));
            uint256 index_before = contractOwnerMapIndex[key_before];
            if (index_before > 0) {
                // delete item from contractOwnerMap[owner_before][index_before-1]
                unchecked {
                    uint256 index_before_real = index_before - 1;
                    contractOwnerMap[owner_before][
                        index_before_real
                    ] = contractOwnerMap[owner_before][
                        contractOwnerMap[owner_before].length - 1
                    ];
                    // move item to the end of the array,then delete the last item
                    contractOwnerMap[owner_before].pop();
                }
                contractOwnerMapIndex[key_before] = 0;
            }

            if (contractOwnerMapIndex[key_after] == 0) {
                contractOwnerMap[owner_after].push(_dao);
                contractOwnerMapIndex[key_after] = contractOwnerMap[owner_after]
                    .length;
            }
        }
    }

    function register(address _dao) public onlySoulBoundMedalAddress(_dao) {
        require(storageEnumerableDAOMap[_dao] == 0); //, "already registered"
        storageEnumerableDAOArr.push(_dao);
        storageEnumerableDAOMap[_dao] = storageEnumerableDAOArr.length;
        // register owner
        _changeOwner(_dao);
    }

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
    ) public override {
        if (storageEnumerableDAOMap[_dao] == 0) {
            require(_dao.code.length > 0); //, "not a valid contract"
            require(
                IERC165(_dao).supportsInterface(
                    type(ISoulBoundMedal).interfaceId
                )
            );//  "not a valid soulbound contract"
            storageEnumerableDAOArr.push(_dao);
            storageEnumerableDAOMap[_dao] = storageEnumerableDAOArr.length;

            // register owner
            _changeOwner(_dao);
        }
        bytes32 userDAOMappingKey = keccak256(abi.encodePacked(_address, _dao));
        if (userDAOMapping[userDAOMappingKey] == false) {
            // register user
            require(_address.code.length == 0);//, "address is a contract"
            userDAOMapping[userDAOMappingKey] = true;
            if (storageEnumerableUserMap[_address].length == 0) {
                storageEnumerableUserArr.push(_address);
            }
            storageEnumerableUserMap[_address].push(
                storageEnumerableDAOMap[_dao]
            );
        }

        bytes32 userDAOMedalIndexMappingKey = keccak256(
            abi.encodePacked(_address, _dao, _medalIndex)
        );
        if (userDaoMedalIndexMapUnique[userDAOMedalIndexMappingKey] == false) {
            userDaoMedalIndexMapUnique[userDAOMedalIndexMappingKey] = true;

            if (userDaoMedalIndexMapIndex[userDAOMappingKey].length == 0) {
                uint256 DAOIndex = storageEnumerableDAOMap[_dao];
                userDaoMedalsDaoIndexMap[_address].push(DAOIndex);
            }
            userDaoMedalIndexMapIndex[userDAOMappingKey].push(_medalIndex);
        }
    }

    // endregion

    // region Composability functions for other contracts

    //DAOOwner
    function getDAOOwner(address _dao) public view returns (address) {
        return DAOOwner[_dao];
    }

    //address[] private storageEnumerableUserArr;
    function get_storageEnumerableUserArr()
        public
        view
        returns (address[] memory)
    {
        return storageEnumerableUserArr;
    }

    //mapping(address => uint256[]) private storageEnumerableUserMap;
    function get_storageEnumerableUserMap(address _address)
        public
        view
        returns (uint256[] memory)
    {
        return storageEnumerableUserMap[_address];
    }

    //mapping(bytes32 => bool) private userDAOMapping;
    function get_userDAOMapping(bytes32 key) public view returns (bool) {
        return userDAOMapping[key];
    }

    //mapping(address => uint256) private storageEnumerableDAOMap;
    function get_storageEnumerableDAOMap(address _dao)
        public
        view
        returns (uint256)
    {
        return storageEnumerableDAOMap[_dao];
    }

    //address[] private storageEnumerableDAOArr;
    function get_storageEnumerableDAOArr()
        public
        view
        returns (address[] memory)
    {
        return storageEnumerableDAOArr;
    }

    //mapping(address => mapping(bytes4 => string)) private storageStrings;
    function get_storageStrings(address _dao, bytes4 _key)
        public
        view
        returns (string memory)
    {
        return storageStrings[_dao][_key];
    }

    //mapping(address => uint256[]) private userDaoMedalsDaoIndexMap;
    function get_userDaoMedalsDaoIndexMap(address _address)
        public
        view
        returns (uint256[] memory)
    {
        return userDaoMedalsDaoIndexMap[_address];
    }

    //mapping(bytes32 => uint256[]) private userDaoMedalIndexMapIndex;
    function get_userDaoMedalIndexMapIndex(bytes32 key)
        public
        view
        returns (uint256[] memory)
    {
        return userDaoMedalIndexMapIndex[key];
    }

    //mapping(bytes32 => bool) private userDaoMedalIndexMapUnique;
    function get_userDaoMedalIndexMapUnique(bytes32 key)
        public
        view
        returns (bool)
    {
        return userDaoMedalIndexMapUnique[key];
    }

    //mapping(address => address[]) private contractOwnerMap;
    function get_contractOwnerMap(address _owner)
        public
        view
        returns (address[] memory)
    {
        return contractOwnerMap[_owner];
    }

    //mapping(bytes32 => uint256) private contractOwnerMapIndex;
    function get_contractOwnerMapIndex(bytes32 key)
        public
        view
        returns (uint256)
    {
        return contractOwnerMapIndex[key];
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
            "status":0 //// status of the cliam,   1:pending,2:rejected ,>2 tokenid
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

    // region tokenId

    // /**
    //  * @dev get tokenId or cliam status by DAO and medal index
    //  * @param _user address user address
    //  * @param _dao address DAO contract address
    //  * @param _medalIndex uint256 medal index
    //  * @return uint256   1:pending,2:rejected ,>2 tokenid
    //  */
    // function _getCliamStatusByBytes32Key(
    //     address _user,
    //     address _dao,
    //     uint256 _medalIndex
    // ) private view returns (uint256) {
    //     ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
    //     bytes32 k = keccak256(abi.encodePacked(_user, _medalIndex));
    //     try medalContract.getCliamStatusByBytes32Key(k) returns (
    //         uint256 _status
    //     ) {
    //         return _status;
    //     } catch {}
    //     return 0;
    // }

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
    "owned": [
        "0x1",
        "0x2"
    ],
    "dao": [
        {
            "address": "0x1",
            "medals": [
                {
                    "medalindex": 0, 
                    "status":1, //status of the cliam,0:nodata, 1:pending,2:rejected ,>2 tokenid
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
        string memory result = '{"owned":[';

        {
            //Stack too deep
            address[] memory _ownerArr = contractOwnerMap[_address];
            uint256 _i = 0;
            for (uint256 i = 0; i < _ownerArr.length; i++) {
                address _dao = _ownerArr[i];
                ITokenInfo ownable = ITokenInfo(_dao);
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
        }
        result = string(abi.encodePacked(result, '],"dao":['));
        {
            uint256[] memory userDaoMedals = userDaoMedalsDaoIndexMap[_address];

            for (uint256 i = 0; i < userDaoMedals.length; i++) {
                //for (uint256 i = _pageIndex*5; i < 5*(_pageIndex+1); i++) {
                if (i > 0) {
                    result = string(abi.encodePacked(result, ","));
                }
                address _dao = storageEnumerableDAOArr[userDaoMedals[i] - 1];
                {
                    result = string(
                        abi.encodePacked(
                            result,
                            '{"address":"',
                            Strings.toHexString(uint256(uint160(_dao))),
                            '","medals":['
                        )
                    );
                }
                {
                    ISoulBoundMedal medalContract = ISoulBoundMedal(_dao);
                    string[] memory _medalnameArr;
                    string[] memory _medaluriArr;
                    ISoulBoundMedal.MedalPanel[] memory _medalPanel;
                    {
                        try medalContract.getMedals() returns (
                            string[] memory __medalnameArr,
                            string[] memory __medaluriArr,
                            ISoulBoundMedal.MedalPanel[] memory __medalPanel
                        ) {
                            _medalnameArr = __medalnameArr;
                            _medaluriArr = __medaluriArr;
                            _medalPanel = __medalPanel;
                        } catch {}
                    }
                    uint256[]
                        memory requestedMedalIndexArrary = userDaoMedalIndexMapIndex[
                            keccak256(abi.encodePacked(_address, _dao))
                        ];

                    for (
                        uint256 j = 0;
                        j < requestedMedalIndexArrary.length;
                        j++
                    ) {
                        if (j > 0) {
                            result = string(abi.encodePacked(result, ","));
                        }
                        uint256 status = 0;
                        uint256 medalIndex = requestedMedalIndexArrary[j];
                        {
                            try
                                medalContract.getCliamStatusByBytes32Key(
                                    keccak256(
                                        abi.encodePacked(_address, medalIndex)
                                    )
                                )
                            returns (uint256 _status) {
                                status = _status;
                            } catch {}
                        }
                        {
                            result = string(
                                abi.encodePacked(
                                    result,
                                    '{"medalindex":',
                                    Strings.toString(medalIndex),
                                    ',"status":',
                                    Strings.toString(status),
                                    ',"name":"',
                                    Base64.encode(
                                        bytes(_medalnameArr[medalIndex])
                                    ),
                                    '","uri":"',
                                    Base64.encode(
                                        bytes(_medaluriArr[medalIndex])
                                    ),
                                    '","request":',
                                    Strings.toString(
                                        _medalPanel[medalIndex]._request
                                    ),
                                    ',"approved":',
                                    Strings.toString(
                                        _medalPanel[medalIndex]._approved
                                    ),
                                    ',"rejected":',
                                    Strings.toString(
                                        _medalPanel[medalIndex]._rejected
                                    ),
                                    ',"genesis":',
                                    Strings.toString(
                                        _medalPanel[medalIndex]._genesis
                                    ),
                                    "}"
                                )
                            );
                        }
                    }
                }
                result = string(abi.encodePacked(result, "]}"));
            }
        }

        result = string(abi.encodePacked(result, "]}"));

        return result;
    }

    // endregion
}
