import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import core.comp.Graph;
import lindissima.comp.lakeModel.LMPhaseDiagram;
import lindissima.process.WeedCon;

/*
 * Component for exploring the bistable features of the lake model.
 * 
 * Allows user to vary levels of nitrogen and visualize the evolution of weed growth for
 * both the clear and mirky cases of the model. Whatsmore for each nitrogen level a phase
 * diagram is drawn
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 22-07-2005
 */
class lindissima.comp.lakeModel.ExploreBistableLakeModel extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.lakeModel.ExploreBistableLakeModel");
	
	//flags
	private var active:Boolean = false;
	
	//processes
	private var wc:WeedCon;
	
	//parameters
	public var clearPoints:Array;
	public var mirkyPoints:Array;
	public var nLevel:Number;
	
	//constants
	public static var inc:Number = 0.3;
	public static var maxValue:Number = 3;

	
	//phase diagram component used for determining the separator
	private var pd:LMPhaseDiagram;
	
	/*
	 * Constructor
	 */
	function ExploreBistableLakeModel(){

		logger.debug("instantiating ExploreBistableLakeModel");
		
		//initialize processes
		wc = WeedCon(WeedCon.getProcess());

		//init internal parameters
		this.clearPoints = new Array();
		this.mirkyPoints = new Array();
		this.nLevel = 0;
		
		//create nitrogen input box
		initNitInputBox();

		//init graph
		var wcvtGraph = Utils.newObject(Graph, this, "wcvtGraph", this.getNextHighestDepth(), {_x:400, _y:40, w:550, h:300, xAxisRange:365, xAxisScale:20, yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		wcvtGraph.addLimit("mirky", LindApp.getMsg("lakeModel.weedConVsTimeGraph.mirkyLimit"), LUtils.getIP("umbTurb"), LUtils.getIP("umbTurb"), 0x666666);
		wcvtGraph.addLimit("separator", LindApp.getMsg("lakeModel.weedConVsTimeGraph.sepLimit"), null, null, 0xffaa00);
		wcvtGraph.addGraphicFromFunc("wcvtClearGraphic", 0x09a6cc, this, this.getClearPoint, 1, 1, 0, false);
		wcvtGraph.addGraphicFromFunc("wcvtMirkyGraphic", 0xcccc00, this, this.getMirkyPoint, 1, 1, 0, false);
		LUtils.addClearTurbidBg(wcvtGraph, "horizontal");
		LUtils.addDryWetAxis(wcvtGraph, 1, 20);
		
		//init phase diagram
		pd = new LMPhaseDiagram();
		pd.setNLevel(this.nLevel);
		pd.segPerFrame = 1;
		pd.parentComp = this;
		pd.drawDiagram(this, "wcPhaseDiag", this.getNextHighestDepth(), {_x:20, _y:40, w:360, h:300, xAxisRange:30, xAxisScale:2, xAxisLabel:"Concentración de Algas", yAxisRange:170, yAxisScale:500, yAxisLabel:""});
		
		//run model
		runModel();
		
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
		this.clearPoints.splice(0);
		this.mirkyPoints.splice(0);
		this.nLevel = 0;
		
		//update visible nitrogen level
		this["nib"].tf_ib.text = String(this.nLevel);
		
		//clear any previous outputs
		this.wc.clearOutput();
		
		//reset phase diagram
		this.pd.reset();
		
		//reset separator
		var sep:Number = this.pd.getSeparator();
		this["wcvtGraph"].updateLimit('separator', sep, sep);
		
		//erase graph
		this["wcvtGraph"].update();
		
		//run model
		runModel();
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
		nib["tf_ib"].text = String(this.nLevel);
		nib["tf_ib"].border = true;
		nib["tf_ib"].borderColor = Const.DEFAULT_BORDER_COLOR;
		//nib["tf_ib"].type = "input";
		nib["tf_ib"].selectable = true;
		nib["tf_ib"].embedFonts = true;
		
		//create button increment
		var btn_inc = Utils.newObject(core.comp.EyeBtn, nib, "btn_inc", nib.getNextHighestDepth(), {_x:nib["tf_ib"]._x+nib["tf_ib"]._width+10, _y:0, literal:LindApp.getMsg("btn.increment", new Array(String(inc)))})
		btn_inc.onRelease = function(){
			var eblm:ExploreBistableLakeModel = this._parent._parent;
			if(eblm.nLevel<=ExploreBistableLakeModel.maxValue-ExploreBistableLakeModel.inc){
				eblm.nLevel += ExploreBistableLakeModel.inc;
				eblm.runModel();
			}
		}
		
		//create button de-increment
		var btn_deinc = Utils.newObject(core.comp.EyeBtn, nib, "btn_deinc", nib.getNextHighestDepth(), {_x:nib["btn_inc"]._x+nib["btn_inc"]._width+10, _y:0, literal:LindApp.getMsg("btn.de-increment", new Array(String(inc)))})
		btn_deinc.onRelease = function(){
			var eblm:ExploreBistableLakeModel = this._parent._parent;
			if(Utils.roundNumber(eblm.nLevel,1)>=ExploreBistableLakeModel.inc){
				eblm.nLevel = Utils.roundNumber(eblm.nLevel-ExploreBistableLakeModel.inc, 1);
				eblm.runModel();
			}
		}
	}
	
	/*
	 * Runs the model with the initial level of filtered nitrogen indicated by the
	 * internal parameter nLevel
	 */
	public function runModel():Void{
		
		//set the filtered nitrogen in the lake
		LUtils.setIP("nLake", this.nLevel);
		this["nib"].tf_ib.text = String(this.nLevel);
		
		//get point for clear model
		this.wc.clearOutput();
		LUtils.setInitialWeeds("low", 0);
		this.wc.getOutput(365)
		this.clearPoints = this.wc.getOutputs();
		
		//get point for mirky model
		this.wc.clearOutput();
		LUtils.setInitialWeeds("high", 0);
		this.wc.getOutput(365);
		this.mirkyPoints = this.wc.getOutputs();
		
		//update phase diagram
		this.pd.reset();
		this.pd.setNLevel(this.nLevel);
		this.pd.update();
		
		//update graph
		this["wcvtGraph"].updateLimit('separator', this.pd.getSeparator(), this.pd.getSeparator());
		this["wcvtGraph"].update();
	}
	
	/*
	 * Gets clear point for graphic
	 * 
	 * @param d the day to get the point for
	 * @return the concentration of weeds for this day
	 */
	public function getClearPoint(d:Number):Number{
		if (this.clearPoints.length>d){
			return Utils.roundNumber(this.clearPoints[d], 2);
		}else{
			return null;
		}
	}
	
	/*
	 * Gets mirky point for graphic
	 * 
	 * @param d the day to get the point for
	 * @return the concentration of weeds for this day
	 */
	public function getMirkyPoint(d:Number):Number{
		
		if (this.mirkyPoints.length>d){
			return Utils.roundNumber(this.mirkyPoints[d], 2);
		}else{
			return null;
		}
	}
	
	

}