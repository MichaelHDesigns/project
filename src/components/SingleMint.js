import React, { useState } from "react";
import { useWeb3React } from "@web3-react/core";
import { getSingleMint } from "../../utils";
import "./SingleMint.css";

const SingleMint = () => {
  const { account } = useWeb3React();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [file, setFile] = useState(null);
  const [imageUrl, setImageUrl] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [isError, setIsError] = useState(false);

  const handleFileUpload = (event) => {
    setFile(event.target.files[0]);
    setImageUrl(URL.createObjectURL(event.target.files[0]));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();

    setIsLoading(true);

    const singleMintContract = await getSingleMint();
    const formData = new FormData();
    formData.append("file", file);
    formData.append("name", name);
    formData.append("description", description);

    try {
      await singleMintContract.methods.mint().send({
        from: account,
        gas: 500000,
        value: "10000000000000000", // 0.01 ETH
      });
      setIsLoading(false);
      setIsSuccess(true);
    } catch (error) {
      console.log(error);
      setIsLoading(false);
      setIsError(true);
    }
  };

  return (
    <div className="SingleMint">
      <h2>Mint a Single NFT</h2>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Name</label>
          <input
            type="text"
            className="form-control"
            id="name"
            value={name}
            onChange={(event) => setName(event.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="description">Description</label>
          <textarea
            className="form-control"
            id="description"
            value={description}
            onChange={(event) => setDescription(event.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="file">Image</label>
          <input
            type="file"
            className="form-control-file"
            id="file"
            onChange={handleFileUpload}
            required
          />
        </div>
        <img src={imageUrl} alt="" className="preview-image" />
        <button type="submit" className="btn btn-primary" disabled={isLoading}>
          {isLoading ? "Minting..." : "Mint"}
        </button>
      </form>
      {isSuccess && (
        <div className="alert alert-success mt-3" role="alert">
          NFT successfully minted!
        </div>
      )}
      {isError && (
        <div className="alert alert-danger mt-3" role="alert">
          Failed to mint NFT. Please try again.
        </div>
      )}
    </div>
  );
};

export default SingleMint;
