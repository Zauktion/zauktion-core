pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template ZKoupon() {
    // The public inputs
    signal input nullifier;
    signal input couponId;

    // The private inputs
    signal input couponCode;

    // Hash the couponCode and couponId
    // Check if the result matches the unique hash - nullifier.
    component hasher = Poseidon(2);
    hasher.inputs[0] <== couponCode;
    hasher.inputs[1] <== couponId;

    hasher.out === nullifier;
}

component main { public [ nullifier, couponId ] } = ZKoupon();