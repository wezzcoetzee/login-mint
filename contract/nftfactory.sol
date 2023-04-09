pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract NftFactory is Ownable {
    using SafeMath for uint256;

    event NewVault(uint vaultId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Vault {
        string name;
        uint16 level;
    }

    Vault[] public vaults;

    mapping(uint => address) public vaultToOwner;
    mapping(address => uint) vaultCount;

    function _createVault(string memory _name, uint _dna) internal {
        uint id = vaults.push(Vault(_name, 1)) - 1;
        vaultToOwner[id] = msg.sender;
        vaultCount[msg.sender] = vaultCount[msg.sender].add(1);
        emit NewVault(id, _name, _dna);
    }

    function _generateRandomDna(
        string memory _str
    ) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomVault(string memory _name) public {
        require(vaultCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - (randDna % 100);
        _createVault(_name, randDna);
    }
}
