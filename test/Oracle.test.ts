import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { PriceOracle } from "../typechain-types";
import hre from "hardhat";
import { parseUnits } from "ethers";
import { expect } from "chai";
describe("Oracle", () => {
    let oracle: PriceOracle;
    let deployer: HardhatEthersSigner;
    let alice: HardhatEthersSigner;
    const { deployments, getNamedAccounts } = hre;
    const { deploy, getOrNull, read, execute } = deployments;
    const eth = "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE";
    before(async () => {
        await deployments.fixture();
        [deployer, alice] = await hre.ethers.getSigners();
    });
    it("Submit success with deployer", async () => {
        await execute(
            "PriceOracle",
            {
                from: deployer.address,
                log: true,
            },
            "setPrice",
            [eth],
            [parseUnits("1000", 6)]
        );
        const price_eth = (await read("PriceOracle", "getPrice", eth))[0];
        expect(price_eth.toString()).to.equal(parseUnits("1000", 6));
    });
});
