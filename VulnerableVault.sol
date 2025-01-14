// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableVault {
    uint256 public totalShares; // Total shares in the vault
    uint256 public totalEther; // Total assets in the vault

    mapping(address => uint256) public balances; // User shares

    // Deposit Ether into the vault
    function deposit() external payable {
        require(msg.value > 0, "Must send ETH"); // Ensure a positive deposit
        uint256 shares = (totalShares == 0)
            ? msg.value // First depositor gets 1 share per wei
            : (msg.value * totalShares) / totalEther; // Calculate shares based on ratio
        balances[msg.sender] += shares; // Update user shares
        totalShares += shares; // Update total shares
        totalEther += msg.value; // Update total Ether
    }

    // Withdraw Ether from the vault
    function withdraw(uint256 shareAmount) external {
        require(balances[msg.sender] >= shareAmount, "Insufficient shares"); // Ensure sufficient shares
        uint256 ethToWithdraw = (shareAmount * totalEther) / totalShares; // Calculate Ether to withdraw
        balances[msg.sender] -= shareAmount; // Update user shares (CEI)
        totalShares -= shareAmount; // Update total shares
        totalEther -= ethToWithdraw; // Update total Ether
        (bool success, ) = msg.sender.call{value: ethToWithdraw}(""); // Transfer Ether
        require(success, "Transfer failed"); // Ensure transfer success
    }

    // Directly donate Ether to the vault (inflates share value)
    function donate() external payable {
        totalEther += msg.value; // Increase vault Ether without issuing shares
    }
}
