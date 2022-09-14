const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require('web3');
const fs = require("fs");


describe("2Blocks", function () {
  let ConclusionFactory;
  let ConclusionRendererFactory;
  let spaceFontFactory;

  let Conclusion;
  let ConclusionRenderer;
  let spaceFont;

  let owner;
  let addr1;
  let addr2;
  let addrs;

  // for signing
  let signer = "0x4A455783fC9022800FC6C03A73399d5bEB4065e8";
  let signerPk =
      "0x3532c806834d0a952c89f8954e2f3c417e3d6a5ad0d985c4a87a545da0ca722a";

  beforeEach(async function() {
    ConclusionFactory = await ethers.getContractFactory("Conclusion");
    ConclusionRendererFactory = await ethers.getContractFactory("ConclusionRenderer");
    spaceFontFactory = await ethers.getContractFactory("SpaceFont");

    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    Conclusion = await ConclusionFactory.deploy();
    ConclusionRenderer = await ConclusionRendererFactory.deploy();
    spaceFont = await spaceFontFactory.deploy();

    await Conclusion.setRenderer(ConclusionRenderer.address)
    ConclusionRenderer.setFontContract(spaceFont.address)
    

    const file = await fs.readFileSync(
        __dirname + '/../initialization-scripts/font.txt'
    );

    const content = file.toString();

    const partition_size = content.length / 2

    const firstPart = content.substring(0, partition_size);
    const secondPart = content.substring(partition_size, partition_size*2)
    const thirdPart = content.substring(partition_size*2, partition_size*3)
    const fourthPart = content.substring(partition_size*3, partition_size*4);
    const fifthPart = content.substring(partition_size*4);

    await spaceFont.saveFile(0, firstPart)
    await spaceFont.saveFile(1, secondPart)
    await spaceFont.saveFile(2, thirdPart)
    await spaceFont.saveFile(3, fourthPart)
    await spaceFont.saveFile(4, fifthPart)

    const fileBG = await fs.readFileSync(
        __dirname + '/../initialization-scripts/pow_gradient.txt'
    );
    const bg = fileBG.toString();

    await ConclusionRenderer.saveFile(0, bg)

  })

  it("should mint-drip-reroll-summon", async function () {
      await Conclusion.mint()

      let uri = await Conclusion.tokenURI(1)

      console.log("HERE", uri)
      
  });
});