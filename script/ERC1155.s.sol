// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC1155} from "../src/ERC1155.sol";

contract ERC1155Script is Script {
    ERC1155 public erc1155;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        erc1155 = new ERC1155();

        vm.stopBroadcast();
    }
}
