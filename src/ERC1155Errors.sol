// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;


error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

/*Indicates an error related to the current balance of a sender. Used in transfers.

Usage guidelines:

    balance MUST be less than needed for a tokenId.*/

error ERC1155InvalidSender(address sender);
/*
Indicates a failure with the token sender. Used in transfers.

Usage guidelines:

    RECOMMENDED for disallowed transfers from the zero address.
    MUST NOT be used for approval operations.
    MUST NOT be used for balance or allowance requirements.
        Use ERC1155InsufficientBalance or ERC1155MissingApprovalForAll instead.
*/
error ERC1155InvalidReceiver(address receiver);
/*
Indicates a failure with the token receiver. Used in transfers.

Usage guidelines:

    RECOMMENDED for disallowed transfers to the zero address.
    RECOMMENDED for disallowed transfers to non-ERC1155TokenReceiver contracts or those that reject a transfer. (eg. returning an invalid response in onERC1155Received).
    MUST NOT be used for approval operations.
*/
error ERC1155MissingApprovalForAll(address operator, address owner);
/*
Indicates a failure with the operator’s approval in a transfer. Used in transfers.

Usage guidelines:

    isApprovedForAll(owner, operator) MUST be false for the tokenId’s owner and operator.
*/
error ERC1155InvalidApprover(address approver);
/*
Indicates a failure with the approver of a token to be approved. Used in approvals.

Usage guidelines:

    RECOMMENDED for disallowed approvals from the zero address.
    MUST NOT be used for transfer operations.
*/
error ERC1155InvalidOperator(address operator);
/*
Indicates a failure with the operator to be approved. Used in approvals.

Usage guidelines:

    RECOMMENDED for disallowed approvals to the zero address.
    MUST be used for disallowed approvals to the owner itself.
    MUST NOT be used for transfer operations.
        Use ERC1155InsufficientApproval instead.
*/
error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
/*
Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation. Used in batch transfers.*/