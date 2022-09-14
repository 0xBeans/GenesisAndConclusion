// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "openzeppelin/token/ERC721/ERC721.sol";
import "openzeppelin/access/Ownable.sol";

import "./IConclusionRenderer.sol";

contract Conclusion is ERC721, Ownable {
    error AlreadyMinted();
    error TokenDoesNotExist();
    error MergeHasOccured();

    struct MintInfo {
        uint128 blockNumber;
        uint128 blockDifficulty;
    }

    uint256 public lastWorkBlock;
    uint256 public totalSupply;

    address public conclusionRenderer;

    mapping(address => uint256) mintedBlocks;
    mapping(uint256 => MintInfo) tokenToBlockNum;

    modifier onlyEOA() {
        require(msg.sender == tx.origin, "only EOA");
        _;
    }

    constructor() ERC721("The Last Work", "CONCLUSION") {}

    function setRenderer(address renderer) external onlyOwner {
        conclusionRenderer = renderer;
    }

    function mint() external onlyEOA {
        _assetPoW();

        if (mintedBlocks[tx.origin] > 0)
            revert AlreadyMinted();

        uint256 currSupply = totalSupply;

        mintedBlocks[tx.origin] = block.number;
        tokenToBlockNum[currSupply] = MintInfo(
            uint128(block.number),
            uint128(block.difficulty)
        );

        unchecked {
            _mint(tx.origin, currSupply++);
        }

        totalSupply = currSupply;
    }

    function _assetPoW() internal {
        if (isPoS())
            revert MergeHasOccured();

        lastWorkBlock = block.number;
    }

    function isPoS() public view returns (bool) {
        return block.difficulty > 2**64 || block.difficulty == 0;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (!_exists(_tokenId))
            revert TokenDoesNotExist();

        if (conclusionRenderer == address(0))
            return "";

        MintInfo memory info = tokenToBlockNum[_tokenId];

        return
            IConclusionRenderer(conclusionRenderer).tokenURI(
                _tokenId,
                info.blockNum,
                info.blockdifficulty
            );
    }
}
