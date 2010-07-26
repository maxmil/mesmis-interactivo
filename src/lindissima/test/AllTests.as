import as2unit.framework.*;
import as2unit.utils.*;
import lindissima.model.InitParamCollection;

/*
 * A holding class till TestSuites are in place
 * Keeps references to test classes so single class can be reference on timeline
 * 
 * @author
 * @version
 */
 class lindissima.test.AllTests {

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
		testSuite.addTest( new TestSuite(lindissima.test.TestCSModel_default));
		testSuite.addTest( new TestSuite(lindissima.test.TestCSModel_noShrub));
		testSuite.addTest( new TestSuite(lindissima.test.TestCSModel_fertilizer));
		testSuite.addTest( new TestSuite(lindissima.test.TestCSModel_rootPrune));
		testSuite.addTest( new TestSuite(lindissima.test.TestLakeModel_default));
		
		return testSuite;
	}
}