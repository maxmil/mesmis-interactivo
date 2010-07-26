import ascb.util.logging.Logger;
import lindissima.Const;
import lindissima.process.Process;
import lindissima.process.CornBiomass;
import lindissima.utils.LUtils;
/*
 * Singleton process that defines the anual net profit of the corn farmer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-06-2005
 */
 class lindissima.process.FarmerNetProfit extends lindissima.process.Process {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.process.FarmerNetProfit");
	
	//singleton instance
	private static var instance:FarmerNetProfit;
	
	/*
	 * Private constructor prevents instantiation
	 */
	private function FarmerNetProfit(){
		super();
		//logger = lindissima.TestActivity.logger;
		//define interval and name
		int = Const.PROC_INT_YEAR;
		name = "FarmerNetProfit";
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getProcess():Process{
		if (!instance){
			instance = new FarmerNetProfit();
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
		var cornBiomass:Process = CornBiomass.getProcess();
		
		//calculate the brute profit from the final biomass of the corn per hectare
		//to convert biomass from grams/m2 to kg/hectare multiply by 10
		var bruteProfit:Number = cornBiomass.getOutput(t*52+Const.WEEK_END_CORN_CYCLE)*10*LUtils.getIP("indCosecha")*LUtils.getIP("cstM");
		
		//calculate the cost of the fertilizer
		//NOTE: Convertion from gms/m2 to kg/hectare is by factor of 10
		var cstFertilizer:Number = (LUtils.getIP("cstUrea")*LUtils.getIP("nAnual", t)*10)/(Const.NIT_PER_UREA*Const.WEIGHT_UREA);
		
		//calculate the cost of foliage prunes
		var totalCstFolPrune:Number = 0;
		if (LUtils.getIPArray("densA")>0){
			var folPrune = LUtils.getIPArray("podasTallo");
			var cstFolPrune = LUtils.getIP("cstPodTallo");
			var aidFolPrune= LUtils.getIP("sbsdPodTallo");
			for (var i=0; i<folPrune.length; i++){
				if (Math.floor(folPrune[i]/52) == t){
					totalCstFolPrune += cstFolPrune - aidFolPrune;
				}
			}
		}
		
		//calculate the cost of the root prunes
		var totalCstRootPrune:Number = (LUtils.getIP("densA")>0) ? (LUtils.getIP("cstPodRaiz")-LUtils.getIP("sbsdPodRaiz"))*LUtils.getIP("podasRaiz") : 0;
		
		//logger.debug("year="+t);
		//logger.debug("costFertilizer="+cstFertilizer);
		//logger.debug("bruteProfit="+bruteProfit);
		//logger.debug("totalCstFolPrune="+totalCstFolPrune);
		//logger.debug("totalCstRootPrune="+totalCstRootPrune);
		//logger.debug("ret="+String(bruteProfit-cstFertilizer-totalCstFolPrune-totalCstRootPrune));
		//logger.debug("");
		
		return (bruteProfit-cstFertilizer-totalCstFolPrune-totalCstRootPrune);
	}
	
	/*
	 * Calculates the average profit for the years specified
	 * 
	 * @param y the number of years to calculate the average profit for
	 * @return the average profit
	 */
	public function avgeProfit(y:Number):Number{
		var sum:Number = 0;
		for (var i=0; i<y; i++){
			sum += getOutput(i);
		}
		return (sum/y);
	}
	
}