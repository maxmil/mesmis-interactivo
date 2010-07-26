import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;


/*
 * Singleton process that defines the death rate of herbivore 2
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Dh2 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Dh2");
	
	//singleton instance
	private static var instance:Dh2;
		
	//constant parameters
	private var h2_ini:Number;
	private var dh2_e:Number;
	private var dh2_f:Number;
	private var dh2_epid:Number;
	private var dh2_carn:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Dh2(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Dh2";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Dh2();
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
		dh2_e = SUtils.getIP("dh2_e");
		dh2_f = SUtils.getIP("dh2_f");
		dh2_epid = SUtils.getIP("dh2_epid");
		dh2_carn = SUtils.getIP("dh2_carn");
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
		if (t<1 || h2_ini==0){
			return 0;
		}
		
		//return variable
		var ret:Number;
		
		//define dependent processes
		var ph2:Process = Ph2.getProcess();
		var pc:Process = Pc.getProcess();
		
		//useful values
		var ph2_prev = ph2.getOutput(t-1);
		
		//if is above the epidemia limit then two thirds of last weeks population dies
		//otherwise the death rate is the base value dh2_e plus a constant proportion of the total population
		//dh2_f plus a proportion that were killed by the carnivore
		if(ph2_prev>dh2_epid){
			ret = 2*dh2_epid/3;
		}else{
			ret = dh2_e+(dh2_f*ph2_prev)+(dh2_carn*pc.getOutput(t-1));
		}
		
		//logger.debug("t="+t+" dh2="+ret);

		return ret;
	}
}