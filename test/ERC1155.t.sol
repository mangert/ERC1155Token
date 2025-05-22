// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC1155} from "../src/ERC1155.sol";
import "../src/ERC1155Errors.sol";

contract ERC1155Test is Test {
    
    ERC1155 public erc1155;
    address user1 = address(0);
    
    string exampleUri = "https://example.com/metadata1";
    uint256 initialBalance = 100;

    event URI(string _value, uint256 indexed _id);

    function setUp() public {
        erc1155 = new ERC1155();                        
    }

    function test_create() public {
        
        erc1155.create(initialBalance, exampleUri);
        uint256 balance = erc1155.balanceOf(address(this), 1);
        assertEq(balance, initialBalance);               
    }    

    function test_create_RevertWhen_CallerIsNotOwner() public {
        
        vm.expectRevert(abi.encodeWithSelector(ERC1155NotAnOwner.selector, address(0)));
        
        vm.prank(user1);
        erc1155.create(initialBalance, exampleUri);        
    }

    function test_create_ExpectEmit() public {
        
        vm.expectEmit(true, false, false, true);
        
        emit URI(exampleUri, 1);        
        erc1155.create(initialBalance, exampleUri);
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
