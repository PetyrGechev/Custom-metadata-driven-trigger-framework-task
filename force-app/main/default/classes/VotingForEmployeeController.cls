public with sharing class VotingForEmployeeController {
	@AuraEnabled
	public static List<VotingForEmployeeWrapper> getAllVotingForEmployeesByCampaignId(string cmpId) {
		List<VotingForEmployeeWrapper> votingForEmployeeWrapperList = new List<VotingForEmployeeWrapper>();
		List<Voting_for_employee__c> votingsForEmployee = [
			SELECT Name, (SELECT Name FROM Nominees__r)
			FROM Voting_for_employee__c
			WHERE Vote_Campaign__c = :cmpId
			WITH USER_MODE
		];

		for (Voting_for_employee__c voting : votingsForEmployee) {
			VotingForEmployeeWrapper wrapper = new VotingForEmployeeWrapper(voting.Name, voting.Nominees__r);
			wrapper.calculateVote();
			votingForEmployeeWrapperList.add(wrapper);
		}
		return votingForEmployeeWrapperList;
	}

	@AuraEnabled(cacheable=true)
	public static boolean IsItAlreadyVotedForThisEmployee(string userId, string votingId) {
		boolean isVoted = false;

		Voting_for_employee__c currenrCampaign = [
			SELECT Id, Name, (SELECT Id, NAME, USER__c FROM Nominees__r)
			FROM Voting_for_employee__c
			WHERE ID = :votingId
			WITH USER_MODE
		];

		List<Nominee__c> nominees = currenrCampaign.Nominees__r;

		for (Nominee__c nom : nominees) {
			if (nom.User__c == userId) {
				isVoted = true;
			}
		}
		return isVoted;
	}
}
