import "FooToken"
import "FungibleToken"

access(all) fun main(account: Address) {
  let vault = getAccount(account).getCapability(/public/Vault)
	  .borrow<&FooToken.Vault{FungibleToken.Balance}>()
	  ?? panic("Can't borrow public Vault")

  log(vault.balance)
}