import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the death rate of the carvnivore
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Dc extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Dc");
	
	//singleton instance
	private static var instance:Dc;
		
	//constant parameters
	private var c_ini:Number;
	private var dc_e:Number;
	private var dc_f:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Dc(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Dc";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Dc();
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
		dc_e = SUtils.getIP("dc_e");
		dc_f = SUtils.getIP("dc_f");
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
		var pc:Process = Pc.getProcess();
		
		//the deaths are defined by a linear function
		ret = dc_e+(dc_f*pc.getOutput(t-1));
		
		//logger.debug("t="+t+" dc="+ret);

		return ret;
	}
}