import ascb.util.logging.Logger;
import lindissima.process.*;
import lindissima.Const;
import lindissima.Globals;

/*
 * Generates log output for test values. When model is stable can be executed to 
 * help generate the code for unit tests
 *
 * @author Max Pimm
 * @version 1.0
 * @created 06-07-2005
 */
 class lindissima.test.util.GenerateTestValues {
	 
	private static var logger:Logger = Logger.getLogger("lindissima.test.util.GenerateTestValues");
	
	/*
	 * Constructor, executes all logic
	 */
	function GenerateTestValues(){
		
		logger = lindissima.TestActivity.logger;
		
		logger.debug("instantiating GenerateTestValues");
		
		//define processes to generate with the type of each one
		var procs:Array = new Array(16);
		procs[0] = new Array(NFiltered.getProcess(), "corn-cycle");
		procs[1] = new Array(NInSoil.getProcess(), "all-year");
		procs[2] = new Array(NAvailCorn.getProcess(), "corn-cycle");
		procs[3] = new Array(FNCorn.getProcess(), "corn-cycle");
		procs[4] = new Array(CornBiomass.getProcess(), "corn-cycle");
		procs[5] = new Array(NExtractCorn.getProcess(), "corn-cycle");
		procs[6] = new Array(FarmerNetProfit.getProcess(), "anual");
		procs[7] = new Array(LakeNetProfit.getProcess(), "anual");
		procs[8] = new Array(ExtShrubRoots.getProcess(), "corn-cycle");
		procs[9] = new Array(FolPruneBiomass.getProcess(), "prune-cycle");
		procs[10] = new Array(NAvailShrub.getProcess(), "corn-cycle");
		procs[11] = new Array(NExtractShrub.getProcess(), "corn-cycle");
		procs[12] = new Array(NInPrune.getProcess(), "prune-cycle");
		procs[13] = new Array(ShrubBiomass.getProcess(), "corn-cycle");
		procs[14] = new Array(FNShrub.getProcess(), "corn-cycle");
		procs[15] = new Array(FolPruneOnGround.getProcess(), "corn-cycle");
		

		for (var i=0; i<procs.length; i++){
			outputProc(procs[i]);
		}
	}
	
	/*
	 * Outputs the expected values for the process
	 * 
	 * @param proc the process
	 */
	private function outputProc(procObj:Array):Void{
		
		//initialize
		var proc:Process = procObj[0];
		var type:String = procObj[1];
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
		switch (type){
			case "all-year":
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
			break;
			case "corn-cycle":
				var outputs = new Array(6);
				outputs[0] = proc.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
				
				logger.debug("		var expOutputs:Array = new Array(6)");
				logger.debug("		expOutputs[0]=\""+outputs[0]+"\"");
				
				for (var j=1; j<6; j++){
					outputs[j] = proc.getOutput((j-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
					logger.debug("		expOutputs["+j+"]=\""+outputs[j]+"\"");
				}
				logger.debug("");
				
				logger.debug("		//calculate real outputs outputs");
				logger.debug("		var outputs = new Array(6);");
				logger.debug("		outputs[0] = "+varName+".getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();");
				logger.debug("		for (var i=1; i<6; i++){");
				logger.debug("			outputs[i] = "+varName+".getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();");
				logger.debug("		}");
				logger.debug("");
				logger.debug("		//check process");
				logger.debug("		assertEquals(\"Initial output incorrect\", expOutputs[0], outputs[0]);");
				logger.debug("		assertEquals(\"Output after 1 year incorrect\", expOutputs[1], outputs[1]);");
				logger.debug("		assertEquals(\"Output after 2 years incorrect\", expOutputs[2], outputs[2]);");
				logger.debug("		assertEquals(\"Output after 3 years incorrect\", expOutputs[3], outputs[3]);");
				logger.debug("		assertEquals(\"Output after 4 years incorrect\", expOutputs[4], outputs[4]);");
				logger.debug("		assertEquals(\"Output after 5 years incorrect\", expOutputs[5], outputs[5]);");
			break;
			case "prune-cycle":
				var prunes:Array = Globals.getSelInitParams().getInitParamVal("podasTallo");
				var l:Number = prunes.length*2;
				var outputs:Array = new Array(l);
				
				logger.debug("		var prunes:Array = Globals.getSelInitParams().getInitParamVal(\"podasTallo\");");
				logger.debug("");
				logger.debug("		var expOutputs:Array = new Array("+String(l)+")");
				
				for (var j=0; j<l/2; j++){
					outputs[2*j] = proc.getOutput(prunes[j]-1).toString();
					outputs[2*j+1] = proc.getOutput(prunes[j]).toString();
					logger.debug("		expOutputs["+String(2*j)+"]=\""+outputs[2*j]+"\"");
					logger.debug("		expOutputs["+String(2*j+1)+"]=\""+outputs[2*j+1]+"\"");
				}
				
				logger.debug("");
				
				logger.debug("		//calculate real outputs outputs");
				logger.debug("		var outputs = new Array("+String(l)+");");
				logger.debug("		for (var i=0; i<prunes.length; i++){");
				logger.debug("			outputs[2*i] = "+varName+".getOutput(prunes[i]-1).toString();");
				logger.debug("			outputs[2*i+1] = "+varName+".getOutput(prunes[i]).toString();");
				logger.debug("		}");
				logger.debug("");
				logger.debug("		//check process");
				
				for (var j=0; j<l/2; j++){
					logger.debug("		assertEquals(\"Output week before prune (t="+ String(prunes[j]-1) +")\", expOutputs["+String(2*j)+"], outputs["+String(2*j)+"]);");
					logger.debug("		assertEquals(\"Output for prune week (t="+ String(prunes[j]) +")\", expOutputs["+String(2*j+1)+"], outputs["+String(2*j+1)+"]);");
				}
			break;
			case "anual":
				var outputs = new Array(5);
				outputs[0] = proc.getOutput(0).toString();
				
				logger.debug("		var expOutputs:Array = new Array(6)");
				
				for (var j=0; j<5; j++){
					outputs[j] = proc.getOutput(j).toString();
					logger.debug("		expOutputs["+j+"]=\""+outputs[j]+"\"");
				}
				logger.debug("");
				
				logger.debug("		//calculate real outputs outputs");
				logger.debug("		var outputs = new Array(5);");
				logger.debug("		for (var i=0; i<5; i++){");
				logger.debug("			outputs[i] = "+varName+".getOutput(i).toString();");
				logger.debug("		}");
				
				logger.debug("		//check process");
				logger.debug("		assertEquals(\"Output after 1 year incorrect\", expOutputs[0], outputs[0]);");
				logger.debug("		assertEquals(\"Output after 2 years incorrect\", expOutputs[1], outputs[1]);");
				logger.debug("		assertEquals(\"Output after 3 years incorrect\", expOutputs[2], outputs[2]);");
				logger.debug("		assertEquals(\"Output after 4 years incorrect\", expOutputs[3], outputs[3]);");
				logger.debug("		assertEquals(\"Output after 5 years incorrect\", expOutputs[4], outputs[4]);");
			break;
			default:
			break;
		}
		
		logger.debug("	}");
		logger.debug("");
		logger.debug("");
	}
}