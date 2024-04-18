// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Recommendation} from "../src/Recommendation.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract RecommendationTest is Test {
    Recommendation public recommendation; // Recommendation is an ERC721 token

    address public constant SENDING_USER = address(1);
    address public constant RECEIVING_USER = address(2);
    string public constant SAMPLE_SENDING_USER_NAME = "Sending User's Name";
    string public constant SAMPLE_RECEIVING_USER_NAME = "Recieving User's Name";
    string public constant SAMPLE_DESCRIPTION = "Sample NFT Description";

    function setUp() public {
        recommendation = new Recommendation();
    }

    function test_isOwnedBySomeone() public {
        vm.prank(SENDING_USER);
        uint256 tokenId = recommendation.mintAndSend(
            RECEIVING_USER, SAMPLE_SENDING_USER_NAME, SAMPLE_RECEIVING_USER_NAME, SAMPLE_DESCRIPTION
        );

        // Assert that the owner of the tokenId is the expected owner
        address actualOwner = recommendation.ownerOf(tokenId);
        assertEq(actualOwner, RECEIVING_USER);
    }

    function test_metadataIsCorrect() public {
        vm.prank(SENDING_USER);
        uint256 tokenId = recommendation.mintAndSend(
            RECEIVING_USER, SAMPLE_SENDING_USER_NAME, SAMPLE_RECEIVING_USER_NAME, SAMPLE_DESCRIPTION
        );

        string memory tokenURI = recommendation.tokenURI(tokenId);
        console.log(tokenURI); // paste this result in to a web browser to verify the JSON metadata is accurate
    }

    function test_maxLengthOfDescription() public {
        string memory longString = "";
        for (uint256 i = 0; i < 100; i++) {
            longString = string.concat(longString, SAMPLE_DESCRIPTION);
        }
        vm.expectRevert();
        recommendation.mintAndSend(RECEIVING_USER, SAMPLE_SENDING_USER_NAME, SAMPLE_RECEIVING_USER_NAME, longString);
    }
}
