pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./nftmint.sol";

contract NftOwnership is NftMint, ERC721 {
    using SafeMath for uint256;

    mapping(uint => address) vaultApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerVaultCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return vaultToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerVaultCount[_to] = ownerVaultCount[_to].add(1);
        ownerVaultCount[msg.sender] = ownerVaultCount[msg.sender].sub(1);
        vaultToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            vaultToOwner[_tokenId] == msg.sender ||
                vaultApprovals[_tokenId] == msg.sender
        );
        _transfer(_from, _to, _tokenId);
    }

    function approve(
        address _approved,
        uint256 _tokenId
    ) external payable onlyOwnerOf(_tokenId) {
        vaultApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
