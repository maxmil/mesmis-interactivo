import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.NFiltered;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the anual net profit of the lake from tourism each year
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.LakeNetProfit extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.LakeNetProfit");
	
	//singleton instance
	private static var instance:LakeNetProfit;
	
	//array of lake initial conditions
	private var lakeIni:Array;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function LakeNetProfit(){
		super();
		//define interval and name
		int = Const.PROC_INT_YEAR;
		name = "LakeNetProfit";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new LakeNetProfit();
			instance.lakeIni = new Array();
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

		//define dependent processes
		var nFiltered:Process = NFiltered.getProcess();
		
		//define dependent variables
		var shrubs:Boolean = LUtils.getIP("densA")>0;
		var rootPrune:Number = LUtils.getIP("podasRaiz");
		var folPrune:Array = LUtils.getIPArray("podasTallo");
		var aidFolPrune= LUtils.getIP("sbsdPodTallo");
		var aidRootPrune = LUtils.getIP("sbsdPodRaiz");
		
		//calcualte the cost of root prunes
		var cstRootPrune:Number = (shrubs && aidRootPrune) ? aidRootPrune*rootPrune : 0;
		
		//calculate the cost of foliage prunes
		var cstFolPrune:Number = 0;
		if (shrubs && aidFolPrune>0){
			
			//calculate the number of foliage prunes this year
			var nFolPrune:Number = 0;
			for (var i=0; i<folPrune.length; i++){
				if (Math.floor(folPrune[i]/52) == t){
					nFolPrune ++;
				}
			}
			
			cstFolPrune = nFolPrune*aidFolPrune;
		}
		
		//redefine weed concentration at the beggining of the year taking
		//into account the nitrogen filtered from the previous year and
		//the initial condition of the weeds the previous year
		var nLixPrev:Number = nFiltered.getAcumAnual(t-1);
		var nLix:Number = nFiltered.getAcumAnual(t);
		var lowLimit:Number = LUtils.getIP("nCritBaja");
		var highLimit:Number = LUtils.getIP("nCritAlta");
		var algasIniPrevLow:Boolean = (t>0) ? this.lakeIni[t-1]==Const.WEED_CONCENTRATION_LOW : true;
		var weedConLow:Boolean;
		if((!algasIniPrevLow && nLixPrev>highLimit) || (algasIniPrevLow && nLixPrev>lowLimit)){
			weedConLow = false;
		}else{
			weedConLow = LUtils.getIP("algasIni",t)==Const.WEED_CONCENTRATION_LOW;
		}
		
		//save initial condition
		this.lakeIni[t] = (weedConLow) ? Const.WEED_CONCENTRATION_LOW : Const.WEED_CONCENTRATION_HIGH; 

		//calculate brute profit
		var bruteProfit:Number = 0;
		if((weedConLow && nLix<lowLimit) || (!weedConLow && nLix<highLimit)){
			bruteProfit = LUtils.getIP("ingAnRib");
		}
		
		//logger.debug("year="+t);
		//logger.debug("nLixPrev=" + nLixPrev);
		//logger.debug("nLix=" + nLix);
		//logger.debug("weedConLow=" + weedConLow);
		//logger.debug("nFiltered="+nFiltered.getAcumAnual(t-1));
		//logger.debug("bruteProfit="+bruteProfit);
		//logger.debug("cstFolPrune="+cstFolPrune);
		//logger.debug("cstRootPrune="+cstRootPrune);
		//logger.debug("ret="+String(bruteProfit-cstFolPrune-cstRootPrune));
		//logger.debug("");
		
		return bruteProfit - Const.HECTARES_CORN*(cstFolPrune + cstRootPrune);		
	}
	
	/*
	 * Calculates the average profit for the years specified
	 * 
	 * @param y the number of years to calculate the average profig for
	 * @return the average profit
	 */
	public function avgeProfit(y:Number):Number{
		var sum:Number = 0;
		for (var i=0; i<y; i++){
			sum += getOutput(i);
		}
		return (sum/y);
	}
	
	/*
	 * Overides parent class method to reset instance variables aswell
	 */
	public function clearOutput():Void{
		this.outputs = new Array();
		this.lakeIni = new Array();
	}
}