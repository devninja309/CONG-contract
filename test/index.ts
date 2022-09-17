import { expect } from "chai";
import { ethers } from "hardhat";

describe("CONG", function () {
  let cong: any;

  before(async () => {
    const congFactory = await ethers.getContractFactory("CONG");
    cong = await congFactory.deploy("Cong", "CONG", ethers.utils.parseEther("100000000"));
    await cong.deployed();

  })

  it("Check owner's token amount", async function () {
    let owner: any;
    [owner] = await ethers.getSigners();
    expect(await cong.balanceOf(owner.address)).to.equal(ethers.utils.parseEther("100000000"));
  });

  it("PreSale Time Test", async function () {
    await cong.setPreSaleStart(1663682639);

    expect(await cong.preSaleStart()).to.equal(1663682639);
  });

  it("Test enrollOne with only one user", async function () {
    await cong.enrollOne("0xffF0313bDcc071490ec4947D8072D7A6D1394411");

    expect(await cong.investors("0xffF0313bDcc071490ec4947D8072D7A6D1394411")).to.equal(true);
  });

  it("Test enrollAll with user array", async function () {
    await cong.enrollAll([
      "0xffF0313bDcc071490ec4947D8072D7A6D1394411",
      "0x503D11Bd91fCB198aAA09AA72D063b4a62077323",
      "0xaD909939c964E1eFC958E96Df6C5DAf5ECc6b347",
    ]);

    expect(await cong.investors("0x503D11Bd91fCB198aAA09AA72D063b4a62077323")).to.equal(true);
  });
});
