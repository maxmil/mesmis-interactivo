import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.CornBiomass;
import lindissima.process.ShrubBiomass;
import lindissima.process.ExtShrubRoots;
import lindissima.process.NInSoil;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of corn
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.NAvailCorn extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NAvailCorn");
	
	//singleton instance
	private static var instance:NAvailCorn;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NAvailCorn(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NAvailCorn";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NAvailCorn();
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
		var cornBiomass:Process = CornBiomass.getProcess();
		var shrubBiomass:Process = ShrubBiomass.getProcess();
		var extShrubRoots:Process = ExtShrubRoots.getProcess();
		
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else{
			var potential:Number = LUtils.getIP("efiCapM") * cornBiomass.getOutput(t);
			var competition:Number = extShrubRoots.getOutput(t) * LUtils.getIP("efiCapA") * shrubBiomass.getOutput(t);
			ret = nInSoil.getOutput(t)*(potential/(potential+competition));
			//logger.debug("potential="+potential+" competition="+competition);
		}
		//logger.debug("t="+t+" NAvailCorn="+ret);
		return ret;
	}
	
}