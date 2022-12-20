public with sharing class ProfileController {
	public static void changeUserProfileToAnalyst(string userId) {
		final string ANALYST = 'Analyst';
		try {
			User userToUpdate = [SELECT Id, Name FROM User WHERE ID = :userId WITH USER_MODE];
			Profile analystProfile = [SELECT Id, Name FROM Profile WHERE Name = :ANALYST WITH USER_MODE];
			userToUpdate.ProfileId = analystProfile.Id;
			update as user userToUpdate;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}
}
