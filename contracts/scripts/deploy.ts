// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  /*
  const EventsFactory = await ethers.getContractFactory("EventsFactory");
  const eventsFactory = await EventsFactory.deploy();
  await eventsFactory.deployed();
  console.log("EventsFactory deployed to:", eventsFactory.address);
  */
  /*
   const ZkApp = await ethers.getContractFactory("ZkApp");/
   const IdcheckVerifier = await ethers.getContractFactory("IdcheckVerifier");
   const idcheckVerifier = await IdcheckVerifier.deploy();
   await idcheckVerifier.deployed();
   console.log("IdcheckVerifier deployed to:", idcheckVerifier.address);
   const ZauktionVerifier = await ethers.getContractFactory("ZauktionVerifier");
   const zauktionVerifier = await ZauktionVerifier.deploy();
   await zauktionVerifier.deployed();
   const PepeCoin = await ethers.getContractFactory("PepeCoin");
   const pepeCoin = await PepeCoin.deploy(ethers.utils.parseEther('100000000'));
   await pepeCoin.deployed();
   console.log("PepeCoin deployed to:", pepeCoin.address);
   const Vault = await ethers.getContractFactory("Vault");
   const vault = await Vault.deploy();
   await vault.deployed();
   console.log("Vault deployed to:", vault.address);
   const lock = await pepeCoin.transfer(vault.address, ethers.utils.parseEther('100000000'));
  console.log("ZauktionVerifier deployed to:", zauktionVerifier.address);
  */
  const Zauktion = await ethers.getContractFactory("Zauktion");
  const zauktion = await Zauktion.deploy();
  await zauktion.deployed();
  console.log("Zauktion deployed to:", zauktion.address);
  //const setAuction = await zauktion.setAuction(1, ethers.utils.parseEther('0.0000001'), 1682191709, 1682191809, zauktionVerifier.address, idcheckVerifier.address, vault.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
