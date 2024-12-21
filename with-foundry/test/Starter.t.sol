pragma solidity ^0.8.17;

import "../contract/Starter.sol";
import "../circuits/target/contract.sol";
import "forge-std/console.sol";

import "forge-std/Test.sol";
import {NoirHelper} from "foundry-noir-helper/NoirHelper.sol";


contract StarterTest is Test {
    Starter public starter;
    UltraVerifier public verifier;
    NoirHelper public noirHelper;

    bytes32[] public dynamicCorrect = new bytes32[](2);
    bytes32[] public correct = new bytes32[](2);
    bytes32[] public wrong = new bytes32[](2);

    function setUp() public {
        noirHelper = new NoirHelper();
        verifier = new UltraVerifier();
        starter = new Starter(verifier);

        correct[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000003);
        correct[1] = correct[0];
        wrong[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000004);
        // wrong[1] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000004);
    }

    function testVerifyProof() public {
        noirHelper.withInput("x", 3).withInput("y", 3);
        (,bytes memory proof) = noirHelper.generateProof(2);
        starter.verifyEqual(proof, correct);
    }

    function test_wrongProof() public {
        noirHelper.withInput("x", 4).withInput("y", 4);
        (,bytes memory proof) = noirHelper.generateProof(2);
        vm.expectRevert();
        starter.verifyEqual(proof, wrong);
    }

    function test_dynamicProof() public {
        // Set expected dynamic proof outcome
        dynamicCorrect[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000001);
        dynamicCorrect[1] = dynamicCorrect[0];

        noirHelper.withInput("x", 1).withInput("y", 1);

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof(2);

        starter.verifyEqual(proof, publicInputs);

        assert(dynamicCorrect[0] == publicInputs[0]);
        assert(dynamicCorrect[1] == publicInputs[1]);
    }

    function test_dynamicProofSecondTest() public {
        // Set expected dynamic proof outcome
        dynamicCorrect[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000008);
        dynamicCorrect[1] = dynamicCorrect[0];

        noirHelper.withInput("x", 8).withInput("y", 8);

        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof(2);

        starter.verifyEqual(proof, publicInputs);

        assert(dynamicCorrect[0] == publicInputs[0]);
        assert(dynamicCorrect[1] == publicInputs[1]);
    }

    function test_dynamicProofThirdTest() public {
        // Set expected dynamic proof outcome
        dynamicCorrect[0] = bytes32(0x0000000000000000000000000000000000000000000000000000000000000007);
        dynamicCorrect[1] = dynamicCorrect[0];
        
        noirHelper.withInput("x", 7).withInput("y", 7);
        
        (bytes32[] memory publicInputs, bytes memory proof) = noirHelper.generateProof(2);

        starter.verifyEqual(proof, publicInputs);

        assert(dynamicCorrect[0] == publicInputs[0]);
        assert(dynamicCorrect[1] == publicInputs[1]);
    }
   
}
