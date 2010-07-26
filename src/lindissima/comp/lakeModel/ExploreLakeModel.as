import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import core.comp.Graph;
import core.comp.ResultTable;
import lindissima.comp.lakeModel.LMPhaseDiagram;
import lindissima.process.WeedCon;

/*
 * Component for exploring the lake model when the initial condition is clear (low weed concentration).
 * Offers table with fixed values of nitrogen filtering and a graphic that shows the evoltion
 * of weed concentration against time for a particular level of nitrogen filtering.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 19-07-2005
 */
class lindissima.comp.lakeModel.ExploreLakeModel extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.lakeModel.ExploreLakeModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var wc:WeedCon;
	
	//parameters
	public var savedVals:Array;
	
	//initial condition of concentration of weeds in lake. Valid values are "low" and "high"
	public var initCond:String;
	
	//constants
	public static var nRows:Number = 7;
	public static var inc:Number = 0.5;
	
	//phase diagram component used for determining the separator
	private var pd:LMPhaseDiagram;
	
	/*
	 * Constructor
	 */
	function ExploreLakeModel(){

		logger.debug("instantiating ExploreLakeModel");
		
		//initialize internal variables
		savedVals = new Array();
		for (var i=0; i<nRows; i++){
			savedVals.push(new Object({nFiltered:i*inc, weedCon:null}))
		}
		
		//initialize processes
		wc = WeedCon(WeedCon.getProcess());
		
		//create img
		var loader = this["createClassObject"](mx.controls.Loader, "loader", this.getNextHighestDepth(), {_x:30, _y:20, _width:320, _height:100});
		loader.load("lindissima/img/lakeModel/lake_bg.jpg");
		
		//initialize detail table
		var detailTbl = Utils.newObject(ResultTable, this, "detailTbl", this.getNextHighestDepth(),{_x:50, _y:150, nRows:nRows, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		detailTbl.addCol("nFiltered", LindApp.getMsg("tbl.col.nFiltered"), this, this.getTableValue, 100);
		detailTbl.addCol("weedCon", LindApp.getMsg("tbl.col.weedConYearEnd"), this, this.getTableValue, 200);
		
		//initialize table buttons
		initTableBtns();
		
		//initialize graph
		var wcvtGraph = Utils.newObject(Graph, this, "wcvtGraph", this.getNextHighestDepth(), {_x:400, _y:20, w:550, h:300, xAxisRange:365, xAxisScale:20, yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		wcvtGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtGraph.addLimit("separator", LindApp.getMsg("lakeModel.weedConVsTimeGraph.sepLimit"), null, null, 0xffaa00);
		wcvtGraph.addGraphicFromFunc("wcvtGraphic", (initCond=="low") ? 0x09a6cc : 0xcccc00, this.wc, this.wc.getOutput, 1, 10, 0, true);
		LUtils.addDryWetAxis(wcvtGraph, 1, 20);
		LUtils.addClearTurbidBg(wcvtGraph, "horizontal");
		
		//init phase diagram
		pd = new LMPhaseDiagram();
		
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
		
		//redefine savedVals
		this.savedVals.splice(0);
		for (var i=0; i<nRows; i++){
			this.savedVals.push(new Object({nFiltered:i*inc, weedCon:null}))
		}
		
		//update table
		this["detailTbl"].update();
		
		//clear any previous outputs
		this.wc.clearOutput();
		
		//erase graphic
		this["wcvtGraph"].eraseGraphic("wcvtGraphic");
		
		//reset separator
		this.pd.reset();
		var sep:Number = this.pd.getSeparator();
		this["wcvtGraph"].updateLimit('separator', sep, sep);

	}
	
	/*
	 * Initializes the table buttons. One button is drawn next to each row. When the button
	 * is clicked the model is run with the corresponding level of filtered nitrogen
	 */
	private function initTableBtns(){
		
		//row height of table
		var rHeight:Number = this["detailTbl"].rHeight;
		
		//create container clip
		var btns = this.createEmptyMovieClip("btns_play", this.getNextHighestDepth());
		btns._x = this["detailTbl"]._x-20;
		btns._y = this["detailTbl"]._y+rHeight;
		
		//loop through rows creating buttons
		var btn;
		for (var i=0; i<nRows; i++){
			
			//create button
			btn = btns.attachMovie("btn_play", "btn_play_"+String(i), btns.getNextHighestDepth());
			btn._y = rHeight*i + (rHeight-15)/2;
			btn["ind"] = i;
			
			//add functionality
			btn.onRelease = function(){
				var ecl:ExploreLakeModel = this._parent._parent;
				ecl.runModel(this.ind);
			}
			
		}
	}
	
	/*
	 * Runs the model with the initial level of filtered nitrogen indicated by the
	 * input parameter and updates all UI Components
	 *
	 * @param i the index of the saved val to calculate in this execution
	 */
	public function runModel(i:Number):Void{
		
		//get saved val
		var savedVal:Object = this.savedVals[i];
		
		//clear any previous outputs
		this.wc.clearOutput();
		
		//set initial condition
		LUtils.setInitialWeeds(this.initCond, 0);
		
		//set the filtered nitrogen in the lake
		LUtils.setIP("nLake", savedVal.nFiltered);
		
		//update saved val (this causes model to rerun)
		savedVal.weedCon = Utils.roundNumber(this.wc.getOutput(365), 2);
		
		//update detail table
		this["detailTbl"].update();
		
		//calculate separator for graph
		this.pd.reset();
		this.pd.setNLevel(savedVal.nFiltered);
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
		
		var savedVal:Object = savedVals[rowInd];
		var ret:String = "";
		
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