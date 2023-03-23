import React, { useState } from 'react';

function PinataUpload({ onApiChange, onSecretChange, onMetadataChange }) {
  const [selectedFile, setSelectedFile] = useState(null);

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleApiChange = (event) => {
    onApiChange(event.target.value);
  };

  const handleSecretChange = (event) => {
    onSecretChange(event.target.value);
  };

  const handleMetadataChange = (event) => {
    onMetadataChange(event.target.value);
  };

  const handleUpload = async () => {
    const formData = new FormData();
    formData.append("file", selectedFile);

    const response = await fetch("https://api.pinata.cloud/pinning/pinFileToIPFS", {
      method: "POST",
      body: formData,
      headers: {
        pinata_api_key: process.env.REACT_APP_PINATA_API_KEY,
        pinata_secret_api_key: process.env.REACT_APP_PINATA_SECRET_API_KEY,
      },
    });

    const { IpfsHash } = await response.json();
    onMetadataChange(`{"ipfsHash": "${IpfsHash}"}`);
  };

  return (
    <div>
      <input type="file" onChange={handleFileChange} />
      <br />
      <label>Pinata API Key:</label>
      <input type="text" onChange={handleApiChange} />
      <br />
      <label>Pinata Secret API Key:</label>
      <input type="text" onChange={handleSecretChange} />
      <br />
      <button onClick={handleUpload}>Upload to Pinata</button>
    </div>
  );
}

export default PinataUpload;
