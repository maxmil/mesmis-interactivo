import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import core.comp.Graph;
import lindissima.utils.LUtils;
import lindissima.process.CornBiomass;

/*
 * Auxiliar component for exploring the corn model. Shows two graphics. 
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-97-2005
 */
class lindissima.comp.cornModel.ExploreCornModelAuxGraphs extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornModel.ExploreCornModelAuxGraphs");
	
	//processes
	private var cb:CornBiomass;
	
	
	/*
	 * Constructor
	 */
	public function ExploreCornModelAuxGraphs() {
		
		logger.debug("instantiating ExploreCornModelAuxGraphs");
		
		//initialize processes
		cb = CornBiomass(CornBiomass.getProcess());
		
		//var nAnual:Array = new Array(15, 15, 15, 15, 15);
		//LUtils.getIPObj("nAnual").setArrVal(nAnual);
		
		//init the graphics
		initGraphs();
	}

	
	/*
	 * Initializes the graphs
	 */
	private function initGraphs():Void {
		
		//create the f(N)Corn vs Nitrogen graphic
		var xRange:Number = LUtils.getIPObj("nAnual").getMaxVal()+LUtils.getIP("nInicial")+1;
		var fncvnGraph = Utils.newObject(Graph, this, "fncvnGraph", this.getNextHighestDepth(), {_x:0, _y:0, w:300, h:250, xAxisRange:xRange, xAxisScale:2, xAxisLabel:LindApp.getMsg("cornModel.excercise.fNCornVsNitGraph.xAxis"), yAxisRange:1, yAxisScale:0.1, yAxisLabel:LindApp.getMsg("cornModel.excercise.fNCornVsNitGraph.yAxis"), drwBorder:false});
		fncvnGraph.addGraphicFromFunc("fncvnGraphic", 0x0000ff, this, this.getFNCorn, 1, 0, 0);

		//creates the cornBiomass vs time graph
		var cbvtGraph = Utils.newObject(Graph, this, "cbvtGraph", this.getNextHighestDepth(), {_x:300, _y:0, w:300, h:250, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornModel.excercise.cornBiomassVsTimeGraph.xAxis"), yAxisRange:400, yAxisScale:50, yAxisLabel:LindApp.getMsg("cornModel.excercise.cornBiomassVsTimeGraph.yAxis"), drwBorder:false});
		cbvtGraph.addGraphicFromFunc("cbvtGraphic", 0x009966, this, this.getCornBiomass, 1/52, 20, 0);
	}
	
	/*
	 * Given the level of nitrogen in the soil calculates the functions f(N)Corn. Used by the
	 * f(N)Corn Vs Nitrogen graphic to calculate values
	 * 
	 * @param n the level of nitrogen in the soil
	 * @return the value of F(N)Corn
	 */
	public function getFNCorn(n:Number):Number{
		return Utils.roundNumber((1-1/(1+LUtils.getIP("fnM_A")*Math.pow(n,LUtils.getIP("fnM_B")))), 2);
	}
	
	
	/*
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the biomass of corn. 
	 * Used by the Corn Biomass Vs Time graphic to calculate values
	 * 
	 * @param t the week divided by 52
	 * @return the value of the corn biomass in this week
	 */
	public function getCornBiomass(t:Number):Number{
		var wk:Number = Math.round(t*52);
		if (wk%52<Const.WEEK_BEGIN_CORN_CYCLE || wk%52>Const.WEEK_END_CORN_CYCLE){
			return null
		}else{
			return (Utils.roundNumber(this.cb.getOutput(wk), 2));
		}
	}
	
	/*
	 * Updates the corn biomass vs time graph
	 */
	public function update():Void{
		this["cbvtGraph"].update();
	}

}
