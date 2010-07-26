import as2unit.framework.TestCase;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.test.CornShrubModel;
import lindissima.process.*;
import lindissima.utils.LUtils;
/*
 * Unit test class for the corn shrub model default parameters
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 05-07-2005
 */
 class lindissima.test.TestCSModel_noShrub extends TestCase{
	 
	var csm:CornShrubModel;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestCSModel_noShrub(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		csm = new CornShrubModel("noShrub");
		
		//select the necesarry init params
		LindApp.selInitParams("noShrub");
		
		//clear outputs
		LUtils.clearOutputs();
	}

	/*
	 * Tests the Process: NFiltered
	 */
	 public function testNFiltered():Void{

		//define process
		var nFiltered = NFiltered.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0.02"
		expOutputs[1]="0.00660998301702985"
		expOutputs[2]="0.00324751197925695"
		expOutputs[3]="0.00174472975266763"
		expOutputs[4]="0.000802808912484479"
		expOutputs[5]="0.000118965801313116"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = nFiltered.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nFiltered.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: NInSoil
	 */
	 public function testNInSoil():Void{

		//define process
		var nInSoil = NInSoil.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="2"
		expOutputs[1]="0.616171603985078"
		expOutputs[2]="0.315124728542926"
		expOutputs[3]="0.171625342112805"
		expOutputs[4]="0.0793299822083469"
		expOutputs[5]="0.0117768725446473"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = nInSoil.getOutput(0).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nInSoil.getOutput(i*52-1).toString();
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
	 * Tests the Process: NAvailCorn
	 */
	 public function testNAvailCorn():Void{

		//define process
		var nAvailCorn = NAvailCorn.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="2"
		expOutputs[1]="0.660998301702985"
		expOutputs[2]="0.324751197925695"
		expOutputs[3]="0.174472975266763"
		expOutputs[4]="0.0802808912484479"
		expOutputs[5]="0.0118965801313116"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = nAvailCorn.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nAvailCorn.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: FNCorn
	 */
	 public function testFNCorn():Void{

		//define process
		var fNCorn = FNCorn.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0.666666666666667"
		expOutputs[1]="0.397952424770861"
		expOutputs[2]="0.245141275157322"
		expOutputs[3]="0.148554269822287"
		expOutputs[4]="0.0743148304286579"
		expOutputs[5]="0.0117567154241867"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = fNCorn.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = fNCorn.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: CornBiomass
	 */
	 public function testCornBiomass():Void{

		//define process
		var cornBiomass = CornBiomass.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="4"
		expOutputs[1]="122.348284674021"
		expOutputs[2]="29.9938337028898"
		expOutputs[3]="12.8816898306445"
		expOutputs[4]="6.95345482788235"
		expOutputs[5]="4.14827459496134"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = cornBiomass.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = cornBiomass.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: NExtractCorn
	 */
	 public function testNExtractCorn():Void{

		//define process
		var nExtractCorn = NExtractCorn.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0.064"
		expOutputs[1]="1.0742983538781"
		expOutputs[2]="0.185399170523647"
		expOutputs[3]="0.0882683979774285"
		expOutputs[4]="0.067999279468682"
		expOutputs[5]="0.0640320046619369"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = nExtractCorn.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nExtractCorn.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: FarmerNetProfit
	 */
	 public function testFarmerNetProfit():Void{

		//define process
		var farmerNetProfit = FarmerNetProfit.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="1223.48284674021"
		expOutputs[1]="299.938337028898"
		expOutputs[2]="128.816898306445"
		expOutputs[3]="69.5345482788235"
		expOutputs[4]="41.4827459496134"

		//calculate real outputs outputs
		var outputs = new Array(5);
		for (var i=0; i<5; i++){
			outputs[i] = farmerNetProfit.getOutput(i).toString();
		}
		//check process
		assertEquals("Output after 1 year incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 2 years incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 3 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 4 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 5 years incorrect", expOutputs[4], outputs[4]);
	}


	/*
	 * Tests the Process: LakeNetProfit
	 */
	 public function testLakeNetProfit():Void{

		//define process
		var lakeNetProfit = LakeNetProfit.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="32000"
		expOutputs[1]="32000"
		expOutputs[2]="32000"
		expOutputs[3]="32000"
		expOutputs[4]="32000"

		//calculate real outputs outputs
		var outputs = new Array(5);
		for (var i=0; i<5; i++){
			outputs[i] = lakeNetProfit.getOutput(i).toString();
		}
		//check process
		assertEquals("Output after 1 year incorrect", expOutputs[0], outputs[0]);
		assertEquals("Output after 2 years incorrect", expOutputs[1], outputs[1]);
		assertEquals("Output after 3 years incorrect", expOutputs[2], outputs[2]);
		assertEquals("Output after 4 years incorrect", expOutputs[3], outputs[3]);
		assertEquals("Output after 5 years incorrect", expOutputs[4], outputs[4]);
	}


	/*
	 * Tests the Process: ExtShrubRoots
	 */
	 public function testExtShrubRoots():Void{

		//define process
		var extShrubRoots = ExtShrubRoots.getProcess();

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
		outputs[0] = extShrubRoots.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = extShrubRoots.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: FolPruneBiomass
	 */
	 public function testFolPruneBiomass():Void{

		//define process
		var folPruneBiomass = FolPruneBiomass.getProcess();

		//define expected outputs
		var prunes:Array = LUtils.getIPArray("podasTallo");

		var expOutputs:Array = new Array(10)
		expOutputs[0]="0"
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"
		expOutputs[5]="0"
		expOutputs[6]="0"
		expOutputs[7]="0"
		expOutputs[8]="0"
		expOutputs[9]="0"

		//calculate real outputs outputs
		var outputs = new Array(10);
		for (var i=0; i<prunes.length; i++){
			outputs[2*i] = folPruneBiomass.getOutput(prunes[i]-1).toString();
			outputs[2*i+1] = folPruneBiomass.getOutput(prunes[i]).toString();
		}
		//check process
		assertEquals("Output week before prune (t=40)", expOutputs[0], outputs[0]);
		assertEquals("Output for prune week (t=41)", expOutputs[1], outputs[1]);
		assertEquals("Output week before prune (t=92)", expOutputs[2], outputs[2]);
		assertEquals("Output for prune week (t=93)", expOutputs[3], outputs[3]);
		assertEquals("Output week before prune (t=144)", expOutputs[4], outputs[4]);
		assertEquals("Output for prune week (t=145)", expOutputs[5], outputs[5]);
		assertEquals("Output week before prune (t=196)", expOutputs[6], outputs[6]);
		assertEquals("Output for prune week (t=197)", expOutputs[7], outputs[7]);
		assertEquals("Output week before prune (t=248)", expOutputs[8], outputs[8]);
		assertEquals("Output for prune week (t=249)", expOutputs[9], outputs[9]);
	}


	/*
	 * Tests the Process: NAvailShrub
	 */
	 public function testNAvailShrub():Void{

		//define process
		var nAvailShrub = NAvailShrub.getProcess();

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
		outputs[0] = nAvailShrub.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nAvailShrub.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: NExtractShrub
	 */
	 public function testNExtractShrub():Void{

		//define process
		var nExtractShrub = NExtractShrub.getProcess();

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
		outputs[0] = nExtractShrub.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = nExtractShrub.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: NInPrune
	 */
	 public function testNInPrune():Void{

		//define process
		var nInPrune = NInPrune.getProcess();

		//define expected outputs
		var prunes:Array = LUtils.getIPArray("podasTallo");

		var expOutputs:Array = new Array(10)
		expOutputs[0]="0"
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"
		expOutputs[5]="0"
		expOutputs[6]="0"
		expOutputs[7]="0"
		expOutputs[8]="0"
		expOutputs[9]="0"

		//calculate real outputs outputs
		var outputs = new Array(10);
		for (var i=0; i<prunes.length; i++){
			outputs[2*i] = nInPrune.getOutput(prunes[i]-1).toString();
			outputs[2*i+1] = nInPrune.getOutput(prunes[i]).toString();
		}
		//check process
		assertEquals("Output week before prune (t=40)", expOutputs[0], outputs[0]);
		assertEquals("Output for prune week (t=41)", expOutputs[1], outputs[1]);
		assertEquals("Output week before prune (t=92)", expOutputs[2], outputs[2]);
		assertEquals("Output for prune week (t=93)", expOutputs[3], outputs[3]);
		assertEquals("Output week before prune (t=144)", expOutputs[4], outputs[4]);
		assertEquals("Output for prune week (t=145)", expOutputs[5], outputs[5]);
		assertEquals("Output week before prune (t=196)", expOutputs[6], outputs[6]);
		assertEquals("Output for prune week (t=197)", expOutputs[7], outputs[7]);
		assertEquals("Output week before prune (t=248)", expOutputs[8], outputs[8]);
		assertEquals("Output for prune week (t=249)", expOutputs[9], outputs[9]);
	}


	/*
	 * Tests the Process: ShrubBiomass
	 */
	 public function testShrubBiomass():Void{

		//define process
		var shrubBiomass = ShrubBiomass.getProcess();

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
		outputs[0] = shrubBiomass.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = shrubBiomass.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: FNShrub
	 */
	 public function testFNShrub():Void{

		//define process
		var fNShrub = FNShrub.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0.5"
		expOutputs[1]="0.5"
		expOutputs[2]="0.5"
		expOutputs[3]="0.5"
		expOutputs[4]="0.5"
		expOutputs[5]="0.5"

		//calculate real outputs outputs
		var outputs = new Array(6);
		outputs[0] = fNShrub.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = fNShrub.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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
	 * Tests the Process: FolPruneOnGround
	 */
	 public function testFolPruneOnGround():Void{

		//define process
		var folPruneOnGround = FolPruneOnGround.getProcess();

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
		outputs[0] = folPruneOnGround.getOutput(Const.WEEK_BEGIN_CORN_CYCLE).toString();
		for (var i=1; i<6; i++){
			outputs[i] = folPruneOnGround.getOutput((i-1)*52+Const.WEEK_END_CORN_CYCLE).toString();
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