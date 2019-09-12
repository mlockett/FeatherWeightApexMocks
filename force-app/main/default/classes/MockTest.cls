/**
 * @description 
 *
 * @author mikelockett 
 * @date 2019-06-16.
 */
@IsTest
public with sharing class MockTest {
	@IsTest
	static void test_SimpleMock() {

		// Create a mock version of the MockTester class.
		MockTester tester = (MockTester) FeatherMock.createMock(MockTester.class);

		// set the mock to return 50 when getInt is called
		FeatherMock.setReturn(tester, 'getInt', 50);

		// call the method
		Integer myInt = tester.getInt();

		// verify mocks returned proper values
		System.assertEquals(50, myInt);

		// get call history
		List<FeatherMock.MockDetail> mockDetails1 = FeatherMock.getCallHistory(tester);

		// verify only one call was made
		System.assertEquals(1, mockDetails1.size());

		// verify getInt was called
		System.assertEquals('getInt', mockDetails1[0].stubbedMethodName);

		MockTester tester2 = (MockTester) FeatherMock.createMock(MockTester.class);
		FeatherMock.setReturn(tester2, 'getInt', 40);

		Integer myInt2 = tester2.getInt(5);

		MockTester tester3 = (MockTester) FeatherMock.createMock(MockTester.class, 'getInt', 1000);
		System.assertEquals(1000, tester3.getInt());

		tester.doStuff();

		// verify mocks returned proper values
		System.assertEquals(50, myInt);
		System.assertEquals(40, myInt2);

		// get call history
		List<FeatherMock.MockDetail> mockDetails = FeatherMock.getCallHistory(tester2);

		//check the first mocked call
		FeatherMock.MockDetail mockDetail = mockDetails[0];
		Object param = mockDetail.listOfArgs[0];

		// verify the first arg was 5
		System.assertEquals(5, param);
		System.assertEquals(1, mockDetail.listOfArgs.size());

		// verify method named getInt was called
		System.assert(FeatherMock.methodCalled(tester, 'getInt'));
	}
}