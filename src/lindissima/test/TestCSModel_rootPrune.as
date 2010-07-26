import as2unit.framework.TestCase;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.test.CornShrubModel;
import lindissima.process.*;
import lindissima.utils.LUtils;
/*
 * Unit test class for the corn shrub model in the case of a root prune
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 05-07-2005
 */
 class lindissima.test.TestCSModel_rootPrune extends TestCase{
	 
	var csm:CornShrubModel;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestCSModel_rootPrune(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		csm = new CornShrubModel("rootPrune");
		
		//select the necesarry init params
		LindApp.selInitParams("rootPrune");
		
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
		expOutputs[1]="0"
		expOutputs[2]="0.0000198343660551299"
		expOutputs[3]="0.0000578348629465645"
		expOutputs[4]="0.0000823269751178291"
		expOutputs[5]="0.000127383162082188"

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
		expOutputs[1]="0"
		expOutputs[2]="0.379482372252507"
		expOutputs[3]="1.20754910806749"
		expOutputs[4]="2.13170409763589"
		expOutputs[5]="3.84752300210248"

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
		expOutputs[1]="0"
		expOutputs[2]="0.32432301073572"
		expOutputs[3]="1.09583003202639"
		expOutputs[4]="2.00445297978452"
		expOutputs[5]="3.73748749211334"

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
		expOutputs[1]="0"
		expOutputs[2]="0.244897210202173"
		expOutputs[3]="0.522862071485285"
		expOutputs[4]="0.667160708878287"
		expOutputs[5]="0.788917648507836"

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
		expOutputs[1]="15.6618509228778"
		expOutputs[2]="27.2671372478172"
		expOutputs[3]="40.4444534868328"
		expOutputs[4]="54.0261224853936"
		expOutputs[5]="78.9300974950207"

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
		expOutputs[1]="0.165030796377246"
		expOutputs[2]="0.296232269209594"
		expOutputs[3]="0.421191043460166"
		expOutputs[4]="0.550837503053212"
		expOutputs[5]="0.772830355053238"

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
		expOutputs[0]="-3.38149077122182"
		expOutputs[1]="112.671372478172"
		expOutputs[2]="244.444534868328"
		expOutputs[3]="380.261224853936"
		expOutputs[4]="629.300974950207"

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
		expOutputs[1]="1"
		expOutputs[2]="1"
		expOutputs[3]="1"
		expOutputs[4]="1"
		expOutputs[5]="1"

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
		expOutputs[1]="495.862386085236"
		expOutputs[2]="0"
		expOutputs[3]="495.996898810384"
		expOutputs[4]="0"
		expOutputs[5]="541.269850420226"
		expOutputs[6]="0"
		expOutputs[7]="673.600506747619"
		expOutputs[8]="0"
		expOutputs[9]="786.617189454504"

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
		expOutputs[2]="0.0711753815079324"
		expOutputs[3]="0.16213464013751"
		expOutputs[4]="0.222015685731905"
		expOutputs[5]="0.283353573131176"

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
		expOutputs[0]="0.04"
		expOutputs[1]="0.04"
		expOutputs[2]="0.04"
		expOutputs[3]="0.04"
		expOutputs[4]="0.04"
		expOutputs[5]="0.04"

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
		expOutputs[1]="2.47931193042618"
		expOutputs[2]="0"
		expOutputs[3]="3.03413071412233"
		expOutputs[4]="0"
		expOutputs[5]="4.057733955988"
		expOutputs[6]="0"
		expOutputs[7]="5.49927910905996"
		expOutputs[8]="0"
		expOutputs[9]="6.82194136466952"

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
		expOutputs[0]="4"
		expOutputs[1]="5.984"
		expOutputs[2]="5.984"
		expOutputs[3]="5.984"
		expOutputs[4]="5.984"
		expOutputs[5]="5.984"

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
		expOutputs[1]="396.689908868189"
		expOutputs[2]="396.801142566753"
		expOutputs[3]="433.019504870678"
		expOutputs[4]="538.884360765067"
		expOutputs[5]="629.298673940951"

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