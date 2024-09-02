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

      modifier campaignActive(uint256 campaignId) {
        require(campaigns[campaignId].active, "Campaign not active");
        require(block.timestamp >= campaigns[campaignId].startTime && block.timestamp <= campaigns[campaignId].endTime, "Campaign is outside active period");
        _;
    }

     // Create a new advertising campaign
    function createCampaign(uint256 budget, uint256 costPerClick, uint256 costPerImpression, uint256 duration) external {
        require(budget > 0, "Budget must be greater than 0");
        require(costPerClick > 0 || costPerImpression > 0, "At least one cost metric must be greater than 0");
        require(duration > 0, "Duration must be greater than 0");
      campaignCount++;
        campaigns[campaignCount] = Campaign({
            advertiser: msg.sender,
            budget: budget,
            costPerClick: costPerClick,
            costPerImpression: costPerImpression,
            totalClicks: 0,
            totalImpressions: 0,
            startTime: block.timestamp,
            endTime: block.timestamp + duration,
            active: true
        });
          emit CampaignCreated(campaignCount, msg.sender, budget, block.timestamp, block.timestamp + duration);
    }

       // Register as a publisher
    function registerPublisher() external {
        require(publishers[msg.sender].wallet == address(0), "Publisher already registered");

        publishers[msg.sender] = Publisher({
            wallet: payable(msg.sender),
            earnings: 0
        });
    }


    // Record an ad click by a publisher
    function recordClick(uint256 campaignId) external campaignActive(campaignId) {
        require(publishers[msg.sender].wallet != address(0), "Publisher not registered");

        Campaign storage campaign = campaigns[campaignId];
        require(campaign.budget >= campaign.costPerClick, "Insufficient campaign budget");
