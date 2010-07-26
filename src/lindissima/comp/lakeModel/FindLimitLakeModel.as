import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.UserMessage;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import lindissima.model.InitParam;
import core.comp.Graph;
import core.comp.ResultTable;
import lindissima.comp.lakeModel.LMPhaseDiagram;
import lindissima.process.WeedCon;

/*
 * Component for finding the limit of nitrogen in the lake model so that the lake
 * maintains clear all year when the initial condition is clear (low weed concentration).
 * 
 * Offers table filled by the user with varying values of nitrogen filtering and a 
 * graphic that shows the evoltion of weed concentration against time for a particular 
 * level of nitrogen filtering.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 20-07-2005
 */
class lindissima.comp.lakeModel.FindLimitLakeModel extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.lakeModel.FindLimitLakeModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var wc:WeedCon;
	
	//initial condition of concentration of weeds in lake. Valid values are "low" and "high"
	public var initCond:String;
	
	//parameters
	public var savedVals:Array;
	public var nLevel:Number;
	public var weedCon:Number;
	
	//constants
	public static var nRows:Number = 15;
	
	//phase diagram component used for determining the separator
	private var pd:LMPhaseDiagram;
	
	/*
	 * Constructor
	 */
	function FindLimitLakeModel(){

		logger.debug("instantiating FindLimitLakeModel");
		
		//initialize internal variables
		savedVals = new Array();
		
		//initialize processes
		wc = WeedCon(WeedCon.getProcess());
		
		//create nitrogen input box
		initNitInputBox();
		
		//initialize buttons
		initBtns();
		
		//initialize detail table
		var detailTbl = Utils.newObject(ResultTable, this, "detailTbl", this.getNextHighestDepth(),{_x:50, _y:100, nRows:nRows, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		detailTbl.addCol("nFiltered", LindApp.getMsg("tbl.col.nFiltered"), this, this.getTableValue, 100);
		detailTbl.addCol("weedCon", LindApp.getMsg("tbl.col.weedConYearEnd"), this, this.getTableValue, 200);
		
		//initialize graph
		var wcvtGraph = Utils.newObject(Graph, this, "wcvtGraph", this.getNextHighestDepth(), {_x:400, _y:100, w:550, h:350, xAxisRange:365, xAxisScale:20, yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		wcvtGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtGraph.addLimit("separator", LindApp.getMsg("lakeModel.weedConVsTimeGraph.sepLimit"), null, null, 0xffaa00);
		wcvtGraph.addGraphicFromFunc("wcvtGraphic", (initCond=="low") ? 0x09a6cc : 0xcccc00, this.wc, this.wc.getOutput, 1, 10, 0, true);
		LUtils.addDryWetAxis(wcvtGraph, 1, 20);
		LUtils.addClearTurbidBg(wcvtGraph, "horizontal");
		
		//init phase diagram
		pd = new LMPhaseDiagram();
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
		
		//redefine savedVals
		this.savedVals.splice(0);
		
		//update table
		this["detailTbl"].update();
		
		//clear any previous outputs
		this.wc.clearOutput();
		
		//reset nitrogen level
		this.nLevel = null;
		this["nib"].tf_ib.text = "";
		
		//erase graphic
		this["wcvtGraph"].eraseGraphic("wcvtGraphic");
		
		//reset separator
		this.pd.reset();
		var sep:Number = this.pd.getSeparator();
		this["wcvtGraph"].updateLimit('separator', sep, sep);

	}
	
	/*
	 * Removes the active user message by fading it out
	 */
	public function removeMessage():Void{
		if (this["msg"]){
			this["msg"].fadeOut();
		}
	}
	
	/*
	 * Initializes the nitrogen input box
	 */
	private function initNitInputBox():Void{
		
		//create container clip
		var nib = this.createEmptyMovieClip("nib", this.getNextHighestDepth());
		nib._x = 50;
		nib._y = 20;
		
		//create literal text field
		Utils.createTextField("tf_lit", nib, nib.getNextHighestDepth(), 0, 0, 180, 20, LindApp.getMsg("lakeModel.nFiltered"), LindApp.getTxtFormat("defaultTxtFormat"));
		
		//create input box
		nib.createTextField("tf_ib", nib.getNextHighestDepth(), nib["tf_lit"]._width+10, 0, 50, 20);
		nib["tf_ib"].setNewTextFormat(LindApp.getTxtFormat("defaultTxtFormat"));
		nib["tf_ib"].text = "";
		nib["tf_ib"].border = true;
		nib["tf_ib"].borderColor = Const.DEFAULT_BORDER_COLOR;
		nib["tf_ib"].type = "input";
		nib["tf_ib"].selectable = true;
		nib["tf_ib"].embedFonts = true;
		
		//create button generate
		var btn_gen = Utils.newObject(core.comp.EyeBtn, nib, "btn_gen", nib.getNextHighestDepth(), {_x:nib["tf_ib"]._x+nib["tf_ib"]._width+10, _y:0, literal:LindApp.getMsg("btn.generate")})
		btn_gen.focusEnabled = true;
		btn_gen.onRelease = function(){
			var flcl:FindLimitLakeModel = this._parent._parent;
			flcl.removeMessage();
			var nLevel:Number = Number(this._parent.tf_ib.text);
			var nAnualIP:InitParam = LUtils.getIPObj("nAnual");
			var minVal:Number = nAnualIP.getMinVal();
			var maxVal:Number = nAnualIP.getMaxVal();
			var precision:Number = nAnualIP.getPrecision();
			if (isNaN(nLevel) || nLevel<minVal || nLevel>maxVal){

				//if is not valid value for anual fertilizer then complain
				var args:Array = new Array(2);
				args[0] = minVal.toString();
				args[1] = maxVal.toString();
				Utils.newObject(UserMessage, flcl, "msg", flcl.getNextHighestDepth(), {txt:LindApp.getMsg("cornModel.excercise.error.fert", args), _x:400, _y:20, w:500, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			}else{

				//round nLevel
				flcl.nLevel = Utils.roundNumber(nLevel, precision);
				this._parent.tf_ib.text = flcl.nLevel;

				//run model with new value of nitrogen
				flcl.runModel(flcl.nLevel);
			}
		}
	}
	
	/*
	 * Initializes the buttons for adding/removing outputs in the table
	 */
	private function initBtns():Void{
		
		//define separation between buttons
		var bntSep:Number = 10;
		
		//create container clip
		var btns = this.createEmptyMovieClip("btns", this.getNextHighestDepth());
		btns._x = 50;
		btns._y = this["nib"]._y+this["nib"]._height+20;
		
		//create button save
		var btn_save = Utils.newObject(core.comp.EyeBtn, btns, "btn_save", btns.getNextHighestDepth(), {_x:0, _y:0, literal:LindApp.getMsg("btn.save")});
		btn_save.focusEnabled = true;
		btn_save.onRelease = function(){
			//add to saved values
			var flcl = this._parent._parent;
			if(!isNaN(flcl.nLevel)){
				flcl.savedVals.unshift(new Object({nFiltered:flcl.nLevel, weedCon:flcl.weedCon}));
				flcl["detailTbl"].update();
			}
		}
		
		//create button remove
		var btn_remove_last = Utils.newObject(core.comp.EyeBtn, btns, "btn_remove", btns.getNextHighestDepth(), {_x:btn_save._x+btn_save._width+bntSep, _y:0, literal:LindApp.getMsg("btn.removeLast")});
		btn_remove_last.onRelease = function(){
			//remove last saved value and update table
			var flcl = this._parent._parent;
			flcl.savedVals.shift();
			flcl["detailTbl"].update();
		}

		//create button remove all
		var btn_remove_all = Utils.newObject(core.comp.EyeBtn, btns, "btn_remove_all", btns.getNextHighestDepth(), {_x:btn_remove_last._x+btn_remove_last._width+bntSep, _y:0, literal:LindApp.getMsg("btn.removeAll")});		
		btn_remove_all.onRelease = function(){
			//remove all saved value and update table
			var flcl = this._parent._parent;
			flcl.savedVals.splice(0);
			flcl["detailTbl"].update();
		}
	}
	
	/*
	 * Runs the model with the initial level of filtered nitrogen indicated by the
	 * input parameter and updates all UI Components
	 *
	 * @param i the index of the saved val to calculate in this execution
	 */
	public function runModel():Void{
		
		//clear any previous outputs
		this.wc.clearOutput();
		
		//set initial condition
		LUtils.setInitialWeeds(this.initCond, 0);
		
		//set the filtered nitrogen in the lake
		LUtils.setIP("nLake", this.nLevel);
		
		//update weed concentration
		this.weedCon = Utils.roundNumber(this.wc.getOutput(365), 2);

		//update detail table
		this["detailTbl"].update();

		//calculate separator for graph
		this.pd.reset();
		this.pd.setNLevel(this.nLevel);
		var sep:Number = this.pd.getSeparator();

		//update graph
		this["wcvtGraph"].updateLimit('separator', sep, sep);
		this["wcvtGraph"].update();
	}
	
	/*
	 * Auxiliar function to draw values for the detail table
	 * 
	 * @param rowInd the index of the row to retreive
	 * @param colId the name of the column to retreive
	 * 
	 * @return the cell value based on the column id and row number using the internal
	 * array of saved values
	 */
	public function getTableValue(rowInd:Number, colId:String):String{
		
		var savedVal:Object;
		var ret:String = "";
		
		//if no value is defined then return ""
		if(rowInd<savedVals.length){
			savedVal = savedVals[rowInd];
		}else{
			return "";
		}
		
		
		switch (colId){
			case "nFiltered":
				ret = String(savedVal.nFiltered);
			break;
			case "weedCon":
				 if (savedVal.weedCon){
					 ret = String(savedVal.weedCon);
				 }
			break;
		}
		
		return ret;
		
	}
}