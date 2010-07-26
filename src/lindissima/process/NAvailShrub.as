import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.NInSoil;
import lindissima.process.ShrubBiomass;
import lindissima.process.CornBiomass;
import lindissima.process.ExtShrubRoots;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of a shrub
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.process.NAvailShrub extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NAvailShrub");
	
	//singleton instance
	private static var instance:Process = Process(new NAvailShrub());
	
	//dependent processes
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NAvailShrub(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NAvailShrub";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		return instance;
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
		var shrubBiomass:Process = ShrubBiomass.getProcess();
		var cornBiomass:Process = CornBiomass.getProcess();
		var extShrubRoots:Process = ExtShrubRoots.getProcess();
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else{
			//lindissima.Test.logger.debug("nInSoil.getOutput(t)="+nInSoil.getOutput(t));
			var potential:Number = extShrubRoots.getOutput(t) * LUtils.getIP("efiCapA") * shrubBiomass.getOutput(t);
			var competition:Number = LUtils.getIP("efiCapM") * cornBiomass.getOutput(t);
			ret = nInSoil.getOutput(t)*(potential/(potential+competition));
			//logger.debug("nInSoil[t]="+nInSoil.getOutput(t)+" extShrubRoots[t]="+extShrubRoots.getOutput(t)+" potential="+potential+" competition="+competition);
		}
		//logger.debug("t="+t+" NAvailShrub="+ret);
		return ret;
	}
	
}