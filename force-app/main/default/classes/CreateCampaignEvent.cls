public with sharing class CreateCampaignEvent implements Queueable {

	private List<Vote_Campaign__c> votingCampaignsAfterUpdateList;
	private Map<id, Vote_Campaign__c> votingCampaignsbeforeUpdateMap;
	private List<Campaing_Event__c> campaignEventsToInsertList = new List<Campaing_Event__c>();

	public CreateCampaignEvent(
		List<Vote_Campaign__c> votingCampaignsAfterUpdateList,
		Map<id, Vote_Campaign__c> votingCampaignsbeforeUpdateMap
	) {
		this.votingCampaignsAfterUpdateList = votingCampaignsAfterUpdateList;
		this.votingCampaignsbeforeUpdateMap = votingCampaignsbeforeUpdateMap;
	}

	public void execute(QueueableContext qc) {
		createEvent();
	}

	private void createEvent() {
		for (Vote_Campaign__c campaign : votingCampaignsAfterUpdateList) {
			string statusBefore = votingCampaignsbeforeUpdateMap.get(campaign.Id).Campaign_Status__c;
			string statusAfter = campaign.Campaign_Status__c;
			string statusLog =
				'Status changed from ' +
				statusBefore +
				' to ' +
				statusAfter +
				' by ' +
				UserInfo.getFirstName() +
				' ' +
				UserInfo.getLastName();

			campaignEventsToInsertList.add(
				new Campaing_Event__c(Status_Change_Log__c = statusLog, Vote_Campaign__c = campaign.Id)
			);
		}
		insert as user campaignEventsToInsertList;
	}
}
