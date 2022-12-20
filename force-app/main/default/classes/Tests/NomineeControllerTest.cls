@isTest
public with sharing class NomineeControllerTest {
	@isTest
	private static void getAllNomineesShouldReturnAllRecords() {
		List<Nominee__c> nominees = TestDataFactory.createNominees(5);

		Test.startTest();
		List<Nominee__c> insertedNominees = NomineeController.getAllNominees();
		Test.stopTest();

		System.assertEquals(insertedNominees.size(), 5, 'Five records should be returned');
	}

	@isTest
	private static void createNewNomineeShouldCreateRecord() {
		Voting_for_employee__c votingForEmp = TestDataFactory.createVotingForEmployee();
		Nominee__c nominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = votingForEmp.Id);

		Test.startTest();
		NomineeController.createNewNominee(nominee);
		List<Nominee__c> insertedNominees = [SELECT Id, Name,Voting_for_employee__c FROM Nominee__c];
		Test.stopTest();

		Nominee__c insertedNominee = insertedNominees[0];
		System.assertEquals(insertedNominee.Voting_for_employee__c ,votingForEmp.Id, 'Ids should be equal');
	}

	@isTest
	private static void createNewNomineeShouldThrowExceptionWhenUnvalidRecord() {
		Nominee__c nominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = null);

		try {
			Test.startTest();
			NomineeController.createNewNominee(nominee);
			Test.stopTest();
			System.assert(false,'Expecting exception');
		} catch (Exception e) {
			System.assert(true, e.getMessage());
		}
	}
}
