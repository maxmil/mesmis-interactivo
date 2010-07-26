import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.NInSoil;
import lindissima.process.FolPruneOnGround;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of corn
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.NFiltered extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NFiltered");
	
	//singleton instance
	private static var instance:NFiltered;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NFiltered(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NFiltered";	 
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NFiltered();
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
		var nInSoil:Process = NInSoil.getProcess();
		var folPruneOnGround:Process = FolPruneOnGround.getProcess();
		
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			//if t represents one of the weeks before the corn is planted or after it is
			//harvested then return 0
			ret = 0;
		}else{
			ret = nInSoil.getOutput(t)*(LUtils.getIP("propNLixSem"))/(1+folPruneOnGround.getOutput(t)*LUtils.getIP("indProtCob"));
		}
		if (t==145){
				//logger.debug(nInSoil.getOutput(t)+"  "+folPruneOnGround.getOutput(t))
		}
		return ret;
	}
	
}