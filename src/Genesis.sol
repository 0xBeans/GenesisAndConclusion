// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin/token/ERC721/ERC721.sol";
import "openzeppelin/access/Ownable.sol";

import "./IGenesisRenderer.sol";

contract Genesis is ERC721, Ownable {
    error AlreadyMinted();
    error TokenDoesNotExist();
    error MergeHasNotOccured();
    error TooLate();

    uint256 immutable MAX_MINT_DISTANCE = 100;

    struct MintInfo {
        uint128 blockNumber;
        uint128 blockDifficulty;
    }

    uint256 public genesisMergeBlock;
    uint256 public totalSupply;

    address public genesisRenderer;

    mapping(address => uint256) mintedBlocks;
    mapping(uint256 => MintInfo) tokenToBlockNum;

    modifier onlyEOA() {
        require(msg.sender == tx.origin, "only EOA");
        _;
    }

    constructor() ERC721("New Genesis", "GENESIS") {}

    function setRenderer(address renderer) external onlyOwner {
        genesisRenderer = renderer;
    }

    function mint() external onlyEOA {        
        assertPos();

        if (mintedBlocks[tx.origin] > 0)
            revert AlreadyMinted();

        if (block.number - genesisMergeBlock > MAX_MINT_DISTANCE)
            revert TooLate();

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

    function assertPoS() public {
        if (!isPoS())
            revert MergeHasNotOccured();

        if (genesisMergeBlock == 0)
            genesisMergeBlock = block.number;
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

        if (genesisRenderer == address(0))
            return "";

        MintInfo memory info = tokenToBlockNum[_tokenId];

        return
            IGenesisRenderer(genesisRenderer).tokenURI(
                _tokenId,
                info.blockNumber,
                genesisMergeBlock
            );
    }
}
