"use strict"

import { ethers } from "ethers";

import { groth16 } from "snarkjs";
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils";

import abi from '../configs/zauktion.json';
const zauktionWasmFile = "../configs/zauktion.wasm";
const zauktionZkeyFile = "../configs/zauktion.zkey";
const idcheckWasmFile = "../configs/idcheck.wasm";
const idcheckZkeyFile = "../configs/idcheck.zkey";

import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

/*
const rpcURL = `https://rpc.chiadochain.net`;
const provider = new ethers.providers.JsonRpcProvider(rpcURL, 10200);
const signer = new ethers.Wallet(process.env.PROJECT_PK_TEST, provider);
const erc721 = new ethers.Contract(process.env.CONTRACT_TESTNET, abi, signer)
*/

export const zauktionBidProof = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  try {
    const data = event.body;
    const bid = BigInt(data.bid);
    const idSecret = data.idSecret;
    let idSecretHash = "";
    for (let i = 0; i < idSecret.length; i++) {
      idSecretHash += idSecret.charCodeAt(i).toString(16);
    }
    // const giveawayTokens = await erc721.mintGiveawayTokens(payload.address, 1);
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
        proofForTxD: ff.utils.stringifyBigInts(proofForTx.pub)
      }),
    };
  } catch (err) {
    console.error(err)
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
    }
  }
}

export const idcheckProof = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  try {
  } catch (err) {
    console.error(err)
    return {
      statusCode: err.statusCode || 501,
      body: JSON.stringify(
        {
          message: "Error Occured when airdropping!",
          details: err,
        },
        null,
        2
      ),
    }
  }
}