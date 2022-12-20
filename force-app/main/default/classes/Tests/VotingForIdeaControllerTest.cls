@isTest
private class VotingForIdeaControllerTest {
	@testSetup
	static void setup() {
        Vote_Campaign__c campaign = TestDataFactory.createVotingCampaign();
		Voting_for_idea__c votingForIdea = new Voting_for_idea__c(
			Name = 'TestVotingForIdea',
			Idea_description__c = 'TestDescription',
		    Vote_Campaign__c = campaign.Id
		);
		insert votingForIdea;
	}

	@isTest
	private static void getVotingForIdeaByIdShouldReturnRecord() {
		Voting_for_idea__c insertedVotingForIdea = [SELECT Id, Name FROM Voting_for_idea__c LIMIT 1];

		Test.startTest();
		List<Voting_for_idea__c > votingForIdeaList = VotingForIdeaController.getVotingForIdeaById(insertedVotingForIdea.Id);
		Voting_for_idea__c votingForIdea=votingForIdeaList[0];
        Test.stopTest();

		System.assertEquals(votingForIdea.Name, 'TestVotingForIdea', 'Returned name should be TestVotingForIdea');
		System.assertEquals(
			votingForIdea.Idea_description__c,
			'TestDescription',
			'Returned description should be TestDescription'
		);
		System.assertEquals(votingForIdea.Id, insertedVotingForIdea.Id, 'Id should be the same');
	}

    @isTest
    private static void getAllVotingForIdeasByCampaignIdShouldReturnRigthRecords() {
        List<Voting_for_idea__c> votingForIdeaToinsert = new List<Voting_for_idea__c>();
        Vote_Campaign__c campaign = TestDataFactory.createVotingCampaign();
		Voting_for_idea__c firstVotingForIdea = new Voting_for_idea__c(
			Name = 'TestVotingForIdeaOne',
		    Vote_Campaign__c = campaign.Id
		);
        votingForIdeaToinsert.add(firstVotingForIdea);
        Voting_for_idea__c secondVotingForIdea = new Voting_for_idea__c(
			Name = 'TestVotingForIdeaTwo',
		    Vote_Campaign__c = campaign.Id
		);
        votingForIdeaToinsert.add(secondVotingForIdea);
		insert votingForIdeaToinsert;
  
		Test.startTest();
		List<Voting_for_idea__c> ideas= VotingForIdeaController.getAllVotingForIdeasByCampaignId(campaign.Id);
		Test.stopTest();

        System.assertEquals(ideas.size(), 2 ,'There should be two records');

	}
  
}


