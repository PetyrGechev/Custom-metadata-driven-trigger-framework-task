@isTest
private class TestDataFactoryTest {
	static Account account;

	static testMethod void createAccountsTest() {
		account = TestDataFactory.createAccounts(1)[0];
		insert account;
		List<Account> accounts = [
			SELECT Id,Name
			FROM account
			WHERE id = :account.id
		];
		system.assert(accounts.size()>0);

	}
}
