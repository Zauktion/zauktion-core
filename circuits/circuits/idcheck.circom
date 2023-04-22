pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template idcheck(){
    // private input sig
    signal input idSecret;
    
    // public input sig
    signal input idCommitment;
    signal output winnerCommitment;

    winnerCommitment <== Poseidon(2)([idCommitment, idSecret]); 
}

component main { public[idCommitment] } = idcheck();