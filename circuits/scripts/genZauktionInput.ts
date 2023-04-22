const fs = require("fs");
const ff = require("ffjavascript");

async function main() {
  const bid = BigInt('1000')
  const biddingAddress = BigInt("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")
  const groupId = BigInt(10)
  const x = BigInt(1)
  const circuitInputs = ff.utils.stringifyBigInts({
    // Converts the buffer to a BigInt
    bid: bid,
    biddingAddress: biddingAddress,
    groupId: groupId,
    x: x,
  });
  fs.writeFileSync("./input.json", JSON.stringify(circuitInputs), "utf-8");
}

main();
