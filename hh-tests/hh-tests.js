const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require('web3');
const fs = require("fs");


describe("Mirakai Full integration tests", function () {
  let conclusionFactory;
  let conclusionRendererFactory;
  let mirakaiScrollsRendererFactory;
  let mirakaiHeroesFactory;
  let mirakaiHeroesRendererFactory;
  let mirakaiDnaParserFactory;
  let orbsFactory;

  let conclusion;
  let mirakaiScrollsRenderer;
  let mirakaiHeroes;
  let mirakaiHeroesRenderer;
  let mirakaiDnaParser;
  let orbs;

  let owner;
  let addr1;
  let addr2;
  let addrs;

  // for signing
  let signer = "0x4A455783fC9022800FC6C03A73399d5bEB4065e8";
  let signerPk =
      "0x3532c806834d0a952c89f8954e2f3c417e3d6a5ad0d985c4a87a545da0ca722a";

  beforeEach(async function() {
    conclusionFactory = await ethers.getContractFactory("Conclusion");
    conclusionRendererFactory = await ethers.getContractFactory("ConclusionRenderer");

    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    conclusion = await conclusionFactory.deploy();
    conclusionRenderer = await conclusionRendererFactory.deploy();
    await conclusion.setRenderer(conclusionRenderer.address)
    

    const file = await fs.readFileSync(
        __dirname + '/../initialization-scripts/font.txt'
    );

    const content = file.toString();

    const partition_size = content.length / 5

    const firstPart = content.substring(0, partition_size);
    const secondPart = content.substring(partition_size, partition_size*2)
    const thirdPart = content.substring(partition_size*2, partition_size*3)
    const fourthPart = content.substring(partition_size*3, partition_size*4);
    const fifthPart = content.substring(partition_size*4);

    await conclusionRenderer.saveFile(0, firstPart)
    await conclusionRenderer.saveFile(1, secondPart)
    await conclusionRenderer.saveFile(2, thirdPart)
    await conclusionRenderer.saveFile(3, fourthPart)
    await conclusionRenderer.saveFile(4, fifthPart)

    const fileBG = await fs.readFileSync(
        __dirname + '/../initialization-scripts/pos_gradient.txt'
    );
    const bg = fileBG.toString();

    await conclusionRenderer.saveFile(5, bg)
    // await mirakaiScrollsRenderer.saveFile(0, content);

  })

  it("should mint-drip-reroll-summon", async function () {
      await conclusion.mint()

      let uri = await conclusion.tokenURI(0)

      console.log("HERE", uri)

      let font = await conclusionRenderer.getFont()

      console.log("FOT", font)
      
  });
});