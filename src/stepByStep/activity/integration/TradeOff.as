import ascb.util.logging.Logger;
import core.util.Proxy;
import core.util.Utils;
import core.comp.UserMessage;
import core.comp.Amoeba;
import core.comp.EyeBtn;
import stepByStep.StepByStepApp;
import stepByStep.util.MUtils;

/*
 * Excercise to inforce the idea of trade offs between indicators. The user varies the
 * level of sulfato de amonio and apreciates the change in shape of the amoeba
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.activity.integration.TradeOff extends core.util.GenericMovieClip {
	
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.activity.integration.TradeOff");
	//array of indicators
	private var indicators:Array;
	//the scale of the synthesizer/slide bar
	public var synthScale:Number;
	//the amoeba
	private var amoeba:Amoeba;
	//the message being shown to the user
	private var msg:MovieClip;
	
	/*
	 * Constructor
	 */
	function TradeOff() {
		logger.debug("instantiating trade offs");
		
		//get selected indicators
		this.indicators = MUtils.selectIndicators(StepByStepApp.getApp().indicators);
		
		//get first step
		currStep = 0;
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
		//switch case for each step
		switch (step) {
		case 1 :
			//remove base if exists
			if (this["base"]){
				this["base"].removeMovieClip();
			}
			//init synthScale and tradeOffLevel
			this.synthScale = 100;
			StepByStepApp.setTradeOffLevel(0);
			//attach background
			mcStep.attachMovie("bg_tradeOff", "bg", 10, {_x:250, _y:40, _alpha:80});
			//create message
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("tradeOff.introText.text"), _x:50, _y:50, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("tradeOff.introText.title"), isTransparent:true, titleTxtFormat:StepByStepApp.getTxtFormat("bigTitleTxtFormat"), txtFormat:StepByStepApp.getTxtFormat("bigTxtFormat")});
			//create next button
			createBtnNext();
			break;
		case 2 :
			//create base clip
			var base:MovieClip = this.createEmptyMovieClip("base", this.compDepth);
			//draw amoeba:
			drawAmoeba();
			//draw sinthesizer
			drawSynthesizer();
			//create message
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("tradeOff.presExcercise.text"), _x:50, _y:20, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("tradeOff.presExcercise.title"), isTransparent:false, titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			//create next button
			createBtnNext();
			//create back button
			createBtnBack();
			break;
		case 3 :
			//create message
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {txt:StepByStepApp.getMsg("tradeOff.questions.text"), _x:50, _y:20, w:800, btnClose:false, titleTxt:StepByStepApp.getMsg("tradeOff.questions.title"), isTransparent:false, titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
			//create next button
			createBtnNext();
			//create back button
			createBtnBack();
			//create restart button
			createBtnRestart();
			break;
		}
		return step;
	}
	
	/*
	 * Inicializes the amoeba
	 */
	private function drawAmoeba() :Void{
		logger.debug("initializing amoeba");
		//initialize titles and values
		var titles:Array = new Array(this.indicators.length);
		var tradSysValues:Array = new Array(this.indicators.length);
		var tradeOffValues:Array = new Array(this.indicators.length);
		for (var i = 0; i<this.indicators.length; i++) {
			titles[i] = this.indicators[i].getLiteral();
			tradSysValues[i] = this.indicators[i].getTradSystemCalc();
			tradeOffValues[i] = Math.min(100, Math.max(0, this.indicators[i].getTradSystemCalc()+StepByStepApp.getTradeOffLevel()*this.indicators[i].getTradeOffQuotient()));
		}
		this.amoeba = Utils.newObject(Amoeba, this["base"], "amoeba", this["base"].getNextHighestDepth(), {titles:titles, _x:10, _y:200});
		this.amoeba.addAmoeba("tradSys", "Sistema original", 0x0000ff, tradSysValues);
		this.amoeba.addAmoeba("tradeOff", "Sistema modificado", 0x00ff00, tradeOffValues);
	}
	
	/*
	 * Inicializes the synthesizer
	 */
	private function drawSynthesizer() :Void{
		logger.debug("initializing synthesizer");
		var synth = this["base"].attachMovie("synth", "synth", this["base"].getNextHighestDepth());
		synth._x = 600;
		synth._y = 270;
		//init texts
		synth.titleTxt.text = StepByStepApp.getMsg("tradeOff.slideBar.titleTxt");
		synth.desc.text = StepByStepApp.getMsg("tradeOff.slideBar.desc");
		synth.level_literal.text = StepByStepApp.getMsg("tradeOff.slideBar.actualLevel");
		//set initial value for actual level and add on change listener
		synth.actualLevel.text = (StepByStepApp.getTradeOffLevel()+0.5)*this.synthScale;
		synth.actualLevel.onChanged = function() {
			var tradeOff:TradeOff = this._parent._parent._parent;
			var unscaledLevel = Math.max(Math.min(Number(this.text), tradeOff.synthScale), 0);
			var scaledLevel = (unscaledLevel-(tradeOff.synthScale/2))/(tradeOff.synthScale/2);
			if (!isNaN(unscaledLevel)) {
				this._parent.control._x = (scaledLevel + 1)*100-3;
				this.text = String(unscaledLevel);
				StepByStepApp.setTradeOffLevel(scaledLevel);
				//update trade off amoeba
				tradeOff.updateAmoeba();
			}
		};
		//add drag functionality to synth
		synth.control.onPress = function() {
			this.startDrag(false, -3, this._y, 197, this._y);
			this.onEnterFrame = function() {
				var tradeOff:TradeOff = this._parent._parent._parent;
				//get new value from synth
				var scaledValue = (this._x+3)/100-1;
				var unscaledValue = (scaledValue+1)/2*tradeOff.synthScale
				//save changes
				StepByStepApp.setTradeOffLevel(scaledValue);
				this._parent.actualLevel.text = String(unscaledValue);
				//update trade off amoeba
				tradeOff.updateAmoeba();
			};
		};
		synth.control.onRelease = function() {
			this.stopDrag();
			delete this.onEnterFrame;
		};
	}
	
	/*
	 * Update the amoeba. Executes when the synthesizer is moved
	 */
	public function updateAmoeba() :Void{
		//recalculate values and update amoeba
		var tradeOffValues:Array = new Array(this.indicators.length);
		for (var i = 0; i<this.indicators.length; i++) {
			tradeOffValues[i] = Math.min(100, Math.max(0, this.indicators[i].getTradSystemCalc()+StepByStepApp.getTradeOffLevel()*this.indicators[i].getTradeOffQuotient()));
		}
		this.amoeba.updateAmoeba("tradeOff", tradeOffValues);
	}

	/*
	 * Initializes the buttons
	 */
	private function drawButtons() :Void{
		logger.debug("initializing buttons");
		var btns = this.createEmptyMovieClip("navbtns", 40);
		btns._x = 770;
		btns._y = 690;
		
		//create button atras
		Utils.newObject(EyeBtn, btns, "btn_atras", 11, {literal:"Atras", callBackObj:StepByStepApp.getNav(), callBackFunc:StepByStepApp.getNav().getPrevious});

		//create button siguente
		Utils.newObject(EyeBtn, btns, "btn_siguiente", 12, {_x:70, literal:"Siguiente", callBackObj:StepByStepApp.getNav(), callBackFunc:StepByStepApp.getNav().getNext});
	}
	
	/*
	 * Creates the button "Next"
	 */
	private function createBtnNext():Void {
		
		//define func
		var fnc:Function = function(){
			if (!this.busy) {
				this.nextStep();
			}
		}
		
		//create button
		Utils.newObject(EyeBtn, this["mcStep"], "btn_next", this["mcStep"].getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.next"), _x:860, _y:550, callBackObj:this, callBackFunc:fnc});
	}

	/*
	 * Creates the button "Back"
	 */
	private function createBtnBack():Void {
		
		//define func
		var fnc:Function = function(){
			if (!this.busy) {
				this.previousStep();
			}
		}
		
		//create button
		Utils.newObject(EyeBtn, this["mcStep"], "btn_back", this["mcStep"].getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.previous"), _x:770, _y:550, callBackObj:this, callBackFunc:fnc});
	}

	/*
	 * Creates the button "Restart Excercise"
	 */
	private function createBtnRestart():Void {
		Utils.newObject(EyeBtn, this["mcStep"], "btn_restart", this["mcStep"].getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.restartExcercise"), _x:600, _y:550, callBackObj:this, callBackFunc:Proxy.create(this, this.getStep, 1)});
	}
}
