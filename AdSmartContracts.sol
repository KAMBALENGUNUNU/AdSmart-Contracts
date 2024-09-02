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
          campaign.totalClicks++;
        campaign.budget -= campaign.costPerClick;

        publishers[msg.sender].earnings += campaign.costPerClick;

        emit AdClicked(campaignId, msg.sender, campaign.totalClicks);
    }


    // Record an ad impression by a publisher
    function recordImpression(uint256 campaignId) external campaignActive(campaignId) {
        require(publishers[msg.sender].wallet != address(0), "Publisher not registered");

        Campaign storage campaign = campaigns[campaignId];
        require(campaign.budget >= campaign.costPerImpression, "Insufficient campaign budget");
          campaign.totalImpressions++;
        campaign.budget -= campaign.costPerImpression;

        publishers[msg.sender].earnings += campaign.costPerImpression;

        emit AdImpression(campaignId, msg.sender, campaign.totalImpressions);
    }

     // Withdraw earnings as a publisher
    function withdrawEarnings() external {
        require(publishers[msg.sender].earnings > 0, "No earnings to withdraw");

        uint256 earnings = publishers[msg.sender].earnings;
        publishers[msg.sender].earnings = 0;

        publishers[msg.sender].wallet.transfer(earnings);

        emit PaymentMade(0, msg.sender, earnings);
    }


    // Deactivate a campaign (can only be done by the advertiser)
    function deactivateCampaign(uint256 campaignId) external onlyAdvertiser(campaignId) {
        campaigns[campaignId].active = false;
    }

      // Fallback function to receive ETH
    receive() external payable {}

    // Withdraw unused budget as an advertiser
    function withdrawUnusedBudget(uint256 campaignId) external onlyAdvertiser(campaignId) {
        require(campaigns[campaignId].active == false || block.timestamp > campaigns[campaignId].endTime, "Campaign must be inactive or expired");
