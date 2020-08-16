pragma solidity ^0.6.0;

/**
 * @dev Interface of the EtherWallet
 */
interface IEtherWallet {
    /**
     * @dev Transfers  ethers to address
     */

    function sendEthers(uint256 amount, address payable receiver)
        external
        returns (uint256, address);

    /**
     * @dev Returns the ether balance for this contract
     */
    function etherBalanceOf() external view returns (uint256);

    function tokenBalanceOf(address tokenAddress)
        external
        view
        returns (uint256);

    /**
     * @dev transfers  tokens to address
     */

    function sendTokens(
        uint256 amount,
        address receiver,
        address tokenAddress
    )
        external
        returns (
            uint256,
            address,
            address
        );

    /**
     * @dev transfers  tokens to address
     */

    function sendBadTokens(
        uint256 amount,
        address receiver,
        address tokenAddress
    )
        external
        returns (
            uint256,
            address,
            address
        );

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    //event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    //event Approval(address indexed owner, address indexed spender, uint256 value);
}
