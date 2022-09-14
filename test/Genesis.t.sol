// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Genesis.sol";

contract GenesisTest is Test {
    Genesis public g;

    function setUp() public {
        g = new Genesis();
        vm.difficulty(2**255);
    }

    function mintContract() public {
        vm.expectRevert("only EOA");
        g.mint();
    }

    function test_mint() public {
        vm.prank(
            0x4C9ACeE7Ba4d5AFD8408D0c68591e2ABB01A3ec9,
            0x4C9ACeE7Ba4d5AFD8408D0c68591e2ABB01A3ec9
        );
        g.mint();
    }

    function test_idk() public {}
}
