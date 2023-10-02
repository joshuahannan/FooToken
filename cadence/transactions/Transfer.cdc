import "FooToken"
import "FungibleToken"

transaction(receiverAccount: Address, amount: UFix64) {
	prepare(acct: AuthAccount) {
	  let signerVault = acct.borrow<&FooToken.Vault>(from: /storage/Vault)
		  ?? panic("Couldn't get signer's Vault")
	  
	let receiverVault = getAccount(receiverAccount).getCapability(/public/Vault)
			.borrow<&FooToken.Vault{FungibleToken.Receiver}>()
			?? panic("Could not get public Vault")

	  receiverVault.deposit(from: <- signerVault.withdraw(amount: amount))
	}

	execute {
		log("Transferred")	
	}
}