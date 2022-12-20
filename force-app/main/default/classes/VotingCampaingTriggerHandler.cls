public with sharing class VotingCampaingTriggerHandler extends TriggerHandler {
	private List<Vote_Campaign__c> votingCampaignsAfterUpdateList;
	private Map<id, Vote_Campaign__c> votingCampaignsbeforeUpdateMap;
	CreateCampaignEvent eventCreator;

	public VotingCampaingTriggerHandler() {
		this.votingCampaignsAfterUpdateList = (List<Vote_Campaign__c>) Trigger.new;
		this.votingCampaignsbeforeUpdateMap = (Map<id, Vote_Campaign__c>) Trigger.oldMap;
		eventCreator = new CreateCampaignEvent(votingCampaignsAfterUpdateList, votingCampaignsbeforeUpdateMap);
	}

	public override void afterUpdate() {
		System.enqueueJob(eventCreator);
	}
}
