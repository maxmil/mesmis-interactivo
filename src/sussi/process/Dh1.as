import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;


/*
 * Singleton process that defines the death rate of herbivore 1
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Dh1 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Dh1");
	
	//singleton instance
	private static var instance:Dh1;
	
	//constant parameters
	private var h1_ini:Number;
	private var dh1_e:Number;
	private var dh1_f:Number;
	private var dh1_epid:Number;
	private var dh1_carn:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Dh1(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Dh1";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Dh1();
			return instance;
		}else{
			return instance;
		}
	}
		
	/*
	 * Overwrites super method to initialize constant parameters
	 */
	private function initConstParams():Void{
		h1_ini = SUtils.getIP("h1_ini");
		dh1_e = SUtils.getIP("dh1_e");
		dh1_f = SUtils.getIP("dh1_f");
		dh1_epid = SUtils.getIP("dh1_epid");
		dh1_carn = SUtils.getIP("dh1_carn");
	}
	
	/*
	 * Calculates the output value at time t using the selected initial parameters and
	 * other dependent processes
	 * 
	 * @param t the index of the week or year (depending on the type of interval) for
	 * which the output value is desired
	 * @return the output value for the given t
	 */ 
	private function calculateValue(t:Number):Number{
		
		//if is before the first week or initial condition is 0 then return 0
		if (t<1 || h1_ini==0){
			return 0;
		}
		
		//return variable
		var ret:Number;
		
		//define dependent processes
		var ph1:Process = Ph1.getProcess();
		var pc:Process = Pc.getProcess();
		
		//useful values
		var ph1_prev = ph1.getOutput(t-1);
		
		//if is above the epidemia limit then two thirds of last weeks population dies
		//otherwise the death rate is the base value dh1_e plus a constant proportion of the total population
		//dh1_f plus a proportion that were killed by the carnivore
		if(ph1_prev>dh1_epid){
			ret = 2*dh1_epid/3;
		}else{
			ret = dh1_e+(dh1_f*ph1_prev)+(dh1_carn*pc.getOutput(t-1));
		}
		
		//logger.debug("t="+t+" dh1="+ret);

		return ret;
	}
	
	/*
	 * Utility function used by phase diagram to get the deaths for a specific
	 * size of population, where there are no other animals present
	 * 
	 * @param nIndiv the number of individuals in the population
	 * 
	 * @return the number of individuals that die the next week
	 */
	public function getDeathsByPop(nIndiv:Number):Number{
		
		//if there are no individuals then death cannot occur
		if (nIndiv==0){
			return 0;
		}

		//return variable
		var ret:Number;
		
		//define dependent processes
		var ph1:Process = Ph1.getProcess();
		var pc:Process = Pc.getProcess();
		
		//if is above the epidemia limit then two thirds of last weeks population dies
		//otherwise the death rate is the base value dh1_e plus a constant proportion of the total population
		//dh1_f plus a proportion that were killed by the carnivore
		if(nIndiv>dh1_epid){
			ret = 2*dh1_epid/3;
		}else{
			ret = dh1_e+(dh1_f*nIndiv);
		}
		
		//logger.debug("t="+t+" dh1.getDeathsByPop="+ret);

		return ret;
		
	}
}