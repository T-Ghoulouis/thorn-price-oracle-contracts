// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Admin {
    address public admin;
    bool public setup;

    function _setAdmin(address _admin) internal {
        require(!setup, "Already setup");
        admin = _admin;
        setup = true;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function transferAdmin(address newAdmin) public virtual onlyAdmin {
        admin = newAdmin;
    }
}
