// didnt have time to write tests T_T , but it was reviewed by some big brains. - hello im a medium size brain i wrote a test
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Conclusion.sol";
import "./Constants.t.sol";

interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}

contract TestConclusion is Test, Constants {
    address public owner;
    address public addr1;
    address public addr2;
    Conclusion conclusion;

    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public {
        conclusion = new Conclusion();
        
        // new deployed contracts will have Test as owner
        owner = address(this); 

        addr1 = cheats.addr(1);
        addr2 = cheats.addr(2);
    }
}

contract TestConclusionMint is TestConclusion {
    function testShouldMint() public {
        assertEq(conclusion.lastWorkBlock() == block.number, false);

        vm.prank(owner,owner);
        vm.difficulty(12);
        conclusion.mint();

        assertEqUint(conclusion.totalSupply(), 1);
        assertEqUint(conclusion.lastWorkBlock(), block.number);
    }

    function testShouldFailToCallMintFromNonEOA() public {
        vm.prank(address(conclusion));
        vm.expectRevert("only EOA");
        conclusion.mint();

        assertEq(conclusion.lastWorkBlock() == block.number, false);
        assertEqUint(conclusion.totalSupply(), 0);
    }

    function testShouldNotMintAfterMergeHasOccured() public {
        vm.prank(owner,owner);
        vm.difficulty(POST_MERGE_DIFFICULTY_MAX);
        // MergeHasOccured == 0x1543afaf
        vm.expectRevert(0x1543afaf);
        conclusion.mint();
    }

    function testShouldNotMintTwiceForSameUser() public {
        // sanity
        assertEqUint(conclusion.totalSupply(), 0);

        vm.startPrank(owner,owner);
        vm.difficulty(13);
        conclusion.mint();
        assertEqUint(conclusion.totalSupply(), 1);

        vm.expectRevert(0xddefae28);
        conclusion.mint();
        assertEqUint(conclusion.totalSupply(), 1);
        vm.stopPrank();
    }
}

contract TestConclusionUtils is TestConclusion {
    function testSetRenderOnlyOwner() public {
        conclusion.setRenderer(addr1);
        assertEq(conclusion.conclusionRenderer(), addr1);
    }

    function testShouldFailToSetRenderNotOnlyOwner() public {
        vm.prank(addr2);
        vm.expectRevert("Ownable: caller is not the owner");
        conclusion.setRenderer(addr1);
    }

    function testMergeHasOccuredWhenDifficulty0() public {
        vm.difficulty(POST_MERGE_DIFFICULTY_MIN);
        assertEq(conclusion.mergeHasOccured(), true);
    }

    function testMergeHasOccuredWhenDifficulty2pwr64() public {
        vm.difficulty(POST_MERGE_DIFFICULTY_MAX);
        assertEq(conclusion.mergeHasOccured(), true);
    }

    function testMergeHasNotOccuredWhenOneTermFalse() public {
        vm.difficulty(12);
        assertEq(conclusion.mergeHasOccured(), false);
    }

    function testCheckProofOfWorkValidAndUpdateBeforeMerge() public {
        vm.difficulty(12);
        assertEq(conclusion.mergeHasOccured(), false);

        conclusion.checkProofOfWorkValidAndUpdate();
        assertEq(conclusion.lastWorkBlock() == block.number, true);
    }

    function testCheckProofOfWorkValidAndUpdateAfterMerge() public {
        vm.difficulty(POST_MERGE_DIFFICULTY_MIN);
        assertEq(conclusion.mergeHasOccured(), true);

        conclusion.checkProofOfWorkValidAndUpdate();
        assertEq(conclusion.lastWorkBlock() == block.number, false);
    }
}
