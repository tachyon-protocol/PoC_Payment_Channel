pragma solidity >=0.4.24 <0.7.0;

contract ReceiverPays {
    address owner = msg.sender;

    constructor() public payable {}

    function claimPayment(uint256 amount, bytes memory signature) public {
        bytes32 message = keccak256(abi.encodePacked(amount));
        require(recoverSigner(message, signature) == owner);
    }

    /// signature methods.
    function splitSignature(bytes memory sig)
    internal
    pure
    returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65);

        assembly {
        // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
        // second 32 bytes.
            s := mload(add(sig, 64))
        // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
    internal
    pure
    returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    function debugHash (uint256 i) public view returns(bytes32) {
        return keccak256(abi.encodePacked(i));
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
//    function prefixed(bytes32 hash) internal pure returns (bytes32) {
//        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
//    }
}
