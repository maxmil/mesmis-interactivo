import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the birth rate of the carnivore
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Bc extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Bc");
	
	//singleton instance
	private static var instance:Bc;
	
	//constant parameters
	private var c_ini:Number;
	private var alpha_ch1:Number;
	private var alpha_ch2:Number;
	private var bc_rAlee:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Bc(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Bc";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Bc();
			return instance;
		}else{
			return instance;
		}
	}
		
	/*
	 * Overwrites super method to initialize constant parameters
	 */
	private function initConstParams():Void{
		c_ini = SUtils.getIP("c_ini");
		alpha_ch1 = SUtils.getIP("alpha_ch1");
		alpha_ch2 = SUtils.getIP("alpha_ch2");
		bc_rAlee = SUtils.getIP("bc_rAlee");
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
		if (t<1 || c_ini==0){
			return 0;
		}

		//return variable
		var ret:Number;
		
		//define dependent processes
		var ph1:Process = Ph1.getProcess();
		var ph2:Process = Ph2.getProcess();
		var pc:Process = Pc.getProcess();
		
		//calculate the births from herbivore 1
		var bh1:Number = alpha_ch1*ph1.getOutput(t-1);

		//calculate the births from herbivore 2
		var bh2:Number = alpha_ch2*ph2.getOutput(t-1);
		
		//calculate the alee factor
		var af:Number = 1/(1+99*Math.exp(-bc_rAlee*pc.getOutput(t-1)));
		
		//return product of the births and the alee factor
		ret = af*(bh1+bh2);
		
		//logger.debug("t="+t+" bh1="+bh1+" bh2="+bh2+" af="+af+" bc="+ret);

		return ret;
	}
}