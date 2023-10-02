import "FooToken"
import "FungibleToken"

transaction(receiverAccount: Address) {
	prepare(acct: AuthAccount) {
	    let minter = acct.borrow<&FooToken.Minter>(from: /storage/Minter)
		    ?? panic("Can't borrow Minter")

        let newVault <- minter.mintToken(amount: 20.0)

        let receiverVault = getAccount(receiverAccount).getCapability(/public/Vault)
            .borrow<&FooToken.Vault{FungibleToken.Receiver}>()
            ?? panic("Could not get public Vault")

        receiverVault.deposit(from: <- newVault)
	}

	execute {}
}