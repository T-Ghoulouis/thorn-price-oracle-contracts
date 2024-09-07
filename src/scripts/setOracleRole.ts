import hre, { network } from "hardhat";
import { getContract } from "../utils";
import { PriceOracle__factory } from "../../typechain-types";
import { BaseContract, Contract } from "ethers";
export async function main() {
    const deployer = await hre.ethers.provider.getSigner(0);

    const deployment = await getContract("PriceOracle");
    const priceOracle = PriceOracle__factory.connect(await deployment.getAddress(), deployer);
    //@ts-ignore
    const ORACLE_ROLE = await priceOracle.ORACLE_ROLE();
    console.log(`ORACLE_ROLE : ${ORACLE_ROLE}`);
    console.log(`deployer : ${deployer.address}`);
    const DEFAULT_ADMIN_ROLE = await priceOracle.DEFAULT_ADMIN_ROLE();
    const isAdmin = await priceOracle.hasRole(DEFAULT_ADMIN_ROLE, deployer.address);
    console.log(`isAdmin : ${isAdmin}`);
    // let txResponse, txReceipt;
    // txResponse = await priceOracle.grantRole(ORACLE_ROLE, deployer.address);

    // txReceipt = await txResponse.wait();
}

main();
