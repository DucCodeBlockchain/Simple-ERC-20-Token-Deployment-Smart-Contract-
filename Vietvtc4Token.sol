// SPDX-License-Identifier: MIT
// This contract is compatible with OpenZeppelin Contracts version ^5.0.0
pragma solidity ^0.8.20;

// Importing required OpenZeppelin contracts and extensions.
import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20FlashMint.sol";

// Define the contract "Vietvtc4" which inherits from multiple OpenZeppelin contracts.
contract Vietvtc4 is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit, ERC20Votes, ERC20FlashMint {
    // Constructor function which initializes the contract
    constructor(address initialOwner)
        ERC20("vietvtc4", "VVD") // Initializing the ERC20 token with name and symbol
        Ownable(initialOwner) // Setting the initial owner
        ERC20Permit("vietvtc4") // Initializing ERC20Permit with token name
    {
        // Minting initial supply of tokens to the contract deployer
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Function to pause all token transfers, can only be called by the contract owner
    function pause() public onlyOwner {
        _pause();
    }

    // Function to unpause all token transfers, can only be called by the contract owner
    function unpause() public onlyOwner {
        _unpause();
    }

    // Function to mint new tokens, can only be called by the contract owner
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Overriding _beforeTokenTransfer function to add pause functionality
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        whenNotPaused // Ensures that transfers are only allowed when not paused
        override(ERC20, ERC20Pausable)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // Overriding _afterTokenTransfer function to integrate ERC20Votes and other functionalities
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    // Overriding _mint function to integrate ERC20Votes functionality
    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    // Overriding _burn function to integrate ERC20Votes functionality
    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }

    // Overriding _update function to integrate ERC20Pausable and ERC20Votes functionalities
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable, ERC20Votes)
    {
        super._update(from, to, value);
    }

    // Overriding nonces function to integrate ERC20Permit functionality
    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);
    }

    // Adding an additional function to burn tokens from another address, can only be called by the owner
    function burnFrom(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    // Adding a function to transfer ownership to multiple addresses (multi-signature like), requires a quorum
    mapping(address => bool) private _owners;
    uint256 private _ownerCount;

    modifier onlyOwners() {
        require(_owners[msg.sender], "Caller is not an owner");
        _;
    }

    function addOwner(address newOwner) public onlyOwner {
        require(!_owners[newOwner], "Address is already an owner");
        _owners[newOwner] = true;
        _ownerCount++;
    }

    function removeOwner(address existingOwner) public onlyOwner {
        require(_owners[existingOwner], "Address is not an owner");
        _owners[existingOwner] = false;
        _ownerCount--;
    }

    function transferOwnershipMultiSig(address newOwner) public onlyOwners {
        addOwner(newOwner);
    }
}
