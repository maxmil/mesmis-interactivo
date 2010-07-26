import ascb.util.logging.Logger;
import core.util.Proxy;
import core.util.Utils;
import core.comp.TextPane;
import core.comp.UserMessage;
import core.comp.EyeBtn;
import stepByStep.StepByStepApp;
import stepByStep.model.valueObject.Indicator;

/*
 * Optimization/Standardization UI component. With a given indicator the component
 * allows the user to define the maximum and minimum values for the indicator simultaneously
 * visually monitoring the satsifaction of the commercial and traditional systems.
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.comp.Optimizer extends core.util.GenericMovieClip {
	
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.activity.characterization.DefineAmoebas");
	
	//table with live data, live values of max, min and satisfaction for both systems
	private var liveData:MovieClip;
	
	//detail text pane
	private var introText:MovieClip;
	
	//the graph showing max, min and satisfaction of both systems
	private var graph:MovieClip;
	
	//the indicator being optimized
	private var indicator:Indicator;
	
	//messages shown to user
	private var msg:UserMessage;
	
	//callback function when accept button is pressed
	private var callBackFunc;

	/*
	 * Constructor
	 */
	public function Optimizer() {

		//create intro text
		initIntroText();

		//init live data
		initLiveData();

		//init graph
		initGraph();

		//init buttons
		initButtons();

		//init messages
		openMsg(1);
	}
	
	/*
	 * Displays the message with the given id
	 * 
	 * @param msgId the id of the message to display
	 */
	public function openMsg(msgId) :Void{

		var msgTxt:String;

		switch (msgId) {
		case 1 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("optimizer.intro.text"), titleTxt: StepByStepApp.getMsg("optimizer.intro.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat: StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), _x:100, _y:100, w:400, callBackObj:this, callBackFunc:this.closeMsg, btnClose:true});
			break;
		case 2 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("optimizer.graphic.text"), titleTxt: StepByStepApp.getMsg("optimizer.graphic.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat: StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), _x:100, _y:80, w:600, callBackObj:this, callBackFunc:this.closeMsg, btnClose:true});
			this.msg.attachMovie("eqn_1", "eqn", this.msg.getNextHighestDepth(), {_x:150, _y:70});
			break;
		case 3 :
			this.msg = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("optimizer.qualitative.text"), titleTxt: StepByStepApp.getMsg("optimizer.qualitative.title"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxtFormat: StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), _x:100, _y:50, w:600, callBackObj:this, callBackFunc:this.closeMsg, btnClose:true});
			break;
		}
	}

	/*
	 * Closes currently open message by fading it out
	 */
	public function closeMsg() :Void{
		this.msg.fadeOut();
	}

	/*
	 * Initializes detail pane
	 */
	private function initIntroText() :Void{

		var introTp = Utils.newObject(TextPane, this, "introTextPane", this.getNextHighestDepth(), {titleTxt:StepByStepApp.getMsg("optimizer.detailPane.title"), _x:570, _y:17, w:290, h:250});
		introText = introTp.getContent();
		introText.optimizer = this;

		//create text field
		Utils.createTextField("txtField", introText, 2, 0, 0, 270, 100, this.indicator.getOptimizeDesc(), StepByStepApp.getTxtFormat("defaultTxtFormat"));
		introTp.init();
	}

	/*
	 * Initializes buttons
	 */
	private function initButtons() :Void{

		var buttons = this.createEmptyMovieClip("buttons", this.getNextHighestDepth());
		buttons.optimizer = this;
		buttons._x = 550;
		buttons._y = 430;

		//create button accept
		Utils.newObject(EyeBtn, buttons, "btn_accept", buttons.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.accept"), _x:230, callBackFunc:this.callBackFunc});

		//create button graphic
		Utils.newObject(EyeBtn, buttons, "btn_graphic", buttons.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.graphic"), _x:150, callBackObj:this, callBackFunc:Proxy.create(this, this.openMsg, 2)});

		//create button valores cualitativos
		Utils.newObject(EyeBtn, buttons, "btn_valcaul", buttons.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.qualitativeValues"), _x:0, callBackObj:this, callBackFunc:Proxy.create(this, this.openMsg, 3)});
	}

	/*
	 * Initializes live data
	 */
	private function initLiveData() :Void{

		var liveDataTp = Utils.newObject(TextPane, this, "liveDataPane", this.getNextHighestDepth(), {titleTxt:"Datos", _x:570, _y:280, w:290, h:137});
		liveData = liveDataTp.getContent().attachMovie("graph_live_data", "liveData", 1);
		liveData.optimizer = this;
		liveData._x = 3;
		liveData._y = 5;
		liveData.sat_level.text = StepByStepApp.getMsg("optimizer.livedata.levelSatisfaction");
		liveData.nom_ind.text = indicator.getLiteral();
		liveData.rend_min.text = indicator.getMin();
		liveData.rend_tradSys.text = indicator.getTradSystem();
		liveData.rend_comSys.text = indicator.getComSystem();
		liveData.rend_max.text = indicator.getMax();
		liveData.sat_min.text = 0;
		var tradSysCalc:Number = indicator.getTradSystemCalc();
		liveData.sat_tradSys.text = (isNaN(tradSysCalc))?"":String(tradSysCalc);
		var comSysCalc:Number = indicator.getComSystemCalc();
		liveData.sat_comSys.text = (isNaN(comSysCalc))?"":String(comSysCalc);
		liveData.sat_max.text = 100;

		//add updateGraph function to live data
		liveData.updateGraph = function() {
			this.optimizer.graph.removeMovieClip();
			this.optimizer.initGraph();
		};

		//add on change events
		liveData.rend_min.onChanged = function() {

			var n = Number(this.text);
			var indicator = this._parent.optimizer.indicator;

			//validate
			if (isNaN(n) || n>indicator.getMax()) {
				return;
			}

			indicator.setMin(this.text);
			this._parent.updateGraph();
		};

		liveData.rend_max.onChanged = function() {

			var n = Number(this.text);
			var indicator = this._parent.optimizer.indicator;

			//validate
			if (isNaN(n) || n<indicator.getMin()) {
				return;
			}

			indicator.setMax(this.text);
			this._parent.updateGraph();
		};

		//init live data
		liveDataTp.init();
	}

	/*
	 * Initializes graph
	 */
	private function initGraph() :Void{

		var maxLimit = this.indicator.getMaxLimit();

		//add graph
		this.graph = this.createEmptyMovieClip("graph", this.getNextHighestDepth());
		this.graph.optimizer = this;
		this.graph._x = 10;
		this.graph._y = 10;
		this.graph.isObjMax = this.indicator.getObjective().toLowerCase() == "max";
		this.graph.xscale = 500/maxLimit;
		this.graph.minY = this.graph.isObjMax ? 407 : 7;
		this.graph.maxY = this.graph.isObjMax ? 7 : 407;

		//add graph background
		this.graph.createEmptyMovieClip("bg", 1);
		var bg = this.graph.bg.attachMovie("optimizer_graph_bg", "graph_bg", 1);
		bg.units.text = this.indicator.getUnits();
		bg.unit_1.text = String(maxLimit/5);
		bg.unit_2.text = 2*maxLimit/5;
		bg.unit_3.text = 3*maxLimit/5;
		bg.unit_4.text = 4*maxLimit/5;
		bg.unit_5.text = maxLimit;
		
		//define texts
		bg.excellent.label = StepByStepApp.getMsg("optimizer.excellent");
		bg.acceptable.label = StepByStepApp.getMsg("optimizer.acceptable");
		bg.deficient.label = StepByStepApp.getMsg("optimizer.deficient");
		bg.veryDeficient.label = StepByStepApp.getMsg("optimizer.veryDeficient");
		bg.yAxis.label = StepByStepApp.getMsg("optimizer.yAxis");
		bg.xAxis = StepByStepApp.getMsg("optimizer.xAxis");
		
		trace(bg.yAxis + "  " + StepByStepApp.getMsg("optimizer.yAxis") + " " + bg.yAxis.label);

		//draw graph foreground
		var fg:MovieClip = this.graph.createEmptyMovieClip("fg", 2);

		//draw line
		var line = fg.createEmptyMovieClip("line", 1);

		//create line
		line.lineStyle(2, 0x00FFFF, 100);
		line.moveTo(36+this.indicator.getMin()*this.graph.xscale, this.graph.minY);
		line.lineTo(this.graph.xscale*this.indicator.getMax()+36, this.graph.maxY);

		//add markers
		fg.attachMovie("comSys_marker", "comSys_marker", 2);
		fg.attachMovie("tradSys_marker", "tradSys_marker", 3);
		fg.comSys_marker._x = this.graph.xscale*this.indicator.getComSystem()+36-6;
		fg.tradSys_marker._x = this.graph.xscale*this.indicator.getTradSystem()+36-6;
		if (this.graph.isObjMax) {
			fg.comSys_marker._y = Math.min(401, Math.max(0, 407-(this.indicator.getComSystem()-this.indicator.getMin())*400/(this.indicator.getMax()-this.indicator.getMin())-6));
			fg.tradSys_marker._y = Math.min(401, Math.max(0, 407-(this.indicator.getTradSystem()-this.indicator.getMin())*400/(this.indicator.getMax()-this.indicator.getMin())-6));
		} else {
			fg.comSys_marker._y = Math.min(401, Math.max(0, 407-(this.indicator.getMax()-this.indicator.getComSystem())*400/(this.indicator.getMax()-this.indicator.getMin())-6));
			fg.tradSys_marker._y = Math.min(401, Math.max(0, 407-(this.indicator.getMax()-this.indicator.getTradSystem())*400/(this.indicator.getMax()-this.indicator.getMin())-6));
		}

		//add controllers
		fg.attachMovie("graph_control", "min_control", 4);
		fg.min_control._x = this.graph.xscale*this.indicator.getMin()+36-7.5;
		fg.min_control._y = this.graph.minY-fg.min_control._height/2;
		fg.min_control.literal.text = "Min";
		fg.attachMovie("graph_control", "max_control", 5);
		fg.max_control._x = this.graph.xscale*this.indicator.getMax()+36-7.5;
		fg.max_control._y = this.graph.maxY-fg.max_control._height/2;
		fg.max_control.literal.text = "Max";

		//add drag funcionality
		fg.min_control.onPress = function() {
			this.startDrag(false, 36-7.5, this._parent._parent.minY-this._height/2, Math.min(536-7.5, this._parent.max_control._x), this._parent._parent.minY-this._height/2);
			this.onEnterFrame = function() {
				this._parent._parent.optimizer.indicator.setMin((this._x+7.5-36)/this._parent._parent.xscale);
				this._parent._parent.optimizer.refreshGraph();
			};
		};
		fg.min_control.onRelease = function() {
			this.stopDrag();
			this.onEnterFrame = null;
		};
		fg.min_control.onRollOut = function() {
			this.stopDrag();
			this.onEnterFrame = null;
		};
		fg.max_control.onPress = function() {
			this.startDrag(false, Math.max(this._parent.min_control._x, 36-7.5), this._parent._parent.maxY-this._height/2, 536-7.5, this._parent._parent.maxY-this._height/2);
			this.onEnterFrame = function() {
				this._parent._parent.optimizer.indicator.setMax((this._x+7.5-36)/this._parent._parent.xscale);
				this._parent._parent.optimizer.refreshGraph();
			};
		};
		fg.max_control.onRelease = function() {
			this.stopDrag();
			this.onEnterFrame = null;
		};
		fg.max_control.onRollOut = function() {
			this.stopDrag();
			this.onEnterFrame = null;
		};
	}
	
	/*
	 * Redraws graph acording to maximum and minimum values read from position of the
	 * maximum and minimum markers
	 */
	public function refreshGraph() :Void{
		
		//recalcute levels of satisfaction
		if (this.graph.isObjMax) {
			this.indicator.setComSystemCalc(Math.min(100, Math.max(0, (this.indicator.getComSystem()-this.indicator.getMin())*100/(this.indicator.getMax()-this.indicator.getMin()))));
			this.indicator.setTradSystemCalc(Math.min(100, Math.max(0, (this.indicator.getTradSystem()-this.indicator.getMin())*100/(this.indicator.getMax()-this.indicator.getMin()))));
		} else {
			this.indicator.setComSystemCalc(Math.min(100, Math.max(0, (this.indicator.getMax()-this.indicator.getComSystem())*100/(this.indicator.getMax()-this.indicator.getMin()))));
			this.indicator.setTradSystemCalc(Math.min(100, Math.max(0, (this.indicator.getMax()-this.indicator.getTradSystem())*100/(this.indicator.getMax()-this.indicator.getMin()))));
		}

		//redraw line
		var fg:MovieClip = this.graph.fg;
		fg._line.removeMovieClip();
		fg.createEmptyMovieClip("line", 1);
		fg.line.lineStyle(2, 0x00FFFF, 100);
		fg.line.moveTo(this.indicator.getMin()*this.graph.xscale+36, this.graph.minY);
		fg.line.lineTo(this.indicator.getMax()*this.graph.xscale+36, this.graph.maxY);

		//reposition markers
		fg.comSys_marker._y = 407-4*this.indicator.getComSystemCalc()-6;
		fg.tradSys_marker._y = 407-4*this.indicator.getTradSystemCalc()-6;

		//update live data
		var liveData = graph.optimizer.liveData;
		liveData.rend_min.text = this.indicator.getMin();
		liveData.rend_max.text = this.indicator.getMax();
		liveData.sat_tradSys.text = this.indicator.getTradSystemCalc();
		liveData.sat_comSys.text = this.indicator.getComSystemCalc();
	}
}
