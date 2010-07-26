import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.utils.LUtils;
import lindissima.process.Process;
import lindissima.process.FNShrub;
import lindissima.process.NExtractCorn;
import lindissima.process.NExtractShrub;
import lindissima.process.NFiltered;
import lindissima.process.NInPrune;
import lindissima.process.ShrubBiomass;

/*
 * Singleton process that defines the the amount of nitrogen in the soil each week
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.NInSoil extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NInSoil");
	
	//singleton instance
	private static var instance:NInSoil;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NInSoil(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NInSoil";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NInSoil();
			return instance;
		}else{
			return instance;
		}
	}
	
	/*
	 * Calculates the output value at time t using the selected initial parameters and
	 * other dependent processes
	 * 
	 * @param t the index of the semana or year (depending on the type of interval) for
	 * which the output value is desired
	 * @return the output value for the given t
	 */ 
	private function calculateValue(t:Number):Number{
		//return variable
		var ret:Number;
		//define dependent processes
		var nExtractCorn:Process = NExtractCorn.getProcess();
		var nExtractShrub:Process = NExtractShrub.getProcess();
		var nFiltered:Process = NFiltered.getProcess();
		var nInPrune:Process = NInPrune.getProcess();
		var fNShrub:Process = FNShrub.getProcess();
		var shrubBiomass:Process = ShrubBiomass.getProcess();
		
		if(t==0){
			//if is first week then initialize acording to init params
			ret = LUtils.getIP("nInicial")+LUtils.getIP("nAnual", 0);
		}else if (t%52==0){
			//define the year
			var y:Number = t/52;
			//if is beginning of year (not first year)
			//add the initial amount from the previous year
			//substract the acumulated ammount filtered from the previous year
			//subtract the acumulated ammount extracted by corn from the previous year
			//subtract the acumulated ammount extracted by shrubs from the previous year
			//add anual nitrogen from pruned foliage from the shrubs
			//add the inital amount added this year
			ret = getOutput(t-52) - nFiltered.getAcumAnual(y-1) - nExtractCorn.getOutput((y-1)*52+Const.WEEK_END_CORN_CYCLE) - nExtractShrub.getOutput((y-1)*52+Const.WEEK_END_CORN_CYCLE) + nInPrune.getAcumAnual(y-1) + LUtils.getIP("nAnual", y);
			//logger.debug(getOutput(t-52)+" "+nFiltered.getAcumAnual(y-1)+" "+nExtractCorn.getOutput((y-1)*52+Const.WEEK_END_CORN_CYCLE)+" "+nExtractShrub.getOutput((y-1)*52+Const.WEEK_END_CORN_CYCLE)+" "+nInPrune.getAcumAnual(y-1)+" "+LUtils.getIP("nAnual", y));
		}else if(t%52<=Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE+1){
			//if t is outside the corn cycle then the nitrogen stays the same
			ret = this.outputs[t-1];
		}else{
			//subtract the nitrogen extracted by the corn and the shrub aswell as the filtered nitrogen from the nitrogen level last week
			//TODO: Error in excel model should force positive increments
			//if the foliage was pruned two weeks ago must calculate the nitrogen extracted by the shrub last week
			//else can use getInc
			var incNShrub:Number 
			if (LUtils.isFolPruneWeek(t-2)){
				incNShrub = fNShrub.getOutput(t-1)*shrubBiomass.getInc(t-1)*LUtils.getIP("maxConcNitA");
			}else{
				incNShrub = nExtractShrub.getInc(t-1);
			}
			ret = this.outputs[t-1] - nExtractCorn.getInc(t-1, false) - incNShrub - nFiltered.getOutput(t-1);
		}
		//logger.debug("t="+t+" NInSoil="+ret);
		return Math.max(0,ret);
	}
	
	/*
	 * Gets the base level for the beginning of a year. Is the initial level for that year before
	 * adding fertilizer
	 * 
	 */
	public function getBaseLevel(y:Number):Number{
		if (y==0){
			return  LUtils.getIP("nInicial");
		}else{
			return getOutput(y*52) - LUtils.getIP("nAnual", y);
		}
	}
	
}