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
 class lindissima.test.TestCSModel_default extends TestCase{
	 
	var csm:CornShrubModel;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestCSModel_default(methodName:String){
				
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
	 * Tests the Process: NFiltered
	 */
	 public function testNFiltered():Void{

		//define process
		var nFiltered = NFiltered.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="0.02"
		expOutputs[1]="0"
		expOutputs[2]="0.0000249896735779781"
		expOutputs[3]="0.0000627213930980141"
		expOutputs[4]="0.000104028357443679"
		expOutputs[5]="0.000179170083448826"

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
		expOutputs[2]="0.4854298058197"
		expOutputs[3]="1.45680404776562"
		expOutputs[4]="3.08231495676474"
		expOutputs[5]="6.02645600585212"

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
		expOutputs[0]="1"
		expOutputs[1]="0"
		expOutputs[2]="0.323148518740544"
		expOutputs[3]="1.07290945074005"
		expOutputs[4]="2.48126576769053"
		expOutputs[5]="5.28575868567767"

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
		expOutputs[0]="0.5"
		expOutputs[1]="0"
		expOutputs[2]="0.244226943660215"
		expOutputs[3]="0.517586260392133"
		expOutputs[4]="0.712748159223879"
		expOutputs[5]="0.840910214660557"

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
		expOutputs[1]="7.75279880653015"
		expOutputs[2]="11.040269020232"
		expOutputs[3]="15.6232930480765"
		expOutputs[4]="22.6702319062227"
		expOutputs[5]="37.3775338726546"

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
		expOutputs[1]="0.0833667950862577"
		expOutputs[2]="0.108673438072129"
		expOutputs[3]="0.148070685204668"
		expOutputs[4]="0.210818901746985"
		expOutputs[5]="0.332328928407136"

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

		//TODO: Update new values having changed code - do other test cases aswell
		/*
			..........F..............................
			..F................F........
			Time: 132.57 seconds
			There were 3 failures:
			1) testFarmerNetProfit (lindissima.test.TestCSModel_default)
				Output after 1 year incorrect - expected:<-2.47201193469849> but was:<-722.472011934698>
			2) testFarmerNetProfit (lindissima.test.TestCSModel_fertilizer)
				Output after 1 year incorrect - expected:<-468.885769686633> but was:<-1188.88576968663>
			3) testFarmerNetProfit (lindissima.test.TestCSModel_rootPrune)
				Output after 1 year incorrect - expected:<-3.38149077122182> but was:<-1443.38149077122>

			FAILURES!!!
			Tests run: 66,  Failures: 3,  Errors: 0
		*/

		//define process
		var farmerNetProfit = FarmerNetProfit.getProcess();

		//define expected outputs
		var expOutputs:Array = new Array(6)
		expOutputs[0]="-2.47201193469849"
		expOutputs[1]="30.4026902023197"
		expOutputs[2]="76.2329304807648"
		expOutputs[3]="146.702319062227"
		expOutputs[4]="293.775338726546"

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
		expOutputs[0]="1"
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
		expOutputs[1]="495.937474860417"
		expOutputs[2]="0"
		expOutputs[3]="496.001495727211"
		expOutputs[4]="0"
		expOutputs[5]="588.941561580483"
		expOutputs[6]="0"
		expOutputs[7]="751.187409059628"
		expOutputs[8]="0"
		expOutputs[9]="853.103110465153"

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
		expOutputs[0]="1"
		expOutputs[1]="0"
		expOutputs[2]="0.175151595726495"
		expOutputs[3]="0.410943463293671"
		expOutputs[4]="0.654951145417464"
		expOutputs[5]="0.846229718709068"

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
		expOutputs[1]="2.58476060526435"
		expOutputs[2]="0"
		expOutputs[3]="3.35829150427945"
		expOutputs[4]="0"
		expOutputs[5]="4.84273324211405"
		expOutputs[6]="0"
		expOutputs[7]="6.57503562081791"
		expOutputs[8]="0"
		expOutputs[9]="7.82298737571572"

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
		expOutputs[1]="396.749979888333"
		expOutputs[2]="396.804820648927"
		expOutputs[3]="471.156873832481"
		expOutputs[4]="600.954230976093"
		expOutputs[5]="682.487977719576"

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