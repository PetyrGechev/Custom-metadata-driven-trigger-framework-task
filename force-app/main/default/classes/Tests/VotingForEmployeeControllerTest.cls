@isTest
public with sharing class VotingForEmployeeControllerTest {

    @isTest
	private static void IsItAlreadyVotedForThisEmployeeShouldReturnFalseWhenUserHasNotVoted() {
		User testUser = TestDataFactory.createNewUser();
		Voting_for_employee__c votForEmp = TestDataFactory.createVotingForEmployee();

		Test.startTest();
		boolean result = VotingForEmployeeController.IsItAlreadyVotedForThisEmployee(testUser.Id, votForEmp.Id);
		Test.stopTest();
		System.assertEquals(false, result, 'Should return false when user is not voted alraedy');
	}

	@isTest
	private static void IsItAlreadyVotedForThisEmployeeShouldReturnTrueWhenUserHasVoted() {
		User testUser = TestDataFactory.createNewUser();
		Voting_for_employee__c votForEmp = TestDataFactory.createVotingForEmployee();
		Nominee__c nomineeObj = new Nominee__c(Voting_for_employee__c = votForEmp.Id, User__c = testUser.Id);
		insert nomineeObj;

		Test.startTest();
		boolean result = VotingForEmployeeController.IsItAlreadyVotedForThisEmployee(testUser.Id, votForEmp.Id);
		Test.stopTest();
		System.assertEquals(true, result, 'Should return true when user is voted alraedy');
	}

	@isTest
	private static void getAllVotingForEmployeesByCampaignIdShouldReturnValidListOfVotingForEmployeeWrapper() {
		Vote_Campaign__c votCamp=TestDataFactory.createVotingCampaign();
		Voting_for_employee__c votingForEmp = new Voting_for_employee__c(
			Name = 'TestVoringForEmployee',
			Vote_Campaign__c = votcamp.Id
		);
		insert votingForEmp;
		Nominee__c nominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = votingForEmp.Id);
		insert nominee;

		Test.startTest();
		List<VotingForEmployeeWrapper> resultList = VotingForEmployeeController.getAllVotingForEmployeesByCampaignId(votCamp.Id);
		Test.stopTest();
		System.assertEquals(resultList.size(), 1, 'There should be one returned VotingForEmployeeWrapper in the list');
	}
}