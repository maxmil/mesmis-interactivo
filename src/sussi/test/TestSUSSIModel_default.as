import as2unit.framework.TestCase;
import core.util.Utils;
import sussi.Const;
import sussi.SussiApp;
import sussi.test.TestInitParams;
import sussi.process.*;
import sussi.utils.SUtils;
/*
 * Unit test class for SUSSI model with carnivores, herbivore 1 and herbivore 2
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.test.TestSUSSIModel_default extends TestCase{
	 
	var tip:TestInitParams;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestSUSSIModel_default(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		tip = new TestInitParams("default");
		
		//select the necesarry init params
		SussiApp.selInitParams("default");
		
		//clear outputs
		SUtils.clearOutputs();
	}

	/*
	 * Tests the Process: Bh1
	 */
	 public function testBh1():Void{

		//define process
		var bh1 = Bh1.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.00767421519867298"
		expOutputs[2]="0.00728786458056945"
		expOutputs[3]="0.00859208578315578"
		expOutputs[4]="0.00941747864594064"
		expOutputs[5]="0.00977586268347211"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = bh1.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = bh1.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}
	
	/*
	 * Tests the Process: Dh1
	 */
	 public function testDh1():Void{

		//define process
		var dh1 = Dh1.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.0300001059500926"
		expOutputs[2]="0.03"
		expOutputs[3]="0.03"
		expOutputs[4]="0.03"
		expOutputs[5]="0.03"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = dh1.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = dh1.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Ph1
	 */
	 public function testPh1():Void{

		//define process
		var ph1 = Ph1.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="180"
		expOutputs[1]="23.51231354948"
		expOutputs[2]="7.05191999935089"
		expOutputs[3]="2.21332955540414"
		expOutputs[4]="0.736542749958292"
		expOutputs[5]="0.252556925911863"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = ph1.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = ph1.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Bh2
	 */
	 public function testBh2():Void{

		//define process
		var bh2 = Bh2.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.020743323713001"
		expOutputs[2]="0.0104094421447162"
		expOutputs[3]="0.00944919537047108"
		expOutputs[4]="0.0097040860982442"
		expOutputs[5]="0.00988184649481349"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = bh2.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = bh2.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Dh2
	 */
	 public function testDh2():Void{

		//define process
		var dh2 = Dh2.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.035000042380037"
		expOutputs[2]="0.035"
		expOutputs[3]="0.035"
		expOutputs[4]="0.035"
		expOutputs[5]="0.035"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = dh2.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = dh2.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Ph2
	 */
	 public function testPh2():Void{

		//define process
		var ph2 = Ph2.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="180"
		expOutputs[1]="48.1888117302812"
		expOutputs[2]="16.0766425054079"
		expOutputs[3]="4.23130147200924"
		expOutputs[4]="1.10867431051851"
		expOutputs[5]="0.294136209055847"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = ph2.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = ph2.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Bc
	 */
	 public function testBc():Void{

		//define process
		var bc = Bc.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.00145876878162775"
		expOutputs[2]="0.000473954980820243"
		expOutputs[3]="0.000132079966410357"
		expOutputs[4]="0.0000377893663404115"
		expOutputs[5]="0.000011189696594873"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = bc.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = bc.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Dc
	 */
	 public function testDc():Void{

		//define process
		var dc = Dc.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0"
		expOutputs[1]="0.4"
		expOutputs[2]="0.4"
		expOutputs[3]="0.4"
		expOutputs[4]="0.4"
		expOutputs[5]="0.4"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = dc.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = dc.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

	/*
	 * Tests the Process: Pc
	 */
	 public function testPc():Void{

		//define process
		var pc = Pc.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="20"
		expOutputs[1]="0.0000318623061214791"
		expOutputs[2]="1.0018590406578e-16"
		expOutputs[3]="2.98277841492661e-28"
		expOutputs[4]="8.73532444383774e-40"
		expOutputs[5]="2.54656697307001e-51"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = pc.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = pc.getOutput(i*52-1).toString();
		}

		//check process
		assertEquals("Initial output incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 1 year incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 2 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 3 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 4 years incorrect", expOutputs[4], outputs[4]);
		assertEquals("Output after 5 years incorrect", expOutputs[5], outputs[5]);
	}

}