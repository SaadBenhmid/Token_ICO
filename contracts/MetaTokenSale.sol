pragma solidity ^0.8.0;

import "./MetaToken.sol";

contract MetaTokenSale{

    address admin;

    MetaToken public tokenContract;

    uint public tokenPrice;
    uint public tokensSold;

    event Sell(
        address _buyer,
        uint256 _amount
    );

    constructor(MetaToken _tokenContract, uint256 _tokenPrice){
        admin = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
    }

    function multiply(uint x, uint y) internal pure returns(uint z){
        require( y == 0 || ( z = x * y ) / y == x );
    }

    function buyTokens(uint256 _numberOfTokens) public payable {

        require(msg.value == multiply(_numberOfTokens, tokenPrice));

        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens);

        require(tokenContract.transfer(msg.sender, _numberOfTokens));
        
        tokensSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }

    //ending Token sale
    function endSale() public {
        require(msg.sender == admin);

        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));

        selfdestruct(admin);
    }
}