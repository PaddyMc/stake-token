/**
    @title: StakeToken
    @dev: StakeToken contract for use in Ethereum POS
    @author: PaddyMc
 */

pragma solidity ^0.4.24;

import "./StakeTokenBase.sol";

contract StakeToken is StakeTokenBase {
  address public constant stakeAddress = 0x7A5d089701E1baC31cBE9c15BDa39486d7D45e49;
  string public constant name = "StakeToken";
  string public constant symbol = "STK";
  uint8 public constant decimals = 18;

  uint256 public constant INITIAL_SUPPLY = 1 * (10 ** uint256(decimals));

  event Staked(address staker, uint coinsCreated, uint time);
  event PaidOut(address staker, uint percentage);
  event StakeFinished(address staker);

  struct StakeInfo {
    uint256 ethStart;
    uint256 initialSupply;
    uint time;
    bool returnTokens;
    uint percentReturn;
    bool paid;
  }

  uint numberOfStakers = 0;
  uint totalStake = 0;
  mapping (uint => address) stakersList;
  mapping (address => StakeInfo) stakers;

  constructor() 
    public 
  {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }

  // Staking Functions
  function getStakeAddress() 
    public 
    pure 
    returns (address) 
  {
    return stakeAddress;
  }

  // A user can only stake once per account
  function stake () 
    public 
    payable 
  {
    require(numberOfStakers < 1000, "Staker pool full");
    require(msg.sender.balance > 10000, "Can't afford tokens");
    require(stakers[msg.sender].ethStart == 0, "Already staked");

    stakers[msg.sender].ethStart = stakeAddress.balance > 0 ? stakeAddress.balance : 1;
    stakers[msg.sender].initialSupply = msg.value;
    uint time = now;
    //should not be used, ok for POC on testnet
    stakers[msg.sender].time = time;
    stakers[msg.sender].returnTokens = false;
    stakers[msg.sender].percentReturn = 0;
    stakers[msg.sender].paid = false;

    stakersList[numberOfStakers] = msg.sender;
    numberOfStakers++;

    // This address will be used to stake in Ethereum 2.0/CASPER/Serinity
    stakeAddress.transfer(msg.value);

    // Security flaw here, ok for POC on testnet
    mint(msg.sender, msg.value);

    emit Staked(msg.sender, msg.value, stakers[msg.sender].time);
  }

  // Redeeming Stake will be handled in backend go
  function redeemStake (uint256 value) 
    public 
    payable
  {
    require(stakers[msg.sender].ethStart > 0, "User has not staked");
    require(balanceOf(msg.sender) == value, "User has not returned all tokens");

    stakers[msg.sender].returnTokens = true;
    stakers[msg.sender].percentReturn = calculatePercentageGained(msg.sender);
    burn(value);
    emit PaidOut(msg.sender, stakers[msg.sender].percentReturn);
  }

  function getStakeAccount () 
    public 
    view 
    returns (
      uint256, 
      uint, 
      bool, 
      uint,
      bool
    ) 
  {
    require(stakers[msg.sender].ethStart > 0, "User has not staked");
    return (
      stakers[msg.sender].ethStart,
      stakers[msg.sender].time,
      stakers[msg.sender].returnTokens,
      stakers[msg.sender].percentReturn,
      stakers[msg.sender].paid
    );
  }

  function calculatePercentageGained (address staker)
    private
    view
    returns (uint)
  {
    //uint min = 60000;
    //uint mins5 = min.mul(5);
    uint day = 86400000;
    uint month = day.mul(30);
    uint year = month.mul(12);
    uint percentGained = 0;
    uint time = now - stakers[staker].time;

    // This is a very naive solution, ok for POC on testnet
    //min5
    if(time > 1) {
      percentGained = 1;
    } else if (time > day) {
      percentGained = 2;
    } else if (time > year){
      percentGained = 5;
    } else {
      percentGained = 0;
    }

    return percentGained;
  }

  // Functions for use with backend payment system
  function getNumberOfStakers () 
    public 
    view
    returns (uint)
  {
    return numberOfStakers;
  }

  function getStakerByNumber (uint position) 
    public 
    view
    returns (uint256, uint256, uint, bool, uint, bool)
  {
    return (
      stakers[stakersList[position]].ethStart,

      // diminishing returns for stakers with much more tokens than initial supply
      stakers[stakersList[position]].initialSupply,
      stakers[stakersList[position]].time,
      stakers[stakersList[position]].returnTokens,
      stakers[stakersList[position]].percentReturn,
      stakers[stakersList[position]].paid
    );
  }

  function stakerPaid (address staker) 
    public
    onlyOwner
  {
    stakers[staker].paid = true;
    emit StakeFinished(staker);
  }

  // Returns tokens through Request Network
}