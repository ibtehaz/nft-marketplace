// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    
    mapping(uint256 => address) public _tokenOwner;
    mapping(address => uint256) public _ownedTokenCount;
    
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner!=address(0); 
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to!= address(0), 'ERC721 minting to the 0 address');
        require(!_exists(tokenId), 'ERC721 minting token already minted');
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[to]++;
        emit Transfer(address(0), to, tokenId);
        
    }

}