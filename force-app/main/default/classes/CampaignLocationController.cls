public with sharing class CampaignLocationController {
	@AuraEnabled(cacheable=true)
	public static Voting_Location__c getCampaignLocationById(string cmpId) {
		try {
			return [
				SELECT Id, Name, City__c, Country__c, Street__c, Zip_Code__c
				FROM Voting_Location__c
				WHERE Voting_Location__c.Id = :cmpId
				WITH USER_MODE
			];
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}
}
