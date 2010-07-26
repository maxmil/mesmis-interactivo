import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.utils.LUtils;
import lindissima.process.Process;
import lindissima.process.FolPruneBiomass;

/*
 * Singleton process that defines the biomass of pruned foliage that remains
 * on the ground at the foot of the shrubs.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.process.FolPruneOnGround extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.FolPruneOnGround");
	
	//singleton instance
	private static var instance:FolPruneOnGround;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function FolPruneOnGround(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "FolPruneOnGround";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new FolPruneOnGround();
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
		var folPruneBiomass:Process = FolPruneBiomass.getProcess();		
		
		if(LUtils.getIP("densA") == 0 || t<Const.WEEK_BEGIN_CORN_CYCLE){
			//if there are no shrubs or if t represents one of the weeks before the corn is planted then return 0
			ret = 0;
		}else{
			//else multiply last weeks output by the index of persistence of ground cover and add it to 
			//the biomass of pruning from this week
			ret = getOutput(t-1)*LUtils.getIP("indPersCob")+folPruneBiomass.getOutput(t);
		}
		//logger.debug("t="+t+" FolPruneOnGround="+ret);
		return ret;
		
	}
	
}