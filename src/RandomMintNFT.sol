// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomMintNFT is ERC721, Ownable {
    uint256 public totalSupply;
    bool public reveal;

    uint256[] public usedTokenID;
    mapping(uint => bool) public existsTokenID;

    constructor(address initialOwner, uint256 _totalSupply)
        ERC721("RandomMintToken", "RMT")
        Ownable(initialOwner)
    {
        totalSupply = _totalSupply;
    }

    function setReveal(bool _reveal) public onlyOwner {
        reveal = _reveal;
    }

    function random() public view returns (uint) {
        uint256 randomUint = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender)));
        return (randomUint % totalSupply);
    }

    function randomMint(address to) public {
        uint256 tokenId = random();

        while (existsTokenID[tokenId] == true) {
            tokenId += 1;
            if (tokenId > totalSupply) {
                tokenId = tokenId % totalSupply;
            }
        } 
        
        usedTokenID.push(tokenId);
        existsTokenID[tokenId] = true;
        _safeMint(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return baseURI;
    }

    function _baseURI() internal view override virtual returns (string memory) {
        if (reveal) {
            return "ipfs://QmU8qXD6ZwAyAZNsqYWxuoAznmKpDnUra7uBTNAazzYusb/reveal-metadata.json";
        } else {
            return "ipfs://QmU8qXD6ZwAyAZNsqYWxuoAznmKpDnUra7uBTNAazzYusb/unreveal-metadata.json";
        }
    }
}