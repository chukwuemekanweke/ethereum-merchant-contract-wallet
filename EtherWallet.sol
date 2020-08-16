pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./IERC20.sol";
import "./IBadERC20.sol";

contract EtherWallet is Ownable {


    constructor (address payable _owner,address _agent, address _switchWalletAdmin) public {
        owner = _owner;
        contractAgent = _agent;
        switchWalletAdmin = _switchWalletAdmin;

    }
    
    receive() external payable { 
        
      
        
     }
    
    
    function sendEthers(uint amount, address payable receiver) onlyOwner public returns (uint,address){
       uint etherBalance =  address(this).balance;
       require(etherBalance != 0, "EtherWallet: ether balance cannot be zero");
       require(etherBalance>=amount,"EtherWallet: insufficient balance");
       receiver.transfer(amount);
       return (amount,receiver);
    }
    
    function etherBalanceOf() public view  returns (uint amount){
        return address(this).balance;
    }
    
     function tokenBalanceOf(address tokenAddress) public view  returns (uint amount){
         IERC20 token = IERC20(tokenAddress);

        return token.balanceOf(address(this));
    }
    
    
     function sendTokens(uint amount,address receiver,address tokenAddress)onlyOwner public returns (uint,address,address){
        IERC20 token = IERC20(tokenAddress);
        uint tokenBalance = token.balanceOf(address(this));
        require(tokenBalance != 0, "EtherWallet: token balance cannot be zero");
        require(tokenBalance>=amount,"EtherWallet: insufficient balance");
        token.transfer(receiver, amount);
       return (amount,address(this),receiver);
    }
    
     function sendBadTokens(uint amount,address payable receiver,address tokenAddress)onlyOwner public returns (uint,address,address payable){
        IBadERC20 token = IBadERC20(tokenAddress);
        uint tokenBalance = token.balanceOf(address(this));
        require(tokenBalance != 0, "EtherWallet: token balance cannot be zero");
        require(tokenBalance>=amount,"EtherWallet: insufficient balance");
        token.transfer(receiver, amount);
       return (amount,address(this),receiver);
    }
    
    
    
}