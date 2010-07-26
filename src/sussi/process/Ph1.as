import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;


/*
 * Singleton process that defines the population of herbivore 1
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Ph1 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Ph1");
	
	//singleton instance
	private static var instance:Ph1;
	
	//constant parameters
	private var h1_ini:Number;
	private var dh1_epid:Number;
	private var rp_prob:Number;
	private var rp_size:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Ph1(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Ph1";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Ph1();
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
		dh1_epid = SUtils.getIP("dh1_epid");
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
		if (h1_ini==0){
			return 0;
		}
		
		//return variable
		var ret:Number;
		
		//define dependent processes
		var bh1:Process = Bh1.getProcess();
		var dh1:Process = Dh1.getProcess();
		
		//usefull constants
		var ph1_prev:Number = getOutput(t-1);
		
		//if is first week then return the initial condition
		//else if the population is above the level of epidemia then reduce to one third of the initial condition
		//else the previous population plus the births and less the deaths from this week, and if necessary a random pertubation
		if (t<1){
			ret = h1_ini;
		}else if(ph1_prev>dh1_epid){
			ret = dh1_epid/3;
		}else{
			ret = ph1_prev*(1+bh1.getOutput(t)-dh1.getOutput(t));
			
			//if random pertubation occurs
			if (Math.random()<rp_prob){
				ret = Math.max(0, ret+rp_size);
			}
		}

		//logger.debug("t="+t+" ph1="+ret);

		return ret;
	}
}