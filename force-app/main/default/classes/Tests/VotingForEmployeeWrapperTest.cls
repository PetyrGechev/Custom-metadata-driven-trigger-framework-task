@isTest
public with sharing class VotingForEmployeeWrapperTest {
	@isTest
	private static void VotingForEmployeeWrapperContructorTest() {
		final string votingForEmployeeName = 'TestName';
		List<Nominee__c> nominees = TestDataFactory.createNominees(5);

		VotingForEmployeeWrapper wrapper = new VotingForEmployeeWrapper(votingForEmployeeName, nominees);

		System.assertEquals(wrapper.votingForEmployeeName, 'TestName', 'votingForEmployeeName should be TestName');
	}

	@isTest
	private static void VotingForEmployeeWrapperContructorSecondTest() {
		final string votingForEmployeeName = 'TestName';
		List<Nominee__c> nominees = TestDataFactory.createNominees(5);

		VotingForEmployeeWrapper wrapper = new VotingForEmployeeWrapper(votingForEmployeeName, nominees);

		System.assertEquals(wrapper.nominees.size(), 5, 'There should be 5 nominees');
	}

	@isTest
	private static void VotingForEmployeeWrapperFinalNomineeResultsListTest() {
		final string votingForEmployeeName = 'TestName';
		List<Nominee__c> nominees = TestDataFactory.createNominees(2);

		VotingForEmployeeWrapper wrapper = new VotingForEmployeeWrapper(votingForEmployeeName, nominees);
		wrapper.calculateVote();

		System.assertEquals(wrapper.finalNomineeResultsList.size(), 2, 'There should be 2 final results');
	}

	@isTest
	private static void VotingForEmployeeWrapperFinalNomineeResultsListShouldCountSameNameRecords() {
		List<Nominee__c> nominees = new List<Nominee__c>();
		Voting_for_employee__c votingForEmp = TestDataFactory.createVotingForEmployee();
		Nominee__c firstNominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = votingForEmp.Id);
		nominees.add(firstNominee);
		Nominee__c secondNominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = votingForEmp.Id);
		nominees.add(secondNominee);

		VotingForEmployeeWrapper wrapper = new VotingForEmployeeWrapper(votingForEmp.Name, nominees);
		wrapper.calculateVote();

		System.assertEquals(wrapper.finalNomineeResultsList.size(), 1, 'There should be 1 final result');
	}
}
