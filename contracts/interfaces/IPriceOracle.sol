// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

interface IPriceOracle {
    event PriceUpdated(string indexed token, uint256 price);

    function getPrice(
        string calldata token
    ) external view returns (uint256, uint256);

    function setPrice(
        string[] calldata tokens,
        uint256[] calldata prices
    ) external;
}
