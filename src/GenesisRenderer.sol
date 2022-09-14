//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/access/Ownable.sol";
import "sstore2/SSTORE2.sol";

import "./ISpaceFont.sol";

contract GenesisRenderer is Ownable {
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
                            '"name": "Genesis",',
                            '"description": "An attempt to be the first on-chain NFT to be minted on POS",'
                            '"image": "data:image/svg+xml;base64,',
                            Base64.encode(bytes(getSVG(blockNumber))),
                            '",'
                            '"attributes": [{"trait_type": "block number", "value":"',
                            toString(blockNumber),
                            '"},',
                            '{"trait_type": "block difficulty", "value":"',
                            toString(blockDifficulty),
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
                toString(blockNumber),
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
                "fill: black;"
                "}"
                "</style>"
                "</svg>"
            )
        );
    }

    // function getFont() public view returns (string memory) {
    //     return
    //         string(
    //             abi.encodePacked(
    //                 SSTORE2.read(files[0]),
    //                 SSTORE2.read(files[1]),
    //                 SSTORE2.read(files[2]),
    //                 SSTORE2.read(files[3]),
    //                 SSTORE2.read(files[4])
    //             )
    //         );
    // }

    function toString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

library Base64 {
    bytes internal constant TABLE =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
                )
                out := shl(8, out)
                out := add(
                    out,
                    and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
                )
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}
