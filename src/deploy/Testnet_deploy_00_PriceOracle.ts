import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;
    const { deployer } = await getNamedAccounts();

    await deploy("PriceOracle", {
        from: deployer,
        args: [],
        log: true,
        autoMine: true,
        proxy: {
            owner: deployer,
            execute: {
                methodName: "init",
                args: [deployer],
            },
        },
    });
};

deploy.tags = ["sapphire-testnet", "sapphire-mainnet"];
export default deploy;
