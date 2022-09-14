const fs = require("fs");


// conclusion 0x485C38656729c9A59173B4218E85d6B283BE6657
// conclusionRenderer 0xf53B34ea1055809518463F67fc232E3889DA5feC
// genesis 0x5405e951837cFa67dC4ccf8f7bFD34b6Be7eB288
// genesisRenderer 0xC53C322594C5a0f4145a0f63Ad29c98B80695850
// spaceFont 0x4C8455415AEeD60d06F43a696E5BD0fb9dA7027B


async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Initializing contracts with the account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // todo: Update the addresses to attach to after deploy
  const SpaceFont = await ethers.getContractFactory("SpaceFont");
  const spaceFont = await SpaceFont.attach("0x4C8455415AEeD60d06F43a696E5BD0fb9dA7027B");

  const GenesisRenderer = await ethers.getContractFactory("GenesisRenderer");
  const genesisRenderer = await GenesisRenderer.attach("0xC53C322594C5a0f4145a0f63Ad29c98B80695850");

  const ConclusionRenderer = await ethers.getContractFactory("ConclusionRenderer");
  const conclusionRenderer = await ConclusionRenderer.attach("0xf53B34ea1055809518463F67fc232E3889DA5feC");

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