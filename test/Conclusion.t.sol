// didnt have time to write tests T_T , but it was reviewed by some big brains. - hello im a medium size brain i wrote a test
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Conclusion.sol";

interface CheatCodes {
   // Gets address for a given private key, (privateKey) => (address)
   function addr(uint256) external returns (address);
}

contract TestConclusion is Test {
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
        vm.difficulty(0);
        assertEq(conclusion.mergeHasOccured(), true);
    }

    function testMergeHasOccuredWhenDifficulty2pwr64() public {
        vm.difficulty(2**64 + 1);
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
        vm.difficulty(0);
        assertEq(conclusion.mergeHasOccured(), true);

        conclusion.checkProofOfWorkValidAndUpdate();
        assertEq(conclusion.lastWorkBlock() == block.number, false);
    }

    function testShouldFailToCallMintFromNonEOA() public {
        vm.prank(address(conclusion));
        vm.expectRevert("only EOA");
        conclusion.mint();
    }

    function testShouldMint()

}