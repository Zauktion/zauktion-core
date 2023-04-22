import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { groth16 } from "snarkjs";
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils";
import { ZauktionVerifier, IdcheckVerifier } from "../typechain";

const zauktionWasmFile = "./test/zauktion.wasm";
const zauktionZkeyFile = "./test/zauktion.zkey";

const idcheckWasmFile = "./test/idcheck.wasm";
const idcheckZkeyFile = "./test/idcheck.zkey";

describe("Test Zauktion Verifier", () => {
  let accounts: SignerWithAddress[];
  let zauktionVerifier: ZauktionVerifier;
  let idcheckVerifier: IdcheckVerifier;
  before(async () => {
    accounts = await ethers.getSigners();
    const ZauktionVerifier = await ethers.getContractFactory("ZauktionVerifier");
    zauktionVerifier = await ZauktionVerifier.deploy();
    await zauktionVerifier.deployTransaction.wait();

    const IdcheckVerifier = await ethers.getContractFactory("IdcheckVerifier");
    idcheckVerifier = await IdcheckVerifier.deploy();
    await idcheckVerifier.deployTransaction.wait();
  });

  describe("Verify", () => {
    it("should able to verify valid input", async () => {
      const bid = BigInt("1000");
      const idSecret = "secret";
      let idSecretHash = "";
      for (let i = 0; i < idSecret.length; i++) {
        idSecretHash += idSecret.charCodeAt(i).toString(16);
      }
      const auctionId = BigInt(10);
      const x = BigInt(1);
      const circuitInputs = ff.utils.stringifyBigInts({
        // Converts the buffer to a BigInt
        bid: bid,
        idSecret: idSecretHash,
        auctionId: auctionId,
        x: x,
      });
      const proof = await groth16.fullProve(circuitInputs, zauktionWasmFile, zauktionZkeyFile);
      const proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
      console.log(proof);
      const res = await zauktionVerifier.verifyProof(
        ff.utils.stringifyBigInts(proofForTx.a),
        ff.utils.stringifyBigInts(proofForTx.b),
        ff.utils.stringifyBigInts(proofForTx.c),
        ff.utils.stringifyBigInts(proofForTx.pub)
      );
      console.log(res);
    });
    it("should able to verify valid input", async () => {
      const idSecret = "secret";
      let idSecretHash = "";
      for (let i = 0; i < idSecret.length; i++) {
        idSecretHash += idSecret.charCodeAt(i).toString(16);
      }

      const auctionId = BigInt(10);
      const x = BigInt(1);
      const circuitInputs = ff.utils.stringifyBigInts({
        // Converts the buffer to a BigInt
        bid: bid,
        idSecret: idSecret,
        auctionId: auctionId,
        x: x,
      });
      const proof = await groth16.fullProve(circuitInputs, zauktionWasmFile, zauktionZkeyFile);

      const proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
      const res = await zauktionVerifier.verifyProof(
        ff.utils.stringifyBigInts(proofForTx.a),
        ff.utils.stringifyBigInts(proofForTx.b),
        ff.utils.stringifyBigInts(proofForTx.c),
        ff.utils.stringifyBigInts(proofForTx.pub)
      );
      console.log(res);
    });
  });
});
