pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template ZauKtion() {
    // private signals
    signal input bid;

    // public signals
    signal input biddingAddress;
    signal input groupId;
    signal input x;
    
    // outputs
    signal output y;
    signal output nullifier;
    
    signal identityCommitment <== Poseidon(2)([bid, biddingAddress]); 

    signal a1 <== Poseidon(3)([bid, groupId, biddingAddress]);
    y <== a1 * x + bid;

    nullifier <== Poseidon(1)([a1]);
}

component main { public [x, groupId] } = ZauKtion();