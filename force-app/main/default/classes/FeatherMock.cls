/**
 * A feather-weight mocking framework
 *
 * @author mikelockett 
 * @date 2019-06-16
 */

@IsTest
public class FeatherMock {

	// keep track of mock provider for each mock
	private static Map<Object, SimpleMockProvider> providerFromMock = new Map<Object, SimpleMockProvider>();

	/**
	 * get instance of type top mock
	 *
	 * @param typeToMock
	 * @return mock object
	 */
	public static Object createMock(Type typeToMock) {

		FeatherMock.SimpleMockProvider simpleMockProvider = new SimpleMockProvider();
		// mock class of typeToMock.
		Object returnObject = Test.createStub(typeToMock, simpleMockProvider);

		// track objects
		providerFromMock.put(returnObject, simpleMockProvider);
		return returnObject;
	}

	/**
	 * get instance of type top mock
	 *
	 * @param typeToMock
	 * @return mock object
	 */
	public static Object createMock(Type typeToMock, String methodName, Object returnValue) {

		FeatherMock.SimpleMockProvider simpleMockProvider = new SimpleMockProvider();
		// mock class of typeToMock.
		Object returnObject = Test.createStub(typeToMock, simpleMockProvider);

		// track objects
		providerFromMock.put(returnObject, simpleMockProvider);

		FeatherMock.setReturn(returnObject, methodName, returnValue);

		return returnObject;
	}

	/**
	 * get call history for mock
	 *
	 * @param mockObject Object
	 *
	 * @return
	 */
	public static List<MockDetail> getCallHistory(Object mockObject){
		SimpleMockProvider provider = providerFromMock.get(mockObject);
		if( provider != null){
			return provider.getCallHistory();
		}
		return new List<MockDetail>();
	}

	/**
	 * find out if method was called on mock
	 *
	 * @param mockObject
	 * @param methodName
	 *
	 * @return
	 */
	public static Boolean methodCalled(Object mockObject, String methodName){
		SimpleMockProvider provider = providerFromMock.get(mockObject);
		if( provider != null){
			List<MockDetail> mockDetails = provider.getCallHistory();
			for(MockDetail detail : mockDetails){
				if(detail.stubbedMethodName == methodName){
					return true;
				}
			}
		}
		return false;
	}

	public static SimpleMockProvider setReturn(Object mockObject, String methodName, Object returnValue) {
		SimpleMockProvider provider = providerFromMock.get(mockObject);
		if( provider != null){
			provider.setReturn(methodName, returnValue);
		}
		return provider;
	}

	/**
	 * mock provider - provides mock and tracks data for each mock
	 */
	public class SimpleMockProvider implements System.StubProvider {
		private Map<String, Object> returnMap = new Map<String, Object>(); // method name => return value
		private List<MockDetail> callHistory = new List<MockDetail>();

		public SimpleMockProvider() {
		}

		public SimpleMockProvider setReturn(String methodName, Object value) {
			returnMap.put(methodName, value);
			return this;
		}

		/**
		 * gets call history for this instance
		 *
		 * @return list of detail for mocked calls
		 */
		public List<MockDetail> getCallHistory(){
			return callHistory;
		}

		/**
		 * Single method from StubProvider that is magically wired in by SF to handle all calls to mocks
		 *
		 * @param stubbedObject
		 * @param stubbedMethodName
		 * @param returnType
		 * @param listOfParamTypes
		 * @param listOfParamNames
		 * @param listOfArgs
		 *
		 * @return
		 */
		public Object handleMethodCall(
				Object stubbedObject,
				String stubbedMethodName,
				Type returnType,
				List<Type> listOfParamTypes,
				List<String> listOfParamNames,
				List<Object> listOfArgs) {

			// track history
			MockDetail mockDetailEntry = new MockDetail(stubbedObject, stubbedMethodName, returnType, listOfParamTypes,
					listOfParamNames, listOfArgs);
			callHistory.add(mockDetailEntry);

			// return value from return map or null
			// Apex stubbing API magically casts the value correctly for the caller
			return returnMap.get(stubbedMethodName);
		}
	}

	/**
	 * for tracking data for a call to a mock
	 */
	public class MockDetail {
		public MockDetail(Object stubbedObject, String stubbedMethodName,
				Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames,
				List<Object> listOfArgs) {
			this.stubbedObject = stubbedObject;
			this.stubbedMethodName = stubbedMethodName;
			this.returnType = returnType;
			this.listOfParamTypes = listOfParamTypes;
			this.listOfParamNames = listOfParamNames;
			this.listOfArgs = listOfArgs;
		}
		public Object stubbedObject { get; set; }
		public String stubbedMethodName { get; set; }
		public Type returnType { get; set; }
		public List<Type> listOfParamTypes { get; set; }
		public List<String> listOfParamNames { get; set; }
		public List<Object> listOfArgs { get; set; }
	}
}