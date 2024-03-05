const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("WhitelistPluginDemo", function () {
  let whitelistPluginDemo;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();
  
    // Adjust the contract name here
    const WhitelistPluginDemo = await ethers.getContractFactory("WhitelistPluginDemo");
    whitelistPluginDemo = await WhitelistPluginDemo.deploy(owner.address);
  });
  

  it("Should add and verify an address on the whitelist", async function () {
    // Add addr1 to the whitelist
    await whitelistPluginDemo.addToWhitelist(addr1.address);

    // Check if addr1 is on the whitelist
    const isVerified = await whitelistPluginDemo.isAddressVerified(addr1.address);
    expect(isVerified).to.equal(true);
  });

  it("Should remove an address from the whitelist", async function () {
    // Add addr1 to the whitelist
    await whitelistPluginDemo.addToWhitelist(addr1.address);

    // Remove addr1 from the whitelist
    await whitelistPluginDemo.removeFromWhitelist(addr1.address);

    // Check if addr1 is not on the whitelist anymore
    const isVerified = await whitelistPluginDemo.isAddressVerified(addr1.address);
    expect(isVerified).to.equal(false);
  });

});
