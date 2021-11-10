// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './interfaces/IERC721.sol';
import './ERC165.sol';
import './libraries/Counters.sol';

contract ERC721 is ERC165, IERC721 {
   using SafeMath for uint256;
   using Counters for Counters.Counter;

    // token id to owner mapping
    mapping(uint256 => address) public _tokenOwner;
    // owner to number of owned tokens mapping
    mapping(address => Counters.Counter) public _ownedTokenCount;
    
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256("balanceOf(bytes4")^keccak256("ownerOf(bytes4)")^keccak256("transferFrom(bytes4)")));
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), 'Owner query for non-existent token');
        return _ownedTokenCount[_owner].current();
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'Owner query for non-existent token'); 
        return owner;
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');

        _ownedTokenCount[_from].decrement();
        _ownedTokenCount[_to].increment();

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);

    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner); 
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        
        address owner = _tokenOwner[tokenId];
        return owner!=address(0); 
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to!= address(0), 'ERC721 minting to the 0 address');
        require(!_exists(tokenId), 'ERC721 minting token already minted');
        _tokenOwner[tokenId] = to;
        _ownedTokenCount[to].increment();
        emit Transfer(address(0), to, tokenId);

    }

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner, 'ERC721 approve to owner');
        require(owner == msg.sender, 'Only the owner can approve tokens');
        _tokenApprovals[tokenId] = _to;
        emit Approval(owner, _to, tokenId);
    }

    

}