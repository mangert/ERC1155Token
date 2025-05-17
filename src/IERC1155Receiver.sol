// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IERC1155Receiver {

    function onERC1155Received(
        address _from,
        address _to, 
        uint256 _id, 
        uint256 _value, 
        bytes calldata _data
    ) external returns(bytes4);

    function onERC1155BatchReceived(
        address _from,
        address _to, 
        uint256[] calldata _ids, 
        uint256[] calldata _values, 
        bytes calldata _data
    )
}