//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/access/Ownable.sol";
import "sstore2/SSTORE2.sol";

contract SpaceFont is Ownable {
    // storing scroll files in contract storage using sstore2 because
    // marketplaces dont allow 3rd party filess to be loaded via url
    // kill  me
    uint256 public constant FONT_PARTITION_1 = 0;
    uint256 public constant FONT_PARTITION_2 = 1;
    uint256 public constant FONT_PARTITION_3 = 2;
    uint256 public constant FONT_PARTITION_4 = 3;
    uint256 public constant FONT_PARTITION_5 = 4;
    uint256 public constant GRADIENT = 5;

    mapping(uint256 => address) public files;

    // saving scroll files on-chain. pain.
    function saveFile(uint256 index, string calldata fileContent)
        public
        onlyOwner
    {
        files[index] = SSTORE2.write(bytes(fileContent));
    }

    function getFont() public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    SSTORE2.read(files[0]),
                    SSTORE2.read(files[1]),
                    SSTORE2.read(files[2]),
                    SSTORE2.read(files[3]),
                    SSTORE2.read(files[4])
                )
            );
    }
}
