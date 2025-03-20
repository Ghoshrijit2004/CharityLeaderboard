// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CharityLeaderboard {
    struct Donor {
        address donorAddress;
        uint256 totalDonations;
    }

    mapping(address => uint256) public donations;
    address[] public donors;

    event DonationReceived(address indexed donor, uint256 amount);

    function donate() external payable {
        require(msg.value > 0, "Donation must be greater than zero");

        if (donations[msg.sender] == 0) {
            donors.push(msg.sender);
        }

        donations[msg.sender] += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    function getTopDonors() external view returns (Donor[] memory) {
        Donor[] memory topDonors = new Donor[](donors.length);
        
        for (uint256 i = 0; i < donors.length; i++) {
            topDonors[i] = Donor(donors[i], donations[donors[i]]);
        }

        return sortTopDonors(topDonors);
    }

    function sortTopDonors(Donor[] memory topDonors) internal pure returns (Donor[] memory) {
        uint256 length = topDonors.length;
        for (uint256 i = 0; i < length; i++) {
            for (uint256 j = i + 1; j < length; j++) {
                if (topDonors[j].totalDonations > topDonors[i].totalDonations) {
                    Donor memory temp = topDonors[i];
                    topDonors[i] = topDonors[j];
                    topDonors[j] = temp;
                }
            }
        }
        return topDonors;
    }

    function getDonationAmount(address donor) external view returns (uint256) {
        return donations[donor];
    }

    function getTotalDonors() external view returns (uint256) {
        return donors.length;
    }
}
