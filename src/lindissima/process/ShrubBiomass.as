import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.FNShrub;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of a shrub
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.process.ShrubBiomass extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.ShrubBiomass");
	
	//singleton instance
	private static var instance:ShrubBiomass;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function ShrubBiomass(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "ShrubBiomass";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new ShrubBiomass();
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
		var fNShrub:Process = FNShrub.getProcess();
		
		//if there are no shrubs or if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(LUtils.getIP("densA") == 0 || t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else if (t%52==Const.WEEK_BEGIN_CORN_CYCLE || LUtils.isFolPruneWeek(t)){
			//if t represents one of the weeks that the corn is planted or t represents
			//a week where pruning occurs then return
			//the density of shrubs multiplied by the initial mass of each one
			//this represents the assumption that new shrubs are planted each year
			ret = LUtils.getIP("biomasaIniA")*LUtils.getIP("densA");
		}else{
			//calculate the increment in the biomass of the shrub
			var incBiomass:Number = (fNShrub.getOutput(t-1)*LUtils.getIP("fnA_TRA")*this.outputs[t-1])-(LUtils.getIP("fnA_TRC")*LUtils.getIP("fnA_C")*this.outputs[t-1]*this.outputs[t-1]);
			
			//add the increment to the biomass from the previous week and return
			ret = this.outputs[t-1]+incBiomass;
			//logger.debug("fNShrub.getOutput(t-1)="+fNShrub.getOutput(t-1));
		}
		
		//logger.debug("t="+t+" ShrubBiomass="+ret);

		return ret;
		
	}
	
}