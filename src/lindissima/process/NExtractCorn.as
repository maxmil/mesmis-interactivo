import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.utils.LUtils;
import lindissima.process.Process;
import lindissima.process.CornBiomass;
import lindissima.process.FNCorn;

/*
 * Singleton process that defines the amount of nitrogen extracted from the soil by the corn.
 * The process is acumulative each year upto the end of the corn cycle when it is harvested.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.NExtractCorn extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.NExtractCorn");
	
	//singleton instance
	private static var instance:NExtractCorn;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function NExtractCorn(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "NExtractCorn";		 
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new NExtractCorn();
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
		var cornBiomass:Process = CornBiomass.getProcess();
		var fNCorn:Process = FNCorn.getProcess();
		
		//if t represents one of the weeks before the corn is planted or after it is
		//harvested then return 0
		if(t%52<Const.WEEK_BEGIN_CORN_CYCLE || t%52>Const.WEEK_END_CORN_CYCLE){
			ret = 0;
		}else if (t%52==Const.WEEK_BEGIN_CORN_CYCLE){
			//if it is the week that the corn is planted return the product of the 
			//maximum concentration of nitrogen in corn and its initial mass
			ret = LUtils.getIP("biomasaIniM")*LUtils.getIP("densM")*LUtils.getIP("maxConcNitM");
		}else{
			//calculate the increment in the nitrogen of the corn
			var incN:Number = fNCorn.getOutput(t)*cornBiomass.getInc(t, true)*LUtils.getIP("maxConcNitM");
			
			//add the increment to the biomass from the previous week and return
			ret = this.outputs[t-1]+incN;
		}
		
		return ret;
	}
	
	/*
	 * Overrides parent method to implement class specific behaviour
	 * 
	 * @param t the week to get the increment for
	 * @param isPos when true the minimum increment returned is 0
	 * @return 0 if is the first week of the corn cycle. If not the diference 
	 * between the output at time t and time t-1 is calculated
	 */
	 public function getInc(t:Number, isPos:Boolean):Number{
		//define return variable
		var ret:Number;
		 
		if(t<1 || t%52==Const.WEEK_BEGIN_CORN_CYCLE){
			//if is first week of corn cycle return 0
			ret = 0;
		}else{
			 //otherwise return the difference
			ret = getOutput(t)-getOutput(t-1); 
		}
		
		//if isPos avoid returning negative value
		return (isPos) ? Math.max(0, ret) : ret;
	 }
	
}