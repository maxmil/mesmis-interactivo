import ascb.util.logging.Logger;
import core.comp.UserMessage;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import core.comp.ResultTable;
import lindissima.utils.LUtils;
import lindissima.comp.cornShrubModel.ExploreCornShrubModel;
import lindissima.process.NFiltered;
import lindissima.process.FarmerNetProfit;
import lindissima.process.LakeNetProfit;
import lindissima.process.NInSoil;
import core.comp.Amoeba;

/*
 * Auxiliar component for exploring the corn model. Shows two graphics. 
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-97-2005
 */
class lindissima.comp.cornShrubModel.ExploreCornShrubModelAmoeba extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornShrubModel.ExploreCornShrubModelAmoeba");

	//parent component
	private var parentComp;
	
	//amoeba values
	private var criteria:Array;
	private var refVals:Array;
	private var altVals:Array;
	private var weights:Array;
	private var weightScale:Number = 60;
	
	//processes
	private var nis:NInSoil;
	private var nf:NFiltered;
	private var fnp:FarmerNetProfit;
	private var lnp:LakeNetProfit;
		
	/*
	 * Constructor
	 */
	public function ExploreCornShrubModelAmoeba() {
		
		//logger = lindissima.TestActivity.logger;
		
		logger.debug("instantiating ExploreCornShrubModelAmoeba");
		
		//initialize satisfaction value and criteria arrays
		this.refVals = new Array();
		this.altVals = new Array();
		this.weights = new Array(1/6, 1/6, 1/6, 1/6, 1/6, 1/6);
		this.criteria = new Array(6);
		this.criteria[0] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.globalEconomic");
		this.criteria[1] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.cornFarmerEconomic");
		this.criteria[2] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.lakeWorkerEconomic");
		this.criteria[3] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.equity");
		this.criteria[4] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.soilConservation");
		this.criteria[5] = LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.lakeConservation");		
		
		//initialize processes
		nis = NInSoil(NInSoil.getProcess());
		fnp = FarmerNetProfit(FarmerNetProfit.getProcess());
		lnp = LakeNetProfit(LakeNetProfit.getProcess());
		nf = NFiltered(NFiltered.getProcess());
		
		//initializes the table of values
		var valTbl = Utils.newObject(ResultTable, this, "valTbl", 1,{_x:3, _y:3, nRows:6, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		valTbl.addCol("criteria", LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.title"), this, this.getTableValue, 212);
		valTbl.addCol("ref", LindApp.getMsg("tbl.col.refSys"), this, this.getTableValue, 140);
		valTbl.addCol("alt", LindApp.getMsg("tbl.col.altSys"), this, this.getTableValue, 140);
		
		//initialize the table of averages
		var avgeTbl = Utils.newObject(ResultTable, this, "avgeTbl", 2,{_x:3, _y:150, nRows:2, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		avgeTbl.addCol("type", LindApp.getMsg("tbl.col.average"), this, this.getTableValueAvge, 212);
		avgeTbl.addCol("ref", LindApp.getMsg("tbl.col.refSys"), this, this.getTableValueAvge, 140);
		avgeTbl.addCol("alt", LindApp.getMsg("tbl.col.altSys"), this, this.getTableValueAvge, 140);

		//create show details button
		var btn_show_details = Utils.newObject(core.comp.BubbleBtn, this, "btn_show_details", 3, {_x:395, _y:215, literal:LindApp.getMsg("btn.showDetails"), callBackObj:this, callBackFunc:showDetails});
		
		//create update reference button
		var btn_update_ref = Utils.newObject(core.comp.BubbleBtn, this, "btn_update_ref", 4, {_x:245, _y:215, literal:LindApp.getMsg("btn.updateRef"), callBackObj:this, callBackFunc:updateRef});
	}
	
	/*
	 * Resets component to its initial conditions
	 */
	public function reset():Void{

		//reset values and weights
		this.refVals.splice(0)
		this.altVals.splice(0);
		this.weights = new Array(1/6, 1/6, 1/6, 1/6, 1/6, 1/6);
		
		//update tables
		this["valTbl"].update();
		this["avgeTbl"].update();
		
		//hide detail
		hideDetails();
	}
	
	/*
	 * Populates the average table
	 * 
	 * @param ind the row index
	 * @param id the column id
	 * @return a string value to be printed in the cell
	 */
	public function getTableValueAvge(ind:Number, id:String):String{
		var ret:Number;
		
		switch (id){
			case "type":
				//get the row criteria
				switch (ind){
					case 0:
						return LindApp.getMsg("cornShrubModel.excercise.amoeba.average.weighted");
					break;
					case 1:
						return LindApp.getMsg("cornShrubModel.excercise.amoeba.average.notWeighted");
					break;
				}
			break;
			case "ref":
				//get the reference system value
				if(this.refVals.length==6){
					if(ind==0){
						ret = getWeightedAverage(this.refVals);
					}else{
						ret = getUnweightedAverage(this.refVals);
					}
				}else{
					return "";
				}
			break;
			case "alt":
				//get the alternative system value
				if(this.altVals.length==6){
					if(ind==0){
						ret = getWeightedAverage(this.altVals);
					}else{
						ret = getUnweightedAverage(this.altVals);
					}
				}else{
					return "";
				}
			break;			
			default:
				return "";
			break
		}
		
		if (ret==undefined){
			return "";
		}
		
		return String(Utils.roundNumber(ret, 2));
	}
	
	/*
	 * Populates the value table
	 * 
	 * @param ind the row index
	 * @param id the column id
	 * @return a string value to be printed in the cell
	 */
	public function getTableValue(ind:Number, id:String):String{
		var ret:Number;
		
		switch (id){
			case "criteria":
				//get the row criteria
				return this.criteria[ind];
			break;
			case "ref":
				//get the reference system value
				ret = this.refVals[ind];
			break;
			case "alt":
				//get the alternative system value
				ret = this.altVals[ind];
			break;
			case "weights":
				ret = this.weights[ind]*this.weightScale;
			break;
			default:
				return "";
			break
		}
		
		if (ret==undefined){
			return "";
		}
		
		return String(Utils.roundNumber(ret, 2));
	}
	
	/*
	 * Gets the weighted average for a criteria
	 */
	private function getWeightedAverage(vals:Array):Number{
		var ret:Number = 0;
		for (var i=0; i<6; i++){
			ret += vals[i]*weights[i];
		}
		return ret;
	}
	
	/*
	 * Gets the unweighted average for a criteria
	 */
	private function getUnweightedAverage(vals:Array):Number{
		var ret:Number = 0;
		for (var i=0; i<6; i++){
			ret += vals[i]/6;
		}
		return ret;
	}
	
	/*
	 * Copies the alternative amoeba to the reference amoeba
	 */
	private function updateRef():Void{
		
		//if alternative is not defined then do nothing
		if(this.altVals.length < 6){
			return;
		}
		
		//copy values
		for (var i=0; i<6; i++){
			this.refVals[i] = this.altVals[i];
		}
		
		//update tables
		this["valTbl"].update();
		this["avgeTbl"].update();
	}
	
	/*
	 * Calculates the alternative amoeba
	 */
	private function calcAltVals():Void{
		
		//calculate the corn farmer economic criteria 
		var avp:Number = fnp.avgeProfit(lindissima.comp.cornShrubModel.ExploreCornShrubModel.nYears)*Const.HECTARES_CORN;
		
		var benNetReqM = LUtils.getIP("benNetReqM");
		var fe:Number = Math.min(100, Math.max(0, 100*(avp-benNetReqM)/(LUtils.getIP("benNetOptM")-benNetReqM)));
		
		//calculate the lake worker economic criteria 
		avp = lnp.avgeProfit(ExploreCornShrubModel.nYears);
		var benNetReqR = LUtils.getIP("benNetReqR");
		var lwe:Number = Math.min(100, Math.max(0, 100*(avp-benNetReqR)/(LUtils.getIP("benNetOptR")-benNetReqR)));
		
		//calculate equity
		var equity:Number = (fe==0 && lwe==0) ? 100 : 100*(1-Math.abs(fe-lwe)/Math.max(fe, lwe));
		
		//calculate global economic satisfaction
		var globalE:Number = (fe+lwe)/2;
		
		//calculate soil conservation
		var sc:Number;
		var nInSoil:Number = this.nis.getBaseLevel(ExploreCornShrubModel.nYears-1);
		var maxN:Number = LUtils.getIP("limN100Sat");
		var minN:Number = LUtils.getIP("limN0Sat");
		if (nInSoil>=maxN){
			sc = 100;
		}else if(nInSoil<=minN){
			sc = 0;
		}else{
			sc = 100*(nInSoil-minN)/(maxN-minN);
		}
		
		//calculate the lake conservation
		var lc:Number;
		var totClear:Number = 0;
		for (var y=0; y<ExploreCornShrubModel.nYears; y++){
			if((LUtils.getIP("algasIni", y)==Const.WEED_CONCENTRATION_LOW && nf.getAcumAnual(y-1)<=LUtils.getIP("nCritBaja")) || (LUtils.getIP("algasIni", y)==Const.WEED_CONCENTRATION_HIGH && nf.getAcumAnual(y-1)<=LUtils.getIP("nCritAlta"))){
				totClear++;
			}
		}
		lc = 100*totClear/ExploreCornShrubModel.nYears
		
		//copy vals to alternative system values
		this.altVals[0] = globalE;
		this.altVals[1] = fe;
		this.altVals[2] = lwe;
		this.altVals[3] = equity;
		this.altVals[4] = sc;
		this.altVals[5] = lc;
		
	}

	/*
	 * Shows amoeba details
	 */
	private function showDetails():Void{
		
		//hide all visible elements in parent component
		this.parentComp.hideAll();
		this.parentComp.removeMsg();
		
		//remove if exists
		if (this.parentComp.amoeba_details){
			this.parentComp.amoeba_details.removeMovieClip();
		}
		
		//create container
		var cont = this.parentComp.createEmptyMovieClip("amoeba_details", this.parentComp.getNextHighestDepth());
		
		//create title
		Utils.createTextField("title", cont, 1, 20, 20, 600, 40, LindApp.getMsg("cornShrubModel.excercise.amoeba.title"), LindApp.getTxtFormat("bigTitleTxtFormat"));
		
		//create the table of values and weights
		var valTbl = Utils.newObject(ResultTable, cont, "valTbl", 3,{_x:20, _y:150, nRows:6, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8, rHeight:30});
		valTbl.addCol("criteria", LindApp.getMsg("cornShrubModel.excercise.amoeba.criteria.title"), this, this.getTableValue, 140);
		valTbl.addCol("ref", LindApp.getMsg("tbl.col.refSys.short"), this, this.getTableValue, 80);
		valTbl.addCol("alt", LindApp.getMsg("tbl.col.altSys.short"), this, this.getTableValue, 80);
		valTbl.addCol("weights", LindApp.getMsg("tbl.col.weights"), this, this.getTableValue, 80, true);
		
		//draw update button
		Utils.newObject(core.comp.BubbleBtn, cont, "btn_update", 4, {literal:LindApp.getMsg("btn.update"), _x: 320, _y:370, callBackObj:this, callBackFunc:this.updateWeights, active:true});
		
		//create the table of averages
		var avgeTbl = Utils.newObject(ResultTable, cont, "avgeTbl", 5,{_x:20, _y:420, nRows:2, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8, rHeight:30});
		avgeTbl.addCol("type", LindApp.getMsg("tbl.col.average"), this, this.getTableValueAvge, 140);
		avgeTbl.addCol("ref", LindApp.getMsg("tbl.col.refSys"), this, this.getTableValueAvge, 120);
		avgeTbl.addCol("alt", LindApp.getMsg("tbl.col.altSys"), this, this.getTableValueAvge, 120);
		
		//create amoeba
		var amoeba = Utils.newObject(Amoeba, cont, "amoeba", 6, {titles:criteria, _x:400, _y:60, radius:190, centerX:300, centerY:220});
		amoeba.addAmoeba("refSys", LindApp.getMsg("tbl.col.refSys"), 0xcc00ff, this.refVals);
		amoeba.addAmoeba("altSys", LindApp.getMsg("tbl.col.altSys"), 0x00ccff, this.altVals);
		
		//draw back button
		Utils.newObject(core.comp.EyeBtn, cont, "btn_back_amoeba", 7, {literal:LindApp.getMsg("btn.previous"), _x: 870, _y:550, callBackObj:this, callBackFunc:this.hideDetails, active:true});
	}
	
	/*
	 * Removes the details
	 */
	public function hideDetails():Void{
		
		//show all visible elements in parent component
		this.parentComp.showAll();
		
		//remove details
		this.parentComp["amoeba_details"].removeMovieClip();
	}

	/*
	 * Updates the values in the alternative amoeba and refreshes all visible components
	 */
	public function update():Void{
		
		//update values in alternative amoeba
		calcAltVals();
		
		//update tables
		this["valTbl"].update();
		this["avgeTbl"].update();
		
	}
	
	/*
	 * Updates the weights and average tables
	 */
	public function updateWeights():Void{
		
		//remove errors if exist
		if (this.parentComp["errorMsg"]){
			this.parentComp["errorMsg"].removeMovieClip();
		}
		
		//read new weights
		var newWeights:Array = new Array(6);
		var tot:Number = 0;
		for (var i=0; i<6; i++){
			newWeights[i] = Number(this.parentComp.amoeba_details.valTbl["weights_row_" + String(i)].text);
			tot += newWeights[i];
		}
		
		//check that weights sum to this.weightScale
		if (Math.round(tot)!=this.weightScale){
			Utils.newObject(UserMessage, this.parentComp, "errorMsg", this.parentComp.getNextHighestDepth(), {txt:LindApp.getMsg("cornShrubModel.excercise.amoeba.error.weightSum"), _x:200, _y:200, w:250, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			return;
		}
		
		//copy to weights
		for (var i=0; i<6; i++){
			this.weights[i] = newWeights[i]/this.weightScale;
		}
		
		//update
		this["avgeTbl"].update();
		this.parentComp.amoeba_details.avgeTbl.update();
	}

}
