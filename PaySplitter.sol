// SPDX-License-Identifier: GPL-3.0

// This contract should
// ** store a list of addresses
// ** evenly divide the receipt of ETHER to all wallet addresses on the list
// note: this contract is controlled by an owner, who may or may not be receiving ETH


pragma solidity >=0.8.2 <0.9.0;

contract PaySplitter {
    
    // list of addresses and owner
    address private owner;
    uint256 amount;
    
    struct WalletList{
        string name;
        address wallet;
    }

    WalletList[] public walletPayees;

    // use mapping to ease index-based deletion?
    mapping(address => uint) public walletToIndex;

    // set contract administrator
    constructor()  {
        owner = msg.sender;
    }

    // adding a person to the list of addresses
    function addWalletToList(string memory _name, address _wallet) public {
        require(msg.sender == owner && walletToIndex[_wallet] == 0, "Caller is not owner or wallet exists");
        walletPayees.push(WalletList(_name, _wallet)); // add to payees list struct object
        walletToIndex[_wallet] = walletPayees.length; // add to mapping
    }

    // Remove wallet from list of addresses and wallet index mapping
    function removeWalletFromList(address _wallet) public {
        require(msg.sender == owner, "Caller is not owner or wallet exists");
        // move last array item to place of index to delete from 'walletPayees'
        uint newIndex = walletToIndex[_wallet];
        walletPayees[walletToIndex[_wallet]-1] = walletPayees[walletPayees.length - 1];
        // modify index in mapping 'walletToIndex' of item that was shifted
        walletToIndex[walletPayees[walletToIndex[_wallet]-1].wallet] = newIndex;
        // remove from mapping
        delete walletToIndex[_wallet];
        // pop array
        walletPayees.pop();
        
    }

    function viewWallets() public view returns (address[] memory){
        require(msg.sender == owner, "Caller is not owner");
        address[] memory addressList = new address[](walletPayees.length);
        for (uint i=0; i < walletPayees.length; i++) {
            addressList[i] = walletPayees[i].wallet;
        }
        return (addressList);
    }

    // withdraw function which splits ETH balance of contract between the walletPayees addresses
    function withdraw() public {
        // divide the amount of pay by length of the wallet array
        uint splitPay = amount / walletPayees.length;
        address payable currentWallet;
        // distribute the amount to the wallets
        for (uint i; i < walletPayees.length; i++) {
            // convert wallet to address payable
            currentWallet = payable(walletPayees[i].wallet);
            currentWallet.transfer(splitPay);
        }
    }

    receive() external payable {
        amount = msg.value;
    }

}
