public with sharing class UserController {
	@AuraEnabled(cacheable=true)
	public static List<User> getAllUsers() {
		List<User> users = [
			SELECT Id, name, ProfileId, IsActive
			FROM User
			WHERE NAME != 'Automated Process' AND NAME != 'Data.com Clean' AND NAME != 'Platform Integration User'
			WITH USER_MODE
		];
		return users;
	}
}
