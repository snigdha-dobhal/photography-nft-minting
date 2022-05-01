
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Photography is ERC721, Ownable {
    using Strings for uint256;
    uint256 public totalQuantity;
    uint256 public maxQuantity;
    bool public isMintEnabled;
    string private baseURI;
    mapping(address => uint) public whiteList;
    mapping(uint256 => string) private tokenURIs;

    constructor() ERC721("photography", "PICS"){
        maxQuantity = 3000;
    }

    function toggleIsMintEnabled() external onlyOwner{
        isMintEnabled = !isMintEnabled;
    }

    function getIsMintEnabled() external returns(bool){
        return isMintEnabled;
    }

    function setMaxQuantity(uint256 _maxQuantity) external onlyOwner{
        maxQuantity = _maxQuantity;
    }

    function getMaxQuantity() external view returns(uint256){
        return maxQuantity;
    }

    function getTotalQuantity() external view returns(uint256){
        return totalQuantity;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) 
        internal 
        virtual
    {
        require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
        tokenURIs[tokenId] = _tokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function approveUserToMint(address _address) external onlyOwner{
        whiteList[_address] = 1;
    }

    function disapproveUserToMint(address _address) external onlyOwner{
        whiteList[_address] = 0;
    }

    function mint(string memory tokenURI) external returns (uint256){
        require(whiteList[msg.sender] == 1, "Account not approved for minting");
        require(isMintEnabled, "Minting is not enabled");
        require(maxQuantity > totalQuantity, "NFT max limit already reached");

        totalQuantity++;
        uint256 tokenId = totalQuantity;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }
   
}