import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines concentration of weeds in the lake
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.WeedCon extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.WeedCon");
	
	//singleton instance
	private static var instance:WeedCon;
	
	//constant values
	private static var hap:Number;
	private static var nTerm:Number;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function WeedCon(){
		super();
		//define interval and name
		int = Const.PROC_INT_WEEK;
		name = "WeedCon";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new WeedCon();
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
		
		//define hap if not defined
		if(!hap || hap==null){
			hap = Math.pow(LUtils.getIP("fnva_ha"), LUtils.getIP("fnva_P"));
		}
		
		//define nitrogen term if not defined
		if(!nTerm || nTerm == null){
			var nit:Number = LUtils.getIP("nLake");
			nTerm = nit/(nit+LUtils.getIP("fnva_hn"));
		}
		
		//get output for prevoius week
		var weedPrev:Number;
		if (t == 0){
			var algasIni:Number = LUtils.getIP("algasIni", 0);
			if (algasIni==Const.WEED_CONCENTRATION_LOW){
				weedPrev = LUtils.getIP("algasIniBaja")
			}else if (algasIni==Const.WEED_CONCENTRATION_HIGH){
				weedPrev = LUtils.getIP("algasIniAlta")
			}else if (algasIni==Const.WEED_CONCENTRATION_CUSTOM){
				weedPrev = LUtils.getIP("algasIniCustom")
			}
		}else{
			weedPrev = this.getOutput(t-1);
		}
		
		//get vegetation for previous week
		var veg:Number = hap/(Math.pow(weedPrev, LUtils.getIP("fnva_P"))+hap);
		var hv:Number = LUtils.getIP("fnva_hv");
		var weedInc:Number = LUtils.getIP("fnva_r")*weedPrev*nTerm*hv/(hv+veg)-LUtils.getIP("fnva_c")*Math.pow(weedPrev, 2);
		
		//calculate return value
		ret = weedPrev+weedInc;
		
		//logger.debug("veg="+veg);
		//logger.debug("weedInc="+weedInc);
		//logger.debug("t="+t+" WeedCon="+String(ret))
		
		return ret;
	}
	
	/*
	 * Overides parent class method to reset static variables aswell
	 */
	public function clearOutput():Void{
		this.outputs = new Array();
		hap = null;
		nTerm = null;
	}
	
}