import "FooToken"
import "FungibleToken"

transaction {
	prepare(acct: AuthAccount) {
	  acct.save(<- FooToken.createEmptyVault(), to: /storage/Vault)
	  acct.link<&FooToken.Vault{FungibleToken.Balance, FungibleToken.Receiver}>(/public/Vault, target: /storage/Vault)
	}

	execute {
		log("Created vault")
	}
}