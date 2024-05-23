import "FungibleToken"
import "FooToken"

transaction(recipient: Address, amount: UFix64) {

    /// Reference to the Example Token Minter Resource object
    let tokenMinter: &FooToken.Minter

    /// Reference to the Fungible Token Receiver of the recipient
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: auth(BorrowValue) &Account) {

        // Borrow a reference to the admin object
        self.tokenMinter = signer.storage.borrow<&FooToken.Minter>(from: FooToken.MinterStoragePath)
            ?? panic("Signer is not the token admin")

        self.tokenReceiver = getAccount(recipient).capabilities.borrow<&{FungibleToken.Receiver}>(FooToken.VaultPublicPath)
            ?? panic("Could not borrow receiver reference to the Vault")
    }

    execute {

        // Create mint tokens
        let mintedVault <- self.tokenMinter.mintTokens(amount: amount)

        // Deposit them to the receiever
        self.tokenReceiver.deposit(from: <-mintedVault)
    }
}