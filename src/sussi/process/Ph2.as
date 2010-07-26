import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the population of herbivore 2
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Ph2 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Ph2");
	
	//singleton instance
	private static var instance:Ph2;
	
	//constant parameters
	private var h2_ini:Number;
	private var dh2_epid:Number;
	private var rp_prob:Number;
	private var rp_size:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Ph2(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Ph2";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Ph2();
			return instance;
		}else{
			return instance;
		}
	}
	
	/*
	 * Overwrites super method to initialize constant parameters
	 */
	private function initConstParams():Void{
		h2_ini = SUtils.getIP("h2_ini");
		dh2_epid = SUtils.getIP("dh2_epid");
		rp_prob = SUtils.getIP("rp_prob");
		rp_size = SUtils.getIP("rp_size");
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
		
		//if initial condition is 0 then return 0
		if (h2_ini==0){
			return 0;
		}
		
		//return variable
		var ret:Number;
		
		//define dependent processes
		var bh2:Process = Bh2.getProcess();
		var dh2:Process = Dh2.getProcess();
		
		//usefull constants
		var ph2_prev:Number = getOutput(t-1);
		
		//if is first week then return the initial condition
		//else if the population is above the level of epidemia then reduce to one third of the initial condition
		//else the previous population plus the births and less the deaths from this week, and if necessary a random pertubation
		if (t<1){
			ret = h2_ini;
		}else if(ph2_prev>dh2_epid){
			ret = dh2_epid/3;
		}else{
			ret = ph2_prev*(1+bh2.getOutput(t)-dh2.getOutput(t));
			
			//if random pertubation occurs
			if (Math.random()<rp_prob){
				ret = Math.max(0, ret+rp_size);
			}
		}

		//logger.debug("t="+t+" ph2="+ret);

		return ret;
	}
}