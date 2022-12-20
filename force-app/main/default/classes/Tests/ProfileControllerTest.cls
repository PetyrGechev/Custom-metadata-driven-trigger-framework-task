@isTest
public with sharing class ProfileControllerTest {
	@isTest
	private static void changeUserProfileToAnalystShouldChangeProfile() {
		final string ANALYST = 'Analyst';
		User testUser = TestDataFactory.createNewUser();
		Profile analystProfile = [SELECT Id, Name FROM Profile WHERE Name = :ANALYST];

		Test.startTest();

		ProfileController.changeUserProfileToAnalyst(testUser.Id);

		Test.stopTest();
		User updatedUser = [SELECT Id, Name, ProfileId FROM User WHERE Id = :testUser.Id];
		System.assertEquals(updatedUser.ProfileId, analystProfile.Id, 'ProfileIds should be equal');
	}

	@isTest
	private static void changeUserProfileToAnalystShouldThrowExpWhenInvalidID() {
        
		Test.startTest();
		try {
			ProfileController.changeUserProfileToAnalyst(null);
			System.assert(false, 'Expected an exception.');
		} catch (Exception ex) {
			System.assert(true, ex.getMessage());
		}
		Test.stopTest();
	}
}
