import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.ShrubBiomass;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the extention of the roots of the shrub
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 27-06-2005
 */
 class lindissima.process.ExtShrubRoots extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.ExtShrubRoots");
	
	//singleton instance
	private static var instance:ExtShrubRoots;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function ExtShrubRoots(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "ExtShrubRoots";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new ExtShrubRoots();
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
		
		//if there are no shrubs or is before the corn is planted then return 0
		if(LUtils.getIP("densA") == 0 || t%52<Const.WEEK_BEGIN_CORN_CYCLE){
			ret = 0;
		}else{
			//if the roots are pruned at the beginning of the year
			var podasRaiz = LUtils.getIP("podasRaiz");
			if (podasRaiz>0){
				//if it is the week that the corn is planted then the roots are pruned
				if (t%52==Const.WEEK_BEGIN_CORN_CYCLE){
					//calculate the proportion that has been pruned
					ret = 1-podasRaiz;
				}else{
					//calculate the recuperation of the roots based on the biomass of the shrub
					//and the index of recuperation of the roots
					//note that the recuperation is limited to a maximum value of 1
					ret = Math.min(1, this.outputs[t-1]+shrubBiomass.getOutput(t)*LUtils.getIP("indRecRaices"))
				}
			}else{
				//the roots have not been pruned and are therfore complete == 1
				ret = 1;
			}
		}
		//logger.debug("t="+t+" ExtShrubRoots="+ret);
		return ret;
	}
	
}