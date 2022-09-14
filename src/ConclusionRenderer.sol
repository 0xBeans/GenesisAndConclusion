//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/access/Ownable.sol";

import {Base64} from "solady/utils/Base64.sol";
import {SSTORE2} from "solady/utils/SSTORE2.sol";
import {LibString} from "solady/utils/LibString.sol";

import "./ISpaceFont.sol";

contract ConclusionRenderer is Ownable {
    // storing scroll files in contract storage using sstore2 because
    // marketplaces dont allow 3rd party filess to be loaded via url
    // kill  me

    uint256 public constant GRADIENT = 0;

    mapping(uint256 => address) public files;

    address public spaceFont;

    function setFontContract(address font) external onlyOwner {
        spaceFont = font;
    }

    // saving scroll files on-chain. pain.
    function saveFile(uint256 index, string calldata fileContent)
        public
        onlyOwner
    {
        files[index] = SSTORE2.write(bytes(fileContent));
    }

    // we have dna as a param in the interface incase we want to do update our
    // renderer to use it (ie potential onchain layering)
    function tokenURI(
        uint256 tokenId,
        uint256 blockNumber,
        uint256 blockDifficulty
    ) external view returns (string memory svgString) {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        abi.encodePacked(
                            "{"
                            '"name": "Conclusion",',
                            '"description": "An attempt to be the last on-chain NFT to be minted on POW",'
                            '"image": "data:image/svg+xml;base64,',
                            Base64.encode(bytes(getSVG(blockNumber))),
                            '",'
                            '"attributes": [{"trait_type": "block number", "value":"',
                            LibString.toString(blockNumber),
                            '"},',
                            '{"trait_type": "block difficulty", "value":"',
                            LibString.toString(blockDifficulty),
                            '"}]}'
                        )
                    )
                )
            );
    }

    function getSVG(uint256 blockNumber)
        internal
        view
        returns (string memory svgString)
    {
        svgString = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' width='256' height='256' viewBox='0 0 256 256' preserveAspectRatio='none'>"
                "<image height='256' width='256' href='",
                string(SSTORE2.read(files[GRADIENT])),
                "'/>"
                "<text x='50%' y='40%' dominant-baseline='middle' text-anchor='middle' class='title'>"
                "MINTED"
                "</text>"
                "<text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' class='title'>"
                "AT"
                "</text>"
                "<text x='50%' y='60%' dominant-baseline='middle' text-anchor='middle' class='title'> #",
                LibString.toString(blockNumber),
                "</text>"
                "<style type='text/css'>"
                "@font-face {"
                "font-family: 'Space-Grotesk';"
                "font-style: normal;"
                "src:url(",
                // getFont(),
                ISpaceFont(spaceFont).getFont(),
                ");}"
                ".title {"
                "font-family: 'Space-Grotesk';"
                "letter-spacing: 0.025em;"
                "font-size: 23px;"
                "fill: white;"
                "}"
                "</style>"
                "</svg>"
            )
        );
    }
}
