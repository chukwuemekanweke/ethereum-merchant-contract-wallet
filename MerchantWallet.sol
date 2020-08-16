pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
//import "./IERC20Wallet.sol";
//import "./ERC20Wallet.sol";

import "./IEtherWallet.sol";
import "./EtherWallet.sol";

import "./IERC20.sol";

import "./SafeMath.sol";

contract MerchantWallet is Ownable {
    string[] public clients;

    //A map of a user's ether wallets
    mapping(string => address[]) public etherContractWallets;
    mapping(address => string) public contractWalletOwners;

    event WalletCreationEvent(
        address contractWalletAddress,
        address merchantWalletAddress,
        string clientId
    );

    event TokenSweepEvent(
        uint256 amount,
        address tokenAddress,
        address destinationAddress,
        address merchantWalletAddress,
        address contractWalletAddress,
        string clientId
    );

    event EtherSweepEvent(
        uint256 amount,
        address destinationAddress,
        address merchantWalletAddress,
        address contractWalletAddress,
        string clientId
    );

    constructor(address _admin, address payable _owner) public {
        owner = _owner;
        admin = _admin;
    }

    function createEtherWallet(string calldata clientId)
        external
        onlyOwner
        returns (bool)
    {
        require(
            etherContractWallets[clientId].length == 0,
            "MerchantWallet: Ether wallet exists"
        );
        createWallet(clientId);
        clients.push(clientId);
        return true;
    }

    function addNewEtherWallet(string calldata clientId)
        external
        onlyOwner
        returns (bool)
    {
        createWallet(clientId);
        return true;
    }

    function createWallet(string memory clientId) internal {
        EtherWallet etherWallet = new EtherWallet(owner, address(this), admin);
        etherContractWallets[clientId].push(address(etherWallet));
        contractWalletOwners[address(etherWallet)] = clientId;
        emit WalletCreationEvent(address(etherWallet), address(this), clientId);
    }

    function sweepEthers(address walletContractAddress)
        external
        onlyOwner
        returns (bool)
    {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        uint256 etherBalance = wallet.etherBalanceOf();
        require(etherBalance != 0, "EtherWallet: ether balance cannot be zero");
        (uint256 amount, address destinationAddress) = wallet.sendEthers(
            etherBalance,
            owner
        );
        emit EtherSweepEvent(
            amount,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function sendEthers(
        uint256 amountToSend,
        address payable receiverAddress,
        address walletContractAddress
    ) external onlyOwner returns (bool) {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        (uint256 amount, address destinationAddress) = wallet.sendEthers(
            amountToSend,
            receiverAddress
        );
        emit EtherSweepEvent(
            amount,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function sweepTokens(address walletContractAddress, address tokenAddress)
        external
        onlyOwner
        returns (bool)
    {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );

        IEtherWallet wallet = IEtherWallet(walletContractAddress);

        uint256 tokenBalance = wallet.tokenBalanceOf(tokenAddress);

        require(tokenBalance != 0, "EtherWallet: ether balance cannot be zero");

        (
            uint256 amount,
            address _tokenAddress,
            address destinationAddress
        ) = wallet.sendTokens(tokenBalance, owner, tokenAddress);
        emit TokenSweepEvent(
            amount,
            _tokenAddress,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function sweepBadTokens(address walletContractAddress, address tokenAddress)
        external
        onlyOwner
        returns (bool)
    {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );

        IEtherWallet wallet = IEtherWallet(walletContractAddress);

        uint256 tokenBalance = wallet.tokenBalanceOf(tokenAddress);

        require(tokenBalance != 0, "EtherWallet: ether balance cannot be zero");

        (
            uint256 amount,
            address _tokenAddress,
            address destinationAddress
        ) = wallet.sendBadTokens(tokenBalance, owner, tokenAddress);
        emit TokenSweepEvent(
            amount,
            _tokenAddress,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function sendTokens(
        uint256 amountToSend,
        address payable receiverAddress,
        address walletContractAddress,
        address tokenAddress
    ) external onlyOwner returns (bool) {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );

        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        (
            uint256 amount,
            address _tokenAddress,
            address destinationAddress
        ) = wallet.sendTokens(amountToSend, receiverAddress, tokenAddress);
        emit TokenSweepEvent(
            amount,
            _tokenAddress,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function sendBadTokens(
        uint256 amountToSend,
        address payable receiverAddress,
        address walletContractAddress,
        address tokenAddress
    ) external onlyOwner returns (bool) {
        string memory clientId = contractWalletOwners[walletContractAddress];
        require(
            keccak256(bytes(clientId)) != keccak256(bytes("")),
            "MerchantWallet: Contract is not a switch wallet ether wallet contract "
        );

        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        (
            uint256 amount,
            address _tokenAddress,
            address destinationAddress
        ) = wallet.sendBadTokens(amountToSend, receiverAddress, tokenAddress);
        emit TokenSweepEvent(
            amount,
            _tokenAddress,
            destinationAddress,
            address(this),
            walletContractAddress,
            clientId
        );
    }

    function getClients() public view returns (string[] memory) {
        return clients;
    }

    function getClientEtherWalletAddress(
        string calldata clientId,
        uint256 index
    ) external view returns (address) {
        require(
            etherContractWallets[clientId].length > 0,
            "MerchantWallet: Ether wallet does not exist"
        );
        require(
            etherContractWallets[clientId].length > index,
            "MerchantWallet: User does not have this many wallets"
        );
        address walletContractAddress;


            address[] memory walletContractAddresses
         = etherContractWallets[clientId];
        for (uint256 i = 0; i < walletContractAddresses.length; ++i) {
            if (i == index) walletContractAddress = walletContractAddresses[i];
        }

        require(
            walletContractAddress != address(0),
            "MerchantWallet: COuld not find wallet at this index"
        );
        return walletContractAddress;
    }

    function getClientWalletCount(string calldata clientId)
        external
        view
        returns (uint256 count)
    {

            address[] memory walletContractAddresses
         = etherContractWallets[clientId];
        return walletContractAddresses.length;
    }
}
