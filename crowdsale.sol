pragma solidity ^0.5.0;

import "Homework_W21/PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inheriting the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{
    
    constructor(
        uint rate,
        address payable wallet, //0x304AdE1cf8929482C531132A27c7bb0bf309fdA0
        uint goal,
        uint open,
        uint close,
        PupperCoin token 
        )
        
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(goal)
        TimedCrowdsale(open,close)
        RefundableCrowdsale(goal)
        public
    {
    // constructor can stay empty 
    }
}

    // uint Cap = 300;
    // uint Balance;
    // address payable owner = msg.sender;
    
    // // modifier to assess if max cap has been hit
    // modifier maxCap {
    //     require(Balance =< 300);
    //     // if max cap is sub 300, run the function
    //     _;
    // }
    
    // // modifier to assess if deadline has passed 
    // modifier deadline {
    //     require (now =< CloseTime);
    //   // if deadline has not passed, run the function
    //     _;
    // }

    // // 1. check if maxCap is hit 2. accept crowdfunding transfers & 3. update balance
    // function transfer(address recipient, uint value) public maxCap {
    //     balances[msg.sender] = balances[msg.sender].sub(value);
    //     balances[CrowdFundWallet] = balances[CrowdFundWallet].add(value);
    // }
    
    // // check balance vs Cap @TODO question - should this be done by modifier or by function
    // function balance() public view returns (uint) {
    //     if (CrowdFundWallet >= Cap) {   
    // }    
    
    // // refund if cap has been hit
    // function refund() public ... {
    //     _refund(recipient,amount)
    //     require (balance >=300) {refund to msg.sender}
    // }



contract PupperCoinSaleDeployer{

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all Ether raised by the sale "0x304AdE1cf8929482C531132A27c7bb0bf309fdA0"
        uint goal
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        // @TODO what is the goal? 
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, goal, now, now + 24 weeks, token);
        token_sale_address = address(token_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

