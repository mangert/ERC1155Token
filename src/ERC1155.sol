// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC1155.sol";

contract ERC1155 is IERC1155 {

    address private immutable owner; 

    mapping (address _owner => mapping (uint256 _id => uint256)) balanceOf;
    
    constructor() {
        owner = msg.sender;
    }

    
}