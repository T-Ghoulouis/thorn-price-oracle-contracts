// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract PriceOracle is Initializable, AccessControlUpgradeable {
    uint256 public numTokens;
    mapping(uint256 => address) private numTotokens;
    mapping(address => uint256) private tokenToNum;
    mapping(address => bool) private enabledTokens;
    mapping(address => uint256) private priceUSD;

    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    event PriceUpdated(address indexed token, uint256 price);

    function initialize() external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        __AccessControl_init();
    }

    function getPrice(address token) public view returns (uint256) {
        require(enabledTokens[token], "Not support token");
        return priceUSD[token];
    }

    function setPrice(
        address[] calldata tokens,
        uint256[] calldata prices
    ) public onlyRole(ORACLE_ROLE) {
        require(tokens.length == prices.length, "Invalid input");
        for (uint256 i = 0; i < tokens.length; i++) {
            priceUSD[tokens[i]] = prices[i];
            emit PriceUpdated(tokens[i], prices[i]);
        }
    }

    function enableToken(address token) public onlyRole(ORACLE_ROLE) {
        enabledTokens[token] = true;
    }

    function disableToken(address token) public onlyRole(ORACLE_ROLE) {
        enabledTokens[token] = false;
    }

    function _addToken(address token) internal {
        if (tokenToNum[token] > 0) {
            return;
        }
        numTokens++;
        numTotokens[numTokens] = token;
        tokenToNum[token] = numTokens;
    }
}
