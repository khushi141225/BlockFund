const hre = require("hardhat");

async function main() {
  const BlockFund = await hre.ethers.getContractFactory("BlockFund");

  const contract = await BlockFund.deploy();
  await contract.deployed();

  console.log("BlockFund deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
