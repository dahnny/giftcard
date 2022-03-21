// SPDX-License-Identifier: MIT  

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract GiftCard{

    struct Card{
        address payable owner;
        string number;
        string description;
        string image;
        uint amount;
    }
    address internal admin;
    constructor (){
        admin = 0xE2a0411465fd913502A8390Fe22DC7004AC47A04;
    }

    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    mapping(uint => Card) cards;
    uint cardLength = 0;

    function createCard(
        string memory _number,
        string memory _description,
        string memory _image,
        uint _amount
    )public payable{
         require(
                IERC20Token(cUsdTokenAddress).transferFrom(
                    msg.sender,
                    admin,
                    _amount
            ),
            "Transaction could not be performed"
        );
        cards[cardLength] = Card(
            payable(msg.sender),
            _number,
            _description,
            _image,
            _amount
        );
        cardLength++;
    }

    function buyCard(uint _index)public payable{
        require(
                IERC20Token(cUsdTokenAddress).transferFrom(
                    msg.sender,
                    cards[_index].owner,
                    cards[_index].amount * 3
            ),
            "Transaction could not be performed"
        );
        cards[_index].owner = payable(msg.sender);
    }

    function giftCard(uint _index, address _address)public payable{
        cards[_index].owner = payable(_address);
    }

     function getCard(uint _index) public view returns(
        address payable,
        string memory,
        string memory,
        string memory,
        uint
    ){
        Card storage card = cards[_index];
        return(
            card.owner,
            card.number,
            card.description,
            card.image,
            card.amount
        );
    }

     function getCardLength () public view returns (uint){
        return (cardLength);
    }

}