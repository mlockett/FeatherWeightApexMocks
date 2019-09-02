/**
 * For testing mocks; SF doesn't allow creating stubs on inner classes, so we need a top level class to verify
 *
 * @author mikelockett 
 * @date 2019-07-13.
 */

public with sharing class MockTester {
	public Integer getInt() {
		return 10;
	}

	public Integer getInt(Integer anInt) {
		return anInt + 5;
	}

	public void doStuff(){}
}