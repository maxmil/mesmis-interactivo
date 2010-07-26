import core.comp.Graph;
import core.util.GenericMovieClip;
import core.util.Utils;
import sussi.Const;
import sussi.SussiApp;
import sussi.process.Process;
import sussi.process.Ph1;
import sussi.process.Ph2;
import sussi.process.Pc;
import sussi.utils.SUtils;

/*
 * Graphic component that animates the population growth of the different species
 * involved
 *
 * @author Max Pimm
 * @created 27-09-2005
 * @version 1.0
 */
 class sussi.comp.PopulationGraph extends GenericMovieClip {
	
	//graph initial properties
	public var w:Number;
	public var h:Number;
	public var xAxisRange:Number;
	public var xAxisScale:Number;
	public var xAxisLabel:String;
	public var yAxisRange:Number;
	public var yAxisScale:Number;
	public var yAxisLabel:String;
	public var init:Boolean;
	
	//other graphic elements
	public var separatrix:Number;
	
	//processes
	public var ph1:Process;
	public var ph2:Process;
	public var pc:Process;
	
	//animation properties
	public var speed:Number;

	/*
	 * Constructor
	 */
	function PopulationGraph(){
		
		//define default values if not defined via init Object
		w = (w) ? w : 500;
		h = (h) ? h : 300;
		xAxisRange = (xAxisRange==undefined) ? Const.PROC_YEARS_LIMIT*52 : xAxisRange;
		xAxisScale = (xAxisScale==undefined) ? 52 : xAxisScale;
		xAxisLabel = (xAxisLabel==undefined) ? SussiApp.getMsg("graph.populationVsTime.xAxisLabel") : xAxisLabel;
		yAxisRange = (yAxisRange==undefined) ? SUtils.getIP("dh1_epid") : yAxisRange;
		yAxisScale = (yAxisScale==undefined) ? 20 : yAxisScale;
		yAxisLabel = (yAxisLabel==undefined) ? SussiApp.getMsg("graph.populationVsTime.yAxisLabel") : yAxisLabel ;
		init = (init==undefined) ? true : init
		speed = (speed==undefined) ? 3 : speed;
		
		//define processes
		ph1 = Ph1.getProcess();
		ph2 = Ph2.getProcess();
		pc = Pc.getProcess();
		
		//create graph component
		var graph:Graph = Utils.newObject(Graph, this, "graph", 1, {w:w, h:h-10, xAxisRange:xAxisRange, xAxisScale:xAxisScale, yAxisRange:yAxisRange, yAxisScale:yAxisScale, yAxisLabel:yAxisLabel, xAxisLabel:xAxisLabel, axesDist:45});
		
		//add graphics for all populations that are not 0
		if (SUtils.getIP("h1_ini")>0){
			graph.addGraphicFromFunc("h1Graphic", Const.COLOR_H1, this, getPointH1, 1, speed, 3, !init, 52, SUtils.getIP("fl_week"));
		}
		if (SUtils.getIP("h2_ini")>0){
			graph.addGraphicFromFunc("h2Graphic", Const.COLOR_H2, this, getPointH2, 1, speed, 0, !init);
		}
		if (SUtils.getIP("c_ini")>0){
			graph.addGraphicFromFunc("cGraphic", Const.COLOR_C, this, getPointC, 1, speed, 0, !init);
		}
		
		//add limits
		var prms:Array = new Array();
		
		//poinization
		var fl_lim_pol:Number = SUtils.getIP("fl_lim_pol");
		if(fl_lim_pol!=undefined && yAxisRange>fl_lim_pol){
			prms[0] = String(fl_lim_pol);
			graph.addLimit("polinization", SussiApp.getMsg("graph.populationVsTime.limit.polinization", prms), fl_lim_pol, fl_lim_pol, Const.COLOR_LIM_POL);
		}
		
		//separatrix
		if(separatrix!=undefined){
			graph.addLimit("separatrix", SussiApp.getMsg("graph.populationVsTime.separatrix"), separatrix, separatrix, Const.COLOR_SEPARATRIX);
		}
		
		//epidemia h1
		var dh1_epid:Number = SUtils.getIP("dh1_epid");
		if (dh1_epid <= yAxisRange){
			prms[0] = String(dh1_epid);
			graph.addLimit("h1_epid", SussiApp.getMsg("graph.populationVsTime.limit.epidemia.h1", prms), dh1_epid, dh1_epid, Const.COLOR_LIM_EPID_H1);
		}
		
		//add background
		drawEcomomicLimitBg()
		
		//add footnote
		Utils.createTextField("footNote", this, this.getNextHighestDepth(), 45, h-15, w-45, 15, SussiApp.getMsg("graph.populationVsTime.footNote"), SussiApp.getTxtFormat("smallTxtFormat"));
	}
	
	/*
	 * Draws background on graph te separate the two sides fo the economic limit
	 */
	private function drawEcomomicLimitBg():Void{

		//define separator and graph
		var graph:Graph = this["graph"]
		var sep:Number = Math.min(SUtils.getIP("fl_lim_pol"), yAxisRange);
		
		//create container clip
		var mc:GenericMovieClip = graph["bg"].createEmptyMovieClip("polinizationBg", graph["bg"].getNextHighestDepth());
		
		//define extremes
		var minY:Number = graph.topPadding;
		var maxY:Number = graph.h-graph.axesDist;
		var minX:Number = graph.axesDist+1;
		var maxX:Number = graph.w-graph.rightPadding;
		var sepY:Number = graph.getYPos(sep);

		//create left fill - under economic limit
		mc.beginFill(Const.COLOR_NO_POLINIZATION, 30);
		mc.moveTo(minX, sepY);
		mc.lineTo(maxX, sepY);
		mc.lineTo(maxX, maxY);
		mc.lineTo(minX, maxY);
		mc.lineTo(minX, sepY);
		mc.endFill();

		//if showing then create right fill - above economic limit
		if(yAxisRange>SUtils.getIP("fl_lim_pol")){
			mc.beginFill(Const.COLOR_POLINIZATION, 30);
			mc.moveTo(minX, minY);
			mc.lineTo(maxX, minY);
			mc.lineTo(maxX, sepY);
			mc.lineTo(minX, sepY);
			mc.lineTo(minX, minY);
			mc.endFill();
		}
	}
	
	/*
	 * Auxiliar function to get graph points for population of h1's
	 * 
	 * @param t the week for which the population is required
	 * 
	 * @return the number of individuals in the population
	 */
	public function getPointH1(t:Number):Number{
		return Utils.roundNumber(ph1.getOutput(t), 2);
	}
	
	/*
	 * Auxiliar function to get graph points for population of h2's
	 * 
	 * @param t the week for which the population is required
	 * 
	 * @return the number of individuals in the population
	 */
	public function getPointH2(t:Number):Number{
		return Utils.roundNumber(ph2.getOutput(t), 2);
	}
	
	/*
	 * Auxiliar function to get graph points for population of c's
	 * 
	 * @param t the week for which the population is required
	 * 
	 * @return the number of individuals in the population
	 */
	public function getPointC(t:Number):Number{
		return Utils.roundNumber(pc.getOutput(t), 2);
	}
	
	/*
	 * Starts animation of graph
	 */
	public function animate():Void{
		this["graph"].update();
	}
	
	/*
	 * Clears graph
	 */
	public function reset():Void{
		this["graph"].eraseGraphic("h1Graphic");
		this["graph"].eraseGraphic("h2Graphic");
		this["graph"].eraseGraphic("cGraphic");
	}
}
