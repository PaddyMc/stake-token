<h1>
  Stake Token: Smart Contract
</h1>
<p>
  This token takes ETH to stake in the new CASPER Proof Of Stake consensus algorithm, as compensation
  the contract distributes STK which will grow in value based on the amount of 
  time the token is held.
</p>
[Link to Frontend DApp source code](https://github.com/PaddyMc/stake-token-frontend)
<hr />
<h3>For deployment</h3>
<ul>
  <li>
    Replace stakeAddress {StakeToken.sol #Line 12} with new staking address (Address of your main account)
  </li>
</ul>

<h3>
  To Test
</h3>
<p>Ensure you have ganache or ganache-cli running</p>
<ul>
  <li>
    npm install
  </li>
  <li>
    truffle console --network development
  </li>
  <li>
    test
  </li>
</ul>

<h3>
  To Deploy
</h3>
<p>Ensure you have updated the mnemonic and infura token in truffle.js</p>
<ul>
  <li>
    truffle console --network rinkbey
  </li>
  <li>
    migrate
  </li>
</ul>

<p>To update the Smart Contract in the Stake token DApp</p>
 <ul>
  <li>
    Take the Smart Contract address output from the 'migrate' command
  </li>
  <li>
    Follow the instructions in the stake-token-frontend repo
  </li>
</ul>

<h3>
  Smart Contract: Rinkeby
</h3>
<ul>
  <li>
    0xb08deb79cfb7a79f0628b690803a8a40d5432b83
  </li>
</ul>
