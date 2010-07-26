import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.Amoeba;
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
class stepByStep.comp.TradeOff extends core.util.GenericMovieClip {
	
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.comp.TradeOff");
	
	//array of indicators
	private var indicators:Array;
	
	//the scale of the synthesizer/slide bar
	public var synthScale:Number;
	
	//the amoeba
	private var amoeba:Amoeba;
	
	/*
	 * Constructor
	 */
	function TradeOff() {
		
		logger.debug("instantiating trade offs");
		
		//define default properties
		synthScale = (synthScale==undefined)?100:synthScale;
		
		//get selected indicators
		this.indicators = MUtils.selectIndicators(StepByStepApp.getApp().indicators);
		
		//initialize subcomponents
		drawAmoeba();
		drawSynthesizer();
	}
	
	/*
	 * Inicializes the amoeba
	 */
	private function drawAmoeba() :Void{

		//initialize titles and values
		var titles:Array = new Array(this.indicators.length);
		var tradSysValues:Array = new Array(this.indicators.length);
		var tradeOffValues:Array = new Array(this.indicators.length);
		
		//define titles and values
		for (var i = 0; i<this.indicators.length; i++) {
			titles[i] = this.indicators[i].getLiteral();
			tradSysValues[i] = this.indicators[i].getTradSystemCalc();
			tradeOffValues[i] = Math.min(100, Math.max(0, this.indicators[i].getTradSystemCalc()+StepByStepApp.getTradeOffLevel()*this.indicators[i].getTradeOffQuotient()));
		}
		
		//create amoeba
		this.amoeba = Utils.newObject(Amoeba, this, "amoeba", this.getNextHighestDepth(), {titles:titles, _x:10, _y:100});
		this.amoeba.addAmoeba("tradSys", StepByStepApp.getMsg("tradeOff.amoeba.originalSystem"), 0x0000ff, tradSysValues);
		this.amoeba.addAmoeba("tradeOff", StepByStepApp.getMsg("tradeOff.amoeba.modifiedSystem"), 0x00ff00, tradeOffValues);
	}
	
	/*
	 * Inicializes the synthesizer
	 */
	private function drawSynthesizer() :Void{

		var synth = this.attachMovie("synth", "synth", this.getNextHighestDepth());
		synth._x = 100;
		synth._y = 0;
		
		//init texts
		synth.titleTxt.text = StepByStepApp.getMsg("tradeOff.slideBar.titleTxt");
		synth.desc.text = StepByStepApp.getMsg("tradeOff.slideBar.desc");
		synth.level_literal.text = StepByStepApp.getMsg("tradeOff.slideBar.actualLevel");
		
		//set initial value for actual level and add on change listener
		synth.actualLevel.text = (StepByStepApp.getTradeOffLevel()+0.5)*this.synthScale;
		synth.actualLevel.onChanged = function() {
			
			//get levels
			var tradeOff:TradeOff = this._parent._parent;
			var unscaledLevel = Math.max(Math.min(Number(this.text), tradeOff.synthScale), 0);
			var scaledLevel = (unscaledLevel-(tradeOff.synthScale/2))/(tradeOff.synthScale/2);
			
			//update
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
				var tradeOff:TradeOff = this._parent._parent;
				
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
	 * Desactivates the component
	 */
	public function desactivate():Void{
		this.onRelease = function(){
			//do nothing
		}
		this.useHandCursor = false;
	}
	
	
	/*
	 * Activates the component
	 */
	public function activate():Void{
		delete this.onRelease;
		this.useHandCursor = true;
	}
}
