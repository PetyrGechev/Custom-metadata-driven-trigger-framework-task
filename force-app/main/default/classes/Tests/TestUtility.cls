public with sharing class TestUtility {
	static Integer myNumber = 1;

	public static Id getFakeId(Schema.SObjectType sObjectType) {
		string index = String.valueOf(myNumber++);
		return (Id) (sObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12 - index.length()) + index);
	}
}
//Id = TestUtility.getFakeId(Case.SObjectType); get ID !!