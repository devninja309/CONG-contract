//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CONG is ERC20, Ownable {
    mapping(address => bool) public investors;
    uint256 public preSaleStart;
    uint256 public maxSupply;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        uint256 maxSupply_
    ) ERC20(name_, symbol_) {
        maxSupply = maxSupply_;
        _mint(msg.sender, initialSupply_);
    }

    function issue(address target, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "Exceed totalSupply");
        _mint(target, amount);
    }

    function enrollOne(address addr) external onlyOwner {
        investors[addr] = true;
    }

    function enrollAll(address[] memory addr) external onlyOwner {
        for (uint256 idx = 0; idx < addr.length; idx++) {
            investors[addr[idx]] = true;
        }
    }

    function setPreSaleStart(uint256 startTime) external onlyOwner {
        preSaleStart = startTime;
    }

    function transfer(address to, uint256 amount)
        public
        override
        returns (bool)
    {
        super.transfer(to, amount);
        if (investors[msg.sender]) {
            uint256 interval = block.timestamp - preSaleStart;
            if (interval >= 365 days && interval < 730 days) {
                _burn(to, (amount * 1) / 200);
            }
            if (interval >= 730 days) {
                _burn(to, (amount * 3) / 400);
            }
        } else {
            _burn(to, (amount * 1) / 100);
        }

        return true;
    }
}
