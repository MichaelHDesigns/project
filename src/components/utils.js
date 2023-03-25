import Web3 from "web3";
import SingleMintContract from "../../abis/SingleMint.json";

const getWeb3 = async () => {
  if (window.ethereum) {
    const web3 = new Web3(window.ethereum);
    try {
      await window.ethereum.enable();
      return web3;
    } catch (error) {
      console.log(error);
    }
  } else if (window.web3) {
    return window.web3;
  } else {
    console.log("Non-Ethereum browser detected. You should consider trying MetaMask!");
  }
};

const getSingleMintContract = async (web3) => {
  const networkId = await web3.eth.net.getId();
  const deployedNetwork = SingleMintContract.networks[networkId];
  return new web3.eth.Contract(
    SingleMintContract.abi,
    deployedNetwork && deployedNetwork.address
  );
};

export { getWeb3, getSingleMintContract };
