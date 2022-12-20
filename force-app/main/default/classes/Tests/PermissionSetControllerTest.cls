@isTest
public with sharing class PermissionSetControllerTest {
	@isTest
	private static void isPermissionSetAnalystShouldReturnTrueIfPSisForAnalyst() {
		final string ANALYST = 'Analyst';
		PermissionSet permissionSet = [SELECT Id, Name FROM PermissionSet WHERE Name = :ANALYST];

		Test.startTest();
		boolean result = PermissionSetsController.isPermissionSetAnalyst(permissionSet.Id);
		Test.stopTest();

		System.assertEquals(result, true, 'Should return true if the permission set Id is for Analyst');
	}

	@isTest
	private static void isPermissionSetAnalystShouldReturnFalseIfPSisForAnalyst() {
		final string MODERATOR = 'Moderator';
		PermissionSet permissionSet = [SELECT Id, Name FROM PermissionSet WHERE Name = :MODERATOR];

		Test.startTest();
		boolean result = PermissionSetsController.isPermissionSetAnalyst(permissionSet.Id);
		Test.stopTest();

		System.assertEquals(result, false, 'Should return false if the permission set Id is for Analyst');
	}

	@isTest
	private static void getAllPermissionSetsShouldReturnAllThreePermissionSets() {
		Test.startTest();
		List<PermissionSet> permissionSets = PermissionSetsController.getAllPermissionSets();
		Test.stopTest();

		System.assertEquals(permissionSets.size(), 3, 'There should be 3 records in the list');
	}

	@isTest
	private static void getAllPermissionSetsShouldReturnModeratorPermissionSet() {
		final string MODERATOR = 'Moderator';

		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];

		Test.startTest();
		List<PermissionSet> permissionSets = PermissionSetsController.getAllPermissionSets();

		Test.stopTest();

		System.assert(
			(new List<PermissionSet>(permissionSets)).contains(moderatorPermissionSet),
			'getAllPermissionSets method should return Moderator PS'
		);
	}

	@isTest
	private static void getAllPermissionSetsShouldReturnModeratorPermissionSetByName() {
		final string MODERATOR = 'Moderator';

		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];
		boolean nameExists = false;
		Test.startTest();
		List<PermissionSet> permissionSets = PermissionSetsController.getAllPermissionSets();
		for (PermissionSet ps : permissionSets) {
			if (ps.Name == 'Moderator') {
				nameExists = true;
			}
		}
		Test.stopTest();
		System.assertEquals(nameExists, true, 'Name should exist in the list of permissions');
	}

	@isTest
	private static void getAllPermissionSetAssigmentsShouldReturnAllThreePermissionSetsAssigments() {
		final string MODERATOR = 'Moderator';
		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];
		User testUser = TestDataFactory.createNewUser();
		PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment();
		permissionSetAssignment.AssigneeId = testUser.Id;
		permissionSetAssignment.PermissionSetId = moderatorPermissionSet.Id;
		insert permissionSetAssignment;
		boolean nameExists = false;
		Test.startTest();
		List<PermissionSetAssignment> permissionSetAssignments = PermissionSetsController.getAllPermissionSetAssignmentsRelatedToVotingApp();
		Test.stopTest();
		for (PermissionSetAssignment psa : permissionSetAssignments) {
			if (psa.PermissionSet.Id == moderatorPermissionSet.Id) {
				nameExists = true;
			}
		}
		System.assertEquals(nameExists, true, 'Name should exist in the list of permissions set assignments');
	}

	@isTest
	private static void createNewPermissionSetAssignmentShouldCreateRecord() {
		final string MODERATOR = 'Moderator';
		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];
		User testUser = TestDataFactory.createNewUser();

		Test.startTest();
		PermissionSetsController.createNewPermissionSetAssignment(moderatorPermissionSet.Id, testUser.Id);
		List<PermissionSetAssignment> pmsAssignment = [
			SELECT Id, AssigneeId
			FROM PermissionSetAssignment
			WHERE PermissionSetId = :moderatorPermissionSet.Id
		];
		Test.stopTest();
		System.assert(pmsAssignment.size() > 0, 'Not empty list');
	}

	@isTest
	private static void createNewPermissionSetAssignmentShouldCreateRecordAndChangeProfileToAnalystIfPSisForAnalyst() {
		final string ANALYST = 'Analyst';
		PermissionSet analystPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :ANALYST];
		User testUser = TestDataFactory.createNewUser();

		Test.startTest();
		PermissionSetsController.createNewPermissionSetAssignment(analystPermissionSet.Id, testUser.Id);
		User updatedUser = [SELECT Id, Name, ProfileId FROM User WHERE Id = :testUser.Id];
		Profile profile = [SELECT Id, Name FROM Profile WHERE Name = :ANALYST];
		Test.stopTest();
		System.assertEquals(updatedUser.ProfileId, profile.Id, 'Ids should be equal');
	}

	@isTest
	private static void createNewPermissionSetAssignmentShouldThrowExpWhenInvalidIds() {
		try {
			Test.startTest();
			PermissionSetsController.createNewPermissionSetAssignment(null, 'test');
			Test.stopTest();
			System.assert(false, 'Expecting exception');
		} catch (Exception e) {
			System.assert(true, e.getMessage());
		}
	}

	@isTest
	private static void deletePermissionSetAssigmentByIdThrowExpWhenInvalidIds() {
		final string MODERATOR = 'Moderator';
		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];
		User testUser = TestDataFactory.createNewUser();
		PermissionSetAssignment pmsAssignmentTest = new PermissionSetAssignment();
		pmsAssignmentTest.AssigneeId = testUser.Id;
		pmsAssignmentTest.PermissionSetId = moderatorPermissionSet.Id;
		insert pmsAssignmentTest;
		Test.startTest();
		PermissionSetsController.deletePermissionSetAssigmentById(pmsAssignmentTest.Id);
		Test.stopTest();
		List<PermissionSetAssignment> pmsAssignment = [
			SELECT Id, AssigneeId
			FROM PermissionSetAssignment
			WHERE Id = :pmsAssignmentTest.Id
		];
		System.assertEquals(pmsAssignment.size(), 0, 'should be equal to zero');
	}

	@isTest
	private static void isAlreadyAssignedShouldReturnTrueIfUserIsAssigned() {
		final string MODERATOR = 'Moderator';
		PermissionSet moderatorPermissionSet = [SELECT Id, Name FROM PermissionSet WHERE NAME = :MODERATOR];
		User testUser = TestDataFactory.createNewUser();
		PermissionSetAssignment pmsAssignmentTest = new PermissionSetAssignment();
		pmsAssignmentTest.AssigneeId = testUser.Id;
		pmsAssignmentTest.PermissionSetId = moderatorPermissionSet.Id;
		insert pmsAssignmentTest;

		Test.startTest();
		boolean result = PermissionSetsController.isAlreadyAssigned(moderatorPermissionSet.Id, testUser.Id);
		Test.stopTest();
		System.assertEquals(true, result, 'Should return true when user is assigned alraedy');
	}

	@isTest
	private static void isAlreadyAssignedShouldReturnFalseIfUserIsNotAssigned() {
		User testUser = TestDataFactory.createNewUser();

		Test.startTest();
		boolean result = PermissionSetsController.isAlreadyAssigned(null, testUser.Id);
		Test.stopTest();
		System.assertEquals(false, result, 'Should return false when user is not assigned alraedy');
	}
}
