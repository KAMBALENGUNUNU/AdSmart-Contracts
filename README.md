## Overview

**AdSmart Contracts** is a decentralized platform designed to revolutionize digital advertising by leveraging the power of blockchain technology. The platform aims to solve critical issues in the digital marketing industry, including lack of transparency, high costs due to intermediaries, delayed payments, ad fraud, and trust issues between advertisers and publishers.

This project provides a smart contract written in Solidity that enables advertisers to create ad campaigns, allows publishers to earn from clicks and impressions, and automates payments securely and transparently.
## Features

- **Campaign Creation**: Advertisers can create campaigns with a specified budget, cost per click, cost per impression, and duration.
- **Publisher Registration**: Publishers can register to participate in campaigns and earn from their contributions.
- **Ad Click and Impression Recording**: Publishers can record clicks and impressions, which are then verified and stored on the blockchain.
- **Automated Payments**: Payments to publishers are automated through smart contracts, ensuring instant and secure transactions.
- **Campaign Deactivation**: Advertisers can deactivate campaigns and withdraw unused budgets once campaigns are inactive or expired.
## Smart Contract

The smart contract is written in Solidity and is designed with security and gas optimization in mind. It features modifiers to ensure only authorized users can perform certain actions and employs efficient storage operations to minimize gas costs.
### Contract Structure

- **Campaign**: A struct that holds information about each campaign, including advertiser, budget, cost per click, cost per impression, and other relevant data.
- **Publisher**: A struct that holds information about each publisher, including wallet address and earnings.
- **Campaign Management**: Functions to create campaigns, record clicks and impressions, and handle payments.
- **Payment Handling**: Functions to automate payments to publishers and allow advertisers to withdraw unused budgets.
### Security Considerations

- The contract includes safeguards to ensure only the campaign creator (advertiser) can modify or deactivate campaigns.
- Publishers can only withdraw earnings that they have legitimately earned through clicks and impressions.
- The contract's logic ensures that campaigns cannot overspend their budgets.

## Installation

To use or test this smart contract, you can follow these steps:
1. **Clone the repository**:
    ```bash
    git clone https://github.com/KAMBALENGUNUNU/adsmart-contracts.git
    cd adsmart-contracts
    ```
2. **Deploy the contract** using Remix IDE or a local Ethereum development environment such as Hardhat or Truffle.
    - Open the `AdSmartContracts.sol` file in Remix.
    - Compile the contract.
    - Deploy the contract to your preferred Ethereum network (e.g., Rinkeby, Mainnet).

