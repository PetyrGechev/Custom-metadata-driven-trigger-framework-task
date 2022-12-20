public with sharing class TestDataFactory {
    public  enum UserType{
        ANALYST,
        VOTER,
        MODERATOR
     }
	public static List<Account> createAccounts(Integer numberOfAccounts) {
		List<Account> accounts = new List<Account>();
		for (Integer i = 0; i < numberOfAccounts; i++) {
			Account account = new Account(Name = 'Test Account' + Math.random());
			accounts.add(account);
		}
		return accounts;
	}

	public static Vote_Campaign__c createVotingCampaign() {
		Vote_Campaign__c votCamp = new Vote_Campaign__c(
			Name = 'TestCampaign',
			Campaign_Status__c = 'Paused',
			Start_date__c = System.today(),
			End_date__c = System.today() + 7
		);
		insert votCamp;
		return votCamp;
	}

	public static Feedback_gathering__c createFeedbackGathering() {
		Vote_Campaign__c votcamp = TestDataFactory.createVotingCampaign();
		Feedback_gathering__c feedback = new Feedback_gathering__c(
			Name = 'TestFeedbackGathering',
			Vote_Campaign__c = votcamp.Id
		);
		insert feedback;
		return feedback;
	}

	public static Question__c createQuestion() {
		Feedback_gathering__c feedback = TestDataFactory.createFeedbackGathering();
		Question__c question = new Question__c(Name = 'TestQuestion', Feedback_gathering__c = feedback.Id);
		insert question;
		return question;
	}

	public static Result__c createResult() {
		Question__c question = TestDataFactory.createQuestion();
		Result__c result = new Result__c(Question__c = question.Id, Answer__c = 'Test answer');
		insert result;
		return result;
	}

	public static Voting_for_employee__c createVotingForEmployee() {
		Vote_Campaign__c votcamp = TestDataFactory.createVotingCampaign();
		Voting_for_employee__c votingForEmp = new Voting_for_employee__c(
			Name = 'TestVoringForEmployee',
			Vote_Campaign__c = votcamp.Id
		);
		insert votingForEmp;
		return votingForEmp;
	}

	public static List<Nominee__c> createNominees(Integer count) {
		Voting_for_employee__c votingForEmp = TestDataFactory.createVotingForEmployee();
		List<Nominee__c> nominees = new List<Nominee__c>();
		for (Integer i = 0; i < count; i++) {
			Nominee__c nominee = new Nominee__c(Name = 'TestNominee' + i, Voting_for_employee__c = votingForEmp.Id);
			nominees.add(nominee);
		}
		insert nominees;
		return nominees;
	}

	public static User createNewUser() {
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
		User newUser = new User(
			Lastname = 'TestUser',
			Alias = 'Alias1',
			Email = 'TestUserEmail@gmail.com',
			Username = 'test2@abv.com',
			ProfileId = profileId.id,
			TimeZoneSidKey = 'GMT',
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey = 'UTF-8',
			LocaleSidKey = 'en_US'
		);
		insert newUser;
		return newUser;
	}

    public static Voting_for_idea__c createNewVotingForIdea() {
        Vote_Campaign__c votCmp= TestDataFactory.createVotingCampaign();
		Voting_for_idea__c voteForIdea = new Voting_for_idea__c(
			Name = 'TestVoteForIdea',
            Vote_Campaign__c= votCmp.Id
		);
		insert voteForIdea;
		return voteForIdea;
	}
}  