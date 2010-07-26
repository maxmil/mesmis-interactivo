import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import core.comp.Graph;
import lindissima.utils.LUtils;
import lindissima.process.CornBiomass;
import lindissima.process.ShrubBiomass;
import lindissima.process.NFiltered;
import lindissima.process.FolPruneOnGround;
import lindissima.process.NInSoil;
import lindissima.process.NInPrune;
import lindissima.process.FNCorn;
import lindissima.process.FNShrub;

/*
 * Auxiliar component for exploring the corn model. Shows two graphics. 
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-97-2005
 */
class lindissima.comp.cornShrubModel.ExploreCornShrubModelAuxGraphs extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornShrubModel.ExploreCornShrubModelAuxGraphs");

	//processes
	private var cb:CornBiomass;
	private var sb:ShrubBiomass;
	private var nis:NInSoil;
	private var nf:NFiltered;
	private var nip:NInPrune;
	private var fpg:FolPruneOnGround;
	private var fnc:FNCorn;
	private var fns:FNShrub;
		
	/*
	 * Constructor
	 */
	public function ExploreCornShrubModelAuxGraphs() {
		
		logger.debug("instantiating ExploreCornModelAuxGraphs");
		
		//initialize processes
		cb = CornBiomass(CornBiomass.getProcess());
		sb = ShrubBiomass(ShrubBiomass.getProcess());
		nis = NInSoil(NInSoil.getProcess());
		fpg = FolPruneOnGround(FolPruneOnGround.getProcess());
		nf = NFiltered(NFiltered.getProcess());
		nip = NInPrune(NInPrune.getProcess());
		fnc = FNCorn(FNCorn.getProcess());
		fns = FNShrub(FNShrub.getProcess());
		
		//create the nitrogen in the soil vs time graph
		var nisvtGraph = Utils.newObject(Graph, this, "nisvtGraph", 1, {_x:5, _y:5, w:250, h:200, xInit:1, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nInSoilVsTimeGraph.xAxis"), yAxisRange:20, yAxisScale:2, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nInSoilVsTimeGraph.yAxis"), drwBorder:true, axesDist:40});
		nisvtGraph.addLimit("errosion", LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.irrevErosionLimit"), Const.LIMIT_ERROSION, Const.LIMIT_ERROSION, 0xff0000);
		nisvtGraph.addLimit("intoxification", LindApp.getMsg("cornModel.excercise.nInSoilVsTimeGraph.toxLimit"), Const.LIMIT_ENTOXIFICATION, Const.LIMIT_ENTOXIFICATION, 0xff0000);
		nisvtGraph.addGraphicFromFunc("nsbvtGraphic", 0x666666, this, this.getNInSoilBase, 1, 1, 2);
		nisvtGraph.addGraphicFromFunc("nsevtGraphic", 0x0000ff, this, this.getNInSoilEndYear, 1, 1, 2);
		nisvtGraph.addGraphicFromFunc("npvtGraphic", 0xffaa00, this, this.getNInPrune, 1, 1, 2);
		nisvtGraph.addGraphicFromFunc("fvtGraphic", 0xffcc00, this, this.getAnualFert, 1, 1, 2);
		
		//create the corn and shrub biomass vs time graph
		var bmvtGraph =  Utils.newObject(Graph, this, "bmvtGraph", 2, {_x:260, _y:5, w:250, h:200, xInit:0, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.biomassVsTimeGraph.xAxis"), yAxisRange:1000, yAxisScale:100, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.biomassVsTimeGraph.yAxis"), drwBorder:true, axesDist:45});
		bmvtGraph.addGraphicFromFunc("cb", 0xff9900, this, this.getCornBiomass, 1/52, 20, 0);
		bmvtGraph.addGraphicFromFunc("sb", 0x006600, this, this.getShrubBiomass, 1/52, 20, 0);
		
		//create the prune on ground graph
		var fpgvtGraph =  Utils.newObject(Graph, this, "fpgvtGraph", 3, {_x:515, _y:5, w:250, h:200, xInit:0, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.folPruneVsTimeGraph.xAxis"), yAxisRange:1000, yAxisScale:100, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.folPruneVsTimeGraph.yAxis"), drwBorder:true, axesDist:45});
		fpgvtGraph.addGraphicFromFunc("fpg", 0xcc9933, this, this.getFolPruneOnGround, 1/52, 20, 0);
		
		//create the nitrogen filtered vs time graph
		var nfvtGraph = Utils.newObject(Graph, this, "nfvtGraph", 4, {_x:5, _y:210, w:250, h:200, xInit:1, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nFilteredVsTimeGraph.xAxis"), yAxisRange:10, yAxisScale:1, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nFilteredVsTimeGraph.yAxis"), drwBorder:true, axesDist:40});
		nfvtGraph.addLimit("biestab_lower", LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nFilteredVsTimeGraph.bistabiltyLowerLimit"), LUtils.getIP("nCritAlta"), LUtils.getIP("nCritAlta"), 0xff0000);
		nfvtGraph.addLimit("biestab_upper", LindApp.getMsg("cornShrubModel.excercise.auxGraphs.nFilteredVsTimeGraph.bistabiltyUpperLimit"), LUtils.getIP("nCritBaja"), LUtils.getIP("nCritBaja"), 0xff0000);
		nfvtGraph.addGraphicFromFunc("nfvtGraphic", 0x0000ff, this, this.getNFiltered, 1, 1, 2);
		
		//create the f(N) vs time graph
		var fnvtGraph =  Utils.newObject(Graph, this, "fnvtGraph", 5, {_x:260, _y:210, w:250, h:200, xInit:0, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.fnVsTimeGraph.xAxis"), yAxisRange:1.2, yAxisScale:0.2, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.fnVsTimeGraph.yAxis"), drwBorder:true, axesDist:45});
		fnvtGraph.addGraphicFromFunc("fncvtGraphic", 0xff9900, this, this.getFNCorn, 1/52, 20, 0);
		fnvtGraph.addGraphicFromFunc("fnsvtGraphic", 0x006600, this, this.getFNShrub, 1/52, 20, 0);
		
		//create the f(N) vs Nitrogen graphic
		var xRange:Number = LUtils.getIPObj("nAnual").getMaxVal()+LUtils.getIP("nInicial")+1;
		var fnvnGraph = Utils.newObject(Graph, this, "fnvnGraph", 6, {_x:515, _y:210, w:250, h:200, xAxisRange:xRange, xAxisScale:2, xAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.fNVsNitGraph.xAxis"), yAxisRange:1, yAxisScale:0.1, yAxisLabel:LindApp.getMsg("cornShrubModel.excercise.auxGraphs.fNVsNitGraph.yAxis"), drwBorder:true, axesDist:40});
		fnvnGraph.addGraphicFromFunc("fncvnGraph", 0xff9900, this, this.getFNCornVsNit, 1, 0, 0);
		fnvnGraph.addGraphicFromFunc("fncvnGraph", 0x006600, this, this.getFNShrubVsNit, 1, 0, 0);
	}
	
	/*
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the f(N) of the shrub
	 * 
	 * @param t the week divided by 52
	 * @return the value of f(N) of shrub
	 */
	public function getFNShrub(t:Number):Number{
		var wk:Number = Math.round(t*52);
		if (wk%52<Const.WEEK_BEGIN_CORN_CYCLE || wk%52>Const.WEEK_END_CORN_CYCLE){
			return null
		}else{
			return (Utils.roundNumber(this.fns.getOutput(wk), 2));
		}
	}
	
	/*
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the f(N) of the corn
	 * 
	 * @param t the week divided by 52
	 * @return the value of f(N) of corn
	 */
	public function getFNCorn(t:Number):Number{
		var wk:Number = Math.round(t*52);
		if (wk%52<Const.WEEK_BEGIN_CORN_CYCLE || wk%52>Const.WEEK_END_CORN_CYCLE){
			return null
		}else{
			return (Utils.roundNumber(this.fnc.getOutput(wk), 2));
		}
	}

	/*
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the biomass of corn. 
	 * 
	 * @param t the week divided by 52
	 * @return the value of the foliage prune acting as coverage on the ground for this week
	 */
	public function getFolPruneOnGround(t:Number):Number{
		var wk:Number = Math.round(t*52);
		if (wk%52<Const.WEEK_BEGIN_CORN_CYCLE || wk%52>Const.WEEK_END_CORN_CYCLE){
			return null
		}else{
			return (Utils.roundNumber(this.fpg.getOutput(wk), 2));
		}
	}
	
	/*
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the biomass of corn. 
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
	 * Given the week of the year (expressed in years, ie fractions of 52) calculates the biomass of shrub. 
	 * 
	 * @param t the week divided by 52
	 * @return the value of the shrub biomass in this week
	 */
	public function getShrubBiomass(t:Number):Number{
		var wk:Number = Math.round(t*52);
		if (wk%52<Const.WEEK_BEGIN_CORN_CYCLE || wk%52>Const.WEEK_END_CORN_CYCLE){
			return null
		}else{
			return (Utils.roundNumber(this.sb.getOutput(wk), 2));
		}
	}

	/*
	 * Auxiliar function to draw values for anual fertilizer
	 * 
	 * @param y the year for which the net profit is required
	 * @return the fertilizer added
	 */
	public function getAnualFert(y:Number):Number{
		return LUtils.getIP("nAnual", y-1);
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen filtered in graph.
	 * 
	 * @param y the year for which the filtered nitrogen is required
	 * @return the nitrogen filtered that year to a precision of 2 decimal places
	 */
	public function getNFiltered(y:Number):Number{
		return Utils.roundNumber(this.nf.getAcumAnual(y-1), 2);
	}

	/*
	 * Auxiliar function to draw values for nitrogen in soil in graph.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getNInSoilBase(y:Number):Number{
		return Utils.roundNumber(this.nis.getBaseLevel(y-1), 2);
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen in soil in graph.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getNInSoilEndYear(y:Number):Number{
		return Utils.roundNumber(this.nis.getOutput((y-1)*52), 2);
		
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen in prune in graph
	 * 
	 * @param y the year for which the net profit is required
	 * @return nigtrogen added from pruning in the previous year
	 */
	public function getNInPrune(y:Number):Number{
		return Utils.roundNumber(this.nip.getAcumAnual(y-2), 2);
		
	}
	
	/*
	 * Given the level of nitrogen in the soil calculates the functions f(N)Corn. Used by the
	 * f(N)Corn Vs Nitrogen graphic to calculate values
	 *
	 * @param n the level of nitrogen in the soil
	 * @return the value of F(N)Corn
	 */
	public function getFNCornVsNit(n:Number):Number{
		return Utils.roundNumber((1-1/(1+LUtils.getIP("fnM_A")*Math.pow(n,LUtils.getIP("fnM_B")))), 2);
	}

	/*
	 * Given the level of nitrogen in the soil calculates the functions f(N)Shrub.
	 *
	 * @param n the level of nitrogen in the soil
	 * @return the value of F(N)Shrub
	 */
	public function getFNShrubVsNit(n:Number):Number{
		return Utils.roundNumber((1-1/(1+LUtils.getIP("fnA_A")*Math.pow(n,LUtils.getIP("fnA_B")))), 2);
	}
	
	/*
	 * Updates the graphs
	 */
	public function update():Void{
		this["nisvtGraph"].update();
		this["bmvtGraph"].update();
		this["fpgvtGraph"].update();
		this["nfvtGraph"].update();
		this["fnvtGraph"].update();
	}

}
