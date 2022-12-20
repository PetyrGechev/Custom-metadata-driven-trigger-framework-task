trigger VotingCampaingTrigger on Vote_Campaign__c (after update) {
    new VotingCampaingTriggerHandler().run();
}