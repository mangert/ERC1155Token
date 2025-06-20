// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC1155} from "../src/ERC1155.sol";
import "../src/ERC1155Errors.sol";


contract ERC1155Test is Test {
    
    ERC1155 public erc1155;
    
    address user0 = address(0);
    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");
    
    string exampleUri = "https://example.com/metadata1";
    uint256 initialBalance = 100;

    event URI(string _value, uint256 indexed _id);
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function setUp() public {
        erc1155 = new ERC1155();                        
    }

    //create tests
    function test_create() public {
        
        erc1155.create(initialBalance, exampleUri);
        uint256 balance = erc1155.balanceOf(address(this), 1);
        assertEq(balance, initialBalance);               
    }    

    function test_create_RevertWhen_CallerIsNotOwner() public {
        
        vm.expectRevert(abi.encodeWithSelector(ERC1155NotAnOwner.selector, user1));
        
        vm.prank(user1);
        erc1155.create(initialBalance, exampleUri);        
    }

    function test_create_ExpectEmit_Transfer() public {
        
        vm.expectEmit(true, true, true, true);        
        
        emit TransferSingle(address(this), address (0), address(this), 1, initialBalance);        
        erc1155.create(initialBalance, exampleUri);
    }
    
    function test_create_ExpectEmit_URI() public {
        
        vm.expectEmit(true, false, false, true);
        
        emit URI(exampleUri, 1);        
        erc1155.create(initialBalance, exampleUri);
    }

    //mint tests
    function test_mint() public {
        
        erc1155.create(initialBalance, exampleUri);        
        
        address[] memory addresses = new address[](2);
        addresses[0] = user1;   
        addresses[1] = user2;   
        
        uint256[] memory quantities = new uint256[](2);
        quantities[0] = 1000;        
        quantities[1] = 2000;        
        
        vm.expectEmit(true, true, true, true);
        emit TransferSingle(address(this), address(0x0), addresses[0], 1, quantities[0]);                
        emit TransferSingle(address(this), address(0x0), addresses[1], 1, quantities[1]);                
        erc1155.mint(1, addresses, quantities);

        uint256 balance = erc1155.balanceOf(addresses[0], 1);
        assertEq(quantities[0], balance); 
    }

    function test_mint_RevertWhen_mintNonExistentToken() public {
        
        erc1155.create(initialBalance, exampleUri);        

        address[] memory addresses = new address[](2);
        addresses[0] = user1;   
        addresses[1] = address(0);   
        
        uint256[] memory quantities = new uint256[](3);
        quantities[0] = 1000;        
        quantities[1] = 2000;        
        
        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidMintArrayLength.selector, quantities.length,addresses.length));        
        erc1155.mint(1, addresses, quantities);
    }

    //transfer tests
    function test_safeTransferFrom() public {

        erc1155.create(initialBalance, exampleUri); 
        
        uint256 balanceBefore = erc1155.balanceOf(user1, 1);

        uint256 amount = 50;
        erc1155.safeTransferFrom(address(this), user1, 1, amount, "");
        
        uint256 balanceAfter = erc1155.balanceOf(user1, 1);
        
        assertEq(balanceAfter, balanceBefore + amount); 
    }

    function test_safeTransferFromRevertWhen_MissingApprovas() public{
        
        erc1155.create(initialBalance, exampleUri); 
        
        uint256 amount = 50;
        address owner = address(this);

        vm.expectRevert(abi.encodeWithSelector(ERC1155MissingApprovalForAll.selector, user1, owner));        
        vm.prank(user1);
        erc1155.safeTransferFrom(owner, user2, 1, amount, "");
        
    }   
    
    function test_safeTransferFromRevertWhen_InsufficientBalance() public{
        
        erc1155.create(initialBalance, exampleUri);             
        uint256 amount = 500;    
        uint256 balanceFrom = erc1155.balanceOf(address(this), 1);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InsufficientBalance.selector, address(this), balanceFrom, amount, 1));        
        erc1155.safeTransferFrom(address(this), user1, 1, amount, "");
    }
    
    function test_safeTransferFromRevertWhen_InvalidReceiver() public{        
    
        erc1155.create(initialBalance, exampleUri);             
        uint256 amount = 50;    
        
        address to = address(0);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidReceiver.selector, to));        
        erc1155.safeTransferFrom(address(this), to, 1, amount, "");
    }    
    
    function test_safeTransferFromRevertWhen_NonERC155Receiver() public{
        
        erc1155.create(initialBalance, exampleUri);             
        uint256 amount = 50;    
        
        address to = address(erc1155);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidReceiver.selector, to));        
        erc1155.safeTransferFrom(address(this), to, 1, amount, "");
    }

    //batch transfer tests
    function test_safeBatchTransferFrom() public {

        erc1155.create(initialBalance, exampleUri); //1
        erc1155.create(initialBalance, exampleUri); //2
        erc1155.create(initialBalance, exampleUri); //3        
        
        uint256[] memory ids = new uint256[](2);
        ids[0] = 2;   
        ids[1] = 3;   
        
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 20;        
        amounts[1] = 10;        
        
        uint256 balance2Before = erc1155.balanceOf(user1, 2);
        uint256 balance3Before = erc1155.balanceOf(user1, 3);
        
        erc1155.safeBatchTransferFrom(address(this), user1, ids, amounts, "");
        
        uint256 balance2After = erc1155.balanceOf(user1, 2);
        uint256 balance3After = erc1155.balanceOf(user1, 3);
        
        assertEq(balance2After, balance2Before + amounts[0]); 
        assertEq(balance3After, balance3Before + amounts[1]); 
    }

    function test_safeBatchTransferFromRevertWhen_MissingApprovas() public{
        
        erc1155.create(initialBalance, exampleUri); 
        
        uint256[] memory ids = new uint256[](2);
        ids[0] = 2;   
        ids[1] = 3;   
        
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 20;        
        amounts[1] = 10;        

        address owner = address(this);

        vm.expectRevert(abi.encodeWithSelector(ERC1155MissingApprovalForAll.selector, user1, owner));        
        vm.prank(user1);
        erc1155.safeBatchTransferFrom(owner, user2, ids, amounts, "");
        
    }   

    function test_safeBatchTransferFromRevertWhen_InvalidReceiverZero() public{
        
        erc1155.create(initialBalance, exampleUri); 
        
        uint256[] memory ids = new uint256[](2);
        ids[0] = 2;   
        ids[1] = 3;   
        
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 20;        
        amounts[1] = 10;        

        address to = address(0);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidReceiver.selector, to));        
        
        erc1155.safeBatchTransferFrom(address(this), to, ids, amounts, "");        
    }

    function test_safeBatchTransferFromRevertWhen_InvalidArraysLength() public{
        
        erc1155.create(initialBalance, exampleUri); 
        
        uint256[] memory ids = new uint256[](3);
        ids[0] = 2;   
        ids[1] = 3;   
        
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 20;        
        amounts[1] = 10;        

        address owner = address(this);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidArrayLength.selector, ids.length, amounts.length));                
        erc1155.safeBatchTransferFrom(owner, user2, ids, amounts, "");        
    }

    function test_safeBatchTransferFromRevertWhen_NonERC155Receiver() public{
        
        erc1155.create(initialBalance, exampleUri);             
        erc1155.create(initialBalance, exampleUri);            
        
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;   
        ids[1] = 2;   
        
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 20;        
        amounts[1] = 10;        
        
        address to = address(erc1155);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidReceiver.selector, to));        
        erc1155.safeBatchTransferFrom(address(this), to, ids, amounts, "");
    }

    //set approvals tests
    function test_setApprovalForAll() public{
        
        address owner = msg.sender;        
        
        vm.expectEmit(true, true, false, true);
        emit ApprovalForAll(owner, user1, true);
        vm.prank(owner);
        erc1155.setApprovalForAll(user1, true);        
    }

    function test_setApprovalForAllRevertedWhen_InvalidOperatorZero() public {        

        erc1155.create(initialBalance, exampleUri);                       
        
        address operator = address(0);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidOperator.selector, operator));        
        erc1155.setApprovalForAll(operator, true);        
    }

    function test_setApprovalForAllRevertedWhen_InvalidOperatorSelf() public {        

        erc1155.create(initialBalance, exampleUri);                       
        
        address operator = address(this);

        vm.expectRevert(abi.encodeWithSelector(ERC1155InvalidOperator.selector, operator));        
        erc1155.setApprovalForAll(operator, true);        
    } 

    //other functions
    function test_setUri() public {
        
        erc1155.create(initialBalance, exampleUri); 
        erc1155.setURI(exampleUri, 1);
        string memory ex_uri = erc1155.uri(1);

        assertEq(ex_uri, exampleUri);
    }

    function test_setUriRevertedWhen_NonExistentToken() public {
        
        erc1155.create(initialBalance, exampleUri); 

        vm.expectRevert(abi.encodeWithSelector(ERC1155NonExistentToken.selector, 2));        
        erc1155.setURI(exampleUri, 2);

    }

    function test_setUriRevertedWhen_NotAnOwner() public {
        
        erc1155.create(initialBalance, exampleUri); 

        vm.expectRevert(abi.encodeWithSelector(ERC1155NotAnOwner.selector, user1));        
        vm.prank(user1);
        erc1155.setURI(exampleUri, 1);

    }


    function test_supportsInterface() public {        
        
        bytes4 interfaceERC165 = 0x01ffc9a7;
        bool isERC165 = erc1155.supportsInterface(interfaceERC165);
        assertEq(isERC165, true); 

        bytes4 interfaceERC1155 = 0xd9b67a26;
        bool isERC1155 = erc1155.supportsInterface(interfaceERC1155);
        assertEq(isERC1155, true); 

        bytes4 interfaceERC1155MetadataURI = 0x0e89341c;
        bool isERC1155MetadataURI = erc1155.supportsInterface(interfaceERC1155MetadataURI);
        assertEq(isERC1155MetadataURI, true); 

        bytes4 interfaceOther = 0x0e89310c; //левое число
        bool isInterfaceOther = erc1155.supportsInterface(interfaceOther);
        assertEq(isInterfaceOther, false);         
    }

}
