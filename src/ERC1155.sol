// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC1155.sol";
import "./IERC1155MetadataURI.sol";
import "./IERC1155Receiver.sol";
import "./ERC1155Errors.sol";


contract ERC1155 is IERC1155, IERC1155MetadataURI {

    address private immutable owner; 

    mapping private (uint256 _ids => mapping (address _owner => uint256)) public balanceOf;
    mapping (address owner => mapping(address operator => bool)) public isApprovedForAll;

    string private _uri;    
    
    constructor() {
        owner = msg.sender;
    }

    function uri(uint256 _id) external view returns(string memory){
        return _uri;
    }

    function safeTransferFrom(
        address _from,
        address _to, 
        uint256 _id, 
        uint256 _value, 
        bytes calldata _data
        ) external {

    }

    function safeBatchTransferFrom(
        address _from, 
        address _to, 
        uint256[] calldata _ids, 
        uint256[] calldata _values, 
        bytes calldata _data
        ) external {

    }

    function balanceOfBatch(
        address[] calldata _owners, 
        uint256[] calldata _ids
        ) external view returns (uint256[] memory batchBalances){
            
            uint256 ownersLen = _owners.length;
            uint256 idsLen = _ids.length;
            require(ownersLen == idsLen, ERC1155Errors.ERC1155InvalidArrayLength(idsLen, ownersLen));

            batchBalances = new uint256[](ownersLen);

            for(uint256 i = 0; i != idsLen; ++i){
                batchBalances[i] = balanceOf[_owners[i]][_ids[i]];
            }


    }

    function setApprovalForAll(address _operator, bool _approved) external {

    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {

    }



    

    








    




 
    




























    

    
}