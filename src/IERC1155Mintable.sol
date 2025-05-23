// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC1155.sol";
/**
*  @dev Mintable form of ERC1155
*/
interface IERC1155Mintable is IERC1155 {    
    

    function supportsInterface(bytes4 _interfaceId) external view  returns (bool);

    /**
     * @notice Creates a new token type and assings _initialSupply to minter
     * @param _initialSupply - initial supply value
     * @param _uri - token URI    
     */
    function create(uint256 _initialSupply, string calldata _uri) external returns(uint256 _id);

    /**
     * @notice Batch mint tokens. Assign directly to _to[].
     * @param _id - token ID
     * @param _to - receiver address
     * @param _quantities - minting value
     */    
    function mint(uint256 _id, address[] calldata _to, uint256[] calldata _quantities) external;

     /**
     * @notice set URI to token
     * @param _uri - setting token URI 
     * @param _id - token ID     
     */ 
    function setURI(string calldata _uri, uint256 _id) external;
    
}
