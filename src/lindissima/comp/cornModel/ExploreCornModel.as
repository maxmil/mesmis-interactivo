import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.ComponentWindow;
import core.comp.UserMessage;
import lindissima.comp.cornModel.ExploreCornModelAuxGraphs;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.model.InitParam;
import core.comp.Graph;
import core.comp.ResultTable;
import lindissima.process.CornBiomass;
import lindissima.process.FarmerNetProfit;
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
class lindissima.comp.cornModel.ExploreCornModel extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornModel.ExploreCornModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var nis:NInSoil;
	private var fnp:FarmerNetProfit;
	private var cb:CornBiomass;
	
	//parameters
	public var nAnual:Number;
	public var savedVals:Array;

	
	/*
	 * Constructor
	 */
	public function ExploreCornModel() {
		
		logger.debug("instantiating ExploreCornModel");
		
		//initialize internal variables
		nAnual = LUtils.getIP("nAnual", 0);
		savedVals = new Array();
		
		//initialize processes
		nis = NInSoil(NInSoil.getProcess());
		fnp = FarmerNetProfit(FarmerNetProfit.getProcess());
		cb = CornBiomass(CornBiomass.getProcess());
		
		//initialize fertilizer input box
		initFertInputBox();
		
		//create img
		var loader = this["createClassObject"](mx.controls.Loader, "loader", this.getNextHighestDepth(), {_x:40, _y:120, _width:360, _height:170});
		loader.load("lindissima/img/cornModel/corn-field.jpg");
		
		//initialize net profit display
		initNetProfit();
		
		//init buttons
		initBtns();
		
		//init detail table
		initDetailTable();
		
		//init the graphics
		initGraphs();
		
		//set initial value and run
		this["fib"].tf_ib.text = "1";
		this["fib"].btn_gen.onRelease();
		this["btns"].btn_save.onRelease();

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
		
		//regenerate model with no fertilizer
		this.nAnual = 0;
		runModel();
		
		//reset net profit vs nitrogen graph
		this.savedVals.splice(0);
		updateNpvnGraphic();
	}

	/*
	 * Initializes the fertilizer input box
	 */
	private function initFertInputBox():Void{
		
		//create container clip
		var fib = this.createEmptyMovieClip("fib", this.getNextHighestDepth());
		fib._x = 50;
		fib._y = 20;
		
		//create literal text field
		fib.createTextField("tf_lit", 1, 0, 0, 180, 20);
		fib["tf_lit"].setNewTextFormat(LindApp.getTxtFormat("defaultTxtFormat"));
		fib["tf_lit"].text = LindApp.getMsg("cornModel.excercise.anualFertLevel");
		fib["tf_lit"].selectable = true;
		fib["tf_lit"].embedFonts = true;
		
		//create input box
		fib.createTextField("tf_ib", fib.getNextHighestDepth(), fib["tf_lit"]._width+10, 0, 50, 20);
		fib["tf_ib"].setNewTextFormat(LindApp.getTxtFormat("defaultTxtFormat"));
		fib["tf_ib"].text = LUtils.getIP("nAnual", 0).toString();
		fib["tf_ib"].border = true;
		fib["tf_ib"].borderColor = Const.DEFAULT_BORDER_COLOR;
		fib["tf_ib"].type = "input";
		fib["tf_ib"].selectable = true;
		fib["tf_ib"].embedFonts = true;
		
		//create button generate
		var btn_gen = Utils.newObject(core.comp.BubbleBtn, fib, "btn_gen", fib.getNextHighestDepth(), {_x:fib["tf_ib"]._x+fib["tf_ib"]._width+30, _y:0, literal:LindApp.getMsg("btn.generate")})
		btn_gen.onRelease = function(){
			var ecm:ExploreCornModel = this._parent._parent;
			ecm.removeErrorMsg();
			var nAnual:Number = Number(this._parent.tf_ib.text);
			var nAnualIP:InitParam = LUtils.getIPObj("nAnual");
			var minVal:Number = nAnualIP.getMinVal();
			var maxVal:Number = nAnualIP.getMaxVal();
			var precision:Number = nAnualIP.getPrecision(); 
			if (isNaN(nAnual) || nAnual<minVal || nAnual>maxVal){
				//if is not valid value for anual fertilizer then complain
				var args:Array = new Array(2);
				args[0] = minVal.toString();
				args[1] = maxVal.toString();
				Utils.newObject(UserMessage, ecm, "errorMsg", ecm.getNextHighestDepth(), {txt:LindApp.getMsg("cornModel.excercise.error.fert", args), _x:400, _y:20, w:500, txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
			}else{
				//regenerate model				
				ecm.nAnual = Utils.roundNumber(nAnual, precision);
				ecm.runModel();
			}
		}
		
		//create note
		fib.createTextField("tf_note", fib.getNextHighestDepth(), 0, fib["tf_lit"]._height+10, btn_gen._x+btn_gen._width, 20);
		fib["tf_note"].text = LindApp.getMsg("cornModel.excercise.anualFertLevel.note");
		fib["tf_note"].setTextFormat(LindApp.getTxtFormat("smallTxtFormat"));
		fib["tf_note"].autoSize = true;
		fib["tf_note"].wordWrap = true;
		fib["tf_note"].embedFonts = true;
	}
	
	/*
	 * Initializes the average net profit display
	 */
	private function initNetProfit():Void{
		
		//create container clip
		var npd = this.createEmptyMovieClip("npd", this.getNextHighestDepth());
		
		//create literal text field
		npd.createTextField("tf_lit", npd.getNextHighestDepth(), 0, 0, 200, 20);
		npd["tf_lit"].text = LindApp.getMsg("cornModel.excercise.aaverageNetProfit");
		npd["tf_lit"].setTextFormat(LindApp.getTxtFormat("altTxtFormat"));
		npd["tf_lit"].autoSize = true;
		npd["tf_lit"].embedFonts = true;
		
		//create non editable input box
		npd.createTextField("tf_ib", npd.getNextHighestDepth(), npd["tf_lit"]._width+10, 0, 70, 20);
		npd["tf_ib"].setNewTextFormat(LindApp.getTxtFormat("altTxtFormat"));
		npd["tf_ib"].text = Utils.roundNumber(this.fnp.avgeProfit(5), 2).toString();
		npd["tf_ib"].borderColor = Const.DEFAULT_BORDER_COLOR;
		npd["tf_ib"].selectable = true;
		npd["tf_ib"].embedFonts = true;
		
		//reposition
		npd._x = 420-npd._width;
		npd._y = 430;
	}
	
	/*
	 * Initializes the buttons for adding/removing outputs in the netProfitVsNit graphic
	 */
	private function initBtns():Void{
		
		//define separation between buttons
		var bntSep:Number = 30;
		
		//create container clip
		var btns = this.createEmptyMovieClip("btns", this.getNextHighestDepth());
		btns._x = 50;
		btns._y = this["fib"]._y+this["fib"]._height+10;
		
		//create button save
		var btn_save = Utils.newObject(core.comp.BubbleBtn, btns, "btn_save", 10, {_x:0, _y:0, literal:LindApp.getMsg("btn.save")});
		btn_save.onRelease = function(){
			var ecm = this._parent._parent;
			
			//if this is not a repetition of the last value of the saved values
			//then add it to the saved values and update the graph
			if (ecm.savedVals[ecm.savedVals.length]==0 || ecm.savedVals[ecm.savedVals.length-1].x != ecm.nAnual){
				ecm.savedVals.push(new Object({x:ecm.nAnual, y:Number(ecm.npd.tf_ib.text)}));
				ecm.updateNpvnGraphic();
			}
		}
		
		//create button remove
		var btn_remove_last = Utils.newObject(core.comp.BubbleBtn, btns, "btn_remove", 11, {_x:btn_save._x+btn_save._width+bntSep, _y:0, literal:LindApp.getMsg("btn.removeLast")});
		btn_remove_last.onRelease = function(){
			var ecm = this._parent._parent;
			ecm.savedVals.pop();
			ecm.updateNpvnGraphic();
		}

		//create button remove all
		var btn_remove_all = Utils.newObject(core.comp.BubbleBtn, btns, "btn_remove_all", 12, {_x:btn_remove_last._x+btn_remove_last._width+bntSep, _y:0, literal:LindApp.getMsg("btn.removeAll")});		
		btn_remove_all.onRelease = function(){
			var ecm = this._parent._parent;
			ecm.savedVals.splice(0);
			ecm.updateNpvnGraphic();
		}
	}
	
	/*
	 * Initializes the detail table
	 */
	private function initDetailTable():Void{
		
		var detailTbl = Utils.newObject(ResultTable, this, "detailTbl", this.getNextHighestDepth(),{_x:40, _y:300, nRows:5, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		detailTbl.addCol("t", LindApp.getMsg("tbl.col.years"), nis, nis.getTableValueYear, 50);
		detailTbl.addCol("nan", LindApp.getMsg("tbl.col.nAnual"), this, this.getNAnual, 50);
		detailTbl.addCol("nis", LindApp.getMsg("tbl.col.nInSoil"), this, this.getNInSoilTbl, 80);
		detailTbl.addCol("cb", LindApp.getMsg("tbl.col.grainBiomass"), this, this.getGrainBiomass, 90);
		//detailTbl.addCol("bp", LindApp.getMsg("tbl.col.bruteProfit"), this, this.getBruteProfit, 80);
		//detailTbl.addCol("fc", LindApp.getMsg("tbl.col.fertCost"), this, this.getFertilizerCost, 80);
		detailTbl.addCol("fnp", LindApp.getMsg("tbl.col.netProfit"), fnp, fnp.getTableValueYear, 90);
	}
	
	/*
	 * Initializes the graphs
	 */
	function initGraphs():Void {
		
		//create container clip
		var graphs = this.createEmptyMovieClip("graphs", this.getNextHighestDepth());
		graphs._x = 450;
		
		//create the he net profit vs nitrogen graphic. 
		//this graphic shows the sequence of points saved by the user
		var npvnGraph = Utils.newObject(Graph, graphs, "npvnGraph", graphs.getNextHighestDepth(), {xAxisRange:15, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornModel.excercise.netProfitVsNitGraph.xAxis"), yAxisRange:4000, yAxisScale:200, yAxisLabel:LindApp.getMsg("cornModel.excercise.netProfitVsNitGraph.yAxis"), w:500, h:250, drwBorder:true});
		npvnGraph.addLimit("migrate", LindApp.getMsg("cornModel.excercise.netProfitVsTimeGraph.migrationLimit"), 2500, 2500, 0xff0000);
		npvnGraph.addGraphicFromArray("npvnGraphic", 0x0000ff, this.savedVals, 0, 5);
		
		//creates the netProfit vs time graph
		var npvtGraph = Utils.newObject(Graph, graphs, "npvtGraph", graphs.getNextHighestDepth(), {_x:0, _y:250, w:250, h:200, xInit:1, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornModel.excercise.netProfitVsTimeGraph.xAxis"), yAxisRange:4000, yAxisScale:500, yAxisLabel:LindApp.getMsg("cornModel.excercise.netProfitVsTimeGraph.yAxis"), drwBorder:true});
		npvtGraph.addGraphicFromFunc("npvtGraphic", 0x0000ff, this, this.getFarmerNetProfit, 1, 1, 2);
		
		//creates the nitrogen in the soil vs time graph
		var yRange:Number = LUtils.getIPObj("nAnual").getMaxVal()+LUtils.getIP("nInicial")+20;
		var nisvtGraph = Utils.newObject(Graph, graphs, "nisvtGraph", graphs.getNextHighestDepth(), {_x:250, _y:250, xInit:1, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.xAxis"), yAxisRange:yRange, yAxisScale:10, yAxisLabel:LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.yAxis"), w:250, h:200, drwBorder:true});
		nisvtGraph.addLimit("errosion", LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.irrevErosionLimit"), Const.LIMIT_ERROSION, Const.LIMIT_ERROSION, 0xff0000);
		nisvtGraph.addLimit("errosion", LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.toxLimit"), Const.LIMIT_ENTOXIFICATION, Const.LIMIT_ENTOXIFICATION, 0xff0000);
		nisvtGraph.addGraphicFromFunc("nisvtGraphic", 0x0000ff, this, this.getNInSoil, 1, 1, 2);
	}
	
	/*
	 * Auxiliar function to draw values for nAnual in the detail table
	 */
	public function getNAnual():String{
		return String(this.nAnual);
	}
	
	/*
	 * Auxiliar function to draw values for brute profit in the detail table
	 * 
	 * @param y the year
	 * @param id the id of the column, not used
	 * @return the brute profit for year y converted to a String
	 */
	public function getBruteProfit(y:Number, id:String):String{
		var netProfit:Number = Number(this.fnp.getTableValueYear(y, id));
		var fertCost:Number = Number(getFertilizerCost());
		return Utils.roundNumber(netProfit+fertCost, 2).toString();
	}

	/*
	 * Auxiliar function to draw values for fertilizer cost in the detail table
	 * 
	 * @return the cost of the fertilizer converted to a String
	 */
	public function getFertilizerCost():String{
		return Utils.roundNumber((LUtils.getIP("cstUrea")*nAnual*Const.HECTARES_CORN)/(Const.NIT_PER_UREA*Const.WEIGHT_UREA), 2).toString();
	}
	
	/*
	 * Auxiliar function to draw values for grain biomass in table.
	 * 
	 * @param y the year for which the biomass is required
	 * @param id the id of the column, not used
	 * @return the biomass of grain harvested
	 */
	public function getGrainBiomass(y:Number, id:String):String{
		return Utils.roundNumber(this.cb.getAcumAnual(y)*Const.HECTARES_CORN*LUtils.getIP("indCosecha"), 2).toString();
	}	
	
	/*
	 * Auxiliar function to draw values for farmer net profit in graph. Must shift the values by -1.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getFarmerNetProfit(y:Number):Number{
		return Utils.roundNumber(this.fnp.getOutput(y-1), 2);
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen in soil in graph. Must shift the values by -1.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getNInSoil(y:Number):Number{
		return Utils.roundNumber(this.nis.getOutput((y-1)*52), 2);
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen in soil in table. Must shift the values by -1.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getNInSoilTbl(y:Number):Number{
		return Utils.roundNumber(this.nis.getOutput(y*52), 2);
	}
	
	/*
	 * Removes the error message if it exists
	 */
	public function removeErrorMsg():Void{
		if (this["errorMsg"]){
			this["errorMsg"].removeMovieClip();
		}
	}
	
	/*
	 * Regenerates the model and updates the graphics, tables etc
	 */
	public function runModel():Void{
		
		//clear previous outputs
		LUtils.clearOutputs();
		
		//redifine nAnual initial parameter from local information
		var nAnIP:InitParam = LUtils.getIPObj("nAnual");
		var nAnArr:Array = new Array(this.nAnual, this.nAnual, this.nAnual, this.nAnual, this.nAnual);
		nAnIP.setArrVal(nAnArr);
		
		//update fertilizer input box
		this["fib"].tf_ib.text = Utils.roundNumber(this.nAnual, 2).toString();
		
		//update net profit text
		this["npd"].tf_ib.text = Utils.roundNumber(this.fnp.avgeProfit(5), 2).toString();
		
		//update table
		this["detailTbl"].update();
		
		//update graphs
		this["graphs"].npvtGraph.update();
		this["graphs"].nisvtGraph.update();
		
		//if aux graphs are open then also update
		if (this["auxGraphs"]){
			this["auxGraphs"].comp.update();
		}
		
	}
	
	/*
	 * Redraws the net profit vs nitrogen graphic with the sequence of points
	 * defined by the array savedVals
	 */
	public function updateNpvnGraphic():Void{
		this["graphs"].npvnGraph.update();
	}
	
	/*
	 * Opens component window with the auxilar graphs in
	 */
	public function openAuxGraphs(){
		//if not already open
		if (!this["auxGraphs"]){
			//create new component window
			var cw:ComponentWindow = Utils.newObject(ComponentWindow, this, "auxGraphs", this.getNextHighestDepth(), {_x:200, _y:100, w:600, h:300, compClass:ExploreCornModelAuxGraphs, btnClose:true, resize:false, titleTxt:LindApp.getMsg("cornModel.excercise.auxiliarGraphs")});
		}else{
			this["auxGraphs"].reopen();
		}
	}

}
