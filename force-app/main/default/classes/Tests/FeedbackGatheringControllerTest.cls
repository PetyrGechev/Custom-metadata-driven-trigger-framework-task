@isTest
public with sharing class FeedbackGatheringControllerTest {

    @isTest
    private static void getAllResultsFromFeedbackGaderingsByCampaignIdShouldReturnRecord() {

        Result__c fakeResult= TestDataFactory.createResult();
        Vote_Campaign__c campaign= [SELECT Id,Name from Vote_Campaign__c LIMIT 1];
        Result__c testResult=[Select Id,Name from Result__c LIMIT 1];
	
		Test.startTest();
		List<Result__c > results = FeedbackGaderingController.getAllResultsFromFeedbackGaderingsByCampaignId(campaign.Id);
		Result__c result=results[0];
        Test.stopTest();
      
		 System.assertEquals(result.Id,testResult.Id, 'Ids should be equal');

	}
}
