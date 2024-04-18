// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Recommendation} from "../src/Recommendation.sol";

contract DeployRecommendation is Script {
    function setUp() public {}

    function run() external returns (Recommendation) {
        vm.startBroadcast();
        Recommendation recommendation = new Recommendation();
        vm.stopBroadcast();
        return recommendation;
    }
}
