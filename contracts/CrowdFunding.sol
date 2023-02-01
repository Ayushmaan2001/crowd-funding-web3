// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amtCollected;
        string img;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner,string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _img) public returns(uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns];
        //is everthing fine?
        require(campaign.deadline < block.timestamp, "Dealine should be a date in the future");
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.img = _img;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amt = msg.value;
        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amt);

        (bool sent, ) = payable(campaign.owner).call{value: amt}("");

        if(sent){
            campaign.amtCollected += amt;
        }
    }

    function getDonators(uint256 _id) view public returns(address[] memory,uint256[] memory) {
        Campaign storage campaign = campaigns[_id];
        return (campaign.donators,campaign.donations);
    }

    function getCampaigns() public view returns(Campaign[] memory){
        Campaign[] memory _campaigns = new Campaign[](numberOfCampaigns);
        for(uint256 i = 0; i < numberOfCampaigns; i++){
            Campaign storage items = campaigns[i];
            _campaigns[i] = items;
        }
        return _campaigns;
    }
}