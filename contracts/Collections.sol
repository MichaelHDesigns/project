pragma solidity ^0.8.0;

import "./CreateNFT.sol";

contract Collections {
    CreateNFT private nft;
    string private pinataApiKey;
    string private pinataSecretApiKey;
    string private apiUrl = "https://api.pinata.cloud/pinning/pinFileToIPFS";

    constructor(address nftAddress, string memory _pinataApiKey, string memory _pinataSecretApiKey) {
        nft = CreateNFT(nftAddress);
        pinataApiKey = _pinataApiKey;
        pinataSecretApiKey = _pinataSecretApiKey;
    }

    function createCollection(string memory collectionName, string memory collectionDescription, string memory collectionImage) external returns (uint256) {
        string memory tokenURI = _createTokenURI(collectionName, collectionDescription, collectionImage);
        uint256 newTokenId = nft.createNFT(tokenURI, msg.sender);
        return newTokenId;
    }

    function _createTokenURI(string memory collectionName, string memory collectionDescription, string memory collectionImage) private returns (string memory) {
        string[4] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 350 350"><rect width="100%" height="100%" fill="#FFF"/> <text x="10" y="20" font-size="20" font-weight="bold" font-family="sans-serif">Collection Name: ';
        parts[1] = collectionName;
        parts[2] = '</text><text x="10" y="50" font-size="20" font-weight="bold" font-family="sans-serif">Description: ';
        parts[3] = collectionDescription;
        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3]));
        if (bytes(collectionImage).length > 0) {
            string memory imageURI = _uploadToPinata(collectionImage);
            output = string(abi.encodePacked(output, '<image x="10" y="80" width="300" height="200" href="', imageURI, '"/></svg>'));
        } else {
            output = string(abi.encodePacked(output, '</svg>'));
        }
        return output;
    }

    function _uploadToPinata(string memory collectionImage) private returns (string memory) {
        bytes memory imageBytes = bytes(collectionImage);
        string memory fileName = string(abi.encodePacked("collectionImage_", block.timestamp, ".png"));
        (uint256 statusCode, bytes memory result) = _pinFileToIPFS(imageBytes, fileName);
        require(statusCode == 200, "Error uploading image to Pinata");
        string memory ipfsHash = _extractIpfsHash(result);
        string memory imageURI = string(abi.encodePacked("https://gateway.pinata.cloud/ipfs/", ipfsHash));
        return imageURI;
    }

    function _pinFileToIPFS(bytes memory file, string memory fileName) private returns (uint256, bytes memory) {
        string memory boundary = "----UploadBoundary----";
        string memory contentType = "multipart/form-data; boundary=";

        bytes memory requestBody = abi.encodePacked(
            "--", boundary, "\r\n",
            'Content-Disposition: form-data; name="file"; filename="', fileName, '"\"\r\n",
            "Content-Type: application/octet-stream\r\n\r\n", file, "\r\n--", boundary, "--\r\n");

    (bool success, bytes memory data) = address(nft).staticcall(
        abi.encodeWithSignature(
            "post(string,string,bytes,string)",
            apiUrl,
            contentType,
            requestBody,
            pinataApiKey
        )
    );

    require(success, "Failed to post file to Pinata");
    return abi.decode(data, (uint256, bytes));
}

function _extractIpfsHash(bytes memory data) private pure returns (string memory) {
    string memory result;
    uint256 pointer = 0;
    while (pointer < data.length) {
        if (data[pointer] == 0x22 && data[pointer + 1] == 0x49 && data[pointer + 2] == 0x70 && data[pointer + 3] == 0x66 && data[pointer + 4] == 0x73 && data[pointer + 5] == 0x48 && data[pointer + 6] == 0x61 && data[pointer + 7] == 0x73 && data[pointer + 8] == 0x68 && data[pointer + 9] == 0x22 && data[pointer + 10] == 0x3A && data[pointer + 11] == 0x22) {
            pointer += 12;
            while (data[pointer] != 0x22) {
                result = string(abi.encodePacked(result, string(bytes1(data[pointer]))));
                pointer++;
            }
            break;
        }
        pointer++;
    }
    return result;
}
}
