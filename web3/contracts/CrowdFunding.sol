// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
   struct Campaign {
      address owner;
      string title;
      string description;
      uint256 target;
      uint256 deadline;
      uint256 amountCollected;
      string image;
      address[] donators;
      uint256[] donations;
   }

   mapping( uint256 => Campaign) public campaigns; // it is same as c++ like map<int, Campaign> campaigns
    uint256 public numberOfCampaigns=0; // it is used to keep track of the number of campaigns

    function createCampaign ( address _owner , string memory _title , string memory _description , 
    uint256 _target , uint256 _deadline , string memory _image) public returns (uint256){
        Campaign storage campaign = campaigns[numberOfCampaigns]; //similar to java's Campaign campaign = new Campaign();
        require(campaign.deadline<block.timestamp,"The deadline should be a date in the future ."); // used to check the condition
        // require is used to check the condition if the condition is true then the code will run otherwise it will throw an error
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;
        return numberOfCampaigns-1;
    } // this function is used to create a new campaign

    function dontaeToCampaign(uint256 _id) public payable{
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent , ) = payable(campaign.owner).call{value: amount}("");
        if(sent ){
            campaign.amountCollected += amount;
        }

    }

    function getDonators(uint256 _id)view public returns(address[] memory , uint256[] memory){
        return (campaigns[_id].donators , campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaign = new Campaign[](numberOfCampaigns);

        for(uint256 i=0;i<numberOfCampaigns;i++){
            Campaign storage item = campaigns[i];
            allCampaign[i] = item;
        }
        return allCampaign;
    }

    // working of each function is 
    // createCampaign() -> create a new campaign and store it in campaigns mapping
    // donateToCampaign() -> donate to a campaign and update the amountCollected
    // getDonators() -> get the list of donators for a campaign
    // getCampaigns() -> get the list of all campaigns 
}