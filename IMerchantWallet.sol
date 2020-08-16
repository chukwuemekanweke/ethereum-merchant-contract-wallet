pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @dev Interface of the EtherWallet
 */
interface IMerchantWallet {
    function createEtherWallet(string calldata clientId)
        external
        returns (bool);

    function AddNewEtherWallet(string calldata clientId)
        external
        returns (bool);

    function sweepEthersForClient(string calldata clientId)
        external
        returns (bool);

    function sweepEthers(address walletContractAddress) external returns (bool);

    function sendEthers(
        uint256 amountToSend,
        address payable receiverAddress,
        address walletContractAddress
    ) external returns (bool);

    function sweepTokensForClient(
        address tokenAddress,
        string calldata clientId
    ) external returns (bool);

    function sweepTokens(address walletContractAddress, address tokenAddress)
        external
        returns (bool);

    function sendTokens(
        uint256 amountToSend,
        address payable receiverAddress,
        address walletContractAddress,
        address tokenAddress
    ) external returns (bool);

    function tokenBalanceOfForClient(
        string calldata clientId,
        address tokenAddress
    ) external view returns (uint256 amount);

    function tokenBalanceOf(address walletContractAddress, address tokenAddress)
        external
        view
        returns (uint256);

    function tokenDecimals(address walletContractAddress, address tokenAddress)
        external
        view
        returns (uint8);

    function etherBalanceOf(address walletContractAddress)
        external
        view
        returns (uint256);

    function etherBalanceOfForClient(string calldata clientId)
        external
        view
        returns (uint256 amount);

    function getClients() external view returns (string[] memory);

    function getClientEtherWalletAddress(
        string calldata clientId,
        uint256 index
    ) external view returns (address);

    function getClientWalletCount(string calldata clientId)
        external
        view
        returns (uint256 count);
}
