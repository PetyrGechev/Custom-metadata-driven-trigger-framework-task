public with sharing class FeedbackGaderingController {
	@AuraEnabled
	public static List<Result__c> getAllResultsFromFeedbackGaderingsByCampaignId(string cmpId) {
		List<Result__c> results = [
			SELECT
				Answer__c,
				User__r.Name,
				Question__r.Name,
				Question__r.Feedback_gathering__r.Name,
				Question__r.Feedback_gathering__r.Vote_Campaign__c
			FROM Result__c
			WHERE Question__r.Feedback_gathering__r.Vote_Campaign__c = :cmpId
			WITH USER_MODE
			ORDER BY Question__r.Feedback_gathering__r.Name
		];

		return results;
	}
}
