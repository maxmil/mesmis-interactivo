import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.NAvailShrub;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the function f(N) for shrubs
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.FNShrub extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.FNShrub");
	
	//singleton instance
	private static var instance:FNShrub;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function FNShrub(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "FNShrub";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new FNShrub();
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
		var nAvailShrub:Process = NAvailShrub.getProcess();
		
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else{
			//calculate the function f(N) for shrub using the process nAvailShrub
			var fnA_mineral:Number = 1-1/(1+LUtils.getIP("fnA_A")*Math.pow(nAvailShrub.getOutput(t),LUtils.getIP("fnA_B")));
			ret = Math.max(LUtils.getIP("fnA_fnMin"), fnA_mineral);
			//logger.debug("nAvailShrub[t]="+nAvailShrub.getOutput(t));
		}
		//logger.debug("t="+t+" FNShrub="+ret);
		return ret;
	}
	
}