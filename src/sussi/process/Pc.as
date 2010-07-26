import ascb.util.logging.Logger;
import sussi.Const;
import sussi.process.*;
import sussi.utils.SUtils;

/*
 * Singleton process that defines the population of the carnivore
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Pc extends sussi.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Pc");
	
	//singleton instance
	private static var instance:Pc;
			
	//constant parameters
	private var c_ini:Number;
	private var dc_epid:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function Pc(){
		
		//call super constructor
		super();
		
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "Pc";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new Pc();
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
		dc_epid = SUtils.getIP("dc_epid");
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
		if (c_ini==0){
			return 0;
		}

		//return variable
		var ret:Number;
		
		//define dependent processes
		var bc:Process = Bc.getProcess();
		var dc:Process = Dc.getProcess();
		
		//usefull constants
		var pc_prev:Number = getOutput(t-1);
		
		//if is first week then return the initial condition
		//else if the population is above the level of epidemia then reduce to one third of the initial condition
		//else the previous population plus the births and less the deaths from this week, and if necessary a random pertubation
		if (t<1){
			ret = c_ini;
		}else if(pc_prev>dc_epid){
			ret = dc_epid/3;
		}else{
			ret = pc_prev*(1+bc.getOutput(t)-dc.getOutput(t));
		}		
		
		//logger.debug("t="+t+" pc="+ret);

		return ret;
	}
}