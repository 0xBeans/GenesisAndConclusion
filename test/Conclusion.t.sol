// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../src/Conclusion.sol";

contract ConclusionTest is Test {
    Conclusion public c;
    function setUp() public {
      c = new Conclusion();
      vm.difficulty(2**25);
    }

    function test_mintContract() public {
      vm.expectRevert("only EOA");
      c.mint();
    }

    function test_mint() public {
        vm.prank(0x4C9ACeE7Ba4d5AFD8408D0c68591e2ABB01A3ec9, 0x4C9ACeE7Ba4d5AFD8408D0c68591e2ABB01A3ec9);
        c.mint();
    }

    function test_idk() public {
    }
}