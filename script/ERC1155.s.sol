// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC1155} from "../src/ERC1155.sol";

contract ERC1155Script is Script {    
   

    function setUp() public {}

    function run() public {
        
        console.log("PRIVATE_KEY:", vm.envUint("PRIVATE_KEY"));
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ERC1155 erc1155 = new ERC1155();

        vm.stopBroadcast();
        console.log("Contract deployed to:", address(erc1155));

        // Сохраняем в файл        
        //string memory path = "./broadcast/ERC1155.address";
        //vm.writeFile(path, vm.toString(address(erc1155)));
    }
}

