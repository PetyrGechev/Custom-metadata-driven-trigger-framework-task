@isTest
public with sharing class VoteControllerTest {
	@isTest
	private static void createNewVoteShouldCreateNewRecord() {
		Voting_for_idea__c votForIdea = TestDataFactory.createNewVotingForIdea();
		Vote__c vote = new Vote__c(Voting_for_idea__c = votForIdea.Id);

		Test.startTest();
		VoteController.createNewVote(vote);
		Test.stopTest();

		Vote__c insertedVote = [SELECT Id, Name, Voting_for_idea__c FROM Vote__c LIMIT 1];
		System.assertEquals(insertedVote.Voting_for_idea__c, votForIdea.Id, 'Ids Should be equal');
	}

	@isTest
	private static void createNewVoteShouldThrowExpWhenInvalidObj() {
		Test.startTest();
		try {
			VoteController.createNewVote(null);
			System.assert(false, 'Expected an exception.');
		} catch (Exception ex) {
			System.assert(true, ex.getMessage());
		}
		Test.stopTest();
	}

	@isTest
	private static void isItAlreadyVotedForThisIdeaShouldReturnFalseWhenUserIsNotVoted() {
		User testUser = TestDataFactory.createNewUser();
		Voting_for_idea__c votForIdea = TestDataFactory.createNewVotingForIdea();

		Test.startTest();
		boolean result = VoteController.IsItAlreadyVotedForThisIdea(testUser.Id, votForIdea.Id);
		Test.stopTest();
		System.assertEquals(false, result, 'Should return false when user is not voted alraedy');
	}

	@isTest
	private static void isItAlreadyVotedForThisIdeaShouldReturnTrueWhenUserIsVotedAlready() {
		User testUser = TestDataFactory.createNewUser();
		Voting_for_idea__c votForIdea = TestDataFactory.createNewVotingForIdea();
		Vote__c vote = new Vote__c(Voting_for_idea__c = votForIdea.Id, User__c = testUser.Id);
		insert vote;

		Test.startTest();
		boolean result = VoteController.IsItAlreadyVotedForThisIdea(testUser.Id, votForIdea.Id);
		Test.stopTest();
		System.assertEquals(true, result, 'Should return true when user is voted alraedy');
	}
}
