
// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/Ownable.sol

pragma solidity ^0.6.0;
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    address public pendingOwner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor(address owner_) public {
        owner = owner_;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    /**
     * @dev Allows the current owner to set the pendingOwner address.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    /**
     * @dev Allows the pendingOwner address to finalize the transfer.
     */
    function claimOwnership() public {
        require(msg.sender == pendingOwner, "onlyPendingOwner");
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// File: contracts/CloneLib.sol

pragma solidity ^0.6.0;

library CloneLib {
    /*
        returns bytecode of a new contract that clones template
    */
    //https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-sdk/master/packages/lib/contracts/upgradeability/ProxyFactory.sol
    function cloneBytecode(address template)
        internal
        pure
        returns (bytes memory code)
    {
        // Adapted from https://github.com/optionality/clone-factory/blob/32782f82dfc5a00d103a7e61a17a5dedbd1e8e9d/contracts/CloneFactory.sol
        bytes20 targetBytes = bytes20(template);
        assembly {
            code := mload(0x40)
            //code length is 0x37 plus 0x20 for bytes length field. update free memory pointer
            mstore(0x40, add(code, 0x57))
            //store length in first 32 bytes
            mstore(code, 0x37)
            //store data after first 32 bytes
            mstore(
                add(code, 0x20),
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(code, 0x34), targetBytes)
            mstore(
                add(code, 0x48),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
        }
    }

    function predictCloneAddressCreate2(
        address template,
        address deployer,
        bytes32 salt
    ) internal pure returns (address proxy) {
        bytes32 codehash = keccak256(cloneBytecode(template));
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xff),
                                deployer,
                                salt,
                                codehash
                            )
                        )
                    )
                )
            );
    }

    function deployCodeAndInitUsingCreate(
        bytes memory code,
        bytes memory init_data
    ) internal returns (address proxy) {
        uint256 len = code.length;
        assembly {
            proxy := create(0, add(code, 0x20), len)
        }

        if (init_data.length > 0) {
            (bool success, ) = proxy.call(init_data);
            require(success);
        }
    }
/*
    predictable address. see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1014.md
*/

    function deployCodeAndInitUsingCreate2(
        bytes memory code,
        bytes memory init_data,
        bytes32 salt
    ) internal returns (address proxy) {
        uint256 len = code.length;
        assembly {
            proxy := create2(0, add(code, 0x20), len, salt)
        }

        if (init_data.length > 0) {
            (bool success, ) = proxy.call(init_data);
            require(success);
        }
    }
}

// File: contracts/DataUnionFactoryMainnet.sol

pragma solidity ^0.6.0;





interface IAMB {
    function messageSender() external view returns (address);

    function maxGasPerTx() external view returns (uint256);

    function transactionHash() external view returns (bytes32);

    function messageId() external view returns (bytes32);

    function messageSourceChainId() external view returns (bytes32);

    function messageCallStatus(bytes32 _messageId) external view returns (bool);

    function failedMessageDataHash(bytes32 _messageId)
        external
        view
        returns (bytes32);

    function failedMessageReceiver(bytes32 _messageId)
        external
        view
        returns (address);

    function failedMessageSender(bytes32 _messageId)
        external
        view
        returns (address);

    function requireToPassMessage(
        address _contract,
        bytes calldata _data,
        uint256 _gas
    ) external returns (bytes32);
}

interface ITokenMediator {
    function erc677token() external view returns (address);
    function bridgeContract() external view returns (address);
    function relayTokens(address _from, address _receiver, uint256 _value) external;
}

interface IDataUnionMainnet {
        function sidechainAddress() external view returns (address proxy);
}


contract DataUnionFactoryMainnet {
    event MainnetDUCreated(address indexed mainnet, address indexed sidechain, address indexed owner, address template);

    address public data_union_mainnet_template;

    //needed to calculate address of sidechain contract
    address public data_union_sidechain_template;
    address public data_union_sidechain_factory;
    uint256 public sidechain_maxgas;
    IAMB public amb;
    ITokenMediator public token_mediator;

    constructor( address _token_mediator, 
                address _data_union_mainnet_template,
                address _data_union_sidechain_template,
                address _data_union_sidechain_factory,
                uint256 _sidechain_maxgas) public {
        token_mediator = ITokenMediator(_token_mediator);
        data_union_mainnet_template = _data_union_mainnet_template;
        data_union_sidechain_template = _data_union_sidechain_template;
        data_union_sidechain_factory = _data_union_sidechain_factory;
        amb = IAMB(token_mediator.bridgeContract());
        sidechain_maxgas = _sidechain_maxgas;
    }

    function sidechainAddress(address mainet_address)
        public view
        returns (address proxy)
    {
        return CloneLib.predictCloneAddressCreate2(
            data_union_sidechain_template,
            data_union_sidechain_factory,
            bytes32(bytes20(mainet_address)));
    }

/*
    function initialize(
        address _token_mediator,
        address _sidechain_DU_factory,
        uint256 _sidechain_maxgas,
        address _sidechain_template_DU,
        address _owner,
        uint256 adminFeeFraction,
        address[] memory agents
    )  public {
    users can only deploy with salt = their key.
*/
    function deployNewDUMainnet(address owner, uint256 adminFeeFraction, address[] memory agents) public returns (address) {
        bytes memory data = abi.encodeWithSignature("initialize(address,address,uint256,address,address,uint256,address[])",
            token_mediator,
            data_union_sidechain_factory,
            sidechain_maxgas,
            data_union_sidechain_template,
            owner,
            adminFeeFraction,
            agents
        );
        address du = CloneLib.deployCodeAndInitUsingCreate(CloneLib.cloneBytecode(data_union_mainnet_template), data);
        emit MainnetDUCreated(du, sidechainAddress(du), owner, data_union_mainnet_template);
        return du;
    }
}
