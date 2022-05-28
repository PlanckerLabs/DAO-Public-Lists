// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId)
        external
        view
        returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator)
        external
        view
        returns (bool);
}

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length)
        internal
        pure
        returns (string memory)
    {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

interface ISoulBoundMedal is IERC721 {
    /**
     * @dev get logo
     * @return string RFC 3986 URL of the logo
     */
    function getLogoURI() external view returns (string memory);

    /**
     * @dev update logo URI
     * @param logoURI RFC 3986 URL of the logo
     */
    function setLogoURI(string calldata logoURI) external;

    /**
     * @dev get description
     * @return string  description
     */
    function getDescription() external view returns (string memory);

    /**
     * @dev update description
     * @param description description
     */
    function setDescription(string calldata description) external;

    /**
     * @dev Add medals to current DAO
     * @param medals array of medals
     */
    function addMedals(string[] calldata medals) external;

    /**
     * @dev list medals
     * @return string[] the list of medals
     */
    function getMedals() external view returns (string[] memory);

    /**
     * @dev A medal for a community contributor
     * @param contributor address of the contributor
     * @param medal  the medal
     */
    function award(address contributor, uint8 medal) external;

    /**
     * @dev Check if an address has been awarded a medal
     * @param contributor address of the contributor
     * @param medal  the medal
     * @return true if the address has been awarded the medal
     */
    function awarded(address contributor, uint8 medal)
        external
        view
        returns (bool);

    /**
     * @dev Community contributor cliam a medal
     * Emits a {Transfer} event.
     */
    function cliam(uint8 medal) external;
}

interface IDAO2DAOMedal {
    /**
     * @dev register a new DAO
     */
    function register(address _dao) external;

    /**
     * @dev link currentDAO to remoteDAO
     * @param remoteDAO address of the remote DAO
     * @param currentDAO address of the current DAO
     * @param medalMap_from remote DAO medals
     * @param medalMap_to current DAO medals
     */
    function linkDAO(
        address remoteDAO,
        address currentDAO,
        uint8[] calldata medalMap_from,
        uint8[] calldata medalMap_to
    ) external;

    /*
     * @dev unlink currentDAO & remoteDAO
     * @param remoteDAO address of the remote DAO
     * @param currentDAO address of the current DAO
     */
    function unlinkDAO(address remoteDAO, address currentDAO) external;

    /**
     * @dev Check if an address has been awarded a medal in other DAOs
     * @param currentDAO address of the current DAO
     * @param contributor address of the contributor
     * @return true if has been awarded in other DAOs
     */
    function medalCrossVerify(
        address currentDAO,
        address contributor,
        uint8 medal
    ) external view returns (bool);
}

interface IOwnable {
    function owner() external view returns (address);
}

contract DAO2DAOMedal is Ownable, IDAO2DAOMedal {
    struct LinkData {
        address remoteDAO;
        uint8[] medalMap_from;
        uint8[] medalMap_to;
    }

    mapping(address => LinkData[]) _linkMap;
    mapping(address => mapping(address => uint256)) _linkRemoteIndexMap;
    address[] _registeredDAOs;
    mapping(address => uint8) _registeredDAOsIndex;

    function name() public pure returns (string memory) {
        return "DAO to DAO Bridge DEMO";
    }

    modifier onlyDAOContractOwner(address _dao) {
        require(
            msg.sender == IOwnable(_dao).owner(),
            "Only DAO contract owner can call this function"
        );
        _;
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
     * @dev register a new DAO
     */
    function register(address _dao)
        public
        override
        onlySoulBoundMedalAddress(_dao)
    {
        _register(_dao);
    }

    function _register(address _dao) private {
        if (_registeredDAOsIndex[_dao] == 0) {
            _registeredDAOs.push(_dao);
            _registeredDAOsIndex[_dao] = 1;
        }
    }

    /**
     * @dev list DAO address
     * @param offset the offset, from 0
     * @param limit the limit, minimum 1
     * @return string the list of DAO link status
     */
    function listDaos(uint256 offset, uint256 limit)
        public
        view
        returns (string memory)
    {
        string memory result = "[";
        for (
            uint256 i = offset;
            i < _registeredDAOs.length && i < offset + limit;
            i++
        ) {
            if (i > offset) {
                result = string(abi.encodePacked(result, ","));
            }
            address dao = _registeredDAOs[i];
            result = string(
                abi.encodePacked(
                    result,
                    '{"address": "',
                    Strings.toHexString(uint256(uint160(dao))),
                    '","link": ['
                )
            );
            for (uint256 j = 0; j < _linkMap[dao].length; j++) {
                if (j > 0) {
                    result = string(abi.encodePacked(result, ","));
                }
                LinkData memory linkData = _linkMap[dao][j];
                uint8[] memory medalMap_from = linkData.medalMap_from;
                uint8[] memory medalMap_to = linkData.medalMap_to;
                result = string(
                    abi.encodePacked(
                        result,
                        '{"address": "',
                        Strings.toHexString(
                            uint256(uint160(linkData.remoteDAO))
                        ),
                        '","mapping": [['
                    )
                );
                for (uint256 k = 0; k < medalMap_from.length; k++) {
                    if (k > 0) {
                        result = string(abi.encodePacked(result, ","));
                    }
                    result = string(
                        abi.encodePacked(
                            result,
                            Strings.toString(uint256(medalMap_from[k]))
                        )
                    );
                }
                result = string(abi.encodePacked(result, "],["));
                for (uint256 k = 0; k < medalMap_to.length; k++) {
                    if (k > 0) {
                        result = string(abi.encodePacked(result, ","));
                    }
                    result = string(
                        abi.encodePacked(
                            result,
                            Strings.toString(uint256(medalMap_to[k]))
                        )
                    );
                }
                result = string(abi.encodePacked(result, "]]}"));
            }
            result = string(abi.encodePacked(result, "]}"));
        }

        return string(abi.encodePacked(result, "]"));
    }

    /**
     * @dev link currentDAO to remoteDAO
     * @param remoteDAO address of the remote DAO
     * @param currentDAO address of the current DAO
     * @param medalMap_from remote DAO medals
     * @param medalMap_to current DAO medals
     */
    function linkDAO(
        address remoteDAO,
        address currentDAO,
        uint8[] calldata medalMap_from,
        uint8[] calldata medalMap_to
    )
        public
        override
        onlyDAOContractOwner(currentDAO)
        onlySoulBoundMedalAddress(currentDAO)
        onlySoulBoundMedalAddress(remoteDAO)
    {
        require(
            medalMap_from.length == medalMap_to.length &&
                medalMap_from.length > 0,
            "medalMap_from and medalMap_to must have same length"
        );
        uint256 index = _linkRemoteIndexMap[currentDAO][remoteDAO];
        if (index > 0) {
            _linkMap[currentDAO][index - 1].medalMap_from = medalMap_from;
            _linkMap[currentDAO][index - 1].medalMap_to = medalMap_to;
        } else {
            LinkData memory linkData;
            linkData.medalMap_from = medalMap_from;
            linkData.medalMap_to = medalMap_to;
            linkData.remoteDAO = remoteDAO;
            _linkMap[currentDAO].push(linkData);
            _linkRemoteIndexMap[currentDAO][remoteDAO] = _linkMap[currentDAO]
                .length; // minimum index is 1
        }
        _register(remoteDAO);
        _register(currentDAO);
    }

    /*
     * @dev unlink currentDAO & remoteDAO
     * @param remoteDAO address of the remote DAO
     * @param currentDAO address of the current DAO
     */
    function unlinkDAO(address remoteDAO, address currentDAO)
        public
        override
        onlyDAOContractOwner(currentDAO)
        onlySoulBoundMedalAddress(currentDAO)
        onlySoulBoundMedalAddress(remoteDAO)
    {
        uint256 index = _linkRemoteIndexMap[currentDAO][remoteDAO];
        if (index > 0) {
            delete _linkMap[currentDAO][index - 1];
            _linkRemoteIndexMap[currentDAO][remoteDAO] = 0;
        } else {
            revert("remoteDAO not linked");
        }
    }

    /**
     * @dev Check if an address has been awarded a medal in other DAOs
     * @param currentDAO address of the current DAO
     * @param contributor address of the contributor
     * @return true if has been awarded in other DAOs
     */
    function medalCrossVerify(
        address currentDAO,
        address contributor,
        uint8 medal
    ) public view override returns (bool) {
        LinkData[] memory linkData = _linkMap[currentDAO];
        for (uint8 i = 0; i < linkData.length; i++) {
            LinkData memory link = linkData[i];
            ISoulBoundMedal soulBoundMedal = ISoulBoundMedal(link.remoteDAO);
            for (uint8 j = 0; j < link.medalMap_to.length; j++) {
                if (link.medalMap_to[j] == medal) {
                    uint8 _medal = link.medalMap_from[j];
                    if (soulBoundMedal.awarded(contributor, _medal)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
