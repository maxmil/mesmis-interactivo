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
 class sussi.test.TestSUSSIModel_H1C extends TestCase{
	 
	var tip:TestInitParams;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestSUSSIModel_H1C(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		tip = new TestInitParams("H1C");
		
		//select the necesarry init params
		SussiApp.selInitParams("H1C");
		
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
		expOutputs[1]="0.073411035265269"
		expOutputs[2]="0.0720707252302306"
		expOutputs[3]="0.0714808271206634"
		expOutputs[4]="0.0712726730080845"
		expOutputs[5]="0.0712222008914012"

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
		expOutputs[1]="0.0703068501009898"
		expOutputs[2]="0.0698203230051654"
		expOutputs[3]="0.0702120740660622"
		expOutputs[4]="0.0706718044486361"
		expOutputs[5]="0.0709816737378953"

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
		expOutputs[1]="191.110361951248"
		expOutputs[2]="196.906737666665"
		expOutputs[3]="199.271639254829"
		expOutputs[4]="200.03478140421"
		expOutputs[5]="200.179558074809"

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
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"
		expOutputs[5]="0"

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
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"
		expOutputs[5]="0"

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
		expOutputs[0]="0"
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"
		expOutputs[5]="0"

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
		expOutputs[1]="0.381037411251224"
		expOutputs[2]="0.392928584190759"
		expOutputs[3]="0.398037720721121"
		expOutputs[4]="0.399828872371819"
		expOutputs[5]="0.400262454070527"

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
		expOutputs[1]="19.7712639393831"
		expOutputs[2]="19.7693684717688"
		expOutputs[3]="20.0665833731808"
		expOutputs[4]="20.3324221896035"
		expOutputs[5]="20.4962147724924"

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