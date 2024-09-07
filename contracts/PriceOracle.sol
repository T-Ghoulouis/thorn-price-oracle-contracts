// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./Admin.sol";

contract PriceOracle is Admin {
    uint256 public numTokens;
    mapping(uint256 => address) private numTotokens;
    mapping(address => uint256) private tokenToNum;

    mapping(address => bool) private enabledTokens;
    mapping(address => uint256) private priceUSD;

    function init(address _admin) public {
        _setAdmin(_admin);
    }

    function getPrice(address token) public view returns (uint256) {
        require(enabledTokens[token], "Not support token");
        return priceUSD[token];
    }

    function setPrice(
        address[] calldata tokens,
        uint256[] calldata prices
    ) public onlyAdmin {
        require(tokens.length == prices.length, "Invalid input");
        for (uint256 i = 0; i < tokens.length; i++) {
            priceUSD[tokens[i]] = prices[i];
        }
    }

    function enableToken(address token) public onlyAdmin {
        enabledTokens[token] = true;
    }

    function disableToken(address token) public onlyAdmin {
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
