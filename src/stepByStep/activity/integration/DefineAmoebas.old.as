import ascb.util.logging.Logger;
import core.util.Utils;
import core.util.Proxy;
import core.comp.UserMessage;
import core.comp.TextPane;
import core.comp.Amoeba;
import core.comp.EyeBtn;
import stepByStep.comp.Optimizer;
import stepByStep.comp.TblIndicators;
import stepByStep.util.MUtils;
import stepByStep.StepByStepApp;
import stepByStep.model.valueObject.Indicator;

/*
 * Definition of amoebas for commercial and traditional system. The user standardizes/optimizes
 * varios indicators in order to generate the satisfaction amoebas for each of the systems
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.activity.integration.DefineAmoebas extends stepByStep.activity.StepByStepActivity {
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.activity.characterization.DefineAmoebas");
	//array of indicators
	private var indicators:Array;
	//the index of the indicator currently being optimized
	private var optimizeInd:Array;
	//the table of indicators
	private var tblIndic;
	//the amoebas
	private var amoeba;
	//the text pane containing the optimizer
	private var tpOptimizer:TextPane;
	//the messages to be shown to the user
	private var msgs:Array;
	//the message being shown to the user
	private var msg:MovieClip;
	//the indicators to be optimized (must be 3)
	private var optimized:Array;
	//the index the array optimized of the indicator being optimized
	private var currOptimizeInd:Number;

	
	/*
	 * Constructor
	 */
	public function DefineAmoebas() {
		
		logger.debug("instantiating DefineAmoebas");
		
		//initialize arrays
		this.optimizeInd = new Array();
		this.optimized = new Array();
		this.msgs = new Array();
		
		//get selected indicators
		this.indicators = MUtils.selectIndicators(StepByStepApp.getApp().indicators);
		
		//initialize indicator weights based on the number of selected indicators
		initIndicatorWeights();
		
		//put indicators to be optimized into arrays
		for (var i = 0; i<this.indicators.length; i++) {
			if (this.indicators[i].getIsOptimize().valueOf()) {
				this.optimizeInd[this.optimizeInd.length] = this.indicators[i];
			}
		}
		currOptimizeInd = 0;
		this.optimized[0] = this.optimizeInd[currOptimizeInd].getId();
		
		//create background
		createBg();
		
		//create component container
		this.createEmptyMovieClip("comps", this.compDepth);
		
		//initialize message dialogs
		nextStep();
	}
	
	/*
	 * Gets the previous step
	 */
	public function previousStep():Void {
		this.currStep--;
		this.getStep(this.currStep);
	}

	/*
	 * Gets the next step
	 */
	public function nextStep():Void {
		this.currStep++;
		this.getStep(this.currStep);
	}

	/*
	 * Gets the given step. Removes the current step container and creates a new
	 * container with the elements of the given step
	 * 
	 * @param step the step to retrieve
	 */
	public function doStepDependencies(step:Number):Number {
		logger.debug("getting step: "+step);
		var mcStep = this["mcStep"];
		//remove elements
		if (step<5) {
			//remove indicator table if exists
			if (this["comps"]["tpIndic"]) {
				this["comps"]["tpIndic"].removeMovieClip();
			}
			//remove amoeba if exists
			if (this["comps"]["tpAmoeba"]) {
				this["comps"]["tpAmoeba"].removeMovieClip();
			}
			//remove detail text if exists
			if (this["comps"]["tpIntro"]) {
				this["comps"]["tpIntro"].removeMovieClip();
			}
		}
		//switch case for each step
		switch (step) {
		case 1 :
			//create messagethis.next
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.introText.text"), _x:50, _y:50, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("defineAmoebas.introText.title"), isTransparent:true, titleTxtFormat:StepByStepApp.getTxtFormat("bigTitleTxtFormat"), txtFormat:StepByStepApp.getTxtFormat("bigTxtFormat")});
			//remove buttons if exists
			if (this["btns"]) {
				this["btns"].removeMovieClip();
			}
			//create buttons clip
			var btns:MovieClip = this.createEmptyMovieClip("btns", this.getNextHighestDepth());
			btns._y = 550;
			Utils.newObject(EyeBtn, btns, "btn_next", btns.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.next"), _x:860, callBackObj:this, callBackFunc:this.nextStep});
			Utils.newObject(EyeBtn, btns, "btn_ant", btns.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.previous"), _x:770, _alpha:0, callBackObj:this, callBackFunc:this.previousStep});
			break;
		case 2 :
			//create message
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.introTabla.text"), _x:50, _y:10, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("defineAmoebas.introTabla.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat")});
			//create indicator table
			var tpIndic = Utils.newObject(TextPane, mcStep, "tpIndic", mcStep.getNextHighestDepth(), {titleTxt:"Síntesis de Resultados", _x:20, _y:190, w:920, h:355});
			this.tblIndic = Utils.newObject(TblIndicators, tpIndic.getContent(), "tbl_indic", tpIndic.getContent().getNextHighestDepth(), {indicators:this.indicators});
			tpIndic.init(false);
			//show back button
			this["btns"].btn_ant.alphaTo(100, 10);
			break;
		case 3 :
			//create message
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.standardization.text"), _x:50, _y:50, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("defineAmoebas.standardization.title"), isTransparent:true, titleTxtFormat:StepByStepApp.getTxtFormat("bigTitleTxtFormat"), txtFormat:StepByStepApp.getTxtFormat("bigTxtFormat")});
			this.msg.attachMovie("eqn_1", "eqn_1", this.getNextHighestDepth(), {_x:300, _y:150});
			break;
		case 4 :
			//create indicator table
			var tpIndic = Utils.newObject(TextPane, this["comps"], "tpIndic", this["comps"].getNextHighestDepth(), {titleTxt:"Síntesis de Resultados", _x:20, _y:10, w:920, h:200});
			this.tblIndic = Utils.newObject(TblIndicators, tpIndic.getContent(), "tbl_indic", tpIndic.getContent().getNextHighestDepth(), {indicators:this.indicators});
			tpIndic.init(false);
			//create amoeba
			initAmoeba();
			//create introtext
			initDetail();
			//activate table
			this.tblIndic.active = true;
			//create message
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.initExcercise.text"), _x:100, _y:220, w:700, btnClose:true, titleTxt:StepByStepApp.getMsg("defineAmoebas.initExcercise.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat: StepByStepApp.getTxtFormat("defaultTitleTxtFormat")});
			break;
		case 5 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.introAmoeba.text"), _x:500, _y:50, w:450, btnClose:true, titleTxt:StepByStepApp.getMsg("defineAmoebas.introAmoeba.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat: StepByStepApp.getTxtFormat("defaultTitleTxtFormat")});
			break;
		case 6 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.excercise.text1", new Array(this.optimizeInd[currOptimizeInd].getLiteral())), _x:100, _y:150, w:700, btnClose:true, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			this["btns"].btn_ant._visible = false;
			break;
		case 7 :
			this.openOptimizer(this.optimizeInd[currOptimizeInd]);
			this["btns"]._visible = false;
			break;
		case 8 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.excercise.text2", new Array(this.optimizeInd[currOptimizeInd].getLiteral())), _x:100, _y:150, w:700, btnClose:true, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			this.currOptimizeInd++;
			if (this.currOptimizeInd<this.optimizeInd.length) {
				this.optimized[this.optimized.length] = this.optimizeInd[this.currOptimizeInd].getId();
				step -= 3;
			}
			this["btns"]._visible = true;
			break;
		case 9 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("defineAmoebas.excercise.text3", new Array(this.optimizeInd[currOptimizeInd].getLiteral())), _x:100, _y:150, w:700, btnClose:true, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			this["btns"].btn_ant.removeMovieClip();
			this["btns"].btn_next.onRelease = function() {
				StepByStepApp.getNav().getNext();
			};
			Utils.newObject(EyeBtn, this["btns"], "btn_restart", this["btns"].getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.restartExcercise"), _x:700, callBackObj:this, callBackFunc:Proxy.create(this, this.getStep, 1)});
			break;
		}
		return step;
	}

	/*
	 * Creates the background for the first step
	 */
	private function createBg() :Void{
		logger.debug("createing background");
		var bg:MovieClip = this["bg"];
		bg._y = 135;
		bg.attachMovie("amoeba_bg", "amoeba_bg", this.getNextHighestDepth(), {_alpha:50});
		bg.createEmptyMovieClip("mask", bg.getNextHighestDepth());
		bg["mask"].beginFill(0x000000, 100);
		bg["mask"].lineTo(960, 0);
		bg["mask"].lineTo(960, 585);
		bg["mask"].lineTo(0, 585);
		bg["mask"].lineTo(0, 0);
		bg["mask"].endFill();
		bg.setMask(bg["mask"]);
	}

	/*
	 * Initializes the indicator weights based on the number of selected
	 * indicators
	 */
	private function initIndicatorWeights() :Void{
		logger.debug("initializing indicator weights: " + String(this.indicators.length) + " indicators selected");
		var w = 100/this.indicators.length;
		var weights:Array = new Array(w, w, w);
		for (var i = 0; i<this.indicators.length; i++) {
			this.indicators[i].setWeights(weights);
		}
	}

	/*
	 * Initializes the amoebas
	 */
	private function initAmoeba() :Void{
		logger.debug("initializing amoebas");
		var tpAmoeba:TextPane = Utils.newObject(TextPane, this["comps"], "tpAmoeba", this["comps"].getNextHighestDepth(), {titleTxt:"Amoeba", _x:20, _y:215, w:500, h:360});
		//define titles tradSysValues y comSysValues
		var titles:Array = new Array(this.indicators.length);
		var tradSysValues:Array = new Array(this.indicators.length);
		var comSysValues:Array = new Array(this.indicators.length);
		for (var i = 0; i<this.indicators.length; i++) {
			titles[i] = this.indicators[i].getLiteral();
			tradSysValues[i] = this.indicators[i].getTradSystemCalc();
			comSysValues[i] = this.indicators[i].getComSystemCalc();
		}
		//create amoeba
		this.amoeba = Utils.newObject(Amoeba, tpAmoeba.getContent(), "amoeba", tpAmoeba.getContent().getNextHighestDepth(), {titles:titles, _x:0, _y:0});
		//add traditional system amoeba
		this.amoeba.addAmoeba("tradSys", "Sistema Tradicional", 0x0000ff, tradSysValues);
		//add commercial system amoeba
		this.amoeba.addAmoeba("comSys", "Sistema Comercial", 0x00ff00, comSysValues);
		tpAmoeba.init(false);
	}

	/*
	 * Given the id of an indicator checks to see whether or not the user
	 * can optimize it.
	 * 
	 * @param indicatorId the id of the indicator to check
	 * @return	true if the optimizer is not open and this indicator has already been optimized,
	 * 			false oterwise.
	 */
	public function canOptimize(indicatorId:Number) :Boolean{
		var ret:Boolean = false;
		if (this.currOptimizeInd>2 && Utils.arrayContains(this.optimized, indicatorId) && this.tpOptimizer == null) {
			ret=true;
		}
		logger.debug("canOptimize: indicatorId="+indicatorId+" canOptimize="+String(ret));
		return ret;
	}
	
	/*
	 * Closes the optimizer, refreshes the table and the amoebas and, if there
	 * are more indicators to optimize, gets the next step
	 * 
	 * @param indicatorId the id of the indicator being optimized
	 */
	public function closeOptimizer(indicatorId:Number) :Void{
		logger.debug("closing optimizer for indicator with id "+String(indicatorId));
		//refresh table
		this.tblIndic.refreshTable();
		//update amoebas
		var tradSysValues:Array = new Array(this.indicators.length);
		var comSysValues:Array = new Array(this.indicators.length);
		for (var i = 0; i<this.indicators.length; i++) {
			tradSysValues[i] = this.indicators[i].getTradSystemCalc();
			comSysValues[i] = this.indicators[i].getComSystemCalc();
		}
		this.amoeba.updateAmoeba("tradSys", tradSysValues);
		this.amoeba.updateAmoeba("comSys", comSysValues);
		//reset optimizer variable
		this.tpOptimizer.removeMovieClip();
		this.tpOptimizer = null;
		//next step
		if (!Utils.arrayContains(this.optimized, indicatorId)) {
			this.nextStep();
		}
	}

	/*
	 * Loads the detail of an indicator
	 * 
	 * @param indicator the indicator to load
	 */
	public function loadDetail(indicator:Indicator) :Void{
		logger.debug("loading detail for indicator "+indicator.getLiteral());
		this["comps"]["tpIntro"].removeMovieClip();
		var tpIntro:TextPane = Utils.newObject(TextPane, this["comps"], "tpIntro", this["comps"].getNextHighestDepth(), {titleTxt:indicator.getLiteral(), _x:530, _y:215, w:410, h:330});
		var cont:MovieClip = tpIntro.getContent();
		Utils.createTextField("tf", cont, 2, 0, 0, 400, 200, indicator.getMeasureDesc(), StepByStepApp.getTxtFormat("defaultTxtFormat"));
		//add open optimizer button
		if (this.canOptimize(indicator.getId())) {
			var btn_opt = Utils.newObject(EyeBtn, cont, "btn_optimize", cont.getNextHighestDepth(), {literal:"Estandarizar", _y:cont._height+10, callBackObj:this, callBackFunc:Proxy.create(this, this.openOptimizer, indicator)});
			btn_opt._x = (cont._width-btn_opt._width)/2;
		}
		//init text pane
		tpIntro.init(true);
	}

	/*
	 * Opens the optimizer for a given indicator
	 * 
	 * @param indicator the indicator to load
	 */
	public function openOptimizer(indicator:Indicator) :Void{
		logger.debug("openning optimizer for indicator "+indicator.getLiteral());
		this.tpOptimizer = Utils.newObject(TextPane, this["comps"], "tpOptimizer", this["comps"].getNextHighestDepth(), {titleTxt:"Estandarización " + indicator.getLiteral(), _x:40, _y:50, w:880, h:500});
		var optimizer:Optimizer = Optimizer(Utils.newObject(Optimizer, this.tpOptimizer.getContent(), "optimizer", this.tpOptimizer.getContent.getNextHighestDepth(), {indicator:indicator}));
		this.tpOptimizer.init(true);
	}


	/*
	 * Initializes the detail pane
	 */
	private function initDetail() :Void{
		logger.debug("initializing detail pane");
		var tpIntro:TextPane = Utils.newObject(TextPane, this["comps"], "tpIntro", this["comps"].getNextHighestDepth(), {titleTxt:"Detalle Indicador", _x:530, _y:215, w:410, h:330});
		var cont:MovieClip = tpIntro.getContent();
		Utils.createTextField("tf", cont, 2, 0, 0, 400, 200, StepByStepApp.getMsg("defineAmoebas.detailPane.initText"), StepByStepApp.getTxtFormat("defaultTxtFormat"));
	}
}
