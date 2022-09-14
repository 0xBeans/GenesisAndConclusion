const file = await fs.readFileSync(
    __dirname + './font.txt'
);

const content = file.toString();

const partition_size = content.length / 4

const firstPart = content.substring(0, partition_size);
const secondPart = content.substring(partition_size, partition_size*2)
const thirdPart = content.substring(partition_size*2, partition_size*3)
const fourthPart = content.substring(partition_size*3, partition_size*4);

await conclusionRenderer.saveFile(0, firstPart)
await conclusionRenderer.saveFile(1, secondPart)
await conclusionRenderer.saveFile(2, thirdPart)
await conclusionRenderer.saveFile(3, fourthPart)

const fileBG = await fs.readFileSync(
    __dirname + './pos_gradient.txt'
);
const bg = fileBG.toString();

await conclusionRenderer.saveFile(4, bg)