// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract PriceOracle is Initializable, AccessControlUpgradeable {
    mapping(address => uint256) private priceUSD;
    mapping(address => uint256) private lastUpdate;

    bytes32 public constant ORACLE_ROLE = keccak256("ORACLE_ROLE");

    event PriceUpdated(address indexed token, uint256 price);

    function initialize() external initializer {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        __AccessControl_init();
    }

    function getPrice(address token) public view returns (uint256, uint256) {
        return (priceUSD[token], lastUpdate[token]);
    }

    function setPrice(
        address[] calldata tokens,
        uint256[] calldata prices
    ) public {
        require(hasRole(ORACLE_ROLE, msg.sender), "Caller is not an oracle");
        require(tokens.length == prices.length, "Invalid input");
        for (uint256 i = 0; i < tokens.length; i++) {
            priceUSD[tokens[i]] = prices[i];
            lastUpdate[tokens[i]] = block.timestamp;
            emit PriceUpdated(tokens[i], prices[i]);
        }
    }
}
