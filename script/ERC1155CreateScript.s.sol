// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/ERC1155.sol";

//может запускать только владелец контракта ERC1155
contract ERC1155CreateScript is Script {
    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(privateKey);
        
        //сюда подставляем адрес контракта
        address tokenAddress = address(0xB1C889B41AF5d809B2a93A4c788aC8c4895FFd45);
        
        ERC1155 erc1155 = ERC1155(tokenAddress);

        vm.startBroadcast(privateKey);

        // Create FUNGIBLE (например, ID = 1, количество = 100)
        erc1155.create(100, "https://raw.githubusercontent.com/mangert/TokenERC1155MData/refs/heads/main/FT_diamond.json"); 

        // Create NON-FUNGIBLE (например, ID = 2, количество = 1)
        erc1155.create(1, "https://raw.githubusercontent.com/mangert/TokenERC1155MData/refs/heads/main/NFT_dachshund.json");

        vm.stopBroadcast();
    }
}
