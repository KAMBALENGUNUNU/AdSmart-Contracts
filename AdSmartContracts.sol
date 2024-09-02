// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdSmartContracts {
    struct Campaign {
        address advertiser;
        uint256 budget;
        uint256 costPerClick;
        uint256 costPerImpression;
        uint256 totalClicks;
        uint256 totalImpressions;
        uint256 startTime;
        uint256 endTime;
        bool active;
    }
    struct Publisher {
        address payable wallet;
        uint256 earnings;
    }

    mapping(uint256 => Campaign) public campaigns;
    mapping(address => Publisher) public publishers;
    uint256 public campaignCount;
     event CampaignCreated(uint256 campaignId, address advertiser, uint256 budget, uint256 startTime, uint256 endTime);
    event AdClicked(uint256 campaignId, address publisher, uint256 clicks);
    event AdImpression(uint256 campaignId, address publisher, uint256 impressions);
    event PaymentMade(uint256 campaignId, address publisher, uint256 amount);
     modifier onlyAdvertiser(uint256 campaignId) {
        require(campaigns[campaignId].advertiser == msg.sender, "Not the advertiser");
        _;
    }