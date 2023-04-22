/* eslint-disable */
import {groth16} from "snarkjs"
import * as ff from "ffjavascript";
import { proofToSCFormat } from "./utils";


const wasmFile = "./zk/zauktion.wasm";
const zkeyFile = "./zk/zauktion.zkey";

const genProof = async() =>{
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
    /*const res = await verifier.verifyProof(
        ff.utils.stringifyBigInts(proofForTx.a),
        ff.utils.stringifyBigInts(proofForTx.b),
        ff.utils.stringifyBigInts(proofForTx.c),
        ff.utils.stringifyBigInts(proofForTx.pub)
    );
    console.log(res);*/
}

export {
    genProof
}