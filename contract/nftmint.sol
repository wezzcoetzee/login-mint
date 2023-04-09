pragma solidity ^0.8.19;

import "./nfthelper.sol";

contract NftMint is NftHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns (uint) {
        randNonce = randNonce.add(1);
        return
            uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    function mint(
        uint _vaultId,
        uint _targetId
    ) external onlyOwnerOf(_vaultId) {
        Vault storage myVault = vaults[_vaultId];
        mintNft(_vaultId, myVault.dna, "vault");
    }
}
