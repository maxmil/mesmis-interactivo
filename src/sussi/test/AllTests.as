import as2unit.framework.*;
import as2unit.utils.*;
import sussi.model.InitParamCollection;

/*
 * Main test class for SUSSI model 
 * 
 * A holding class till TestSuites are in place
 * Keeps references to test classes so single class can be reference on timeline
 * 
 * @author Max Pimm
 * @created 26-09-2005
 * @version
 */
 class sussi.test.AllTests {

	//initial parameters
	public static var ipCol:InitParamCollection = new InitParamCollection();
	
	/*
	 * Constructor
	 */
	public function AllTests(){
	}
	
	/*
	 * Configures test suite and exectutes tests
	 */
	public function test():TestSuite{
		
		//init test suite
		var testSuite:TestSuite = new TestSuite();
		
		//add tests
		testSuite.addTest( new TestSuite(sussi.test.TestSUSSIModel_default));
		testSuite.addTest( new TestSuite(sussi.test.TestSUSSIModel_H1Only));
		testSuite.addTest( new TestSuite(sussi.test.TestSUSSIModel_H1C));
		
		return testSuite;
	}
}