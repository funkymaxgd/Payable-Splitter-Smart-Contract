// SPDX-License-Identifier: GPL-3.0

// This contract should
// ** store a list of addresses
// ** evenly divide the receipt of ETHER to all wallet addresses on the list
// note: this contract is controlled by an owner, who may or may not be receiving ETH


pragma solidity >=0.8.2 <0.9.0;

contract PaySplitter {
    
    // list of addresses and owner
    address private owner;
    
    struct WalletList{
        string name;
        address wallet;
    }

    WalletList[] public walletPayees;

    mapping(string => address) public walletToName;

    // set contract administrator
    function createOwner() public returns (address) {
        owner = msg.sender;

        return (owner);
    }

    // adding a person to the list of addresses
    function addWalletToList(string memory _name, address _wallet) public {
        require(msg.sender == owner, "Caller is not owner");
        walletPayees.push(WalletList(_name, _wallet)); // add to payees list struct object
        walletToName[_name] = _wallet; // add to mapping

        // don't let wallet be added twice ****************************** must fix
    }

    //
    // Remove wallet function?
    //

    function viewWallets() public view returns (address[] memory){
        require(msg.sender == owner, "Caller is not owner");
        address[] memory addressList = new address[](walletPayees.length);
        for (uint i=0; i < walletPayees.length; i++) {
            addressList[i] = walletPayees[i].wallet;
        }
        return (addressList);
    }

    // payable function which splits it between the people

    function receivePay() public payable {

    }

}
