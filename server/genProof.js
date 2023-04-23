import { ethers } from "ethers";
import { groth16 } from "snarkjs";
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils.js";
import * as dotenv from "dotenv";
dotenv.config();

import abi from "./configs/zauktion.json";
const zauktionWasmFile = "./configs/zauktion.wasm";
const zauktionZkeyFile = "./configs/zauktion.zkey";
const idcheckWasmFile = "./configs/idcheck.wasm";
const idcheckZkeyFile = "./configs/idcheck.zkey";

const rpcURL = `https://rpc.chiadochain.net`;
const provider = new ethers.providers.JsonRpcProvider(rpcURL, 10200);
const signer = new ethers.Wallet(process.env.PROJECT_PK_TEST, provider);
const zauktion = new ethers.Contract(
  process.env.CONTRACT_TESTNET,
  abi.abi,
  signer
);

const zauktionBidProof = async (data) => {
  try {
    const bid = BigInt(data.bid);
    const idSecret = data.idSecret;
    let idSecretHash = "";
    for (let i = 0; i < idSecret.length; i++) {
      idSecretHash += idSecret.charCodeAt(i).toString(16);
    }

    const auctionId = await zauktion.auctionId();
    const x = BigInt(1);
    const circuitInputs = ff.utils.stringifyBigInts({
      // Converts the buffer to a BigInt
      bid: bid,
      idSecret: idSecretHash,
      auctionId: auctionId,
      x: x,
    });
    const proof = await groth16.fullProve(
      circuitInputs,
      zauktionWasmFile,
      zauktionZkeyFile
    );
    const proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
    return {
      /*statusCode: 200,
      headers: {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      },*/
      body: JSON.stringify({
        proofForTxA: ff.utils.stringifyBigInts(proofForTx.a),
        proofForTxB: ff.utils.stringifyBigInts(proofForTx.b),
        proofForTxC: ff.utils.stringifyBigInts(proofForTx.c),
        proofForTxD: ff.utils.stringifyBigInts(proofForTx.pub),
      }),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: err.statusCode || 501,
      body: JSON.stringify(
        {
          message: "Error Occured when generating proof!",
          details: err,
        },
        null,
        2
      ),
    };
  }
};

const idcheckProof = async (data) => {
  try {
    const bid = BigInt(data.bid);
    const idSecret = data.idSecret;
    let idSecretHash = "";
    for (let i = 0; i < idSecret.length; i++) {
      idSecretHash += idSecret.charCodeAt(i).toString(16);
    }

    const auctionId = await zauktion.auctionId();
    const x = BigInt(1);
    let circuitInputs = ff.utils.stringifyBigInts({
      // Converts the buffer to a BigInt
      bid: bid,
      idSecret: idSecretHash,
      auctionId: auctionId,
      x: x,
    });
    let proof = await groth16.fullProve(
      circuitInputs,
      zauktionWasmFile,
      zauktionZkeyFile
    );
    let proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
    const signal = proof.publicSignals;
    circuitInputs = ff.utils.stringifyBigInts({
      // Converts the buffer to a BigInt
      idSecret: idSecretHash,
      idCommitment: signals[3],
    });

    proof = await groth16.fullProve(
      circuitInputs,
      idcheckWasmFile,
      idcheckZkeyFile
    );

    proofForTx = proofToSCFormat(proof.proof, proof.publicSignals);
    return {
      statusCode: 200,
      headers: {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
      },
      body: JSON.stringify({
        proofForTxA: ff.utils.stringifyBigInts(proofForTx.a),
        proofForTxB: ff.utils.stringifyBigInts(proofForTx.b),
        proofForTxC: ff.utils.stringifyBigInts(proofForTx.c),
        proofForTxD: ff.utils.stringifyBigInts(proofForTx.pub),
      }),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: err.statusCode || 501,
      body: JSON.stringify(
        {
          message: "Error Occured when generating proof!",
          details: err,
        },
        null,
        2
      ),
    };
  }
};

export { zauktionBidProof, idcheckProof };
