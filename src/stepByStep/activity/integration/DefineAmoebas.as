import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.UserMessage;
import core.comp.TextPane;
import core.comp.Amoeba;
import stepByStep.comp.TradeOff;
import stepByStep.comp.TblIndicators;
import stepByStep.util.MUtils;
import stepByStep.StepByStepApp;

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
		
		//call super class constructor
		super();

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

		//get first step
		getStep(1);
	}

	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		if (step<2 || step==10) {
			
			//remove all components
			this.currComp.removeMovieClip();
			this.currComp = undefined;
			
		}else if(step>1 && step<10){
			
			//remove any other component and create indicator table
			if(this.currComp==undefined || this.currComp._name != "tblIndic"){
				this.currComp.removeMovieClip();
				this.currComp = Utils.newObject(TblIndicators, this, "tblIndic", this.compDepth, {indicators:this.indicators, _x:50, _y:100});
			}			
		}else if(step>10){
			
			//remove any other component and create trade off
			if(this.currComp==undefined || this.currComp._name != "tradeOff"){
				this.currComp.removeMovieClip();
				this.currComp = Utils.newObject(TradeOff, this, "tradeOff", this.compDepth, {indicators:this.indicators, _x:50, _y:70});
			}
			
			//only activate component if is step 14
			if(step>12){
				this.currComp.activate();
			}else{
				this.currComp.desactivate();
			}
		}
		
		return step;
	}
	
	/*
	 * Step 1: Introduction
	 * 
	 * @param cont the container clip for the step
	 */
	public function step1(cont:GenericMovieClip):Void{
		
		var bigTitleTxtFormat:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		
		//create title text underline
		var tu:GenericMovieClip = cont.createEmptyMovieClip("tu", cont.getNextHighestDepth());
		tu.lineStyle(2, 0xC0A47D, 100);
		tu.lineTo(900, 0);
		tu._x = -900;
		tu._y = 50;
		tu.glideTo(20, 50, 10);
	
		//create title as raining text
		var titleCont:GenericMovieClip = cont.createEmptyMovieClip("titleCont", cont.getNextHighestDepth());
		Utils.createTextField("title", titleCont, 1, 0, 0, 900, 10, StepByStepApp.getMsg("defineAmoebas.intro.title"), bigTitleTxtFormat);
		titleCont._x = 960;
		titleCont._y = 20;
		titleCont.glideTo(20, 20, 10);
		
		//add graphics
		cont.attachMovie("integ_intro", "img", cont.getNextHighestDepth(), {_x:100, _y:70, _alpha:100});
		cont.attachMovie("amoeba_1", "img", cont.getNextHighestDepth(), {_x:100, _y:200, _alpha:100});
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineAmoebas.intro.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnGotoMenuPrin();
	}
		
	/*
	 * Step 2: Presentation of table - 1
	 * 
	 * @param cont the container clip for the step
	 */
	public function step2(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.resultsSnthesis.title"), tf);
		tf.align = "left";
		
		//show first column of indicator table
		this["tblIndic"].showCols(1, false);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:450, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro1"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
		
	/*
	 * Step 3: Presentation of table - 2
	 * 
	 * @param cont the container clip for the step
	 */
	public function step3(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.resultsSnthesis.title"), tf);
		tf.align = "left";
		
		//show first 2 columns of indicator table
		this["tblIndic"].showCols(2, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:550, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro2"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
		
	/*
	 * Step 4: Presentation of table - 3
	 * 
	 * @param cont the container clip for the step
	 */
	public function step4(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.resultsSnthesis.title"), tf);
		tf.align = "left";
		
		//show first 3 columns of indicator table
		this["tblIndic"].showCols(3, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro3"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
		
	/*
	 * Step 5: Presentation of table - 4
	 * 
	 * @param cont the container clip for the step
	 */
	public function step5(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.resultsSnthesis.title"), tf);
		tf.align = "left";
		
		//show first 5 columns of indicator table
		this["tblIndic"].showCols(5, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:650, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro4"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 6: Presentation of table - 5
	 * 
	 * @param cont the container clip for the step
	 */
	public function step6(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.standardization.title"), tf);
		tf.align = "left";
		
		//show first 5 columns of indicator table
		this["tblIndic"].showCols(5, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:650, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro5"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 7: Presentation of table - 6
	 * 
	 * @param cont the container clip for the step
	 */
	public function step7(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.standardization.title"), tf);
		tf.align = "left";
		
		//show first 7 columns of indicator table
		this["tblIndic"].showCols(7, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:690, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro6"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 8: Presentation of table - 7
	 * 
	 * @param cont the container clip for the step
	 */
	public function step8(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.standardization.title"), tf);
		tf.align = "left";
		
		//show first 7 columns of indicator table
		this["tblIndic"].showCols(7, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:690, w:250, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.intro7"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 9: Standardization of indicators
	 * 
	 * @param cont the container clip for the step
	 */
	public function step9(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.standardization.title"), tf);
		tf.align = "left";
		
		//show all columns of indicator table
		this["tblIndic"].showCols(10, true);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:330, w:300, txt:StepByStepApp.getMsg("defineAmoebas.tblIndic.startStandardization"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
						
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 10: Graphic representation
	 * 
	 * @param cont the container clip for the step
	 */
	public function step10(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.amoeba.title"), tf);
		tf.align = "left";
		
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
		var amoeba:Amoeba = Utils.newObject(Amoeba, cont, "amoeba", cont.getNextHighestDepth(), {titles:titles, _x:50, _y:50, radius:200, centerX:260, centerY:250});
		amoeba.addAmoeba("tradSys", StepByStepApp.getMsg("defineAmoebas.amoeba.SAR"), 0x0000ff, tradSysValues);
		amoeba.addAmoeba("comSys", StepByStepApp.getMsg("defineAmoebas.amoeba.SAA"), 0x00ff00, comSysValues);
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:620, w:280, txt:StepByStepApp.getMsg("defineAmoebas.amoeba.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
				
		//create buttons
		
		//next button must validate that all indicators have been standardized
		var i:Number = 0;
		while(i<tradSysValues.length && !isNaN(tradSysValues[i]) && !isNaN(comSysValues[i])){
			i++;
		}
		if(i!=tradSysValues.length){
			var fnc1:Function = function(){
				var warning:UserMessage = Utils.newObject(UserMessage, this.mcStep.cont, "warning", this.mcStep.cont.getNextHighestDepth(), {_x:330, _y:250, w:300, txt:StepByStepApp.getMsg("defineAmoebas.amoeba.notAllStandardized"), txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
				this.tweenIn(warning);
			}
			createBtn("btn_next", StepByStepApp.getMsg("btn.next"), this, fnc1, false);
		}else{		
			createBtnNext();
		}
		
		//back button as normal
		createBtnBack();
		
		//see more button
		var fnc2:Function = function(){
			this.mcStep.cont.msg.removeMovieClip();
			var msg2:UserMessage = Utils.newObject(UserMessage, this.mcStep.cont, "msg", cont.getNextHighestDepth(), {_x:180, w:600, txt:StepByStepApp.getMsg("defineAmoebas.amoeba.details"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			msg2._y = (550-msg2._height)/2;
			this.tweenIn(msg2);
		}
		createBtn("btn_seeMore", StepByStepApp.getMsg("btn.amoeba.seeMore"), this, fnc2, false);
	}

	/*
	 * Step 11: Trade off presentation - 1
	 * 
	 * @param cont the container clip for the step
	 */
	public function step11(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.tradeOff.title"), tf);
		tf.align = "left";
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:StepByStepApp.getMsg("defineAmoebas.tradeOff.text1"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}

	/*
	 * Step 12: Trade off presentation - 2
	 * 
	 * @param cont the container clip for the step
	 */
	public function step12(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.tradeOff.title"), tf);
		tf.align = "left";
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:StepByStepApp.getMsg("defineAmoebas.tradeOff.text2"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}	

	/*
	 * Step 13: Trade off presentation - 3
	 * 
	 * @param cont the container clip for the step
	 */
	public function step13(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.tradeOff.title"), tf);
		tf.align = "left";
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:StepByStepApp.getMsg("defineAmoebas.tradeOff.text3"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}	

	/*
	 * Step 14: Trade off excercise - 4
	 * 
	 * @param cont the container clip for the step
	 */
	public function step14(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineAmoebas.tradeOff.title"), tf);
		tf.align = "left";
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:StepByStepApp.getMsg("defineAmoebas.tradeOff.text4"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		var fnc:Function = function(){
			this.app.getNav().getActivity("conclusions");
		}
		createBtn("btn_gotoStep6", this.app.getMsg("btn.gotoStep6"), this, fnc);
		createBtnGotoMenuPrin();
		createBtnBack();
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


}
