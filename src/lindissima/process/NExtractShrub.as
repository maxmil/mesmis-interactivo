import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.utils.LUtils;
import lindissima.process.Process;
import lindissima.process.ShrubBiomass;
import lindissima.process.FNShrub;

/*
 * Singleton process that defines the amount of nitrogen extracted from the soil by the shrub.
 * The process is acumulative each year upto the end of the corn cycle.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.NExtractShrub extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NExtractShrub");
	
	//singleton instance
	private static var instance:NExtractShrub;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NExtractShrub(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NExtractShrub";		 
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NExtractShrub();
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
		var shrubBiomass:Process = ShrubBiomass.getProcess();
		var fNShrub:Process = FNShrub.getProcess();
		
		//if there are no shrubs or if t represents one of the weeks before the corn is planted 
		//or after it is harvested then return 0
		if(LUtils.getIP("densA") == 0 || t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else if (t%52==Const.WEEK_BEGIN_CORN_CYCLE || LUtils.isFolPruneWeek(t-1)){
			//if it is the week that the corn is planted or if a folliage prune occured the previos week
			//then return the product of the maximum concentration of nitrogen in corn and its initial mass
			ret = LUtils.getIP("biomasaIniA")*LUtils.getIP("densA")*LUtils.getIP("maxConcNitA");
		}else{
			//calculate the increment in the biomass of the shrub - cant call getInc because shrub may have been pruned
			var prevShrubBiomass:Number = shrubBiomass.getOutput(t-1);
			var incBiomass:Number = fNShrub.getOutput(t-1)*LUtils.getIP("fnA_TRA")*prevShrubBiomass-LUtils.getIP("fnA_TRC")*LUtils.getIP("fnA_C")*prevShrubBiomass*prevShrubBiomass;
			//calculate the increment in the nitrogen of the shrub
			var incN:Number = fNShrub.getOutput(t)*incBiomass*LUtils.getIP("maxConcNitA");
			
			//add the increment to the biomass from the previous week and return
			ret = this.outputs[t-1]+incN;
		}
		
		return ret;
	}
	
	/*
	 * Overrides parent method to implement class specific behaviour
	 * 
	 * @param t the week to get the increment for
	 * @param isPos when true the minimum increment returned is 0
	 * @return 0 if is the first week of the corn cycle. If not the diference 
	 * between the output at time t and time t-1 is calculated
	 */
	 public function getInc(t:Number, isPos:Boolean):Number{
		//define return variable
		var ret:Number;
		//define dependent processes
		var shrubBiomass:Process = ShrubBiomass.getProcess();
		var fNShrub:Process = FNShrub.getProcess();
		 
		if(t<1 || t%52==Const.WEEK_BEGIN_CORN_CYCLE){
			//if is first week of corn cycle return 0
			ret = 0;
		}else{
			 //otherwise return the difference
			ret = getOutput(t)-getOutput(t-1); 
		}
		
		//if isPos avoid returning negative value
		return (isPos) ? Math.max(0, ret) : ret;
	 }
	
}