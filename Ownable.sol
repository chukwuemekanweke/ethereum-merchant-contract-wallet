pragma solidity ^0.6.4;

/*
 * Ownable
 *
 * Base contract with an owner.
 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
 */
contract Ownable {
    address payable public owner;
    address public contractAgent;
    address public admin;

    modifier onlyOwner() {
        require(
            msg.sender == owner || msg.sender == contractAgent,
            "Unauthorized access to contract"
        );

        _;
    }

    modifier onlyAdminOrOwner() {
        require(
            msg.sender == owner ||
                msg.sender == contractAgent ||
                msg.sender == admin,
            "Unauthorized access to contract"
        );
        _;
    }

    function transferOwnership(address payable newOwner)
        public
        onlyAdminOrOwner
    {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

    function transferAgent(address payable newAgent) public onlyAdminOrOwner {
        if (newAgent != address(0)) {
            contractAgent = newAgent;
        }
    }
}
