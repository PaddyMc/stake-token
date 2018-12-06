var StakeToken = artifacts.require("../contracts/StakeToken.sol");

delay = (ms) => {
  return new Promise(resolve => setTimeout(resolve, ms));
}

contract('StakeToken', function(accounts) {
  var owner = accounts[0];
  var staker = accounts[1];

  var stakeAddress = 0x7A5d089701E1baC31cBE9c15BDa39486d7D45e49
  var stakeTokenContract;

  var arbitraryAmount = 10000;

  beforeEach(async () => {
    stakeTokenContract = await StakeToken.new()
  })

  it("Returns the stakers address", async function () {
    const stakeAddressFromContract = await stakeTokenContract.getStakeAddress()
    assert.equal(stakeAddressFromContract, stakeAddress, "incorrect staker address returned")
  })

  it("transfers a stake token from the owner to a staker", async function () {
    await stakeTokenContract.transfer(staker, arbitraryAmount, {from:owner})
    const balance = await stakeTokenContract.balanceOf(staker)
    assert.equal(balance, arbitraryAmount, "incorrect amount transferred")
  })

  it("Mints new tokens", async function () {
    await stakeTokenContract.stake({from:staker, value: arbitraryAmount})
    const balance = await stakeTokenContract.balanceOf(staker)
    assert.equal(balance.toString(), arbitraryAmount, "incorrect amount minted")
  })

  it("Gets a staker account", async function () {
    await stakeTokenContract.stake({from:staker, value: arbitraryAmount})
    const stakerAccount = await stakeTokenContract.getStakeAccount({from:staker})
    assert.equal(stakerAccount[2], false, "could not get account")
  })

  it("Redeems a stake amount", async function () {
    await stakeTokenContract.stake({from:staker, value: arbitraryAmount * 15})
    const balance = await stakeTokenContract.balanceOf(staker)
    // delay used for testing percentGained variable
    // await delay(280040)
    const stakePaid = await stakeTokenContract.redeemStake(balance, {from:staker})
    const newBalance = await stakeTokenContract.balanceOf(staker)

    assert.equal(balance > newBalance, true, "tokens have not been burned")
    assert.equal(stakePaid.logs[1].args.percentage.toString(), 0, "incorrect precent gained")
  })

  it("Gets a staker by number", async function () {
    await stakeTokenContract.stake({from:staker, value: arbitraryAmount})
    const numberOfStakers = await stakeTokenContract.getNumberOfStakers()
    const stakerAccount = await stakeTokenContract.getStakerByNumber(numberOfStakers - 1)

    assert.equal(stakerAccount.length == 6, true, "could not get account")
  })
})