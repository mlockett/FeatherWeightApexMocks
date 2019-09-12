# Featherweight Apex Mocks

This is a very lightweight mocking framework for Salesforce Apex. The only class 
that must be deployed to use this framework is "FeatherMock."

The MockTester class is a simple class to mock to verify the functionality of the 
mocks. 

The MockTest class is only a for my testing, but is not required for using the 
framework.

## Usage:
 
    // create a mock version of the MockTester class.
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

## Additions:
Added convenience method to get a mock with a methods return value over-written.

    // created a mocked object of type MockTester that returns 1000 anytime getInt is called.
    MockTester tester3 = (MockTester) FeatherMock.createMock(MockTester.class, 'getInt', 1000);
