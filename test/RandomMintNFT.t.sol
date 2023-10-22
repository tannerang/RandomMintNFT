// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {RandomMintNFT} from "../src/RandomMintNFT.sol";

contract CounterTest is Test {
    RandomMintNFT public RandomMintNFTContract;
    address contractOwner = makeAddr("contract owner");

    function setUp() public {
        RandomMintNFTContract = new RandomMintNFT(contractOwner, 500);
    }

    function testRandomMint(uint x) public {
        address user1 = makeAddr("user1");
        vm.startPrank(user1);
        console2.log(RandomMintNFTContract.balanceOf(user1)); // should be 0

        RandomMintNFTContract.randomMint(user1);
        vm.prevrandao(bytes32(x));
        RandomMintNFTContract.randomMint(user1);

        console2.log(RandomMintNFTContract.balanceOf(user1)); // should be 2
        console2.log(RandomMintNFTContract.usedTokenID(0));
        console2.log(RandomMintNFTContract.usedTokenID(1));

        assertEq(true, RandomMintNFTContract.existsTokenID(RandomMintNFTContract.usedTokenID(0)));
        assertEq(true, RandomMintNFTContract.existsTokenID(RandomMintNFTContract.usedTokenID(1)));

        vm.stopPrank();
    }

    function testReveal() public {

        address user1 = makeAddr("user1");
        vm.startPrank(user1);
        RandomMintNFTContract.randomMint(user1);
        string memory unrevealTokenURI = RandomMintNFTContract.tokenURI(RandomMintNFTContract.usedTokenID(0));
        console2.log(unrevealTokenURI); // ipfs://QmU8qXD6ZwAyAZNsqYWxuoAznmKpDnUra7uBTNAazzYusb/unreveal-metadata.json
        vm.stopPrank();

        vm.startPrank(contractOwner);
        RandomMintNFTContract.setReveal(true);
        string memory revealTokenURI = RandomMintNFTContract.tokenURI(RandomMintNFTContract.usedTokenID(0));
        console2.log(revealTokenURI); //ipfs://QmU8qXD6ZwAyAZNsqYWxuoAznmKpDnUra7uBTNAazzYusb/reveal-metadata.json
        vm.stopPrank();

        assertEq(false, keccak256(abi.encodePacked((unrevealTokenURI))) == keccak256(abi.encodePacked((revealTokenURI))));
    }
}
