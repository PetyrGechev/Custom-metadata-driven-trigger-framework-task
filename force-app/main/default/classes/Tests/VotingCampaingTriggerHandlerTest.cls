@isTest
public with sharing class VotingCampaingTriggerHandlerTest {
	@isTest
	private static void VotingCampaingTriggerHandlerShouldCreateNewCampainEventWhenStatusChanged() {
		Vote_Campaign__c votCamp = TestDataFactory.createVotingCampaign();
        votCamp.Campaign_Status__c = 'Paused';
        
        Test.startTest();
		update votCamp;

        Test.stopTest();

        Campaing_Event__c campEvent = [SELECT Id, Vote_Campaign__c FROM Campaing_Event__c LIMIT 1];
		System.assertEquals(campEvent.Vote_Campaign__c, votCamp.Id, 'Ids should be equal');
	}
}
