// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract stockTrading {

struct Stock{
    uint256 price;
    uint256 quantity;
}

mapping(string => Stock) public stocks;
mapping(address => mapping(string => uint256)) public balances;

address public hedgeFund;

event stockBought(address buyer, string stockName, uint256 price, uint256 quantity);
event stocksold(address seller, string stockName, uint256 price, uint256 quantity);

constructor (){
    hedgeFund = msg.sender;
}
modifier onlyhedgeFund(){
    require( hedgeFund == msg.sender, "Only owner can call this fuction");
    _;
}
function buyStock(string memory stockName, uint256 quantity) public payable {
    Stock memory stock = stocks[stockName];  
    require(stock.price > 0, "Stock does not exist");
    require(msg.value >= stock.price * quantity , "Insufficient funds");   

balances[msg.sender] [stockName] += quantity; 
emit stockBought (msg.sender, stockName, stock.price, quantity);
}

function sellStock(string memory stockName, uint256 quantity) public {
    Stock memory stock = stocks[stockName];  
    require(stock.price > 0, "Stock does not exist");
    require(balances[msg.sender] [stockName] >= quantity, "Insufficient stock balance");

     balances[msg.sender] [stockName] -= quantity; 
     payable (msg.sender).transfer(stock.price * quantity);

emit stocksold (msg.sender, stockName, stock.price, quantity);
}
function addStock(string memory stockName, uint256 quantity, uint256 price) public onlyhedgeFund{
        Stock memory stock = stocks[stockName];  
        require(stock.price == 0, "Stock already Exists");
        stocks[stockName] = Stock(price,quantity);
}
  function updateStockPrice(string memory stockName, uint256 price) public onlyhedgeFund{
       Stock memory stock = stocks[stockName];
       require(stock.price > 0, "Stock does not exist.");

       stocks[stockName].price = price;
   }

   function withdrawFunds() public onlyhedgeFund {
       payable(hedgeFund).transfer(address(this).balance);
   }
}
