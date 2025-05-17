// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./ERC1155.sol";

interface IERC1155MetadataURI is IERC1155{

    function uri(uint265 id) external view returns(string memory);

}