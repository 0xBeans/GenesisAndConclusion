//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/access/Ownable.sol";
import "sstore2/SSTORE2.sol";

contract GenesisRenderer is Ownable {
    // storing scroll files in contract storage using sstore2 because
    // marketplaces dont allow 3rd party filess to be loaded via url
    // kill  me
    mapping(uint256 => address) public files;

    // saving scroll files on-chain. pain.
    function saveFile(uint256 index, string calldata fileContent)
        public
        onlyOwner
    {
        files[index] = SSTORE2.write(bytes(fileContent));
    }

    // we have dna as a param in the interface incase we want to do update our
    // renderer to use it (ie potential onchain layering)
    function tokenURI(uint256 tokenId, uint256 blockNumber)
        external
        view
        returns (string memory)
    {
        // return string(abi.encodePacked(baseTokenUri, _tokenId.toString()));
    }
}
