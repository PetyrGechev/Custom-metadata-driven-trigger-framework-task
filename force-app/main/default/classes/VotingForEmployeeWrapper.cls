public with sharing class VotingForEmployeeWrapper {

	public VotingForEmployeeWrapper(string votingForEmployeeName, List<Nominee__c> nominees) {
		this.votingForEmployeeName = votingForEmployeeName;
		this.nominees = nominees;
		this.results = new Map<String, Integer>();
		this.finalNomineeResultsList = new List<NomineeResult>();
	}

	@AuraEnabled
	public String votingForEmployeeName { get; private set; }
	@TestVisible
	private List<Nominee__c> nominees { get; private set; }
	@TestVisible
	private Map<String, Integer> results { get; private set; }
	@AuraEnabled
	public List<NomineeResult> finalNomineeResultsList { get; private set; }

	public void calculateVote() {
		for (Nominee__c nom : nominees) {
			string name = nom.Name;
			if (!results.containsKey(name)) {
				results.put(name, 1);
			} else {
				results.put(name, results.get(name) + 1);
			}
		}

		for (string name : results.keyset()) {
			NomineeResult nomineeResult = new NomineeResult(name, results.get(name));
			finalNomineeResultsList.add(nomineeResult);
		}
	}
	public class NomineeResult {
		@AuraEnabled
		public String name;
		@AuraEnabled
		public integer votes;
		public NomineeResult(string name, Integer votes) {
			this.name = name;
			this.votes = votes;
		}
	}
}
