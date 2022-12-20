@isTest
public with sharing class UserControllerTest {
	@isTest
	private static void getAllUsersShouldReturnRecords() {
		List<User> users = [
			SELECT Id, Name
			FROM USER
			WHERE NAME != 'Automated Process' AND NAME != 'Data.com Clean' AND NAME != 'Platform Integration User'
		];

		Test.startTest();
		List<User> insertedUsers = UserController.getAllUsers();
		Test.stopTest();
		System.assertEquals(insertedUsers.size(), users.size(), 'There should be same amount of users');
	}
}
