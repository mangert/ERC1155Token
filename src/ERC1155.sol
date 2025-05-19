// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC1155.sol";
import "./IERC1155MetadataURI.sol";
import "./IERC1155Mintable.sol";
import "./IERC1155Receiver.sol";
import "./ERC1155Errors.sol";

contract ERC1155 is IERC1155, IERC1155MetadataURI, IERC1155Mintable {

    address private immutable owner; 

    mapping (uint256 _ids => mapping (address _owner => uint256)) private balances;
    mapping (address owner => mapping(address operator => bool)) public isApprovedForAll;

    string private _uri;    
    
    constructor() {
        owner = msg.sender;
    }

    

    function uri(uint256 _id) external view returns(string memory){
        return _uri;
    }

    //функции интерфейса IERC1155

    function balanceOf(address _owner, uint256 _id) public view returns(uint256) {
        return balances[_id][_owner];
    }
    
    function safeTransferFrom(
        address _from,
        address _to, 
        uint256 _id, 
        uint256 _value, 
        bytes calldata _data
        ) external {

            require(_from == msg.sender 
            || isApprovedForAll[_from][msg.sender]
            , ERC1155MissingApprovalForAll(msg.sender, _from));
            
            _safeTransferFrom(_from, _to, _id, _value, _data);
    }

    function safeBatchTransferFrom(
        address _from, 
        address _to, 
        uint256[] calldata _ids, 
        uint256[] calldata _values, 
        bytes calldata _data
        ) external {
            require(_from == msg.sender || isApprovedForAll[_from][msg.sender]);
            _safeBatchTransferFrom(_from, _to, _ids, _values, _data);
    }

    function balanceOfBatch(
        address[] calldata _owners, 
        uint256[] calldata _ids
        ) external view returns (uint256[] memory batchBalances){
            
            uint256 ownersLen = _owners.length;
            uint256 idsLen = _ids.length;
            require(ownersLen == idsLen, ERC1155InvalidArrayLength(idsLen, ownersLen));

            batchBalances = new uint256[](ownersLen);

            for(uint256 i = 0; i != idsLen; ++i){
                batchBalances[i] = balanceOf(_owners[i],_ids[i]);
            }
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        
        _setApprovalForAll(msg.sender, _operator, _approved);
    }

    //функции интерфейса Mintable (TODO)
    function supportsInterface(bytes4 _interfaceId) public  view  returns (bool) {return true;}

    // Creates a new token type and assings _initialSupply to minter
    function create(uint256 _initialSupply, string calldata _uri) external returns(uint256 _id) {return 0;}

    // Batch mint tokens. Assign directly to _to[].
    function mint(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external {}

    function setURI(string calldata _uri, uint256 _id) external {}
    
    //служебные функции

    function _safeTransferFrom(
        address _from,
        address _to, 
        uint256 _id, 
        uint256 _value, 
        bytes calldata _data
        ) internal {

            require(_to != address(0), ERC1155InvalidReceiver(_to));
            
            address operator = msg.sender;
            uint256 fromBalance = balanceOf(_from, _id);

            require(_value <= fromBalance, ERC1155InsufficientBalance(operator, fromBalance, _value, _id));
            
            _doSafeTransferAcceptanceCheck(_from, _to, _id, _value, _data);

            unchecked {
                balances[_id][_from] = fromBalance - _value;                
            }
            
            balances[_id][_to] += _value;
            
            emit IERC1155.TransferSingle(operator, _from, _to, _id, _value);
    }
    
    function _safeBatchTransferFrom(
        address _from,
        address _to, 
        uint256[] calldata _ids, 
        uint256[] calldata _values, 
        bytes calldata _data
        ) internal {
            
            require(_ids.length == _values.length, ERC1155InvalidArrayLength(_ids.length, _values.length));
            uint256 len = _ids.length;

            require(_to != address(0), ERC1155InvalidReceiver(_to));
            
            address operator = msg.sender;
            _doSafeBatchTransferAcceptanceCheck(_from, _to, _ids, _values, _data);  

            uint256 id;
            uint256 value;
            uint256 fromBalance;
            for(uint256 i = 0; i != len; ++i ){
                id = _ids[i];
                value = _values[i];
                fromBalance = balanceOf(_from, id);
                require(value <= fromBalance, ERC1155InsufficientBalance(operator, fromBalance, value, id));                               
                unchecked {
                balances[id][_from] = fromBalance - value;                
                }
            
                balances[id][_to] += value;
            }            
            
            emit IERC1155.TransferBatch(operator, _from, _to, _ids, _values);
    }

    function _setApprovalForAll(address _owner, address operator, bool approved) internal {

        require(_owner != operator && operator != address(0), ERC1155InvalidOperator(operator));
        isApprovedForAll[_owner][operator] = approved;
        emit IERC1155.ApprovalForAll(_owner, operator, approved);
    }

    function _doSafeTransferAcceptanceCheck(        
        address from, 
        address to, 
        uint256 id,
        uint256 value,
        bytes calldata data
    ) private {
        if(to.code.length > 0){
            try IERC1155Receiver(to).onERC1155Received(from, to, id, value, data) returns(bytes4 response) {
                if(response != IERC1155Receiver.onERC1155Received.selector){
                    revert ERC1155InvalidReceiver(to);
                }               
            } catch {
                revert ERC1155InvalidReceiver(to);
            }
        }        
    }

    function _doSafeBatchTransferAcceptanceCheck(        
        address from, 
        address to, 
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) private {
        if(to.code.length > 0){
            try IERC1155Receiver(to).onERC1155BatchReceived(from, to, ids, values, data) returns(bytes4 response) {
                if(response != IERC1155Receiver.onERC1155BatchReceived.selector){
                    revert ERC1155InvalidReceiver(to);
                }               
            } catch {
                revert ERC1155InvalidReceiver(to);
            }
        }        
    }    
}    