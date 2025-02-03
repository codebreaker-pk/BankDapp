// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    // Data structure to represent an account
    struct Account {
        uint256 balance;
        bool exists;
    }

    // Mapping of addresses to accounts
    mapping(address => Account) private accounts;

    // Event declarations
    event AccountCreated(address indexed accountHolder);
    event Deposit(address indexed accountHolder, uint256 amount);
    event Withdrawal(address indexed accountHolder, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    // Modifier to check if the account exists
    modifier onlyExistingAccount() {
        require(accounts[msg.sender].exists, "Account does not exist");
        _;
    }

    // Function to create an account
    function createAccount() public {
        require(!accounts[msg.sender].exists, "Account already exists");
        accounts[msg.sender] = Account(0, true);
        emit AccountCreated(msg.sender);
    }

    // Function to deposit funds
    function deposit() public payable onlyExistingAccount {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        accounts[msg.sender].balance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Function to withdraw funds
    function withdraw(uint256 amount) public onlyExistingAccount {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");
        accounts[msg.sender].balance -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    // Function to transfer funds to another account
    function transfer(address to, uint256 amount) public onlyExistingAccount {
        require(to != address(0), "Cannot transfer to the zero address");
        require(accounts[to].exists, "Recipient account does not exist");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(accounts[msg.sender].balance >= amount, "Insufficient balance");

        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // Function to check account balance
    function getBalance() public view onlyExistingAccount returns (uint256) {
        return accounts[msg.sender].balance;
    }
}
