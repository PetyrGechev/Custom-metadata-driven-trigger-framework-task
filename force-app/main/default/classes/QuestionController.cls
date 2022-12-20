public with sharing class QuestionController {
	@AuraEnabled
	public static Question__c getQuestionById(string questionId) {
		try {
			Question__c question = [SELECT Id, Name FROM Question__c WHERE ID = :questionId WITH USER_MODE];
			return question;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled
	public static void createNewResult(Result__c resultObj) {
		try {
			insert as user resultObj;
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled(cacheable=true)
	public static boolean itIsAlreadyProvidedFeedback(string userId, string votingId) {
		boolean isProvidedFeedback = false;

		Question__c currentquestion = [
			SELECT Id, Name, (SELECT Id, Name, USER__c FROM Answer__r)
			FROM Question__c
			WHERE ID = :votingId
			WITH USER_MODE
		];

		List<Result__c> results = currentquestion.Answer__r;

		for (Result__c res : results) {
			if (res.User__c == userId) {
				isProvidedFeedback = true;
			}
		}
		return isProvidedFeedback;
	}
}
