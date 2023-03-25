import { abi } from "../abis/Collections.json";
import { useWeb3React } from "@web3-react/core";
import { ethers } from "ethers";
import { getWeb3 } from "./utils.js";

const collectionsAddress = process.env.COLLECTIONS_ADDRESS;

export async function getNFTs(account) {
  if (!account) {
    return [];
  }

  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const contract = new ethers.Contract(collectionsAddress, abi, provider);

  const filter = contract.filters.CollectionCreated(account);
  const events = await contract.queryFilter(filter);

  const collections = await Promise.all(
    events.map(async (event) => {
      const collectionId = event.args[0];
      const collection = await contract.collections(collectionId);
      return {
        id: collectionId.toNumber(),
        name: collection.name,
        description: collection.description,
        owner: collection.owner,
      };
    })
  );

  return collections;
}

export async function createCollection(name, description) {
  const { account } = useWeb3React();
  if (!account) {
    throw new Error("Please connect your wallet.");
  }

  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  const contract = new ethers.Contract(collectionsAddress, abi, signer);

  const transaction = await contract.createCollection(name, description);
  const receipt = await transaction.wait();
  const collectionId = receipt.events[0].args[0].toNumber();

  return collectionId;
}
