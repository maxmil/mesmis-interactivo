import as2unit.framework.TestCase;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.test.CornShrubModel;
import lindissima.process.*;
import lindissima.utils.LUtils;
/*
 * Unit test class for the corn shrub model with foliage prunes
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 05-07-2005
 */
 class lindissima.test.TestCSModel_fertilizer extends TestCase{
	 
	var csm:CornShrubModel;
	
	/*
	 * Constructor
	 * 
	 * @param methodName 
	 */
	public function TestCSModel_fertilizer(methodName:String){
				
		//call superclass constructor
		super( methodName );
		
	}
	
	/*
	 * Set up the test by defining and selecting the corresponding initial parameters
	 * and clearing all previous outputs
	 */
	public function setUp():Void{
		
		//define a new corn model with no fertilizer
		csm = new CornShrubModel("fertilizer");
		
		//select the necesarry init params
		LindApp.selInitParams("fertilizer");
		
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
		expOutputs[0]="0.17"
		expOutputs[1]="0.000186579606465798"
		expOutputs[2]="0.000538648424174958"
		expOutputs[3]="0.000827760116382869"
		expOutputs[4]="0.00105207722846138"
		expOutputs[5]="0.00122836466789576"

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
		expOutputs[0]="17"
		expOutputs[1]="6.31500420353818"
		expOutputs[2]="19.9295895558946"
		expOutputs[3]="31.3383460323256"
		expOutputs[4]="40.2782651604032"
		expOutputs[5]="47.3186679447973"

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
		expOutputs[0]="8.5"
		expOutputs[1]="5.57893838507032"
		expOutputs[2]="19.7904564555207"
		expOutputs[3]="31.2175158063242"
		expOutputs[4]="40.0479419047154"
		expOutputs[5]="46.9858751045088"

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
		expOutputs[0]="0.894736842105263"
		expOutputs[1]="0.847999792448381"
		expOutputs[2]="0.951901007938935"
		expOutputs[3]="0.96896098364593"
		expOutputs[4]="0.975638242659734"
		expOutputs[5]="0.979160534265092"

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
		expOutputs[1]="39.372292596554"
		expOutputs[2]="195.151564342007"
		expOutputs[3]="289.288353108138"
		expOutputs[4]="326.646546876415"
		expOutputs[5]="345.455763547285"

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
		expOutputs[1]="0.349354973662084"
		expOutputs[2]="2.28413705209828"
		expOutputs[3]="3.82623950243744"
		expOutputs[4]="4.51023545090162"
		expOutputs[5]="4.87476780586938"

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
		expOutputs[0]="-468.885769686633"
		expOutputs[1]="1088.9069477679"
		expOutputs[2]="2030.27483542921"
		expOutputs[3]="2403.85677311197"
		expOutputs[4]="2591.94893982067"

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
		expOutputs[0]="0"
		expOutputs[1]="0"
		expOutputs[2]="0"
		expOutputs[3]="0"
		expOutputs[4]="0"

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
		expOutputs[1]="858.640956962445"
		expOutputs[2]="0"
		expOutputs[3]="944.180996908271"
		expOutputs[4]="0"
		expOutputs[5]="959.825060284735"
		expOutputs[6]="0"
		expOutputs[7]="966.564578544404"
		expOutputs[8]="0"
		expOutputs[9]="970.324559890669"

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
		expOutputs[0]="8.5"
		expOutputs[1]="0.847915249395018"
		expOutputs[2]="0.606841619892381"
		expOutputs[3]="0.645741913139567"
		expOutputs[4]="0.73365809817817"
		expOutputs[5]="0.813891404613652"

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
		expOutputs[1]="7.89880829253287"
		expOutputs[2]="0"
		expOutputs[3]="9.13674924831686"
		expOutputs[4]="0"
		expOutputs[5]="9.38946510292392"
		expOutputs[6]="0"
		expOutputs[7]="9.49586053337637"
		expOutputs[8]="0"
		expOutputs[9]="9.55461833381336"

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
		expOutputs[0]="0.894736842105263"
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
		expOutputs[1]="686.912765569956"
		expOutputs[2]="755.351072052439"
		expOutputs[3]="767.866947895467"
		expOutputs[4]="773.258676828033"
		expOutputs[5]="776.266711155174"

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