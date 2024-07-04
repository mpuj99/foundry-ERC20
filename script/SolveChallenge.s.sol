// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This file is to solve challenge from the course foundry updraft, to execute, you need to take off the startBroadcast() and stopBroadcast() from DeployOurToken.s.sol//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



import {Script} from "forge-std/Script.sol";
import {OurToken} from "src/OurToken.sol";
import {ILessonTen} from "./ILessonTen.sol";
import {DeployOurToken} from "./DeployOurToken.s.sol";
import {console} from "forge-std/console.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface IERC20 {
    function mint() external;
    function approve(address spender, uint256 amount) external returns (bool);
}


contract SolveChallenge is Script {

    address public constant lesson10 = 0xE0aE410a16776BCcb04A8d4B0151Bb3F25035994;
    address public constant player = 0x7294984c04de6fe4E3cd0c0b170059f88B00fD59;
    uint256 public constant COST_TO_SOLVE = 1e18;
    address public constant tokenChallenge = 0xC5D0ab0E66fA10040D0f3A65c593612351bB4957;



    function run() external {
        vm.startBroadcast();
        
        IERC20(tokenChallenge).mint();
        IERC20(tokenChallenge).approve(lesson10, COST_TO_SOLVE);

        ILessonTen ilesson10 = ILessonTen(lesson10);
        ilesson10.solveChallenge("me");
        vm.stopBroadcast();

    }

}
