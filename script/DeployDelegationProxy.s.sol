// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IVaultRegistry, VaultMetadata} from "popcorn/src/interfaces/vault/IVaultRegistry.sol";

import {Minter} from "../src/Minter.sol";
import {TokenAdmin} from "../src/TokenAdmin.sol";
import {CREATE3Script} from "./base/CREATE3Script.sol";
import {VyperDeployer} from "../src/lib/VyperDeployer.sol";
import {SmartWalletChecker} from "../src/SmartWalletChecker.sol";
import {IVotingEscrow} from "../src/interfaces/IVotingEscrow.sol";
import {IERC20Mintable} from "../src/interfaces/IERC20Mintable.sol";
import {ILiquidityGauge} from "../src/interfaces/ILiquidityGauge.sol";
import {IGaugeController} from "../src/interfaces/IGaugeController.sol";
import {PopcornLiquidityGaugeFactory} from "../src/PopcornLiquidityGaugeFactory.sol";

contract DeployScript is CREATE3Script, VyperDeployer {
    constructor() CREATE3Script(vm.envString("VERSION")) {}

    function run()
        public
        returns (
            address delegationProxy
    )
    {
        address admin = vm.envAddress("ADMIN");
        vm.startBroadcast(admin);

        address boostV2 = getCreate3Contract("BoostV2");
        delegationProxy = create3.deploy(
            getCreate3ContractSalt("DelegationProxy"),
            bytes.concat(
                compileContract("DelegationProxy"),
                abi.encode(boostV2, admin, admin)
            )
        );

        vm.stopBroadcast();
    }
}
