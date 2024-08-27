# IPManagement Smart Contract

## Overview

The `IPManagement` smart contract is designed to manage the registration, verification, and licensing of intellectual properties (IP). It allows creators to register their IPs on the blockchain, issue licenses, and manage royalty payments in a secure and transparent manner.

## Features

- **IP Registration:** Creators can register their intellectual property on the blockchain.
- **IP Verification:** Anyone can verify the ownership and details of the registered IP.
- **License Issuance:** IP owners can issue licenses for their IPs and set royalty percentages.
- **Royalty Payments:** Licensees can pay royalties to IP owners directly through the contract.

## Contract Details

### Structs

- **IntellectualProperty:** Stores details about the IP, including the title, description, owner, registration timestamp, and license status.
- **License:** Stores license information, including the licensee, license fee, royalty percentage, and active status.

### Mappings

- **ipRegistry:** Maps a unique IP hash to its corresponding `IntellectualProperty` struct.
- **licenseRegistry:** Maps a unique IP hash to its corresponding `License` struct.

### Events

- `IPRegistered(bytes32 indexed ipHash, address indexed owner, string title, string description, uint256 timestamp)`: Emitted when an IP is registered.
- `IPVerified(bytes32 indexed ipHash, address indexed owner)`: Emitted when an IP is verified.
- `LicenseIssued(bytes32 indexed ipHash, address indexed licensee, uint256 licenseFee, uint256 royaltyPercentage, bool isActive)`: Emitted when a license is issued.
- `RoyaltyPaid(bytes32 indexed ipHash, address indexed owner, uint256 amount)`: Emitted when a royalty payment is made.

### Modifiers

- `onlyOwner(bytes32 _ipHash)`: Ensures that only the owner of the IP can perform certain actions.

### Functions

- `registerIP(string memory _title, string memory _description)`: Registers a new IP. Generates a unique IP hash based on the title, description, sender's address, and timestamp.
- `verifyIP(bytes32 _ipHash)`: Verifies the details of a registered IP.
- `issueLicense(bytes32 _ipHash, address _licensee, uint256 _licenseFee, uint256 _royaltyPercentage)`: Issues a license for the IP, setting the license fee and royalty percentage.
- `payRoyalty(bytes32 _ipHash)`: Allows a licensee to pay royalties to the IP owner.

### Fallback and Receive Functions

- `fallback() external payable`: Handles any direct Ether transfers or unknown function calls.
- `receive() external payable`: Handles direct Ether transfers without data.

## Deployment

To deploy the `IPManagement` contract, use a Solidity-compatible development environment like Remix, Truffle, or Hardhat. Make sure to have an Ethereum wallet with sufficient funds for deployment.

## Usage

1. **Register an IP:**

   Call the `registerIP` function with the title and description of the IP. This will generate a unique hash for the IP and store it on the blockchain.

2. **Verify an IP:**

   Use the `verifyIP` function with the IP hash to retrieve the details of the registered IP, including the owner, title, description, and timestamp.

3. **Issue a License:**

   The IP owner can call the `issueLicense` function with the IP hash, licensee address
