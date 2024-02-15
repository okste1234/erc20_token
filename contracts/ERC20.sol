// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract ERC20 {
    uint private totalTokenSupply;
    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) public allowance;
    string public name;
    string public symbol;
    uint8 public decimals;
    address owner = msg.sender;

    constructor() {
        name = "KUVAT";
        symbol = "KVA";
        decimals = 18;
        owner = msg.sender;
        mint(5000000);
    }

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return (balances[account]);
    }

    function transfer(
        address _recipient,
        uint _amount
    ) external returns (bool) {
        require(_recipient != address(0), "no zero address call");
        uint _charges = (_amount * 10) / 100;
        require(
            (balances[msg.sender] + _charges) >= _amount,
            "you don't have sufficient funds to send"
        );
        burn(_charges);
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) external returns (bool) {
        require(_spender != address(0), "wrong EOA");
        uint _charges = (_amount * 10) / 100;
        require(
            (balances[msg.sender] + _charges > 0),
            "You do not have enough token to approve to spender"
        );
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transferFrom(
        address _sender,
        address _recipient,
        uint256 _amount
    ) external returns (bool) {
        uint _charge = (_amount * 10) / 100;

        require(
            allowance[msg.sender][_sender] > _amount,
            "you do not have sufficient allowance to send"
        );

        allowance[msg.sender][_sender] -= _amount;

        burn(_charge);

        balances[msg.sender] -= _amount;

        balances[_recipient] += _amount;

        emit Transfer(_sender, _recipient, _amount);
        return true;
    }

    function mint(uint _amount) internal {
        require(
            msg.sender == owner,
            "You are not authorized to perform mint action"
        );
        balances[owner] += _amount;
        totalTokenSupply += _amount;
        emit Transfer(address(0), msg.sender, _amount);
    }

    function burn(uint _charges) private {
        require(_charges > 0, "nothing to burn");
        require(
            balances[msg.sender] >= _charges,
            "balance is low to continue transaction"
        );
        balances[msg.sender] -= _charges;
        totalTokenSupply -= _charges;
        emit Transfer(msg.sender, address(0), _charges);
    }
}
