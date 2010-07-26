import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.FNShrub;
import lindissima.process.ShrubBiomass;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of foliage pruned from the shrub
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.process.FolPruneBiomass extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.FolPruneBiomass");
	
	//singleton instance
	private static var instance:FolPruneBiomass;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function FolPruneBiomass(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "FolPruneBiomass";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new FolPruneBiomass();
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
		
		//if there are no shrubs or if t represents one of the weeks before the corn is planted or after it is
		//harvested or if the folliage was not pruned this week then return 0
		if(!LUtils.isFolPruneWeek(t)){
			ret = 0;
		}else{
			//if t represents one of the weeks where pruning occurs then return...
			//1) the previous biomass of the shrub added to 
			//2) the increment in biomass that would have ocurred this week before the prune (note that this
			//increment is not recorded in the output of the biomass of the shrub.
			//1)+2) gives us the biomass of the shrub before pruning
			//subtract the current biomass of the shrub (which is what we have after pruning) in order to calculate
			//the biomass of the pruned foliage.
			var prevShrubBiomass:Number = shrubBiomass.getOutput(t-1);
			var incBiomass:Number = fNShrub.getOutput(t-1)*LUtils.getIP("fnA_TRA")*prevShrubBiomass-LUtils.getIP("fnA_TRC")*LUtils.getIP("fnA_C")*prevShrubBiomass*prevShrubBiomass;
			ret = shrubBiomass.getOutput(t-1)+incBiomass-shrubBiomass.getOutput(t);
		}
		//logger.debug("t="+t+" FolPruneBiomass="+ret);
		return ret;
		
	}
	
}