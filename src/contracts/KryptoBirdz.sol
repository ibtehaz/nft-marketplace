// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import './ERC721Connector.sol';

contract Kryptobird is ERC721Connector{
    string[] public KryptoBirdz;
    mapping(string => bool) _kryptoBirdzExists;
    function mint(string memory _kryptoBird) public {
        
        require(!_kryptoBirdzExists[_kryptoBird], 'Error - kryptobird already exists');
        KryptoBirdz.push(_kryptoBird);
        uint _id = uint(KryptoBirdz.length) - 1;
        _mint(msg.sender, _id);
        _kryptoBirdzExists[_kryptoBird] = true;

    }
 

    constructor() ERC721Connector("Kryptobird", "KBIRDZ") {
       
    }
}