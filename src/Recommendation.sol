// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract Recommendation is ERC721 {
    uint256 counter = 1;

    mapping(uint256 => NFTData) public nftData;

    struct NFTData {
        address senderAddress;
        address receiverAddress;
        string senderName;
        string receiverName;
        string description;
    }

    constructor() ERC721("GetReccd", "RECCD") {}

    // Function to mint and send NFT to a specific wallet
    function mintAndSend(
        address receiverAddress,
        string memory senderName,
        string memory receiverName,
        string memory description
    ) public returns (uint256) {
        require(bytes(description).length <= 280, "Description too long");

        uint256 tokenId = counter;
        counter++;

        nftData[tokenId] = NFTData(msg.sender, receiverAddress, senderName, receiverName, description);

        _mint(receiverAddress, tokenId);
        return tokenId;
    }

    function getNFTImage(uint256 tokenId) public pure returns (string memory) {
        return string.concat("https://www.getreccd.com/nft/recommendation/v1/", Strings.toString(tokenId));
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        NFTData memory data = nftData[tokenId];
        string memory json = string(
            abi.encodePacked(
                '{"description": "',
                data.description,
                '", "senderName": "',
                data.senderName,
                '", "receiverAddress": "',
                Strings.toHexString(uint256(uint160(data.receiverAddress))),
                '", "senderAddress": "',
                Strings.toHexString(uint256(uint160(data.senderAddress))),
                '", "receiverName": "',
                data.receiverName,
                '", "image": "',
                getNFTImage(tokenId),
                '"}'
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", Base64.encode(bytes(json))));
    }
}
