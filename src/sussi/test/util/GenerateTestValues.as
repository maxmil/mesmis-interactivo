import ascb.util.logging.Logger;
import sussi.process.*;

/*
 * Generates log output for test values. When model is stable can be executed to 
 * help generate the code for unit tests
 *
 * @author Max Pimm
 * @version 1.0
 * @created 26-09-2005
 */
 class sussi.test.util.GenerateTestValues {
	 
	private static var logger:Logger = Logger.getLogger("sussi.test.util.GenerateTestValues");
	
	/*
	 * Constructor, executes all logic
	 */
	function GenerateTestValues(){
		
		logger.debug("instantiating GenerateTestValues");
		
		//define processes to generate with the type of each one
		var procs:Array = new Array();
		procs[0] = Bh1.getProcess();
		procs[1] = Dh1.getProcess();
		procs[2] = Ph1.getProcess();
		procs[3] = Bh2.getProcess();
		procs[4] = Dh2.getProcess();
		procs[5] = Ph2.getProcess();
		procs[6] = Bc.getProcess();
		procs[7] = Dc.getProcess();
		procs[8] = Pc.getProcess();

		for (var i=0; i<procs.length; i++){
			outputProc(procs[i]);
		}
	}
	
	/*
	 * Outputs the expected values for the process
	 * 
	 * @param proc the process
	 */
	private function outputProc(proc:Process):Void{
		
		//initialize
		var className = proc.getName();
		var varName = className.substring(0,1).toLowerCase() + className.substring(1);
		
		logger.debug("	/*");
		logger.debug("	 * Tests the Process: "+className);
		logger.debug("	 */");
		logger.debug("	 public function test"+className+"():Void{");
		logger.debug("");
		logger.debug("		//define process");
		logger.debug("		var "+varName+" = "+className+".getProcess();");
		logger.debug("");
		logger.debug("		//define expected outputs");
		
		//get outputs depending on the type
		var outputs = new Array(6);
		outputs[0] = proc.getOutput(0).toString();
		
		logger.debug("		var expOutputs:Array = new Array(6)");
		logger.debug("		expOutputs[0]=\""+outputs[0]+"\"");
		
		for (var j=1; j<6; j++){
			outputs[j] = proc.getOutput(j*52-1).toString();
			logger.debug("		expOutputs["+j+"]=\""+outputs[j]+"\"");
		}
		logger.debug("");
		
		logger.debug("		//calculate real outputs outputs");
		logger.debug("		var outputs = new Array(6);");
		logger.debug("		outputs[0] = "+varName+".getOutput(0).toString();");
		logger.debug("		for (var i=1; i<6; i++){");
		logger.debug("			outputs[i] = "+varName+".getOutput(i*52-1).toString();");
		logger.debug("		}");
		logger.debug("");
		logger.debug("		//check process");
		logger.debug("		assertEquals(\"Initial output incorrect\", expOutputs[0], outputs[0]);");
		logger.debug("		assertEquals(\"Output after 1 year incorrect\", expOutputs[1], outputs[1]);");
		logger.debug("		assertEquals(\"Output after 2 years incorrect\", expOutputs[2], outputs[2]);");
		logger.debug("		assertEquals(\"Output after 3 years incorrect\", expOutputs[3], outputs[3]);");
		logger.debug("		assertEquals(\"Output after 4 years incorrect\", expOutputs[4], outputs[4]);");
		logger.debug("		assertEquals(\"Output after 5 years incorrect\", expOutputs[5], outputs[5]);");
		
		
		logger.debug("	}");
		logger.debug("");
	}
}