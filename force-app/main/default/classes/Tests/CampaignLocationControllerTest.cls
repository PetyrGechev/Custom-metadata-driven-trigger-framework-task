@isTest
private class CampaignLocationControllerTest {
	@testSetup
	static void setup() {
		Voting_Location__c votLocation = new Voting_Location__c(
			Name = 'TestLocation',
			City__c = 'TestCity',
			Country__c = 'TestCountry',
			Street__c = 'TestStreet'
		);
		insert votLocation;
	}

	@isTest
	private static void getCampaignLocationByIdShouldReturnCorrectRecord() {
		Voting_Location__c insertedVotLocation = [
			SELECT Id, Name, City__c, Country__c, Street__c, Zip_Code__c
			FROM Voting_Location__c
			LIMIT 1
		];

		Test.startTest();
		Voting_Location__c votLocation = CampaignLocationController.getCampaignLocationById(insertedVotLocation.Id);
		Test.stopTest();

		System.assertEquals(votLocation.Id, insertedVotLocation.Id, 'Id should be the same');
	}

	@isTest
	private static void getCampaignLocationByIdShouldThrowExpWhenIdNofFound() {
		Id fakeID = TestUtility.getFakeId(Voting_Location__c.SObjectType);

		Test.startTest();
		try {
			Voting_Location__c votLocation = CampaignLocationController.getCampaignLocationById(fakeID);
			System.assert(false, 'Expected an exception.');
		} catch (Exception ex) {
			System.assert(true, ex.getMessage());
		}
		Test.stopTest();
	}
}
