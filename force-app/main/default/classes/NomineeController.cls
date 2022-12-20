public with sharing class NomineeController {
	@AuraEnabled(cacheable=true)
	public static List<Nominee__c> getAllNominees() {
		List<Nominee__c> nominees = [
			SELECT Id, Name, Voting_for_employee__c, User__c
			FROM Nominee__c
			WITH USER_MODE
			ORDER BY Name
		];
		return nominees;
	}

	@AuraEnabled
	public static void createNewNominee(Nominee__c nomineeObj) {
		try {
			insert as user nomineeObj;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}
}
