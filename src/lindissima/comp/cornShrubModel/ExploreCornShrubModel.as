import ascb.util.logging.Logger;
import core.util.Utils;
import core.util.Proxy;
import core.comp.BubbleBtn;
import core.comp.TextPane;
import core.comp.ComponentWindow;
import core.comp.UserMessage;
import lindissima.comp.cornShrubModel.ExploreCornShrubModelAuxGraphs;
import lindissima.comp.cornShrubModel.ExploreCornShrubModelAnualDetail;
import lindissima.comp.cornShrubModel.ExploreCornShrubModelAmoeba;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.model.InitParam;
import core.comp.Graph;
import core.comp.ResultTable;
import lindissima.process.NFiltered;
import lindissima.process.FarmerNetProfit;
import lindissima.process.LakeNetProfit;
import lindissima.process.NInSoil;
import lindissima.utils.LUtils;



/*
 * Component for exploring the corn model. Offers an input box so that the user can define the
 * anual amount of fertilizer and shows graphics that allow user to see how the fertilizer affects
 * the amount of nitrogen in the soil and the net profit of the corn farmer, and a table for a more
 * detailed analysis of certain values. Whats more it offers a system for saving values obtained by
 * running the model with different levels of fertilizer, producing a sequence of points in a graphic
 * relating net profit to fertilizer levels.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-97-2005
 */
class lindissima.comp.cornShrubModel.ExploreCornShrubModel extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornModel.ExploreCornShrubModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var nis:NInSoil;
	private var fnp:FarmerNetProfit;
	private var lnp:LakeNetProfit;
	private var nf:NFiltered;
	
	//constants
	public static var nYears:Number = 5;
	
	//parameters
	public var savedVals:Array;
	public var monoVals:Array;
	
	//initial parameter values
	private var initVals:Array;
	
	//solution array
	private var sol:Array;

	/*
	 * Constructor
	 */
	public function ExploreCornShrubModel() {
		
		logger.debug("instantiating ExploreCornShrubModel");
		
		//initialize solution
		var sols:Array = LUtils.getIPArray("csmSoluciones");
		var solIndex:Number = Math.floor(Math.random()*sols.length);
		sol = sols[solIndex].split(";");
		
		//set shrub minimum f(N)
		LUtils.setIP("fnA_fnMin", sol[0]);
		
		//set nitrogen to 0
		LUtils.getIPObj("nAnual").setArrVal(new Array(0, 0, 0, 0, 0));
		
		//initialize saved values
		savedVals = new Array();
		
		//initialize processes
		nis = NInSoil(NInSoil.getProcess());
		fnp = FarmerNetProfit(FarmerNetProfit.getProcess());
		lnp = LakeNetProfit(LakeNetProfit.getProcess());
		nf = NFiltered(NFiltered.getProcess());

		//create the he net profit vs nitrogen graphic.
		initGraph();
		
		//initialize input parameters area
		initInputParams();
		
		//init detail table
		initDetailTable();
		
		//init random generator
		initRandomGenerator();
		
		//init amoeba
		Utils.newObject(ComponentWindow, this, "amoeba", this.getNextHighestDepth(), {_x:440, _y:270, w:500, h:275, compClass:ExploreCornShrubModelAmoeba, btnClose:false, btnMinMax:false, resize:false, allowDrag:true, titleTxt:LindApp.getMsg("cornShrubModel.excercise.amoeba.title"), bgColor:0xffffff, compProps:new Object({parentComp:this})});

		//activate or desactivate depending on value of active
		(active) ? activate() : desactivate();
	}

	/*
	 * Activates the component
	 */
	public function activate():Void{
		
		//delete onRelease handler for this
		delete this.onRelease;
		
		//reset flag
		this.active = true;
	}
		
	/*
	 * Desactivate the component
	 */
	public function desactivate():Void{
		
		//create onRelease handler for this and set cursor to arrow
		this.onRelease = function(){}
		this.useHandCursor = false;
		
		//reset flag
		this.active = false;
	}
	
	/*
	 * Resets component to its initial conditions
	 */
	public function reset():Void{
		
		//remove msg
		removeMsg();

		//reset initial parameters
		this["inPrms_tp"].getContent().nitrogen_ib.text = initVals[0].toString();
		this["inPrms_tp"].getContent().shrubDensity_ib.text = initVals[1].toString();
		this["inPrms_tp"].getContent().nFolPrune_ib.text = initVals[2].toString();
		this["inPrms_tp"].getContent().percentRootPrune_ib.text = initVals[3].toString();
		this["inPrms_tp"].getContent().aidFolPrune_ib.text = initVals[4].toString();
		this["inPrms_tp"].getContent().aidRootPrune_ib.text = initVals[5].toString();
		
		//clear graphic
		this.savedVals.splice(0);
		updateParamsComboBox();
		this["npvnGraph"].update();
		
		//clear random initial condition
		if (this["rg_tp"].getContent().randomMarbles){
			this["rg_tp"].getContent().randomMarbles.removeMovieClip();
		}
		
		//clear detail table
		this["detail_tp"].getContent().detailTbl.clearValues();
		
		//reset amoeba
		this["amoeba"].comp.reset()
		
		//remove mono cultivo curve
		this["npvnGraph"].removeGraphic("monoCurve");
		this["monoCurveGenerator"].removeMovieClip();
		
		//remove components
		if (this["anualDetail"]){
			this["anualDetail"].removeMovieClip();
		}
		if(this["auxGraphs"]){
			this["auxGraphs"].removeMovieClip();
		}
		if (this["const_vals_tp"]){
			this["const_vals_tp"].removeMovieClip();
		}
		
	}
	
	/*
	 * Initializes the net profit vs nitrogen graphic. This graphic shows the sequence of points saved by the user
	 */
	private function initGraph():Void{
		
		//create graph with graphic
		var npvnGraph = Utils.newObject(Graph, this, "npvnGraph", this.getNextHighestDepth(), {_x:440, _y:10, w:500, h:250, xAxisRange:4, xAxisScale:0.5, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.netProfitVsNitGraph.xAxis"), yAxisRange:4000, yAxisScale:200, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.netProfitVsNitGraph.yAxis"), drwBorder:true});
		npvnGraph.addGraphicFromArray("npvnGraphic", 0x0000ff, this.savedVals, 0, 5); 
		
		//create background
		var bg = npvnGraph["bg"].createEmptyMovieClip("lakeStateBg", npvnGraph["bg"].getNextHighestDepth());
		
		//initializations
		LindApp.getTxtFormat("smallTxtFormat").align = "center"
		var xBase:Number;
		var yBase:Number = npvnGraph.getYPos(0)-1;
		var xLimit:Number;
		var yLimit:Number = npvnGraph.getYPos(npvnGraph.yAxisRange); 
		
		//create stable clear region
		xBase = npvnGraph.getXPos(0)+1;
		xLimit = npvnGraph.getXPos(LUtils.getIP("nCritAlta"));
		bg.lineStyle(1, Const.CLEAR_LAKE_COLOR, 100);
		bg.beginFill(Const.CLEAR_LAKE_COLOR, 10);
		bg.moveTo(xBase, yBase);
		bg.lineTo(xBase, yLimit);
		bg.lineTo(xLimit, yLimit);
		bg.lineTo(xLimit, yBase);
		bg.lineTo(xBase, yBase);
		bg.endFill();
		LindApp.getTxtFormat("smallTxtFormat").color = Const.CLEAR_LAKE_COLOR;
		Utils.createTextField("clear_stable", bg, bg.getNextHighestDepth(), xBase, yLimit+20, xLimit-xBase, 1, LindApp.getMsg("cornShrubModel.excercise.netProfitVsNitGraph.stableClearLake"), LindApp.getTxtFormat("smallTxtFormat"));
		
		//create bistable region
		xBase = npvnGraph.getXPos(LUtils.getIP("nCritAlta"))+1;
		xLimit = npvnGraph.getXPos(LUtils.getIP("nCritBaja"));
		bg.lineStyle(1, (Const.MIRKY_LAKE_COLOR+Const.CLEAR_LAKE_COLOR)/2, 100);
		bg.beginFill((Const.MIRKY_LAKE_COLOR+Const.CLEAR_LAKE_COLOR)/2, 10);
		bg.moveTo(xBase, yBase);
		bg.lineTo(xBase, yLimit);
		bg.lineTo(xLimit, yLimit);
		bg.lineTo(xLimit, yBase);
		bg.lineTo(xBase, yBase);
		bg.endFill();
		LindApp.getTxtFormat("smallTxtFormat").color = (Const.MIRKY_LAKE_COLOR+Const.CLEAR_LAKE_COLOR)/2;
		Utils.createTextField("bistable", bg, bg.getNextHighestDepth(), xBase, yLimit+20, xLimit-xBase, 1, LindApp.getMsg("cornShrubModel.excercise.netProfitVsNitGraph.bistableLake"), LindApp.getTxtFormat("smallTxtFormat"));

		//create mirky stable region
		xBase = npvnGraph.getXPos(LUtils.getIP("nCritBaja"))+1;
		xLimit = npvnGraph.getXPos(npvnGraph.xAxisRange);
		bg.lineStyle(1, Const.MIRKY_LAKE_COLOR, 100);
		bg.beginFill(Const.MIRKY_LAKE_COLOR, 10);
		bg.moveTo(xBase, yBase);
		bg.lineTo(xBase, yLimit);
		bg.lineTo(xLimit, yLimit);
		bg.lineTo(xLimit, yBase);
		bg.lineTo(xBase, yBase);
		bg.endFill();
		LindApp.getTxtFormat("smallTxtFormat").color = Const.MIRKY_LAKE_COLOR;
		Utils.createTextField("mirky_stable", bg, bg.getNextHighestDepth(), xBase, yLimit+20, xLimit-xBase, 1, LindApp.getMsg("cornShrubModel.excercise.netProfitVsNitGraph.stableMirkyLake"), LindApp.getTxtFormat("smallTxtFormat"));
		LindApp.getTxtFormat("smallTxtFormat").color = Const.DEFAULT_BORDER_COLOR;
	}
	
	/*
	 * Initializes the input parameters area
	 */
	private function initInputParams():Void{
		
		//create text pane container
		var tp = Utils.newObject(TextPane, this, "inPrms_tp", this.getNextHighestDepth(), {_x:10, _y:10, w:420, h:315, titleTxt:LindApp.getMsg("cornShrubModel.excercise.inputParams.title"), allowDrag:true, resize:false, btnMinMax:false, doScroll:false, bgColor:0xffffff})
		
		//spacing between lines and top padding
		var lSpacing:Number = 30;
		var tPadding:Number = 5;
		
		//create container clip
		var inPrms = tp.getContent();
		
		//create array of input params
		var ids:Array = new Array(6);
		ids[0] = "nitrogen";
		ids[1] = "shrubDensity";
		ids[2] = "nFolPrune";
		ids[3] = "percentRootPrune";
		ids[4] = "aidFolPrune";
		ids[5] = "aidRootPrune";
		
		//create array of initial values
		initVals = new Array(6);
		initVals[0] = LUtils.getIP("nAnual", 0);
		initVals[1] = LUtils.getIP("densA");
		initVals[2] = LUtils.getIPArray("podasTallo").length/nYears;
		initVals[3] = LUtils.getIP("podasRaiz")*100;
		initVals[4] = LUtils.getIP("sbsdPodTallo");
		initVals[5] = LUtils.getIP("sbsdPodRaiz");
		
		//draw literals and fields with initial values
		var tfId:String;
		for (var i=0; i<6; i++){
		
			//create literal text field
			Utils.createTextField(ids[i]+"_lit", inPrms, 2*(i+1), 0, lSpacing*i+tPadding, 350, 20, LindApp.getMsg("cornShrubModel.excercise.inputParam."+ids[i]), LindApp.getTxtFormat("defaultTxtFormat"));
			
			//create input box
			tfId = ids[i]+"_ib";
			inPrms.createTextField(tfId, 2*(i+1)-1, 350, lSpacing*i+tPadding, 50, 20);			
			LindApp.getTxtFormat("defaultTxtFormat").align = "center";
			inPrms[tfId].setNewTextFormat(LindApp.getTxtFormat("defaultTxtFormat"));
			LindApp.getTxtFormat("defaultTxtFormat").align = "left";
			inPrms[tfId].text = String(initVals[i]);
			inPrms[tfId].embedFonts = true;
			inPrms[tfId].autoSize = false;
			inPrms[tfId].border = true;
			inPrms[tfId].borderColor = Const.DEFAULT_BORDER_COLOR;
			inPrms[tfId].type = "input";
		}
		
		//get height so far
		var paramH:Number = inPrms._height+10;
		
		//create reload parameters drop down
		var l:Number = this.savedVals.length;
		var labelArray:Array = new Array(l+1);
		labelArray[0] = LindApp.getMsg("cornShrubModel.excercise.reloadParametersDropDown.default");
		for (var i=0; i<l; i++){
			labelArray[i+1] = LindApp.getMsg("cornShrubModel.excercise.reloadParametersDropDown", new Array(this.savedVals[i].x, this.savedVals[i].y)); 
		}
		Utils.createTextField("rp_lit", inPrms, inPrms.getNextHighestDepth(), 0, paramH+10, 200, 1, LindApp.getMsg("cornShrubModel.excercise.reloadParametersLiteral"), LindApp.getTxtFormat("defaultTxtFormat"));
		var cb:mx.controls.ComboBox = inPrms.createClassObject(mx.controls.ComboBox, "rp_cb", inPrms.getNextHighestDepth(), {labels:labelArray, _x:140, _y:paramH+10, _width:270});
		var lstnr:Object = new Object();
		lstnr.change = Proxy.create(this, this.reloadParams);
		cb.addEventListener("change", lstnr);

		//redefine height
		paramH = inPrms._height+25;
		
		//create remove function
		var removeFunc:Function = function(){
			this.savedVals.pop();
			this["npvnGraph"].update();
			this.updateParamsComboBox();
		}
		//create remove button
		var btn_remove_last = Utils.newObject(BubbleBtn, inPrms, "btn_remove_last", inPrms.getNextHighestDepth(), {_x:20, _y:paramH, w:100, literal:LindApp.getMsg("btn.removeLast"), callBackObj:this, callBackFunc:removeFunc});
		
		//create remove all function
		var removeAllFunc:Function = function(){
			this.savedVals.splice(0);
			this["npvnGraph"].update();
			this.updateParamsComboBox();
		}
		//create remove button
		var btn_remove_all = Utils.newObject(BubbleBtn, inPrms, "btn_remove_all", inPrms.getNextHighestDepth(), {_x:150, _y:paramH, w:100, literal:LindApp.getMsg("btn.removeAll"), callBackObj:this, callBackFunc:removeAllFunc});

		//draw generate button
		var btn_gen = Utils.newObject(core.comp.BubbleBtn, inPrms, "btn_gen", inPrms.getNextHighestDepth(), {_x:280, _y:paramH, w:100, literal:LindApp.getMsg("btn.generate"), callBackObj:this, callBackFunc:this.runModel});

		//redefine height
		paramH = inPrms._height;

		//create "consult constant values" button
		var mc_const_vals = inPrms.createEmptyMovieClip("mc_const_vals", inPrms.getNextHighestDepth())
		Utils.createTextField("btn_const_vals", mc_const_vals, 1, 250, paramH+10, 170, 1, LindApp.getMsg("btn.consultConstValues"), LindApp.getTxtFormat("linkTxtFormat"));
		mc_const_vals["btn_const_vals"].selectable = false;
		mc_const_vals.onRelease = Proxy.create(this, this.openConstVals);
		
		//init text pane
		tp.init();
	}
	
	/*
	 * Collects the form data for the input parameters
	 * 
	 * @return an object with properties representing different input params
	 */
	private function collectInPrms():Object{
				
		var inPrms = this["inPrms_tp"].getContent();
		var inputs:Object = new Object();
		inputs.nitrogen = Number(inPrms["nitrogen_ib"].text);
		inputs.shrubDensity = Number(inPrms["shrubDensity_ib"].text);
		inputs.nFolPrune = Number(inPrms["nFolPrune_ib"].text);
		inputs.percentRootPrune = Number(inPrms["percentRootPrune_ib"].text);
		inputs.aidFolPrune = Number(inPrms["aidFolPrune_ib"].text);
		inputs.aidRootPrune = Number(inPrms["aidRootPrune_ib"].text);
		
		return inputs;
	}
	
	/*
	 * Fills in the form data for the input parameters
	 * 
	 * @param an object with properties representing different input params
	 */
	private function setInPrms(inputs:Object):Void{
				
		var inPrms = this["inPrms_tp"].getContent();
		inPrms["nitrogen_ib"].text = String(inputs.nitrogen);
		inPrms["shrubDensity_ib"].text = String(inputs.shrubDensity);
		inPrms["nFolPrune_ib"].text = String(inputs.nFolPrune);
		inPrms["percentRootPrune_ib"].text = String(inputs.percentRootPrune);
		inPrms["aidFolPrune_ib"].text = String(inputs.aidFolPrune);
		inPrms["aidRootPrune_ib"].text = String(inputs.aidRootPrune);
	}
	
	/*
	 * Initializes the detail table
	 */
	private function initDetailTable():Void{
		
		//create text pane container
		var tp = Utils.newObject(TextPane, this, "detail_tp", this.getNextHighestDepth(), {_x:10, _y:330, w:420, h:110, titleTxt:LindApp.getMsg("cornShrubModel.excercise.detail.title"), allowDrag:true, resize:false, btnMinMax:false, doScroll:false, bgAlpha:90, bgColor:0xffffff})
		
		//create container clip
		var detailCont = tp.getContent();
		
		//create table
		var detailTbl = Utils.newObject(ResultTable, detailCont, "detailTbl", 1,{_x:3, _y:3, nRows:1, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8, noInit:true});
		detailTbl.addCol("nan", LindApp.getMsg("tbl.col.nAnual"), this, this.getTableValue, 50);
		detailTbl.addCol("nis", LindApp.getMsg("tbl.col.nInSoil"), this, this.getTableValue, 81);
		detailTbl.addCol("nf", LindApp.getMsg("tbl.col.nFiltered"), this, this.getTableValue, 81);
		detailTbl.addCol("pcf", LindApp.getMsg("tbl.col.profitCornFarmer"), this, this.getTableValue, 100);
		detailTbl.addCol("plw", LindApp.getMsg("tbl.col.profitLakeWorker"), this, this.getTableValue, 100);
		
		//create button
		var btn_anual_res = Utils.newObject(core.comp.BubbleBtn, detailCont, "btn_anual_res", 2, {_x:0, _y:50, literal:LindApp.getMsg("btn.seeAnualResults"), callBackObj:this, callBackFunc:this.openAnualDetail});
		btn_anual_res._x = 410-btn_anual_res._width;
	}
	
	/*
	 * Initializes the random generator display
	 */
	private function initRandomGenerator():Void{
		
		//create text pane container
		var tp = Utils.newObject(TextPane, this, "rg_tp", this.getNextHighestDepth(), {_x:10, _y:445, w:420, h:100, titleTxt:LindApp.getMsg("cornShrubModel.excercise.randomGenerator.title"), allowDrag:true, resize:false, btnMinMax:false, doScroll:false, bgAlpha:90, bgColor:0xffffff})
		
		//create container clip
		var rgCont = tp.getContent();
		
		//create text literal
		Utils.createTextField("lit", rgCont, 1, 0, 0, 420, 20, LindApp.getMsg("cornShrubModel.excercise.generateRandomInitConditions"), LindApp.getTxtFormat("defaultTxtFormat"));
		
		//create button
		Utils.newObject(core.comp.BubbleBtn, rgCont, "btn_rg", 2, {_x:5, _y:28, literal:LindApp.getMsg("btn.generateRandom"), callBackObj:this, callBackFunc:this.generateRandom});
	}
	
	/*
	 * Validates de input params
	 * 
	 * @param inPrms and object with properties representing the different
	 * input values
	 * @return true if parameters are ok, false other wise
	 */
	private function validateInputParams(inPrms:Object):Boolean{
		
		var errMsg:String = "";
		var ip:InitParam;
		var val:Number;
		
		//validate nitrogen level
		ip = LUtils.getIPObj("nAnual");
		val = inPrms.nitrogen
		if (isNaN(val) || val<ip.getMinVal() || val>ip.getMaxVal() || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.nitrogen", new Array(ip.getMinVal(), ip.getMaxVal(), ip.getPrecision()));
		}
		
		//validate shrub density
		ip = LUtils.getIPObj("densA");
		val = inPrms.shrubDensity
		if (isNaN(val) || val<ip.getMinVal() || val>ip.getMaxVal() || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.shrubDensity", new Array(ip.getMinVal(), ip.getMaxVal(), ip.getPrecision()));
		}
		
		//number of foliage prunes
		ip = LUtils.getIPObj("podasTallo");
		val = inPrms.nFolPrune
		if (isNaN(val) || val<ip.getMinVal() || val>ip.getMaxVal() || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.nFolPrune", new Array(ip.getMinVal(), ip.getMaxVal(), ip.getPrecision()));
		}
		
		//percent of root prune
		ip = LUtils.getIPObj("podasRaiz");
		val = inPrms.percentRootPrune/100;
		if (isNaN(val) || val<ip.getMinVal() || val>ip.getMaxVal() || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.percentRootPrune", new Array(ip.getMinVal()*100, ip.getMaxVal()*100, ip.getPrecision()-2));
		}
		
		//aid foliage prune
		ip = LUtils.getIPObj("sbsdPodTallo");
		val = inPrms.aidFolPrune;
		if (isNaN(val) || val<ip.getMinVal() || val>LUtils.getIP("cstPodTallo") || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.aidFolPrune", new Array(ip.getMinVal(), LUtils.getIP("cstPodTallo"), ip.getPrecision()));
		}
		
		//aid root prune
		ip = LUtils.getIPObj("sbsdPodRaiz");
		val = inPrms.aidRootPrune;
		if (isNaN(val) || val<ip.getMinVal() || val>LUtils.getIP("cstPodRaiz") || Utils.roundNumber(val*Math.pow(10, ip.getPrecision()), 2)%1!=0){
			errMsg += "\n" + LindApp.getMsg("cornShrubModel.excercise.error.aidRootPrune", new Array(ip.getMinVal(), LUtils.getIP("cstPodRaiz"), ip.getPrecision()));
		}
		
		//remove errors if exist
		removeMsg();
		
		//show errors
		if (errMsg.length>0){
			LindApp.getTxtFormat("warningTxtFormat").align="left";
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:LindApp.getMsg("error.revise")+errMsg, _x:10, _y:315, w:800, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			LindApp.getTxtFormat("warningTxtFormat").align="center";
			return false;
		}else{
			return true;
		}
		
	}
	
	/*
	 * Regenerates model with the input parameters currently displayed
	 */
	public function runModel():Void{
		
		//remove msg
		removeMsg();
		
		//collect input params
		var inputs:Object = collectInPrms();
		
		//validate inputs before running model
		if (!validateInputParams(inputs)){
			return;
		}
		
		//check that random initial conditions have been generated
		if (!this["rg_tp"].getContent().randomMarbles){
						
			//create new error message
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:LindApp.getMsg("cornShrubModel.excercise.error.noRandomGenerated"), _x:10, _y:340, w:420, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			
			return;
		}
		
		//clear all previous outputs
		LUtils.clearOutputs();

		//redefine model initial parameters from inputs
		
		//nitrogen
		var nAnIP:InitParam = LUtils.getIPObj("nAnual");
		var nAnArr:Array = new Array(inputs.nitrogen, inputs.nitrogen, inputs.nitrogen, inputs.nitrogen, inputs.nitrogen);
		nAnIP.setArrVal(nAnArr);
		
		//shrub density
		LUtils.setIP("densA", inputs.shrubDensity);

		//number of prunes
		var nFolPrunesIP:InitParam = LUtils.getIPObj("podasTallo");
		var foPruneArr:Array = LUtils.definePruneDates(inputs.nFolPrune, nYears);
		nFolPrunesIP.setArrVal(foPruneArr);

		//root prunes
		LUtils.setIP("podasRaiz", inputs.percentRootPrune/100);

		//redefine subsidies
		LUtils.setIP("sbsdPodTallo", inputs.aidFolPrune);
		LUtils.setIP("sbsdPodRaiz", inputs.aidRootPrune);
		
		//get maximum N filtered - cuases model to run
		var maxN:Number = this.getMaxFiltered();
		
		//if maxN is out of range then warn user otherwise update graph and add point
		if (maxN>this["npvnGraph"].xAxisRange){

			//warn user
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:LindApp.getMsg("cornShrubModel.excercise.error.nMaxOutOfRange"), _x:200, _y:200, w:560, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});

		}else{
			
			//save new point regenerates model
			this.savedVals.push(new Object({x:Utils.roundNumber(this.getMaxFiltered(), 2), y:Utils.roundNumber(this.fnp.avgeProfit(ExploreCornShrubModel.nYears), 2), inPrms:inputs}));
	
			//update combobox
			updateParamsComboBox();
			
			//update graphic
			this["npvnGraph"].update();
		}
		
		//update detail table
		this["detail_tp"].getContent().detailTbl.update();
		
		//update amoeba
		this["amoeba"].comp.update();
		
		//if anual detail open then also update
		if (this["anualDetail"]){
			this["anualDetail"].comp.update();
		}
		
		//if aux graphs are open then also update
		if (this["auxGraphs"]){
			this["auxGraphs"].comp.update();
		}
	}
	
	/*
	 * Generates random initial lake conditions and sets global init param
	 */
	public function generateRandom():Void{
		
		//remove clip if exists
		if (this["rg_tp"].getContent().randomMarbles){
			this["rg_tp"].getContent().randomMarbles.removeMovieClip();
		}
		
		//create clip
		var rm = this["rg_tp"].getContent().createEmptyMovieClip("randomMarbles", this["rg"].getNextHighestDepth());
		
		//generate random numbers and define init param
		rm.algasIni= LUtils.getIPObj("algasIni");
		rm.algasIniArr = new Array(nYears);
		rm.frameCnt = 0;
		rm.highCnt = 0;
		rm.freq = 5;
		rm.onEnterFrame = function(){
			
			//if frame number is multiple of freq
			if(this.frameCnt>=this.freq*ExploreCornShrubModel.nYears){
				
				//set frequency text
				Utils.createTextField("freq_tf", this, ExploreCornShrubModel.nYears, 210, 25, 240, 1, LindApp.getMsg("cornShrubModel.excercise.randomFrequency")+String(this.highCnt/ExploreCornShrubModel.nYears*100), LindApp.getTxtFormat("altTxtFormat"));
				
				//set init param
				this.algasIni.setArrVal(this.algasIniArr);
				
				//stop animation
				delete this.onEnterFrame;
			
			}else if(this.frameCnt%this.freq==0){
				
				//define index
				var ind:Number = this.frameCnt/this.freq;
				
				//get new random number
				var n:Number = Math.floor(Math.random()*10);
				 
				//define init param and add marble
				var marble;
				if (n<LUtils.getIP("probAlta")*10){
					this.algasIniArr[ind] = Const.WEED_CONCENTRATION_HIGH;
					marble = rm.attachMovie("marble_black", "marble_"+String(ind), ind, {_x:(90+ind*25), _y:35});
					this.highCnt++;
				}else{
					this.algasIniArr[ind] = Const.WEED_CONCENTRATION_LOW;
					marble = rm.attachMovie("marble_grey", "marble_"+String(ind), ind, {_x:(90+ind*25), _y:35});
				}
			}
			
			this.frameCnt++;
		}		
	}
	
	/*
	 * Reloads the input parameters for the selected value in the combo box
	 */
	public function reloadParams():Void{
		
		//get selected ind
		var inPrms = this["inPrms_tp"].getContent();
		var ind:Number = inPrms.rp_cb.selectedIndex;
		
		//reload input params
		if (ind){
			var o:Object = this.savedVals[ind-1];
			inPrms.nitrogen_ib.text = o.inPrms.nitrogen;
			inPrms.shrubDensity_ib.text = o.inPrms.shrubDensity;
			inPrms.nFolPrune_ib.text = o.inPrms.nFolPrune;
			inPrms.percentRootPrune_ib.text = o.inPrms.percentRootPrune;
			inPrms.aidFolPrune_ib.text = o.inPrms.aidFolPrune;
			inPrms.aidRootPrune_ib.text = o.inPrms.aidRootPrune;
		}
		
	}
	
	/*
	 * Updates combo box of input parameters from saved values
	 */
	public function updateParamsComboBox():Void{
		var l:Number = this.savedVals.length;
		var labelArray:Array = new Array(l+1);
		labelArray[0] = LindApp.getMsg("cornShrubModel.excercise.reloadParametersDropDown.default");
		for (var i=0; i<l; i++){
			labelArray[i+1] = LindApp.getMsg("cornShrubModel.excercise.reloadParametersDropDown", new Array(this.savedVals[i].x, this.savedVals[i].y)); 
		}
		this["inPrms_tp"].getContent().rp_cb.labels = labelArray;
	}
	
	/*
	 * Populates the detail table
	 * 
	 * @param ind the row index (not used since should always be 0
	 * @param id the column id
	 * @return a string value to be printed in the cell
	 */
	public function getTableValue(ind:Number, id:String):String{
		var ret:Number;
		
		switch (id){
			case "nan":
				//get anual nitrogen applied from the init params
				//since this is constant for all the years it is sufficient to
				//return the first year only
				ret = LUtils.getIP("nAnual", 0);
			break;
			case "nis":
				//get average value of nitrogen in soil
				var tot:Number = 0;
				for (var i=0; i<nYears; i++){
					tot += this.nis.getOutput(i*52);
				}
				ret = tot/nYears;
			break;
			case "nf":
				//get average value of nitrogen filtered from the soil
				var tot:Number = 0;
				for (var i=0; i<nYears; i++){
					tot += this.nf.getAcumAnual(i)
				}
				ret = tot/nYears;
			break;
			case "pcf":
				//get average value of corn farmers net profit
				ret = Utils.roundNumber(fnp.avgeProfit(nYears), 2);
			break;
			case "plw":
				//get average value of lake workers net profit
				ret = Utils.roundNumber(lnp.avgeProfit(nYears)/Const.HECTARES_CORN, 2);
			break;
			default:
				return "";
			break
		}
		
		return String(Utils.roundNumber(ret, 2));
	}
	
	/*
	 * Calculates the maximum value of filtering
	 * 
	 * @return the maximum value of filtered nitrogen
	 */
	public function getMaxFiltered():Number{
		var ret:Number = 0;
		for (var i=0; i<nYears; i++){
			ret = Math.max(ret, this.nf.getAcumAnual(i));
		}
		return ret;
	}

	/*
	 * Opens component window with the anual detail
	 */
	public function openAnualDetail(){
		//if not already open
		if (!this["anualDetail"]){
			//create new component window
			var cw:ComponentWindow = Utils.newObject(ComponentWindow, this, "anualDetail", this.getNextHighestDepth(), {_x:200, _y:100, w:572, h:170, compClass:ExploreCornShrubModelAnualDetail, btnClose:true, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.anualDetail.title"), animate:true});
			cw.comp.update();
		}else{
			this["anualDetail"].reopen();
		}
	}

	/*
	 * Opens component window with the auxilar graphs in
	 */
	public function openAuxGraphs(){
		//if not already open
		if (!this["auxGraphs"]){
			//create new component window
			var cw:ComponentWindow = Utils.newObject(ComponentWindow, this, "auxGraphs", this.getNextHighestDepth(), {_x:50, _y:50, w:770, h:455, compClass:ExploreCornShrubModelAuxGraphs, btnClose:true, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.auxiliarGraphs"), animate:true});
		}else{
			this["auxGraphs"].reopen();
		}
	}

	/*
	 * Opens constant values in a text pane
	 */
	public function openConstVals(){
		//if not already open
		if (!this["const_vals_tp"]){
			//create new text pane
			var tp:TextPane = Utils.newObject(TextPane, this, "const_vals_tp", this.getNextHighestDepth(), {_x:200, _y:200, w:580, h:250, titleTxt:LindApp.getMsg("cornShrubModel.excercise.constVals.title"), allowDrag:true, doScroll:false, resize:false, btnClose:true, btnMinMax:true, bgAlpha:90, bgColor:0xffffff});
			Utils.createTextField("tf", tp.getContent(), 1, 0, 0, 580, 1, LindApp.getMsg("cornShrubModel.excercise.constVals.text"), LindApp.getTxtFormat("defaultTxtFormat"));
			tp.init(true);
		}else{
			this["const_vals_tp"].openBlind();
		}
	}

	/*
	 * Adds graphic to graph with curve for mono cultivation for current params
	 */
	public function doMonoCurve():Void{
		
		//create object containing input parameters
		var inPrms = this["inPrms_tp"].getContent();
		var inputs:Object = new Object();
		inputs.nitrogen = 0;
		inputs.shrubDensity = 0;
		inputs.nFolPrune = 0;
		inputs.percentRootPrune = 0;
		inputs.aidFolPrune = 0;
		inputs.aidRootPrune = 0;
		
		//validate inputs before running model
		if (!validateInputParams(inputs)){
			return;
		}
		
		//check that random initial conditions have been generated
		if (!this["rg_tp"].getContent().randomMarbles){
			
			//remove errors if exist
			if (this["errorMsg"]){
				this["errorMsg"].removeMovieClip();
			}
			
			//create new error message
			Utils.newObject(UserMessage, this, "errorMsg", this.getNextHighestDepth(), {txt:LindApp.getMsg("cornShrubModel.excercise.error.noRandomGenerated"), _x:10, _y:340, w:420, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			
			return;
		}
		
		//redefine model initial parameters from inputs
		
		//shrub density
		LUtils.setIP("densA", inputs.shrubDensity);

		//number of prunes
		var nFolPrunesIP:InitParam = LUtils.getIPObj("podasTallo");
		var foPruneArr:Array = LUtils.definePruneDates(inputs.nFolPrune, nYears);
		nFolPrunesIP.setArrVal(foPruneArr);

		//root prunes
		LUtils.setIP("podasRaiz", inputs.percentRootPrune/100);

		//redefine subsidies
		LUtils.setIP("sbsdPodTallo", inputs.aidFolPrune);
		LUtils.setIP("sbsdPodRaiz", inputs.aidRootPrune);		

		//initialize values
		this.monoVals = new Array();
		
		//add new graphic
		this["npvnGraph"].removeGraphic("monoCurve");
		this["npvnGraph"].addGraphicFromArray("monoCurve", 0xff9900, this.monoVals, 0, 5);
		
		//create movie clip to do a stepped calculation in
		var mc = this.createEmptyMovieClip("monoCurveGenerator", this.getNextHighestDepth());
		mc.cnt = 0
		mc.onEnterFrame = function(){
			if (this.cnt<9){
				
				//calculate next point
				LUtils.clearOutputs();
				
				//set new nitrogen level
				var nAnIP:InitParam = LUtils.getIPObj("nAnual");
				var nAnArr:Array = new Array(this.cnt, this.cnt, this.cnt, this.cnt, this.cnt);
				nAnIP.setArrVal(nAnArr);
		
				//save new point regenerates model
				this._parent.monoVals.push(new Object({x:Utils.roundNumber(this._parent.getMaxFiltered(), 2), y:Utils.roundNumber(this._parent.fnp.avgeProfit(ExploreCornShrubModel.nYears), 2)}));
		
				//update graphic
				this._parent["npvnGraph"].update();
				
				//increment count
				this.cnt++;
				
			}else{
				delete this.onEnterFrame;
			}
		}
	}

	/*
	 * Hides all basic visible components
	 */
	public function hideAll():Void{
		this["npvnGraph"]._visible = false;
		this["inPrms_tp"]._visible = false;
		this["detail_tp"]._visible = false;
		this["rg_tp"]._visible = false;
		this["amoeba"]._visible = false;
		this._parent["mcStep"].btns._visible = false;
		
		//components
		if (this["anualDetail"]){
			this["anualDetail"]._visible = false;
		}
		if(this["auxGraphs"]){
			this["auxGraphs"]._visible = false;
		}
		if (this["const_vals_tp"]){
			this["const_vals_tp"]._visible = false;
		}
	}
	
	/*
	 * Shows all basic visible components
	 */
	public function showAll():Void{
		this["npvnGraph"]._visible = true;
		this["inPrms_tp"]._visible = true;
		this["detail_tp"]._visible = true;
		this["rg_tp"]._visible = true;
		this["amoeba"]._visible = true;
		this._parent["mcStep"].btns._visible = true;
		
		//components
		if (this["anualDetail"]){
			this["anualDetail"]._visible = true;
		}
		if(this["auxGraphs"]){
			this["auxGraphs"]._visible = true;
		}
		if (this["const_vals_tp"]){
			this["const_vals_tp"]._visible = true;
		}

	}

	/*
	 * Remove message
	 */
	public function removeMsg():Void{
		
		//remove the message
		this["msg"].removeMovieClip();		
	}

	/*
	 * Creates message offering the user the solution
	 */
	public function seeSol():Void{
		
		//remove previous messages
		removeMsg();
		
		//create callback buttons
		var btn_seeSol:Object = new Object({callBackObj:this, callBackFunc:runSol, literal:LindApp.getMsg("btn.seeSolutionNow")});
		var btn_contTrying:Object = new Object({callBackObj:this, callBackFunc:removeMsg, literal:LindApp.getMsg("btn.continueTrying")});
		
		//create msg
		Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:200, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.solution"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), callBack_btns: new Array(btn_seeSol, btn_contTrying)});
	}

	/*
	 * Loads the solution
	 */
	public function runSol():Void{
		
		//reinitialize
		reset();
		generateRandom();
		
		//load input params
		var inputs:Object = new Object();
		inputs.nitrogen = Number(this.sol[1]);
		inputs.shrubDensity = Number(this.sol[2]);
		inputs.nFolPrune = Number(this.sol[3]);
		inputs.percentRootPrune = Number(this.sol[4]);
		inputs.aidFolPrune = Number(this.sol[5]);
		inputs.aidRootPrune = Number(this.sol[6]);
		setInPrms(inputs);
		
		//run model
		runModel();
		
		//create new message
		removeMsg();
		Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:450, _y:270, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.solution.desc"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat")});
	}
	
}
