import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import {
    Verifier,
    Verifier__factory,
    Zauktion,
    Zauktion__factory,
} from "../typechain";

describe("Test zauction file", () => {
    let deployer: SignerWithAddress;
    let verifier: Verifier;
    let zauction: Zauktion;
    before(async () => {
        [deployer] = await ethers.getSigners();
        verifier = await new Verifier__factory(deployer).deploy();
        await verifier.deployTransaction.wait();
        zauction = await new Zauktion__factory(deployer).deploy();
        await zauction.deployTransaction.wait();
    })

    it("Owner should be able to setAuction", async () => {
        const bidDue = await time.increase(600);
        await zauction.connect(deployer.address).setAuction(
            10,
            1000,
            bidDue,
            bidDue + 600,
            verifier.address,
            ethers.constants.AddressZero
        )
    })
})
