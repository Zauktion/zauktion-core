import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { groth16 } from "snarkjs";
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils";
import { IAuctionVerifier } from "../typechain";
import { IAuctionVerifier__factory } from "../typechain/factories";

const wasmFile = "./test/zauktion.wasm";
const zkeyFile = "./test/zauktion.zkey";

describe("Test zauktion verifier", () => {
  let deployer: SignerWithAddress;
  let verifier: IAuctionVerifier;
  before(async () => {
    [deployer] = await ethers.getSigners();
    verifier = await new IAuctionVerifier__factory(deployer).deploy();
    await verifier.deployTransaction.wait();
  });

  describe("verify", () => {
    it("should able to verify valid input", async () => {
      const idSecret = "secret";
      let idSecretHash = "";
      for (let i = 0; i < idSecret.length; i++) {
        idSecretHash += idSecret.charCodeAt(i).toString(16);
      }
      const bid = BigInt("1000");
      const auctionId = BigInt(10);
      const x = BigInt(1);
      const circuitInputs = ff.utils.stringifyBigInts({
        // Converts the buffer to a BigInt
        bid: bid,
        idSecret: idSecretHash,
        auctionId: auctionId,
        x: x,
      });
      console.log(circuitInputs)
      const proof = await groth16.fullProve(circuitInputs, wasmFile, zkeyFile);
      console.log(proof);
      const proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
      const res = await verifier.verifyProof(
        ff.utils.stringifyBigInts(proofForTx.a),
        ff.utils.stringifyBigInts(proofForTx.b),
        ff.utils.stringifyBigInts(proofForTx.c),
        ff.utils.stringifyBigInts(proofForTx.pub)
      );
      console.log(res);
    });
  });
});
