import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the birth rate of herbivore 2
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Bh2 extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Bh2");
	
	//singleton instance
	private static var instance:Bh2;
	
	//constant parameters
	private var h2_ini:Number;
	private var bh2_b:Number;
	private var bh2_c:Number;
	private var bh2_rAlee:Number;
	private var comp_h2h1:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Bh2(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Bh2";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Bh2();
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
		bh2_b = SUtils.getIP("bh2_b");
		bh2_c = SUtils.getIP("bh2_c");
		bh2_rAlee = SUtils.getIP("bh2_rAlee");
		comp_h2h1 = SUtils.getIP("comp_h2h1");
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
		var ph1:Process = Ph1.getProcess();
		var ph2:Process = Ph2.getProcess();
		
		//useful constants
		var ph2_prev:Number = ph2.getOutput(t-1);

		//calculate the births without considering alee
		var b:Number = 1/(1+bh2_b*Math.pow(ph2_prev+comp_h2h1*ph1.getOutput(t-1), bh2_c));
		
		//calculate the alee factor
		var af:Number = 1/(1+99*Math.exp(-bh2_rAlee*ph2_prev));
		
		//return product of the births and the alee factor
		ret = b*af;
		
		//logger.debug("t="+t+" b="+b+" af="+af+" bh2="+ret);

		return ret;
	}
}