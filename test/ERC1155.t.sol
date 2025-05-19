// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC1155} from "../src/ERC1155.sol";

contract ERC1155Test is Test {
    ERC1155 public erc1155;

    function setUp() public {
        erc1155 = new ERC1155();
        //counter.setNumber(0);
    }
    
/*
    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }*/
}
