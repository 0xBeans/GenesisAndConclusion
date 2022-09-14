const { expect } = require("chai");
const { ethers } = require("hardhat");
const Web3 = require('web3');
const fs = require("fs");


describe("2Blocks", function () {
  let GenesisFactory;
  let GenesisRendererFactory;
  let spaceFontFactory;

  let Genesis;
  let GenesisRenderer;
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
    GenesisFactory = await ethers.getContractFactory("Genesis");
    GenesisRendererFactory = await ethers.getContractFactory("GenesisRenderer");
    spaceFontFactory = await ethers.getContractFactory("SpaceFont");

    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    Genesis = await GenesisFactory.deploy();
    GenesisRenderer = await GenesisRendererFactory.deploy();
    spaceFont = await spaceFontFactory.deploy();

    await Genesis.setRenderer(GenesisRenderer.address)
    GenesisRenderer.setFontContract(spaceFont.address)
    

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
        __dirname + '/../initialization-scripts/pos_gradient.txt'
    );
    const bg = fileBG.toString();

    await GenesisRenderer.saveFile(0, bg)

  })

  it("should mint-drip-reroll-summon", async function () {
      await Genesis.mint()

      let uri = await Genesis.tokenURI(0)

      console.log("HERE", uri)
      
  });
});