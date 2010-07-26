import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.utils.LUtils;
import lindissima.process.Process;
import lindissima.process.NExtractShrub;

/*
 * Singleton process that defines the amount of nitrogen in the pruned foliage of
 * the shrubs each week
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 04-07-2005
 */
 class lindissima.process.NInPrune extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NInPrune");
	
	//singleton instance
	private static var instance:NInPrune;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NInPrune(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NInPrune";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NInPrune();
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
		var nExtractShrub:Process = NExtractShrub.getProcess();
		
		if(!LUtils.isFolPruneWeek(t)){
			//if this week there is no pruning return 0
			ret = 0;
		}else{
			//if t represents one of the weeks where pruning occurs then return the inverse of the difference in the nitrogen
			//extracted by the shrub this week and the next week
			ret = -nExtractShrub.getInc(t+1, false);
		}
		//logger.debug("t="+t+" NInPrune="+Math.max(0,ret));
		return Math.max(0,ret);
	}
	
}