public with sharing class PermissionSetsController {
	@AuraEnabled(cacheable=true)
	public static List<PermissionSetAssignment> getAllPermissionSetAssignmentsRelatedToVotingApp() {
		final String MODERATOR = 'Moderator';
		final String ANALYST = 'Analyst';
		final String VOTER = 'Voter';

		List<PermissionSetAssignment> permissionSetAssignments = [
			SELECT Id, Assignee.Name, PermissionSet.Name
			FROM PermissionSetAssignment
			WHERE PermissionSet.Name = :MODERATOR OR PermissionSet.Name = :ANALYST OR PermissionSet.Name = :VOTER
			ORDER BY PermissionSet.Name ASC
		];
		return permissionSetAssignments;
	}

	@AuraEnabled
	public static void createNewPermissionSetAssignment(string psaId, string userId) {
		try {
			PermissionSetAssignment permSetAssignment = new PermissionSetAssignment();
			permSetAssignment.AssigneeId = userId;
			permSetAssignment.PermissionSetId = psaId;
			insert permSetAssignment;
			if (isPermissionSetAnalyst(psaId)) {
				ProfileController.changeUserProfileToAnalyst(userId);
			}
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled
	public static boolean isAlreadyAssigned(string psaId, string userId) {
		List<PermissionSetAssignment> permissionSetAssignments = [
			SELECT Id
			FROM PermissionSetAssignment
			WHERE PermissionSetAssignment.AssigneeId = :userId AND PermissionSetAssignment.PermissionSetId = :psaId
		];
		if (permissionSetAssignments.size() > 0) {
			return true;
		}
		return false;
	}

	@TestVisible
	private static boolean isPermissionSetAnalyst(string psaId) {
		final String ANALYST = 'Analyst';
		PermissionSet selectedPermissionSet = [SELECT Name FROM PermissionSet WHERE id = :psaId WITH USER_MODE];
		return selectedPermissionSet.Name == ANALYST ? true : false;
	}

	@AuraEnabled
	public static void deletePermissionSetAssigmentById(string psaId) {
		try {
			delete as user [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetAssignment.Id = :psaId];
		} catch (Exception ex) {
			throw new AuraHandledException(ex.getMessage());
		}
	}

	@AuraEnabled(cacheable=true)
	public static List<PermissionSet> getAllPermissionSets() {
		final String MODERATOR = 'Moderator';
		final String ANALYST = 'Analyst';
		final String VOTER = 'Voter';

		List<PermissionSet> permissionSets = [
			SELECT Id, Name
			FROM PermissionSet
			WHERE Name = :MODERATOR OR Name = :ANALYST OR Name = :VOTER
			WITH USER_MODE
		];
		return permissionSets;
	}
}
