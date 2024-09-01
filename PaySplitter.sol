// SPDX-License-Identifier: GPL-3.0

// This contract should
// store a list of addresses
// evenly divide the receipt of ETHER to all wallet addresses on the list
// this contract is controlled by an owner, who may or may not be receiving ETH


pragma solidity >=0.8.2 <0.9.0;

contract PaySplitter {
    
    // list of addresses and owner
    address private owner;
    
    struct WalletList{
        string name;
        address wallet;
    }

    function createOwner() public returns (address) {
        owner = msg.sender;

    }

    // adding a person to the list of addresses



    function addWalletToList() public {
        require(msg.sender == owner, "Caller is not owner");
    }

    // payable function which splits it between the people

    function receivePay() public payable {

    }

}
