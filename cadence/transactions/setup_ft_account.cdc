import "FungibleToken"
import "FooToken"

transaction () {

    prepare(signer: auth(BorrowValue, IssueStorageCapabilityController, PublishCapability, SaveValue) &Account) {

        // Return early if the account already stores a FooToken Vault
        if signer.storage.borrow<&FooToken.Vault>(from: FooToken.VaultStoragePath) != nil {
            return
        }

        let vault <- FooToken.createEmptyVault(vaultType: Type<@FooToken.Vault>())

        // Create a new FooToken Vault and put it in storage
        signer.storage.save(<-vault, to: FooToken.VaultStoragePath)

        // Create a public capability to the Vault that exposes the Vault interfaces
        let vaultCap = signer.capabilities.storage.issue<&FooToken.Vault>(
            FooToken.VaultStoragePath
        )
        signer.capabilities.publish(vaultCap, at: FooToken.VaultPublicPath)
    }
}