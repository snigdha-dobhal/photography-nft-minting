require('dotenv').config();
const Web3 = require('web3');
const HDWalletProvider = require('@truffle/hdwallet-provider');

const data = require('../build/contracts/Photography.json');
const abiArray = data.abi;
const contract_address = process.env.CONTRACT_ADDRESS;
const owner_address = process.env.OWNER_ADDRESS;
const mnemonic = process.env.MNEMONIC;
const clientURL = process.env.CLIENT_URL;
const provider = new HDWalletProvider(mnemonic, clientURL);
const web3 = new Web3(provider);

async function mintNFT() {
  try {
    const accounts = await web3.eth.getAccounts();
    console.log('accounts:', accounts);
    console.log('contract_address', contract_address);
    const photo = new web3.eth.Contract(abiArray, contract_address);
    let isMintEnabled = await photo.methods
                            .getIsMintEnabled()
                            .call();
    // console.log('isMintEnabled: ', isMintEnabled);
    if(isMintEnabled == false){
        await photo.methods
          .toggleIsMintEnabled()
          .send({ from: owner_address });
    }
    await photo.methods
      .approveUserToMint(accounts[0])
      .send({ from: owner_address });
    await photo.methods
      .mint(
        'https://ipfs.io/ipfs/QmUSW13a9R6K6aXRuKMqDwNCTiakGDZefX6NakAbXFMWqY'
      )
      .send({ from: accounts[0] });
    console.log('Successfully minted NFT');
    const balance = await photo.methods.balanceOf(accounts[0]).call();
    const owner = await photo.methods.ownerOf(balance).call();
    console.log('balance: ', balance);
    console.log('owner: ', owner);
  } catch (err) {
    console.log('error occured while calling deployed contract:', err);
  }
}

mintNFT();
