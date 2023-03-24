pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CreateNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(string => bool) _hashExists;

    constructor() ERC721("NFT", "NFT") {}

    function mintNFT(address recipient, string memory tokenURI) public {
        require(!_hashExists[tokenURI], "Token URI already exists");
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        _hashExists[tokenURI] = true;
    }

    function bulkMintNFT(address recipient, string[] memory tokenURIs) public {
        for (uint256 i = 0; i < tokenURIs.length; i++) {
            require(!_hashExists[tokenURIs[i]], "Token URI already exists");
            _tokenIds.increment();
            uint256 newItemId = _tokenIds.current();
            _safeMint(recipient, newItemId);
            _setTokenURI(newItemId, tokenURIs[i]);
            _hashExists[tokenURIs[i]] = true;
        }
    }

    function mintNFTCollection(address recipient, string[] memory tokenURIs) public {
        require(tokenURIs.length > 1, "Token URI list is too short");
        string memory metadata = generateMetadata(tokenURIs);
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, metadata);
    }
function generateMetadata(string[] memory tokenURIs) public pure returns (string memory) {
    string memory metadata = "";
    metadata = string(abi.encodePacked('{"name": "NFT Collection", "description": "A collection of NFTs", "image": "', tokenURIs[0], '", "attributes": ['));
    for (uint256 i = 0; i < tokenURIs.length; i++) {
        metadata = string(abi.encodePacked(metadata, '{"trait_type": "Token URI", "value": "', tokenURIs[i], '"}'));
        if (i < tokenURIs.length - 1) {
            metadata = string(abi.encodePacked(metadata, ','));
        }
    }
    metadata = string(abi.encodePacked(metadata, ']}'));
    return metadata;
}


function uploadMetadataToPinata(string memory metadata, string memory pinataApiKey, string memory pinataSecretApiKey) public {
    string memory apiUrl = "https://api.pinata.cloud/pinning/pinJSONToIPFS";

    bytes memory jsonMetadataBytes = bytes(metadata);
    string memory jsonEncodedMetadata = Base64.encode(jsonMetadataBytes);
    bytes memory jsonEncodedMetadataBytes = bytes(jsonEncodedMetadata);

    string memory boundary = "-----nft-storage-boundary-----";
    bytes memory requestBody = abi.encodePacked(
        "--", boundary, "\r\n",
        'Content-Disposition: form-data; name="file"; filename="metadata.json"\r\n',
        "Content-Type: application/json\r\n\r\n",
        jsonEncodedMetadataBytes, "\r\n",
        "--", boundary, "--\r\n"
    );

    bytes32 contentHash = keccak256(requestBody);
    string memory contentHashString = Base58.encode(contentHash);

    bytes memory headers = abi.encodePacked(
        'Content-Type: multipart/form-data; boundary=', boundary, "\r\n",
        'pinata_api_key: ', pinataApiKey, "\r\n",
        'pinata_secret_api_key: ', pinataSecretApiKey, "\r\n",
        'Content-Length: ', uint2str(requestBody.length), "\r\n"
    );

    (bool success, bytes memory returnData) = address(0x0000000000000000000000000000000000000001).call{gas: 3000000, value: msg.value}(
        abi.encodeWithSignature("post(string,bytes,string)", apiUrl, requestBody, headers)
    );

    require(success, "Pinata API call failed");
    emit PinataMetadataUploaded(contentHashString);
}

function uint2str(uint256 _i) internal pure returns (string memory) {
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
