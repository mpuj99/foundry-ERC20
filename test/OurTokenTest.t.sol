// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";
import {OurToken} from "src/OurToken.sol";


contract OurTokenTest is Test {
    // We Initialize the variables of type OurToken and DeployOurToken to store the data returned (in the case of OurToken) and, manage and execute the funcions more easily for the deployer (run())
    OurToken public ourToken;
    DeployOurToken public deployer;

    // Make some users to play and transfer with
    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        // This is the owner of the contract that have all the supply
        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }


    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    // This test aproves alice to take some tokens from Bob account
    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }


     function testTransferTokens() public {
        uint256 transferAmount = 50 ether;

        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }

    function testTotalSupply() public view {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testMintTokens() public {
        uint256 mintAmount = 100 ether;
        
        // Assuming only owner can mint, using msg.sender as owner here
        vm.prank(address(msg.sender));
        uint256 balanceSenderBeforeMint = ourToken.balanceOf(address(msg.sender));
        ourToken.mint(address(msg.sender), mintAmount);

        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY() + mintAmount);
        assertEq(ourToken.balanceOf(address(msg.sender)), mintAmount + balanceSenderBeforeMint);
    }

    function testBurnTokens() public {
        uint256 burnAmount = 10 ether;

        // Assuming only owner can burn, using msg.sender as owner here
        vm.prank(address(msg.sender));
        uint256 balanceSenderBeforeBurning = ourToken.balanceOf(address(msg.sender));
        ourToken.burn(address(msg.sender), burnAmount);

        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY() - burnAmount);
        assertEq(ourToken.balanceOf(address(msg.sender)), balanceSenderBeforeBurning - burnAmount);
    }
    


    // TESTS CONTRUCTOR OurToken.sol

    function testInitialSupply() public view {
        // Check that the initial supply was correctly minted to the deployer
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
        assertEq(ourToken.balanceOf(address(msg.sender)) + ourToken.balanceOf(bob), deployer.INITIAL_SUPPLY());
    }

    function testTokenName() public view {
        // Check that the token name is set correctly
        assertEq(ourToken.name(), "OurToken");
    }

    function testTokenSymbol() public view {
        // Check that the token symbol is set correctly
        assertEq(ourToken.symbol(), "OT");
    }


    // This function it has the same utility as testInitialSupply() function, but here I deployed a new token contract before. Because the other function didn't appear at the coverage.
    function testConstructor() public {
         // If I put the vm.prank will only take the first call (deployer.INITIAL_SUPPLY) then it will ignore the second call to create the OurToken.
         // If I put startPrank() it will take all the calls till I put stopPrank()
        vm.startPrank(bob);
        OurToken _ourToken = new OurToken(deployer.INITIAL_SUPPLY());
        vm.stopPrank();

        assertEq(_ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
        assertEq(_ourToken.balanceOf(bob), deployer.INITIAL_SUPPLY());

    }





}