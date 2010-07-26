import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import core.comp.Graph;
import lindissima.process.WeedCon;

/*
 * Component for exploring random nature of the initial conditions in the lake model with
 * three scenarios. A clear equilibrium, a mirky equilibrium and a bistable lake.
 * 
 * Allows user to randomly select the initial weed concentration for each year over a 5
 * year period to see how the effects differ in the three different lake situations
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 25-07-2005
 */
 class lindissima.comp.lakeModel.RandomInitCondLakeModel extends core.util.GenericMovieClip{
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.lakeModel.RandomInitCondLakeModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var wc:WeedCon;
	
	//parameters
	public var clearPoints:Array;
	public var mirkyPoints:Array;
	public var bistabPoints:Array;
	public var nInitial:Array;
	public var probHigh:Number;
	
	//constants
	public static var nYears:Number = 5;
	
	/*
	 * Constructor
	 */
	function RandomInitCondLakeModel(){
		
		logger.debug("instantiating RandomInitCondLakeModel");
		
		//initialize processes
		wc = WeedCon(WeedCon.getProcess());

		//init internal parameters
		this.clearPoints = new Array();
		this.mirkyPoints = new Array();
		this.bistabPoints = new Array();
		this.nInitial = new Array();
		
		//get the probability of a high initial concentration of weeds
		this.probHigh = LUtils.getIP("probAlta");
		
		//create random generator
		initRandomGen();
		
		//init clear graph
		var wcvtClearGraph = Utils.newObject(Graph, this, "wcvtClearGraph", this.getNextHighestDepth(), {_x:20, _y:40, w:900, h:160, xAxisRange:365*nYears,xAxisLabel:LindApp.getMsg("lakeModel.clearEquilibrium"),  xAxisScale:null, yAxisRange:24, yAxisScale:4, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.shortYAxis"), axesDist:40});
		wcvtClearGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtClearGraph.addGraphicFromFunc("wcvtClearGraphic", 0x09a6cc, this, this.getClearPoint, 1, 10, 0, false);
		LUtils.addDryWetAxis(wcvtClearGraph, nYears);
		LUtils.addClearTurbidBg(wcvtClearGraph, "horizontal");

		//init bistable graph
		var wcvtBistabGraph = Utils.newObject(Graph, this, "wcvtBistabGraph", this.getNextHighestDepth(), {_x:20, _y:200, w:900, h:160, xAxisRange:365*nYears,xAxisLabel:LindApp.getMsg("lakeModel.bistable"),  xAxisScale:null, yAxisRange:24, yAxisScale:4, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.shortYAxis"), axesDist:40});
		wcvtBistabGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtBistabGraph.addGraphicFromFunc("wcvtBistabGraphic", (0xcccc00+0x09a6cc)/2, this, this.getBistabPoint, 1, 10, 0, false);
		LUtils.addDryWetAxis(wcvtBistabGraph, nYears);
		LUtils.addClearTurbidBg(wcvtBistabGraph, "horizontal");
		
		//init mirky graph
		var wcvtMirkyGraph = Utils.newObject(Graph, this, "wcvtMirkyGraph", this.getNextHighestDepth(), {_x:20, _y:360, w:900, h:160, xAxisRange:365*nYears, xAxisLabel:LindApp.getMsg("lakeModel.mirkyEquilibrium"), xAxisScale:null, yAxisRange:24, yAxisScale:4, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.shortYAxis"), axesDist:40});
		wcvtMirkyGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtMirkyGraph.addGraphicFromFunc("wcvtMirkyGraphic", 0xcccc00, this, this.getMirkyPoint, 1, 10, 0, false);
		LUtils.addDryWetAxis(wcvtMirkyGraph, nYears);
		LUtils.addClearTurbidBg(wcvtMirkyGraph, "horizontal");
		
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
		
		//reset internal parameters
		this.clearPoints = new Array();
		this.mirkyPoints = new Array();
		this.bistabPoints = new Array();
		this.nInitial = new Array();
		
		//reinicialize marbles
		initMarbles();
		this["rg"].tf_ib.text = "";
		
		//clear all graphics
		this["wcvtClearGraph"].eraseGraphic("wcvtClearGraphic");
		this["wcvtBistabGraph"].eraseGraphic("wcvtBistabGraphic");
		this["wcvtMirkyGraph"].eraseGraphic("wcvtMirkyGraphic");
		
		//show start button
		this["rg"].btn_start._visible = true;
	}
	
	/*
	 * Initializes the nitrogen input box
	 */
	private function initRandomGen():Void{
		
		//create container clip
		var rg = this.createEmptyMovieClip("rg", this.getNextHighestDepth());
		rg._x = 40;
		rg._y = 10;

		//create literal text field
		var txt:String = LindApp.getMsg("lakeModel.randomInitCond.generateRandomInitCond");
		var w:Number = 160;
		Utils.createTextField("tf_lit", rg, rg.getNextHighestDepth(), 0, 0, w, 20, txt, LindApp.getTxtFormat("defaultTxtFormat"));
		
		//create random number box
		rg.createTextField("tf_ib", rg.getNextHighestDepth(), rg["tf_lit"]._width, 0, 20, 20);
		rg["tf_ib"].setNewTextFormat(LindApp.getTxtFormat("defaultTxtFormat"));
		rg["tf_ib"].text = "";
		rg["tf_ib"].border = true;
		rg["tf_ib"].borderColor = Const.DEFAULT_BORDER_COLOR;
		rg["tf_ib"].align = "center";
		rg["tf_ib"].embedFonts = true;

		//create button start
		var btn_start = Utils.newObject(core.comp.EyeBtn, rg, "btn_start", rg.getNextHighestDepth(), {_x:rg["tf_ib"]._x+rg["tf_ib"]._width+10, _y:0, literal:LindApp.getMsg("btn.start")});
		btn_start.onRelease = function(){
			this._parent._parent.startRandom();
			this._visible = false;
			this._parent.btn_stop._visible = true;
		}
		
		//create button start
		var btn_stop = Utils.newObject(core.comp.EyeBtn, rg, "btn_stop", rg.getNextHighestDepth(), {_x:rg["tf_ib"]._x+rg["tf_ib"]._width+10, _y:0, literal:LindApp.getMsg("btn.stop"), _visible:false});
		btn_stop.onRelease = function(){
			this._visible = false;
			this._parent.btn_start._visible = true;
			this._parent._parent.selectNextInitCond();
		}
		
		//initialize marbles
		initMarbles();
	}
	
	/*
	 * Initiates marbles
	 */
	private function initMarbles():Void{
		
		//removes marbles clip if exists
		if(this["rg"].marbles){
			this["rg"].marbles.removeMovieClip();
		}
		
		//create new marbles clip
		var marbles = this["rg"].createEmptyMovieClip("marbles", this["rg"].getNextHighestDepth());
		marbles._x = 280;
		marbles._y = 10;
		
	}
	
	/*
	 * Starts generating random numbers
	 */
	public function startRandom():Void{
		
		this.onEnterFrame = function(){
			var n:Number = Math.floor(Math.random()*10);
			this["rg"].tf_ib.text = String(n);
		}
	}
	
	/*
	 * Selects the currently displayed random number and draws next year
	 */
	public function selectNextInitCond():Void{
		
		//stop numbers from generating
		delete this.onEnterFrame;
		
		//get currently displayed number
		var n:Number = Number(this["rg"].tf_ib.text);
		
		//define init cond
		var initCond:String = (n<this.probHigh*10) ? "high" : "low";
		
		//create marble
		var marbleType:String = (initCond=="high") ? "marble_black" : "marble_grey";
		var m = this["rg"].marbles.attachMovie(marbleType, "marble_"+String(this.nInitial.length), this["rg"].marbles.getNextHighestDepth());
		m._x = 40*this.nInitial.length;
		m._width = 30;
		m._height = 30;
		
		//draw number on marble
		var col:Number = (initCond=="high") ? 0x660000 : 0x006600;
		var number = m.createEmptyMovieClip("number", m.getNextHighestDepth());
		number.beginFill(0xffffff, 100);
		number.drawCircle(0, 0, 5, 10);
		number.endFill();
		Utils.createTextField("tf", number, number.getNextHighestDepth(), -5, -8, 10, 10, String(n), LindApp.getTxtFormat("marbleTxtFormat"));
		
		//create zoomed entrance
		mx.transitions.TransitionManager.start(m,{type:mx.transitions.Zoom, direction:0, duration:1, easing:mx.transitions.easing.Back.easeInOut,startPoint:1});
		
		//save init condition and run model
		this.nInitial[this.nInitial.length] = initCond;
		
		//if is last year hide start button
		if (this.nInitial.length==nYears){
			this["rg"].btn_start._visible = false;
		}
		
		runModel();
	}
	
	/*
	 * Runs the model for one year taking the last value in the array of initial conditions. The outputs
	 * for the year are concatenated to the internal arrays and the graphics redrawn.
	 * 
	 * Note: Each year is calculated from day 0 to day 330. The days 330-365 depend on the initial condition
	 * of the following year acording to the following rules
	 * 1) If initial condition is "low" the weed concentration stays constant from day 330 to day 365
	 * 2) If initial condition is "high" and the concentration on day 330 is lower than the initial value
	 * of a high weed concentration the concentration varies linearly to the initial parameter value of iniAlgasAlta between day 330 and day 365
	 * 3) If initial condition is "high" and the concentration on day 330 is higher than the initial value
	 * of a high weed concentration the concentration remains constant from day 330 to day 365
	 */
	private function runModel():Void{
		
		//define year
		var y:Number = this.nInitial.length-1;
		
		//define initial condition
		var initCond:String = this.nInitial[y];
		
		//run submodels
		runSubModel("clear", y, initCond);
		runSubModel("bistable", y, initCond);
		runSubModel("mirky", y, initCond);
	}
	
	/*
	 * Runs a submodel, one of three: "clear", "mirky" or "bistable". Calculates the
	 * points for this year and updates the graphic
	 * 
	 * @param id the id ("clear", "mirky" or "bistable")
	 * @param y the year
	 * @param the initial condition ("low" or "high")
	 */
	private function runSubModel(id:String, y:Number, initCond:String):Void{
		
		//define id dependent variables
		var arr:Array;
		var graph:Graph;
		var nLake:Number;
		switch (id){
			case "clear":
				arr = this.clearPoints;
				graph = this["wcvtClearGraph"];
				nLake = LUtils.getIP("nLagoClaro");
			break;
			case "mirky":
				arr = this.mirkyPoints;
				graph = this["wcvtMirkyGraph"];
				nLake = LUtils.getIP("nLagoTurbio");
			break;
			case "bistable":
				arr = this.bistabPoints;
				graph = this["wcvtBistabGraph"];
				nLake = LUtils.getIP("nLagoBiestable");
			break;
		}
		
		//if not the first year then add values to the array from day 330 to 365 of the previous year
		//and initialize the initial weed concentration for this year
		//otherwise only initialize the weed concentration for this year
		if (y>0){
		
			//define final value of weed concentration for previous year
			var wcInit:Number = arr[(y-1)*365+329];
			var wcFin:Number = (initCond=="high") ? Math.max(LUtils.getIP("algasIniAlta"), wcInit) : wcInit;
	
			//add values to clearPoints
			var wcInc:Number = (wcFin-wcInit)/35;
			var wcCurr:Number = wcInit+wcInc;

			for(var i=(y-1)*365+330; i<y*365; i++){
				arr[i] = wcCurr;
				wcCurr += wcInc;
			}
			
			//initialize weed concentration
			LUtils.setIP("algasIniCustom", arr[y*365-1]);
			LUtils.setInitialWeeds("custom", 0);
			
		}else{
			LUtils.setInitialWeeds(initCond, 0);
		}
		
		//set amount of nitrogen in lake for this submodel
		LUtils.setIP("nLake", nLake);
				
		//clear output
		this.wc.clearOutput();
		
		//run process for year
		this.wc.getOutput(330);
		
		//concatenate values to original array
		switch (id){
			case "clear":
				this.clearPoints = arr.concat(this.wc.getOutputs());
			break;
			case "mirky":
				this.mirkyPoints = arr.concat(this.wc.getOutputs());
			break;
			case "bistable":
				this.bistabPoints = arr.concat(this.wc.getOutputs());
			break;
		}
		
		//update graphic
		if (y==0){
			graph.update();
		}else{
			graph.update((y-1)*365+330);
		}
	}
	
	/*
	 * Returns clear points for drawing the graphic
	 * 
	 * @param d the day to get the weed concentration for
	 * @return a number representing the weed concentration for this day
	 */
	public function getClearPoint(d:Number):Number{
		if (d<this.clearPoints.length){
			return Utils.roundNumber(this.clearPoints[d], 2);
		}else{
			return null;
		}
	}
	
	/*
	 * Returns bistable points for drawing the graphic
	 * 
	 * @param d the day to get the weed concentration for
	 * @return a number representing the weed concentration for this day
	 */
	public function getBistabPoint(d:Number):Number{
		if (d<this.bistabPoints.length){
			return Utils.roundNumber(this.bistabPoints[d], 2);
		}else{
			return null;
		}
	}
	
	/*
	 * Returns mirky points for drawing the graphic
	 * 
	 * @param d the day to get the weed concentration for
	 * @return a number representing the weed concentration for this day
	 */
	public function getMirkyPoint(d:Number):Number{
		if (d<this.mirkyPoints.length){
			return Utils.roundNumber(this.mirkyPoints[d], 2);
		}else{
			return null;
		}
	}
}