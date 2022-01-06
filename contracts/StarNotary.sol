// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

//Importing openzeppelin-solidity ERC-721 implemented Standard
import "../app/node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

// StarNotary Contract declaration inheritance the ERC721 openzeppelin implementation
contract StarNotary is ERC721 {
  constructor() ERC721("Star Notary Token", "STAR") {}

    // Star data
    struct Star {
        string name;
    }

    // Implement Task 1 Add a name and symbol properties
    // name: Is a short name to your token
    // symbol: Is a short string like 'USD' -> 'American Dollar'
    

    // mapping the Star with the Owner Address
    mapping(uint256 => Star) public tokenIdToStarInfo;
    // mapping the TokenId and price
    mapping(uint256 => uint256) public starsForSale;

    
    // Create Star using the Struct
    function createStar(string memory _name, uint256 _tokenId) public { // Passing the name and tokenId as a parameters
        Star memory newStar = Star(_name); // Star is an struct so we are creating a new Star
        tokenIdToStarInfo[_tokenId] = newStar; // Creating in memory the Star -> tokenId mapping
        _mint(msg.sender, _tokenId); // _mint assign the the star with _tokenId to the sender address (ownership)
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't own");
        starsForSale[_tokenId] = _price;
    }


    function buyStar(uint256 _tokenId) public  payable {
      uint256 starCost = starsForSale[_tokenId];
        require(starCost > 0, "The Star should be up for sale");
        require(msg.value > starCost, "You need to have enough Ether");
        address ownerAddress = ownerOf(_tokenId);
        transferFrom(ownerAddress, msg.sender, _tokenId); // We can't use _addTokenTo or_removeTokenFrom functions, now we have to use _transferFrom
        payable(ownerAddress).transfer(starCost);
        if(msg.value > starCost) {
            payable(msg.sender).transfer(msg.value - starCost);
        }
    }

    // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
      address owner1 = ownerOf(_tokenId1);
      address owner2 = ownerOf(_tokenId2);
      require(owner1 == msg.sender || owner2 == msg.sender, "only token owner can initiate");
      transferFrom(owner1, owner2, _tokenId1);
      transferFrom(owner2, owner1, _tokenId2);
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
      address owner = ownerOf(_tokenId);
      require(owner == msg.sender, "only owner can transfer star");
      transferFrom(owner, _to1, _tokenId);
    }

}