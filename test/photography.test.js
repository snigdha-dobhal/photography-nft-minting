const assert = require('assert');
const c = require('config');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());
const photography = artifacts.require('photography');

contract('validator photography contract()', (accounts) => {
  it('contract owner should be first contract from contracts list', async () => {
    let photographyContract = await photography.deployed();
    let owner = await photographyContract.owner();
    expect(owner).to.equal(accounts[0]);
  });

  it('owner of tokenId 1 should be first contract from contracts list which is also the address that deployed contract', async () => {
    let photographyContract = await photography.deployed();
    const tokenURI =
      'https://ipfs.io/ipfs/QmYxzCq74L2Cy8rxCD5qQQj6q9WBSMDN8oicRBoSCocmKo';
    await photographyContract.mint(tokenURI);
    const owner = await photographyContract.ownerOf(1);
    expect(owner).to.equal(accounts[0]);
  });
});
