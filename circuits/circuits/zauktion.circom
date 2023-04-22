pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template ZauKtion() {
    // private signals
    signal input bid;
    signal input idSecret;

    // public signals
    signal input auctionId;
    signal input x;
    
    // outputs
    signal output y;
    signal output nullifier;
    signal output idCommitment;
    signal output winningCommitment;
    
    idCommitment <== Poseidon(2)([bid, idSecret]); 
    winningCommitment <== Poseidon(2)([idCommitment, idSecret]);

    signal a1 <== Poseidon(2)([auctionId, idSecret]);
    y <== a1 * x + bid;

    nullifier <== Poseidon(1)([a1]);
}

component main { public [x, auctionId] } = ZauKtion();