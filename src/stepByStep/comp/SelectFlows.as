import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.UserMessage;
import core.comp.Scroll;
import core.comp.TextPane;
import core.comp.EyeBtn;
import stepByStep.StepByStepApp;
import mx.controls.ComboBox;

/*
 * Flow Selector. UIComponent that opens in its own text pane and 
 * allows the selection of flows
 * 
 * @author Max Pimm
 * @created 22-05-2005
 * @version 1.0
 */ 
class stepByStep.comp.SelectFlows extends core.util.GenericMovieClip {
	
	//logger
	private static var logger : Logger = Logger.getLogger ("stepByStep.comp.SelectFlows");
	
	//flows array
	private var flows:Array;
	
	//subsistems array
	private var subsystems:Array;
	
	//array index of currently selected flow
	private var currFlowsInd:Number;
	
	//function of callback object that is invoked and passed the index of the selected flow when the selection is made
	private var addFlowFnc:Function;
	
	//function called when close button is pressed
	private var closeFnc:Function;
	
	//user message currently being displayed
	private var usrMsg:UserMessage;
	
	/*
	 * Constructor
	 */
	public function SelectFlows() {
		
		logger.debug("instantiating SelectFlows");
		
		//create container text pane
		var tp:TextPane = Utils.newObject(TextPane, this, "tp", this.getNextHighestDepth(),{titleTxt:StepByStepApp.getMsg("selectFlows.title"), w:500, h:490, doScroll:false});
		var cont:MovieClip = tp.getContent();
		
		//create component text pane
		var scFlow:Scroll = Utils.newObject(Scroll, cont, "scFlow", cont.getNextHighestDepth(),{_x:20, _y:10, w:100, h:430});
		
		//add flows to textpane
		initFlows();
		scFlow.init();
		
		//add detail text pane
		initDetailPane();
		
		//add subsytem combo
		initSubsysCombo();
		
		//add butttons
		initBtns();
		
		//init container text pane
		tp.init(true);
		
		//create intro message
		usrMsg = Utils.newObject(UserMessage, tp, "msg", tp.getNextHighestDepth(),{txt:StepByStepApp.getMsg("selectFlows.intro"), _x:160, _y:130, w:300, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
	}
	
	/*
	 * Initialize flows
	 */
	private function initFlows() :Void {

		//reset indice of selected component
		this.currFlowsInd = null;
		
		//vertical space between flows
		var vspace:Number = 10;
		
		//container clip
		var scClip:MovieClip = this["tp"].getContent()["scFlow"].getContentClip();
		if (scClip["mcflows"]) {
			scClip["mcflows"].removeMovieClip();
		}
		var mcflows:MovieClip = scClip.createEmptyMovieClip("mcflows", scClip.getNextHighestDepth());
		mcflows.selectFlows = this;
		
		//loop through components drawing all those that are not selected
		for (var i = 0; i<flows.length; i++) {
			
			if (!flows[i].getIsSel()) {
				
				//create container clip
				var mcFlow:MovieClip = mcflows.createEmptyMovieClip("mcFlow_"+String(this.flows[i].getId()), mcflows.getNextHighestDepth());
				mcFlow._x = 10;
				mcFlow._y = mcflows._height+vspace;
				mcFlow.ind = i;
				
				//create img clip
				if (this.flows[i].getImg() != null && this.flows[i].getImg().length>0) {
					var img = mcFlow.createEmptyMovieClip("img", mcFlow.getNextHighestDepth());
					
					//create mask clip
					var mask = img.createEmptyMovieClip("mask", img.getNextHighestDepth());
					mask.beginFill(0x000000, 100);
					this.drawArrow(mask);
					mask.endFill();
					img.setMask(mask);
					
					//create loader
					var loader = img.createClassObject(mx.controls.Loader, "loader", mcFlow.getNextHighestDepth(), {_x:0, _y:0, _width:mask._width, _height:mask._height, _alpha:50, scaleContent:true});
					loader.load("stepByStep/img/flows/"+this.flows[i].getImg());
					
					//add rollover functionality
					mcFlow.onRollOver = function() {
						this.img.loader._alpha = 100;
					};
					mcFlow.onRollOut = function() {
						this.img.loader._alpha = 50;
					};
				}
				
				//create outline clip
				var outline = mcFlow.createEmptyMovieClip("outline", mcFlow.getNextHighestDepth());
				outline.lineStyle(5, 0xCCFF99, 100);
				this.drawArrow(outline);
				
				//on release show detail
				mcFlow.onRelease = function() {
					this._parent.selectFlows.selFlow(this.ind);
				};
			}
		}
	}
	
	/*
	 * Initialize detail pane
	 */
	private function initDetailPane() :Void {

		//get detail pane if exists and remove
		var tpDetail:TextPane = this["tp"].getContent()["tpDetail"];
		if (tpDetail) {
			tpDetail.removeMovieClip();
		}
		
		//recreate detail pane with intro text
		tpDetail = Utils.newObject(TextPane, this["tp"].getContent(), "tpDetail", this["tp"].getContent().getNextHighestDepth(), {titleTxt:StepByStepApp.getMsg("selectFlows.detailpane.title"), _x:140, _y:10, w:340, h:300});
		tpDetail.init(false);
	}
	
	/*
	 * Initialize the subsystem combo boxes
	 */
	private function initSubsysCombo() :Void {
		
		//container clip
		var subsysCont:MovieClip = this["tp"].getContent().createEmptyMovieClip("subsysCombo", this["tp"].getContent().getNextHighestDepth());
		
		//init combo box arrays
		var labelsArray = new Array();
		var dataArray = new Array();
		labelsArray[0] = StepByStepApp.getMsg("combo.select");
		dataArray[0] = 0;
		for (var i = 0; i<this.subsystems.length; i++) {
			labelsArray[labelsArray.length] = this.subsystems[i].getLiteral();
			dataArray[dataArray.length] = this.subsystems[i].getId();
		}
		
		//create text field exiting
		Utils.createTextField("tf_exit", subsysCont, subsysCont.getNextHighestDepth(), 140, 320, 340, 20, StepByStepApp.getMsg("selectFlows.selectSubsysExit"), StepByStepApp.getTxtFormat("defaultMsgTxtFormat"));
		
		//create combo box exiting
		var cb_exit:mx.controls.ComboBox = subsysCont.createClassObject(mx.controls.ComboBox, "cb_exit", subsysCont.getNextHighestDepth(), {labels:labelsArray, data:dataArray, dropdownWidth:330, _x:140, _y:340, _width:330});
		cb_exit.setStyle("fontFamily", "Arial");
		cb_exit.setStyle("embedFonts", true);
		cb_exit.rowCount = 6;
		
		//create text field entry
		Utils.createTextField("tf_entry", subsysCont, subsysCont.getNextHighestDepth(), 140, 370, 340, 20, StepByStepApp.getMsg("selectFlows.selectSubsysEntry"), StepByStepApp.getTxtFormat("defaultMsgTxtFormat"));
		
		//create combo box entry
		var cb_entry:mx.controls.ComboBox = subsysCont.createClassObject(mx.controls.ComboBox, "cb_entry", subsysCont.getNextHighestDepth(), {labels:labelsArray, data:dataArray, dropdownWidth:330, _x:140, _y:390, _width:330});
		cb_entry.setStyle("fontFamily", "Arial");
		cb_entry.setStyle("embedFonts", true);
		cb_entry.rowCount = 6;
	}

	/*
	 * Initialize the buttons
	 */
	private function initBtns() :Void {
		
		//create buttons
		var btn_close:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_close", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.close"), callBackObj:null, callBackFunc:this.closeFnc});
		var btn_add_all:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_add_all", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.addAll"), callBackObj:null, callBackFunc:this.addFlowFnc});
		var btn_add:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_add", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.add"), callBackObj:this, callBackFunc:addFlow});
		
		//position buttons
		btn_close._x = this["tp"]._width-btn_close._width-10;
		btn_add_all._x = btn_close._x-btn_add_all._width-10;
		btn_add._x = btn_add_all._x-btn_add._width-10;
	}

	/*
	 * Select a flow
	 * 
	 * @param ind the index of the flow to select
	 */
	public function selFlow(ind:Number) :Void {

		//remove user message if exists
		if (this.usrMsg){
			this.usrMsg.removeMovieClip();
		}
		
		//define content movieclip
		var cont:MovieClip = this["tp"].getContent();
		
		//update selected component index
		this.currFlowsInd = ind;
		
		//remove old detail pane
		cont["tpDetail"].removeMovieClip();
		
		//create new detail text pane
		var tpDetail:TextPane = Utils.newObject(TextPane, cont, "tpDetail", cont.getNextHighestDepth(), {titleTxt:this.flows[ind].getLiteral(), _x:140, _y:10, w:340, h:300});
		var contDetail = tpDetail.getContent();
		Utils.createTextField("tf", contDetail, contDetail.getNextHighestDepth(), 0, 0, 320, 250, this.flows[ind].getDescription(), StepByStepApp.getTxtFormat("defaultTxtFormat"));
		
		//create loader and load image
		var loader = contDetail.createClassObject(mx.controls.Loader, "loader", contDetail.getNextHighestDepth(), {_x:70, _y:contDetail["tf"]._height+10, _width:200, _height:133});
		loader.load("stepByStep/img/flows/"+this.flows[ind].getImg());
		var listener:Object = new Object();
		listener.tp = this["tp"];
		listener.complete = function(eventObject) {
			this.tpDetail.init(true);
		};
		loader.addEventListener("complete", listener);
		tpDetail.init(true);
	}

	/*
	 * Adds the selected flow by calling the callback function
	 * on the callback object and passing it the selected flows id.
	 * 
	 * First it validates that a flow has been selected and that the 
	 * correct entry and exit subsystems are defined
	 */
	public function addFlow() :Void {

		//remove user message if exists
		if (this.usrMsg) {
			this.usrMsg.removeMovieClip();
		}
		
		//check that flow is selected
		if (this.currFlowsInd == null) {
			if (this.usrMsg) {
				this.usrMsg.removeMovieClip();
			}
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("selectFlows.error.noFlowSelected"), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding flow: no flow selected");
			return;
		}
		var cb_exit:ComboBox = this["tp"].getContent().subsysCombo.cb_exit;
		var cb_entry:ComboBox = this["tp"].getContent().subsysCombo.cb_entry;
		
		//check that exit subsistem is selected
		if (cb_exit.value == 0) {
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("selectFlows.error.noSubsysExitSelected", new Array(this.flows[this.currFlowsInd].getLiteral())), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding flow: no exit subsystem selected");
			return;
		}
		
		//check that entry subsistem is selected
		if (cb_entry.value == 0) {
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("selectFlows.error.noSubsysEntrySelected", new Array(this.flows[this.currFlowsInd].getLiteral())), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding flow: no entry subsystem selected");
			return;
		}
		
		//check that exit and entry subsistems are correct
		if (cb_exit.value != this.flows[this.currFlowsInd].getSubsysExit() || cb_entry.value != this.flows[this.currFlowsInd].getSubsysEntry()) {
			var args = new Array(this.flows[this.currFlowsInd].getLiteral(), cb_exit.text, cb_entry.text)
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("selectFlows.error.wrongSubsystems", args), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding flow: the flow "+this.flows[this.currFlowsInd].getLiteral()+" does not go from "+cb_exit.text+" to "+cb_entry.text);
			return;
		}
		
		//invoke callback function on callback object and pass the selected flow index
		this.addFlowFnc(this.currFlowsInd);
		
		//reinitialize flows
		this.initFlows();
		
		//re-initialize detail pane
		this.initDetailPane();
		
		//reset subsys combo boxes
		cb_exit.selectedIndex = 0;
		cb_entry.selectedIndex = 0;
	}

	/*
	 * Draws an arrow shape 
	 * 
	 * @param mc the MovieClip in whice to draw the arrow
	 */
	private function drawArrow(mc:MovieClip) :Void {
		mc.moveTo(0, 10);
		mc.lineTo(50, 10);
		mc.lineTo(50, 0);
		mc.lineTo(80, 30);
		mc.lineTo(50, 60);
		mc.lineTo(50, 50);
		mc.lineTo(0, 50);
		mc.lineTo(0, 10);
	}
}