import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { includes } from "lodash";
import { CHAIN_ID } from "../../utils/network";
import { getChainId } from "hardhat";

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy, getOrNull, read, execute } = deployments;
    const { deployer } = await getNamedAccounts();
    if (includes([CHAIN_ID.OASIS_MAINNET], await getChainId())) {
        if ((await getOrNull("PriceOracle")) == null) {
            await deploy("PriceOracle", {
                from: deployer,
                args: [],
                log: true,
                autoMine: true,
                skipIfAlreadyDeployed: true,
                proxy: {
                    owner: deployer,
                },
            });

            await execute("PriceOracle", { from: deployer, log: true }, "initialize");
            const ORACLE_ROLE = await read("PriceOracle", "ORACLE_ROLE");
            await execute("PriceOracle", { from: deployer, log: true }, "grantRole", ORACLE_ROLE, deployer);
        } else {
            await deploy("PriceOracle", {
                from: deployer,
                args: [],
                log: true,
                autoMine: true,
                proxy: {
                    owner: deployer,
                },
            });
        }
    }
};

deploy.tags = ["oracle"];
export default deploy;
