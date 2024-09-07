import hre, { network } from "hardhat";
import { getContract } from "../utils";
import { PriceOracle__factory } from "../../typechain-types";
import { BaseContract, Contract } from "ethers";
export async function main() {
    const deployer = await hre.ethers.provider.getSigner(0);

    const deployment = await getContract("PriceOracle");
    const priceOracle = PriceOracle__factory.connect(await deployment.getAddress(), deployer);
    //@ts-ignore
    const admin = await priceOracle.admin();
    console.log(`PriceOracle owner: ${admin}`);
}

main();
