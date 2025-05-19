// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC1155.sol";
/**
*  @dev Mintable form of ERC1155
*/
interface IERC1155Mintable is IERC1155 {    
    

    function supportsInterface(bytes4 _interfaceId) external view  returns (bool);

    // Creates a new token type and assings _initialSupply to minter
    function create(uint256 _initialSupply, string calldata _uri) external returns(uint256 _id);

    // Batch mint tokens. Assign directly to _to[].
    function mint(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;

    function setURI(string calldata _uri, uint256 _id) external;
    
}
