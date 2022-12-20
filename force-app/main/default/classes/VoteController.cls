public with sharing class VoteController {
	@AuraEnabled
	public static void createNewVote(Vote__c voteObj) {
		try {
			insert as user voteObj;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled(cacheable=true)
	public static boolean IsItAlreadyVotedForThisIdea(string userId, string votingId) {
		boolean isVoted = false;

		Voting_for_idea__c currenrVoting = [
			SELECT Id, Name, (SELECT Id, NAME, USER__c FROM Ideas__r)
			FROM Voting_for_idea__c
			WHERE ID = :votingId
			WITH USER_MODE
		];

		List<Vote__c> votes = currenrVoting.Ideas__r;

		for (Vote__c vote : votes) {
			if (vote.User__c == userId) {
				isVoted = true;
			}
		}
		return isVoted;
	}
}
