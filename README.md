# 2 Blocks

Try to get in at the last POW work and try to get in at the first POS block.

Anyone can mint Genesis (POS NFT) and Conclusion (POW NFT) - however, if you try to mint the NFT twice, rather than minting 2 tokens, your NFT will just update values (block num and difficulty). So feel free to spam away - it will be poetic if we sign off POW with a fat gas war due to an NFT mint don't ya think?

`Spacefont.sol` is the contract we store our font in (since we can render 3rd party fonts without storing on chain... pain...).

`Genesis.sol` and `Conclusion.sol` are the NFT contracts. You can mint `Genesis` only when POS happens and up to 100 blocks after, you can mint `Conclusion.sol` up until POS.

THE COLLECTION NAMES WILL CHANGE TO SUNSET AND SUNRISE.

The renderers are upgradeable because we plan to do a 'reveal' for ppl that got into the 2 blocks and for those that didn't.

Because we started this so late, it has been lightly tested, but pretty sure it works xD

The initialization scripts are used to upload the font and image gradients to the chain using SSTORE2.

We use foundry to deploy though.

Small caveat: If you sell your NFT (or buy someone elses) NFT while mint is active for Sunset (before merge occurs) or Sunrise (up to 100 blocks after POS), the original minter will be able to change your metadata by calling mint again. But... if you sell/buy these NFTs within the 100 blocks... I don't even know what to say to you... These have NO financial values besides clout and historical purpsoe - this is just a fun experiment.

# Contracts

Conclusion (Sunet NFT) `0x0e824d5f934Ad01A603101d6A41D723C1702822B`

ConclusionRenderer (Sunset Renderer) `0x6cf6A54125DaD7D174631a73347257aE5769572c`

Genesis (Sunrise NFT) `0xfc1726c4ead2393fA14407Ff54B336E2c8BB4aCA`

GenesisRenderer (Sunrise Renderer) `0xf2910c0f6856A2092a831494Cd510F33811B43eb`

SpaceFont (on-chain font) `0x6B9045e4855ebB16c8F7E291943a7743E34cA57C`