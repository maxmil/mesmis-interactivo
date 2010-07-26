import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.FNCorn;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the biomass of corn
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.CornBiomass extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.CornBiomass");
	
	//singleton instance
	private static var instance:CornBiomass;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function CornBiomass(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "CornBiomass";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new CornBiomass();
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
		var fNCorn:Process = FNCorn.getProcess();
		
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else if (t%52==Const.WEEK_BEGIN_CORN_CYCLE){
			//if is week that the corn is planted return the product of the 
			//density of corn and its initial mass
				ret = LUtils.getIP("biomasaIniM")*LUtils.getIP("densM");
		}else{
			//calculate the increment in the biomass of the corn
			var incBiomass:Number = (fNCorn.getOutput(t-1)*LUtils.getIP("fnM_TRA")*this.outputs[t-1])-(LUtils.getIP("fnM_TRC")*LUtils.getIP("fnM_C")*this.outputs[t-1]*this.outputs[t-1]);
			
			//add the increment to the biomass from the previous week and return
			ret = this.outputs[t-1]+incBiomass;
		}

		//logger.debug("t="+t+" cornBiomass="+ret);

		return ret;
	}
	
	/*
	 * Overrides super class method since this process stores the acumulated value
	 * 
	 * @param y the year
	 * @return the acumulated value of all the outputs for the year
	 */
	public function getAcumAnual(y:Number):Number{
		//define return variable
		var ret:Number = 0;
		
		if(y>=0){
			ret = getOutput(y*52+Const.WEEK_END_CORN_CYCLE);
		}
		
		return Utils.roundNumber(ret, 2);
	}
	
}