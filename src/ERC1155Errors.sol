// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/**
 *Indicates an error related to the current balance of a sender. Used in transfers.
 *balance MUST be less than needed for a tokenId
 */
error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

/**
 * Indicates a failure with the token sender. Used in transfers.
 * Disallowes transfers from the zero address.  
 */
error ERC1155InvalidSender(address sender);

/**
 * Indicates a failure with the function caller. Used in creates tokens. *   
 */
error ERC1155NotAnOwner(address caller);


/**
 * Indicates a failure with the token receiver in transfers.
 * Disallowes transfers to the zero address.
 * Disallowes transfers to non-ERC1155TokenReceiver contracts or those that reject a transfer. 
 * (eg. returning an invalid response in onERC1155Received).
 */
error ERC1155InvalidReceiver(address receiver);

/**
 * Indicates a failure with the operator’s approval in a transfer. Used in transfers.
 */
error ERC1155MissingApprovalForAll(address operator, address owner);

/**
 * Indicates a failure with the approver of a token to be approved in approvals.
 * Disallowes approvals from the zero address.
 */
error ERC1155InvalidApprover(address approver);

/**
 * Indicates a failure with the operator to be approved. Used in approvals.
 * Diasallowes approvals to the zero address.
 * Disallowes approvals to the owner itself.
 */
error ERC1155InvalidOperator(address operator);

/**
 * Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
 */
error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);

/**
 * Indicates an invalid token ID.
 */
error ERC1155NonExistentToken(uint256 _id);
