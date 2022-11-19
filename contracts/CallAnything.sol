// SPDX-License-Identifier: MIT

// In order to call a function using only the data fiel of call, we need to encode: 
// The function name => The "function selector": the first 4 bytes of the function signature
                  // => The "function signature": a string that defines the function name & parameters 
// The parameters we want to add 
// Down to the binary level 

pragma solidity ^0.8.7; 

contract CallAnything {
    address public s_someAddress;
    uint256 public s_amount;

    function transfer(address someAddress, uint256 amount) public {
        s_someAddress = someAddress;
        s_amount = amount; 
    }

    function getSelectorOne() public pure returns(bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address, uint256)")));
    }

    function getDataToCallTransfer(address someAddress, uint256 amount) public pure returns(bytes memory) {
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
        // returns the binary encoded data that say => "call the transfer function with the address specified and the amount"
    }

    function callTransferFunctionDirectly(address someAddress, uint256 amount) public returns(bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            // getDataToCallTransfer(someAddress, amount);
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
        );
        return(bytes4(returnData), success); // returns false, fix it later 
    }
 // before we encoded the selector ourselves 
    function callTransferFunctionDirectlySig(address someAddress, uint256 amount) public returns(bytes4, bool) {
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSignature("transfer(address, uint256)", someAddress, amount)
        );
        return(bytes4(returnData), success);
    }

}