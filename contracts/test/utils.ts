import { utils } from "ffjavascript";

const p256 = (n: any) => {
  let nstr = n.toString(16);
  while (nstr.length < 64) nstr = "0" + nstr;
  nstr = `0x${nstr}`;
  return nstr;
};

const proofToSCFormat = (_proof: object, _pub: object) => {
  const proof = utils.unstringifyBigInts(_proof);
  const pub = utils.unstringifyBigInts(_pub);
  let inputs = [];
  for (let i = 0; i < pub.length; i++) {
    inputs.push(p256(pub[i]));
  }
  return {
    a: [p256(proof.pi_a[0]), p256(proof.pi_a[1])],
    b: [
      [p256(proof.pi_b[0][1]), p256(proof.pi_b[0][0])],
      [p256(proof.pi_b[1][1]), p256(proof.pi_b[1][0])],
    ],
    c: [p256(proof.pi_c[0]), p256(proof.pi_c[1])],
    pub: inputs,
  };
};

export { proofToSCFormat };
