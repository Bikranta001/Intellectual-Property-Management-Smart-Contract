// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IPManagement {

    struct IntellectualProperty {
        string title;
        string description;
        address owner;
        uint256 timestamp;
        bool isLicensed;
    }

    struct License {
        address licensee;
        uint256 licenseFee;
        uint256 royaltyPercentage;
        bool isActive;
    }

    mapping(bytes32 => IntellectualProperty) public ipRegistry;
    mapping(bytes32 => License) public licenseRegistry;

    event IPRegistered(bytes32 indexed ipHash, address indexed owner, string title, string description, uint256 timestamp);
    event IPVerified(bytes32 indexed ipHash, address indexed owner);
    event LicenseIssued(bytes32 indexed ipHash, address indexed licensee, uint256 licenseFee, uint256 royaltyPercentage, bool isActive);
    event RoyaltyPaid(bytes32 indexed ipHash, address indexed owner, uint256 amount);

    modifier onlyOwner(bytes32 _ipHash) {
        require(ipRegistry[_ipHash].owner == msg.sender, "Only the owner can perform this action");
        _;
    }

    function registerIP(string memory _title, string memory _description) public {
        bytes32 ipHash = keccak256(abi.encodePacked(_title, _description, msg.sender, block.timestamp));
        require(ipRegistry[ipHash].owner == address(0), "IP already registered");

        ipRegistry[ipHash] = IntellectualProperty({
            title: _title,
            description: _description,
            owner: msg.sender,
            timestamp: block.timestamp,
            isLicensed: false
        });

        emit IPRegistered(ipHash, msg.sender, _title, _description, block.timestamp);
    }

    function verifyIP(bytes32 _ipHash) public view returns (address owner, string memory title, string memory description, uint256 timestamp) {
        IntellectualProperty memory ip = ipRegistry[_ipHash];
        require(ip.owner != address(0), "IP not found");

        return (ip.owner, ip.title, ip.description, ip.timestamp);
    }

    function issueLicense(bytes32 _ipHash, address _licensee, uint256 _licenseFee, uint256 _royaltyPercentage) public onlyOwner(_ipHash) {
        require(!ipRegistry[_ipHash].isLicensed, "IP is already licensed");
        require(_royaltyPercentage <= 100, "Royalty percentage must be less than or equal to 100");

        licenseRegistry[_ipHash] = License({
            licensee: _licensee,
            licenseFee: _licenseFee,
            royaltyPercentage: _royaltyPercentage,
            isActive: true
        });

        ipRegistry[_ipHash].isLicensed = true;
        emit LicenseIssued(_ipHash, _licensee, _licenseFee, _royaltyPercentage, true);
    }

    function payRoyalty(bytes32 _ipHash) public payable {
        License memory license = licenseRegistry[_ipHash];
        require(license.isActive, "License is not active");
        require(msg.value > 0, "Royalty amount must be greater than zero");

        uint256 royaltyAmount = (msg.value * license.royaltyPercentage) / 100;
        payable(ipRegistry[_ipHash].owner).transfer(royaltyAmount);

        emit RoyaltyPaid(_ipHash, ipRegistry[_ipHash].owner, royaltyAmount);
    }
      // Fallback function to handle direct transfers or unknown function calls
    fallback() external payable {
        // Optionally log an event or just accept the Ether
    }

    // Receive function to handle direct Ether transfers without data
    receive() external payable {
        // Optionally log an event or just accept the Ether
    }
}
