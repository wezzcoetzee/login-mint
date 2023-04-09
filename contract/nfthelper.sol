pragma solidity ^0.8.19;

import "./nftfactory.sol";

contract NftHelper is NftFactory {
    uint levelUpFee = 0.001 ether;

    modifier onlyOwnerOf(uint _vaultId) {
        require(msg.sender == vaultToOwner[_vaultId]);
        _;
    }

    modifier aboveLevel(uint _level, uint _vaultId) {
        require(vaults[_vaultId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        _owner.transfer(address(this).balance);
    }

    function _isReady(Vault storage _vault) internal view returns (bool) {
        //   return (_vault.readyTime <= now);
        return true;
    }

    function mintNft(
        uint _vaultId,
        uint _targetDna,
        string memory _species
    ) internal onlyOwnerOf(_vaultId) {
        Vault storage myVault = vaults[_vaultId];
        require(_isReady(myVault));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myVault.dna + _targetDna) / 2;
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("vaulty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createVault("NoName", newDna);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _vaultId) external payable {
        require(msg.value == levelUpFee);
        vaults[_vaultId].level = vaults[_vaultId].level.add(1);
    }

    function changeName(
        uint _vaultId,
        string memory _newName
    ) external aboveLevel(2, _vaultId) onlyOwnerOf(_vaultId) {
        vaults[_vaultId].name = _newName;
    }

    function changeDna(
        uint _vaultId,
        uint _newDna
    ) external aboveLevel(20, _vaultId) onlyOwnerOf(_vaultId) {
        vaults[_vaultId].dna = _newDna;
    }

    function getvaultsByOwner(
        address _owner
    ) external view returns (uint[] memory) {
        uint[] memory result = new uint[](vaultCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < vaults.length; i++) {
            if (vaultToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
