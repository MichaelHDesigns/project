import React, { useState, useEffect } from 'react';
import Web3 from 'web3';
import Collections from './contracts/Collections.json';
import './Gallery.css';

const Gallery = () => {
  const [collections, setCollections] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadCollections = async () => {
      const web3 = new Web3(Web3.givenProvider || 'http://localhost:8545');
      const networkId = await web3.eth.net.getId();
      const contractAddress = Collections.networks[networkId].address;
      const contractInstance = new web3.eth.Contract(Collections.abi, contractAddress);
      
      const userAccounts = await web3.eth.getAccounts();
      const collectionIds = await contractInstance.methods.getCollectionIds(userAccounts[0]).call();
      
      const collectionData = await Promise.all(collectionIds.map(async (id) => {
        const collection = await contractInstance.methods.getCollection(id).call();
        return {
          id: collection.id,
          name: collection.name,
          description: collection.description,
          nfts: collection.nfts.map((nft) => {
            return {
              id: nft.id,
              name: nft.name,
              description: nft.description,
              image: nft.image,
            };
          }),
        };
      }));

      setCollections(collectionData);
      setLoading(false);
    };

    loadCollections();
  }, []);

  return (
    <div>
      {loading ? (
        <p>Loading...</p>
      ) : (
        <div>
          {collections.map((collection) => (
            <div key={collection.id}>
              <h3>{collection.name}</h3>
              <p>{collection.description}</p>
              <div>
                {collection.nfts.map((nft) => (
                  <img key={nft.id} src={`https://ipfs.infura.io/ipfs/${nft.image}`} alt={nft.name} />
                ))}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default Gallery;
