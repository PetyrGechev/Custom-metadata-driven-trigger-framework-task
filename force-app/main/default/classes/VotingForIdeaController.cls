public with sharing class VotingForIdeaController {
	@AuraEnabled(cacheable=true)
	public static List<Voting_for_idea__c> getVotingForIdeaById(string campId) {
		List<Voting_for_idea__c> votingsForIdea = [
			SELECT Id, Name, Idea_description__c
			FROM Voting_for_idea__c
			WHERE ID = :campId
			WITH USER_MODE
		];
		return votingsForIdea;
	}

	@AuraEnabled
	public static List<Voting_for_idea__c> getAllVotingForIdeasByCampaignId(string cmpId) {
		List<Voting_for_idea__c> ideas = [
			SELECT Id, Name, Agree__c, Disagree__c
			FROM Voting_for_idea__c
			WHERE Voting_for_idea__c.Vote_Campaign__c = :cmpId
			WITH USER_MODE
		];
		return ideas;
	}
}
