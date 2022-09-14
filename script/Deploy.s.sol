// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/Conclusion.sol";
import "../src/ConclusionRenderer.sol";
import "../src/Genesis.sol";
import "../src/GenesisRenderer.sol";
import "../src/SpaceFont.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        ConclusionRenderer conclusionRenderer = new ConclusionRenderer();

        GenesisRenderer genesisRenderer = new GenesisRenderer();

        Genesis genesis = new Genesis();
        Conclusion conclusion = new Conclusion();

        SpaceFont spaceFont = new SpaceFont();

        conclusionRenderer.setFontContract(address(spaceFont));
        genesisRenderer.setFontContract(address(spaceFont));

        conclusion.setRenderer(address(conclusionRenderer));
        genesis.setRenderer(address(genesisRenderer));

        console.log("conclusion", address(conclusion));
        console.log("conclusionRenderer", address(conclusionRenderer));
        console.log("genesis", address(genesis));
        console.log("genesisRenderer", address(genesisRenderer));
        console.log("spaceFont", address(spaceFont));
    }
}
