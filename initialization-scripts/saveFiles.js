const fs = require("fs");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Initializing contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // todo: Update the addresses to attach to after deploy
  const SpaceFont = await ethers.getContractFactory("SpaceFont");
  const spaceFont = await SpaceFont.attach("0x6B9045e4855ebB16c8F7E291943a7743E34cA57C");

  const GenesisRenderer = await ethers.getContractFactory("GenesisRenderer");
  const genesisRenderer = await GenesisRenderer.attach("0xf2910c0f6856A2092a831494Cd510F33811B43eb");

  const ConclusionRenderer = await ethers.getContractFactory("ConclusionRenderer");
  const conclusionRenderer = await ConclusionRenderer.attach("0x6cf6A54125DaD7D174631a73347257aE5769572c");

  // read base64 encoded font
  const file = await fs.readFileSync(
    __dirname + '/font.txt'
  );

  const content = file.toString();
  
  const partition_size = content.length / 5

  const firstPart = content.substring(0, partition_size);
  const secondPart = content.substring(partition_size, partition_size*2)
  const thirdPart = content.substring(partition_size*2, partition_size*3)
  const fourthPart = content.substring(partition_size*3, partition_size*4);
  const fifthPart = content.substring(partition_size*4);
  
  let first = await spaceFont.saveFile(0, firstPart)
  let second = await spaceFont.saveFile(1, secondPart)
  let third = await spaceFont.saveFile(2, thirdPart)
  let fourth = await spaceFont.saveFile(3, fourthPart)
  let fifth = await spaceFont.saveFile(4, fifthPart)

  console.log('firstTxn', first);
  console.log('secondTxn', second);
  console.log('thirdTxn', third);
  console.log('fourthTxn', fourth);
  console.log('fifthTxn', fifth);

  const posfileBG = await fs.readFileSync(
    __dirname + '/../initialization-scripts/pos_gradient.txt'
    );
    const bgpos = posfileBG.toString();

    let pos = await genesisRenderer.saveFile(0, bgpos)
    console.log("pos", pos)

    const powfileBG = await fs.readFileSync(
      __dirname + '/../initialization-scripts/pow_gradient.txt'
    );
    const bgpow = powfileBG.toString();

    let pow = await conclusionRenderer.saveFile(0, bgpow)
    console.log("pow", pow)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });