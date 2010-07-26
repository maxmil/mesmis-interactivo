import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.NAvailCorn;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the function f(N) for corn
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.FNCorn extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.FNCorn");
	
	//singleton instance
	private static var instance:FNCorn;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function FNCorn(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "FNCorn";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new FNCorn();
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
		var nAvailCorn:Process = NAvailCorn.getProcess();
		
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else{
			//calculate the function f(N) for corn using the process nAvailCorn
			ret = (1-1/(1+LUtils.getIP("fnM_A")*Math.pow(nAvailCorn.getOutput(t),LUtils.getIP("fnM_B"))));
		}
		//logger.debug("t="+t+" FNCorn="+ret);
		return ret;
	}
	
}