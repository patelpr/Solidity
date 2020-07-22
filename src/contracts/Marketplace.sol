pragma solidity ^0.5.0;

contract Marketplace {
    string public name;
    uint256 public productCount = 0;
    mapping(uint256 => Product) public products;

    struct Product {
        uint256 id;
        string name;
        uint256 price;
        address payable owner;
        bool purchased;
    }
    event ProductCreated(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );
    event ProductPurchased(
        uint256 id,
        string name,
        uint256 price,
        address payable owner,
        bool purchased
    );

    constructor() public {
        name = "Parth";
    }

    function createProduct(string memory _name, uint256 _price) public {
        //Make sure parameter correct
        require(bytes(_name).length > 0, "not defined");
        //require valid Price
        require(_price > 0, "not defined");
        //increment Product count
        productCount++;
        //Create product
        products[productCount] = Product(
            productCount,
            _name,
            _price,
            msg.sender,
            false
        );
        //Trigger Event
        emit ProductCreated(productCount, _name, _price, msg.sender, false);
    }

    function purchaseProduct(uint256 _id) public payable {
        //fetch the product
        Product memory _product = products[_id];
        //fetch the owner
        address payable _seller = _product.owner;
		
		//check error messages for what is going on here
		require(_product.id > 0 && _product.id < productCount,' Umm... your product is showing. NOT!');
        require(msg.value >= _product.price,'NEED MORE CASH');
        require(!_product.purchased,'Not Available');
		require(_seller!=msg.sender,"Can't buy your own ish");


        //--transfer ownership
        _product.owner = msg.sender;
        // Mark as purchased
        _product.purchased = true;
        //update product
        products[_id] = _product;
        //Pay the seller by sending the Ether
        address(_seller).transfer(msg.value);
        //event
        emit ProductPurchased(
            productCount,
            _product.name,
            _product.price,
            msg.sender,
            true
        );
    }
}
