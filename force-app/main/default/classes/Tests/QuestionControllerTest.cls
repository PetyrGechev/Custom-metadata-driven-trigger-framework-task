@isTest
public with sharing class QuestionControllerTest {
	@isTest
	private static void getQuestionByIdShouldReturnRecord() {
		Question__c question = TestDataFactory.createQuestion();

		Test.startTest();
		Question__c insertedQuestion = QuestionController.getQuestionById(question.Id);
		Test.stopTest();

		System.assertEquals(insertedQuestion.Id, question.Id, 'Ids should be equal');
	}

	@isTest
	private static void getQuestionByIdShouldThrowExceptionWhenUnvalidId() {
		Nominee__c nominee = new Nominee__c(Name = 'TestNominee', Voting_for_employee__c = null);

		try {
			Test.startTest();
			Question__c insertedQuestion = QuestionController.getQuestionById(null);
			Test.stopTest();
			System.assert(false, 'Expecting exception');
		} catch (Exception e) {
			System.assert(true, e.getMessage());
		}
	}

	@isTest
	private static void createNewResultShouldCreateRecord() {
		Question__c question = TestDataFactory.createQuestion();
		Result__c result = new Result__c(Question__c = question.Id, Answer__c = 'TestAnswer');

		Test.startTest();
		QuestionController.createNewResult(result);
		Test.stopTest();

		Result__c insertedResult = [SELECT Id, Name, Answer__c FROM Result__c LIMIT 1];
		System.assertEquals(insertedResult.Answer__c, 'TestAnswer', 'Answer should be equal to TestAnswer');
	}

	@isTest
	private static void createNewResultShouldThrowExceptionWhenUnvalidRecord() {
		Result__c result = new Result__c(Question__c = null, Answer__c = 'TestAnswer');

		try {
			Test.startTest();
			QuestionController.createNewResult(result);
			Test.stopTest();
			System.assert(false, 'Expecting exception');
		} catch (Exception e) {
			System.assert(true, e.getMessage());
		}
	}

	@isTest
	private static void itIsAlreadyProvidedFeedbackShouldReturnFalseWhenUserIsNotVoted() {
		User testUser = TestDataFactory.createNewUser();
		Question__c question = TestDataFactory.createQuestion();

		Test.startTest();
		boolean result = QuestionController.itIsAlreadyProvidedFeedback(testUser.Id, question.Id);
		Test.stopTest();
		System.assertEquals(false, result, 'Should return false when user is not voted alraedy');
	}

	@isTest
	private static void itIsAlreadyProvidedFeedbackShouldReturnTrueWhenUserIsVotedAlready() {
		User testUser = TestDataFactory.createNewUser();
		Question__c question = TestDataFactory.createQuestion();
		Result__c resultObj = new Result__c(Question__c = question.Id, User__c = testUser.Id, Answer__c = 'TestAnswer');
		insert resultObj;

		Test.startTest();
		boolean result = QuestionController.itIsAlreadyProvidedFeedback(testUser.Id, question.Id);
		Test.stopTest();
		System.assertEquals(true, result, 'Should return true when user is voted alraedy');
	}
}

// @AuraEnabled(cacheable=true)
// public static boolean itIsAlreadyProvidedFeedback(string userId, string votingId) {
//     boolean isProvidedFeedback = false;

//     Question__c currentquestion = [
//         SELECT Id, Name, (SELECT Id, Name, USER__c FROM Answer__r)
//         FROM Question__c
//         WHERE ID = :votingId
//     ];

//     List<Result__c> results = currentquestion.Answer__r;

//     for (Result__c res : results) {
//         if (res.User__c == userId) {
//             isProvidedFeedback = true;
//         }
//     }
//     return isProvidedFeedback;
// }

// @isTest
// private static void isItAlreadyVotedForThisIdeaShouldReturnFalseWhenUserIsNotVoted() {
//     User testUser = TestDataFactory.createNewUser();
//     Voting_for_idea__c votForIdea = TestDataFactory.createNewVotingForIdea();

//     Test.startTest();
//     boolean result = VoteController.IsItAlreadyVotedForThisIdea(testUser.Id, votForIdea.Id);
//     Test.stopTest();
//     System.assertEquals(false, result, 'Should return false when user is not voted alraedy');
// }

// @isTest
// private static void isItAlreadyVotedForThisIdeaShouldReturnTrueWhenUserIsVotedAlready() {
//     User testUser = TestDataFactory.createNewUser();
//     Voting_for_idea__c votForIdea = TestDataFactory.createNewVotingForIdea();
//     Vote__c vote = new Vote__c(Voting_for_idea__c = votForIdea.Id, User__c = testUser.Id);
//     insert vote;

//     Test.startTest();
//     boolean result = VoteController.IsItAlreadyVotedForThisIdea(testUser.Id, votForIdea.Id);
//     Test.stopTest();
//     System.assertEquals(true, result, 'Should return true when user is voted alraedy');
// }

