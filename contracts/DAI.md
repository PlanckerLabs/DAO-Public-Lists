# Decentralized Application interface

soulBoundMedal.sol 为SoulBound DAO合约。

soulBoundBridge.sol 为 DAO 之间的桥接工具 , 
- 当前桥接工具部署地址为：[0x4702a438E2DC4Bf2F5ba4BA49027d49407157CcC](https://mumbai.polygonscan.com/address/0x4702a438e2dc4bf2f5ba4ba49027d49407157ccc#code)

# soulBoundMedal.sol

```solidity
// ################################################## 
// ###############  constructor  ####################   
// ##################################################  
constructor(
          string memory _name,// NFT Collection Name | NFT集合名称
          string memory _symbol, // NFT Collection Symbol | NFT集合代号
          string[] memory _medalname, // Medal Name Arrary , length must be equal to _medaluri | 勋章名称数组，长度必须与_medaluri一致
          string[] memory _medaluri, // Medal Image Url Arrary , length must be equal to _medalname | 勋章图片url数组，长度必须与_medalname一致
          address _daoBridgeAddress // DAO Bridge Address, used to get cliam status | DAO桥接工具地址，用于获取mint状态等
          )
      )
      
// ##################################################     
    /**
     * @dev save string to storage | 存储字符串
     * @param k key | 键
     * @param v value | 值
     */
    function saveString(bytes4 k, string calldata v)


// ##################################################    

   /**
    * @dev save multiple string to storage | 存储多个字符串
    * @param k key arrary | 键数组
    * @param v value arrary | 值数组
    */
    function saveStrings(bytes4[] calldata k, string[] calldata v)

// ##################################################    

   /**
     * @dev Add medals to current DAO | 添加勋章到当前DAO
     * @param medalsname array of medal name | 勋章名称数组 
     * @param medalsuri array of medal image url | 勋章图片url数组
     */
    function addMedals(
        string[] calldata medalsname,
        string[] calldata medalsuri
    )


// ##################################################    

   /**
     * @dev get medals count | 获取勋章数量
     * @return uint256 the count of medals | 勋章数量
     */
    function countMedals()

// ##################################################     

   /**
     * @dev get medals | 获取勋章
     * @return array of medals | 勋章数组
     */
    function getMedals()

// ##################################################    

   /**
     * @dev get medalIndex by tokenid | 根据 tokenid 获取勋章索引
     * @param tokenid token id | tokenid
     * @return uint256 the medal index | 勋章索引
     */
    function getMedalIndexByTokenid(uint256 tokenid)
    
    
// ##################################################   

    /**
     * @dev get cliam status by key | 根据key获取mint请求状态
     * @param key key, bytes32 : request user address + medalIndex | 键，bytes32：用户地址+勋章索引
     * @return uint8 the cliam status, 1:pending,2:rejected ,>2 tokenid    | 获取mint请求状态， 
     */
    function getCliamStatusByBytes32Key(bytes32 key)
    
    
// ##################################################     

	 /**
     * @dev get size of cliam request list  | 获取mint请求列表大小
     * @return uint256 the size of cliam request list | mint请求列表大小
     */
    function getCliamRequestSize()
    
// ##################################################    

   /**
     * @dev get cliam request item by index | 根据索引获取mint请求项
     * @return ISoulBoundMedal.CliamRequest | 结构体
     */
    function getCliamRequest(uint256 _index)
    
    
// ##################################################     

   /**
     * @dev get the size of cliam request approved list by medal index | 根据勋章索引获取mint请求通过列表大小
     * @param _medalIndex medal index | 勋章索引
     * @return uint256 the size of cliam request approved list | mint请求通过列表大小
     */
    function countCliamRequestApproved(uint256 _medalIndex)
    
    
// ################################################## 

   /**
     * @dev get Approved CliamRequest list index arrary by medal index | 根据勋章索引获取mint请求通过列表索引数组
     * @param _medalIndex medal index | 勋章索引
     * @return uint256[] CliamRequest index arrary of Cliam Request Approved | mint请求通过列表索引数组
     */
    function listCliamRequestApproved(uint256 _medalIndex)
    
// ##################################################   

   /**
     * @dev update medal by medal index  | 根据勋章索引更新勋章
     * @param medalIndex index of medal | 勋章索引
     * @param name new name of medal | 新的勋章名称
     * @param uri new image url of medal | 新的勋章图片url
     */
    function updateMedal(
        uint256 medalIndex,
        string calldata name,
        string calldata uri
    )
    
// ##################################################    

   /**
     * @dev  Approved cliam | 通过mint请求
     * @param cliamId the index of the cliam request id | mint请求索引
     * Emits a {Transfer} event. 
     */
    function cliamApproved(uint256 cliamId) 
    
// ##################################################    

    /**
     * @dev  Rejected cliam  | 拒绝mint请求
     * @param cliamId the index of the cliam request id | mint请求索引
     */
    function cliamRejected(uint256 cliamId)
    
// ##################################################   

    /**
     * @dev Users apply for mint medal | 用户申请mint勋章
     * @param medalIndex the index of the medal | 勋章索引
     */
    function cliamRequest(uint256 medalIndex)
    
// ##################################################  

   /**
     * @dev  RFC 3986 compliant URL:base64://{json encoded with base64} ,json {"name":"base64(medal name)","image":"base64(medal uri)"}
     * @param tokenId  tokenid
     * @return string  the base64 uri of the Token
     */
    function tokenURI(uint256 tokenId)
    

```



# soulBoundBridge.sol
```solidity
// ##################################################   
// #################  functional  ###################   
// ##################################################   

   /**
     * @dev save a string to the storage | 保存字符串到存储
     * @param k key | 键
     */
    function saveString(bytes4 k, string calldata v)
    
// ##################################################    

   /**
     * @dev get a string from the storage | 从存储中获取字符串
     * @param a address | 地址
     * @param k key | 键
     * @return string memory value | 字符串
     */
    function getString(address a, bytes4 k)
    
// ##################################################    

   /**
     * @dev save multiple string to the storage | 保存多个字符串到存储
     * @param k key array | 键数组
     * @param v value array | 值数组
     */
// ##################################################    

   /**
     * @dev get multiple string from the storage | 从存储中获取多个字符串
     * @param a address | 地址
     * @param k key array | 键数组
     * @return string[] memory value array | 字符串数组
     */
    function getStrings(address a, bytes4[] calldata k)
    
// ##################################################    

	 /**
     * @dev get multiple address & multiple string from the storage | 从存储中获取多个地址和多个字符串
     * @param a key array | 键数组
     * @param k value array | 值数组
     * @return string[][] memory value array | 字符串数组
     */
    function getStrings(address[] calldata a, bytes4[] calldata k)
    
// ##################################################   

   /**
     * @dev  call on DAO owner change | 调用DAO所有者改变
     * @param _dao address | DAO地址
     */
    function onOwnerChage(address _dao)
    
// ##################################################   


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
    
// ##################################################   
// ##################     DAO    ####################   
// ##################################################   

   /**
     * @dev  count DAO | 获取全部DAO数量
     * @return uint256 DAO count | DAO数量
     */
    function countDAO()

// ##################################################  

   /**
     * @dev list DAO | 获取全部DAO列表
     * @param offset uint256 query offset | 查询偏移
     * @param limit uint256 query limit | 查询限制
     * @param medals_offset uint256 medal offset | 勋章偏移
     * @param medals_limit uint256 medal limit,no medals fetched if 0 | 勋章限制，如果为0则不获取勋章
     * @return string memory  json string | json字符串
     */
    function listDAO(
        uint256 offset,
        uint256 limit,
        uint256 medals_offset,
        uint256 medals_limit // no medals fetched if 0
    )

// ##################################################   
// #################  CliamRequest  #################   
// ##################################################   

   /**
     * @dev  count CliamRequest by DAO | 获取一个DAO里的所有申请
     * @param _dao address DAO contract address | DAO合约地址
     * @return uint256 CliamRequest count | 申请数量
     */
    function countCliamRequest(address _dao) 

// ################################################## 

   /**
     * @dev  count approved CliamRequest by DAO | 获取一个DAO里的所有已批准申请
     * @param _dao address DAO contract address | DAO合约地址
     * @return string memory  json string | json字符串
     */
    function countCliamRequestApproved(address _dao)
    
// ##################################################   

   /**
     * @dev  count Approved CliamRequest by DAO and medal index | 获取一个DAO里的某个勋章的所有已批准申请
     * @param _dao address DAO contract address | DAO合约地址
     * @return string memory  json string | json字符串
     */
    function countCliamRequestApproved(address _dao, uint256 _madalIndex)
    
// ##################################################   

   /**
     * @dev get CliamRequest by DAO and index | 获取一个DAO里的某个申请
     * @param medalContract  address  medal contract address instance | 勋章合约地址实例
     * @param _index  uint256  CliamRequest index | 申请索引
     * @return string memory  json string | json字符串
     */
    function getCliamRequest(ISoulBoundMedal medalContract, uint256 _index)
    
// ##################################################   

   /**
     * @dev get CliamRequest list by DAO | 获取一个DAO里的所有申请
     * @param _dao address DAO contract address | DAO合约地址
     * @param _offset uint256 query offset | 查询偏移
     * @param _limit uint256 query limit | 查询限制
     * @return string memory  json string | json字符串
     */
    function getCliamRequest(
        address _dao,
        uint256 _offset,
        uint256 _limit
    )
    
// ##################################################

   /**
     * @dev get CliamRequest Approved list by DAO | 获取一个DAO里的所有已批准申请
     * @param _dao address DAO contract address | DAO合约地址
     * @param _offset uint256 query offset | 查询偏移
     * @param _limit uint256 query limit | 查询限制
     * @return string memory  json string | json字符串
     */
    function getCliamRequestApproved(
        address _dao,
        uint256 _offset, // offset of each medal
        uint256 _limit // limit of each medal
    )
    
// ##################################################   

   /**
     * @dev get CliamRequest Approved list by DAO and medal index | 获取一个DAO里的某个勋章的所有已批准申请
     * @param _dao address DAO contract address | DAO合约地址
     * @param _offset uint256 query offset | 查询偏移
     * @param _limit uint256 query limit | 查询限制
     * @param _medalIndex uint256 medal index | 勋章索引
     * @return string memory  json string | json字符串
     */
    function getCliamRequestApproved(
        address _dao,
        uint256 _offset,
        uint256 _limit,
        uint256 _medalIndex
    ) 
    
// ##################################################   
// ###################  medals  #####################   
// ##################################################  

   /**
     * @dev list medals of DAO | 获取一个DAO里的所有勋章
     * @param offset the offset, from 0 to count - 1 | 查询偏移
     * @param limit the limit, minimum 1 | 查询限制
     * @return string json string of query result | json字符串
     */
    function listDAOMedals(
        address _address,
        uint256 offset,
        uint256 limit
    )
    
// ##################################################   
// #################       user     #################   
// ################################################## 

   /**
     * @dev get user info | 获取用户信息
     * @param _address address user address | 用户地址
     * @return string json string of user info | json字符串
     */
    function userDetail(address _address)

```

