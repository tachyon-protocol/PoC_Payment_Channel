//contract, provider, dataBytes
web3.eth.sign(web3.utils.soliditySha3(
    ["address", "address", "uint256"],
    ["0x8c1eD7e19abAa9f23c476dA86Dc1577F1Ef401f5", "0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C", 10]), "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c", function (error, result){console.log(error, result)});

web3.eth.sign("0x13caa24937d2475bb7d260e6ac11edd9b21faf73b0e1e77252eb41f9fcb89382", "0x727fc9e7355eabecf9473c637457f97cd65eb00e", function (error, result){console.log(error, result)});
