import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the birth rate of herbivore 1
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Bh1 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.bh1");
	
	//singleton instance
	private static var instance:Bh1;
	
	//constant parameters
	private var h1_ini:Number;
	private var bh1_b:Number;
	private var bh1_c:Number;
	private var bh1_rAlee:Number;
	private var comp_h1h2:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Bh1(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Bh1";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Bh1();
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
		bh1_b = SUtils.getIP("bh1_b");
		bh1_c = SUtils.getIP("bh1_c");
		bh1_rAlee = SUtils.getIP("bh1_rAlee");
		comp_h1h2 = SUtils.getIP("comp_h1h2");
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
		var ph2:Process = Ph2.getProcess();
		
		//useful constants
		var ph1_prev:Number = ph1.getOutput(t-1);

		//calculate the births without considering alee
		var b:Number = 1/(1+bh1_b*Math.pow(ph1_prev+comp_h1h2*ph2.getOutput(t-1), bh1_c));
		
		//calculate the alee factor
		var af:Number = 1/(1+99*Math.exp(-bh1_rAlee*ph1_prev));
		
		//return product of the births and the alee factor
		ret = b*af;
		
		//logger.debug("t="+t+" b="+b+" af="+af+" bh1="+ret);

		return ret;
	}
	
	/*
	 * Utility function used by phase diagram to get the births for a specific
	 * size of population, where there are no other animals present
	 * 
	 * @param nIndiv the number of individuals in the population
	 * 
	 * @return the number of individuals born the next week
	 */
	public function getBirthsByPop(nIndiv:Number):Number{
		
		//if there are no individuals then reproduction cannot occur
		if (nIndiv==0){
			return 0;
		}

		//return variable
		var ret:Number;
		
		//define dependent processes
		var ph1:Process = Ph1.getProcess();
		var ph2:Process = Ph2.getProcess();

		//calculate the births without considering alee
		var b:Number = 1/(1+bh1_b*Math.pow(nIndiv, bh1_c));
		
		//calculate the alee factor
		var af:Number = 1/(1+99*Math.exp(-bh1_rAlee*nIndiv));
		
		//return product of the births and the alee factor
		ret = b*af;
		
		//logger.debug("nIndiv="+nIndiv+" b="+b+" af="+af+" bh1.getBirthsByPop="+ret);

		return ret;
		
	}
}