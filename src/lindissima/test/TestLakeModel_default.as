import as2unit.framework.TestCase;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.test.CornShrubModel;
import lindissima.process.*;
import lindissima.utils.LUtils;
/*
 * Unit test class for the lake model using default parameters
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 07-07-2005
 */
 class lindissima.test.TestLakeModel_default extends TestCase{
	 
	var csm:CornShrubModel;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestLakeModel_default(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		csm = new CornShrubModel("default");
		
		//select the necesarry init params
		LindApp.selInitParams("default");
		
		//clear outputs
		LUtils.clearOutputs();
	}

	/*
	 * Tests the Process: WeedCon with a low initial level of weeds
	 */
	 public function testWeedConClear():Void{

		//define process
		var weedCon = WeedCon.getProcess();
		
		//set initial concentration to low
		LUtils.setInitialWeeds("low", 0);

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="6.39799408661121"

		//calculate real outputs outputs
		var outputs = new Array(1);
		outputs[0] = weedCon.getOutput(365).toString();

		//check process
		assertEquals("Output after 365 iterations incorrect", expOutputs[0], outputs[0]);
	}
	
	/*
	 * Tests the Process: WeedCon with a high initial level of weeds
	 */
	 public function testWeedConMirky():Void{

		//define process
		var weedCon = WeedCon.getProcess();
		
		//set initial concentration to high
		LUtils.setInitialWeeds("high", 0);

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="13.5483403159582"

		//calculate real outputs outputs
		var outputs = new Array(1);
		outputs[0] = weedCon.getOutput(365).toString();

		//check process
		assertEquals("Output after 365 iterations incorrect", expOutputs[0], outputs[0]);
	}
}