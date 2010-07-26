import ascb.util.logging.Logger;

/*
 * Static utility functions for Mesmis
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-09-2005
 */
 class stepByStep.util.MUtils{
	 
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.util.MUtils");
	
	/*
	 * Prevent instantiation
	 */
	private function MUtils(){
	}
	
	/*
	 * Loops through indicators and builds new array containing
	 * only those whose value of isSel == true
	 * 
	 * @param indicators an array of indicator objects
	 * 
	 * @return an array containing only the selected indicators
	 */
	public static function selectIndicators(indicators:Array):Array{
		var selIndicators:Array = new Array();
		var l:Number = indicators.length;
		for (var i=0; i<l; i++){
			if (indicators [i].getIsSel().valueOf()){
				selIndicators[selIndicators.length] = indicators[i];
			}
		}
		return selIndicators;
	}
	
	/*
	 * Modifies the array of indicators passed to the method so that
	 * all have equal weights
	 * 
	 * @param indicators an array of indicators
	 */
	public static function initIndicatorWeights(indicators:Array):Void{
		var l = indicators.length;
		var w : Array;
		
		//check to see if any of the indicators has not been initiated
		var i : Number = 0;
		while (i<l && indicators[i].getWeights ()!=null){
			i ++;
		}
		
		//initiate all weights again
		if (i<l){
			for (var j = 0; j < l; j ++){
				w = new Array (100/l, 100/l, 100/l);
				indicators [j].setWeights (w);
			}
		}
	}	
}