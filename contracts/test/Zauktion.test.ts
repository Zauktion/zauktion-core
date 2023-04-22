import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { groth16 } from "snarkjs";
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils";
import { Verifier, Verifier__factory } from "../typechain";

const wasmFile = "./test/zauktion.wasm"
const zkeyFile = "./test/zauktion.zkey"

describe("Test zauktion verifier", () => {
  let deployer: SignerWithAddress
  let verifier: Verifier;
  let zoukpon;
  before(async () => {
    [deployer] = await ethers.getSigners();
    verifier = await new Verifier__factory(deployer).deploy();
    await verifier.deployTransaction.wait();
  });

  describe("verify", () => {
    it("should able to verify valid input", async () => {
      const bid = BigInt("1000");
      const biddingAddress = BigInt(
        "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
      );
      const groupId = BigInt(10);
      const x = BigInt(1);
      const circuitInputs = ff.utils.stringifyBigInts({
        // Converts the buffer to a BigInt
        bid: bid,
        biddingAddress: biddingAddress,
        groupId: groupId,
        x: x,
      });
      const proof = await groth16.fullProve(
        circuitInputs,
        wasmFile,
        zkeyFile
      );
      const proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
      const res = await verifier.verifyProof(
        ff.utils.stringifyBigInts(proofForTx.a),
        ff.utils.stringifyBigInts(proofForTx.b),
        ff.utils.stringifyBigInts(proofForTx.c),
        ff.utils.stringifyBigInts(proofForTx.pub),
      )
      console.log(res)
    });
  });
});
