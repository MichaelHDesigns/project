// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CreateNFT.sol";

contract BulkMint {
    CreateNFT private nftContract;
    string private pinataApiKey;
    string private pinataSecretApiKey;
    string private apiUrl = "https://api.pinata.cloud/pinning/pinFileToIPFS";

    address private admin;

    event BulkMinted(uint256[] tokenIds);

    constructor(address _nftAddress, string memory _apiKey, string memory _secretApiKey) {
        nftContract = CreateNFT(_nftAddress);
        pinataApiKey = _apiKey;
        pinataSecretApiKey = _secretApiKey;
        admin = msg.sender;
    }

    function bulkMint(
        string[] memory _tokenURIs,
        address _recipient
    ) external {
        require(msg.sender == admin, "Only admin can call this function");

        uint256 length = _tokenURIs.length;
        uint256[] memory tokenIds = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            string memory tokenURI = _tokenURIs[i];
            string memory contentHash = uploadToPinata(tokenURI);
            uint256 tokenId = nftContract.createNFT(contentHash, _recipient);
            tokenIds[i] = tokenId;
        }

        emit BulkMinted(tokenIds);
    }

    function uploadToPinata(string memory tokenURI) private returns (string memory) {
        string memory boundary = "----FormBoundary";
        string memory contentHash = generateContentHash(tokenURI);

        bytes memory requestBody = abi.encodePacked(
            "--", boundary, "\r\n",
            'Content-Disposition: form-data; name="file"; filename="', contentHash, '.json"\r\n',
            'Content-Type: application/json\r\n\r\n',
            tokenURI, "\r\n",
            "--", boundary, "--\r\n"
        );

        string memory headers = string(abi.encodePacked(
            'Content-Type: multipart/form-data; boundary=', boundary, "\r\n",
            'pinata_api_key: ', pinataApiKey, "\r\n",
            'pinata_secret_api_key: ', pinataSecretApiKey, "\r\n",
            'Content-Length: ', uint2str(requestBody.length), "\r\n"
        ));

        (bool success, bytes memory returnData) = address(0x0000000000000000000000000000000000000001).call{gas: 3000000, value: msg.value}(
            abi.encodeWithSignature("post(string,bytes,string)", apiUrl, requestBody, headers)
        );

        require(success, "Pinata API call failed");
        emit PinataMetadataUploaded(contentHash);

        return contentHash;
    }

    function generateContentHash(string memory tokenURI) private pure returns (string memory) {
        bytes32 contentHash = keccak256(bytes(tokenURI));
        return Base58.encode(bytes28(contentHash));
    }
    function uint2str(uint256 _i) private pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        while (_i != 0) {
            k = k-1;
            uint8 temp = uint8(48 + _i % 10);
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    event PinataMetadataUploaded(string contentHash);
}
