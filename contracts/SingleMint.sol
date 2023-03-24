pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CustomMint is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private apiUrl = "https://api.pinata.cloud/pinning/pinFileToIPFS";

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    function mintNFT(string memory tokenURI, string memory apiKey, string memory secretApiKey) external returns (uint256) {
        string memory contentHash = uploadToPinata(tokenURI, apiKey, secretApiKey);
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, contentHash);
        return newTokenId;
    }

    function uploadToPinata(string memory tokenURI, string memory apiKey, string memory secretApiKey) private returns (string memory) {
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
            'pinata_api_key: ', apiKey, "\r\n",
            'pinata_secret_api_key: ', secretApiKey, "\r\n",
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
