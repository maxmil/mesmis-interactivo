import ascb.util.logging.Logger;
import core.util.Utils;
import sussi.Const;

/*
 * Superclass from which all processes should inherit
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.process.Process {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.process.Process");
	
	//the name of the process
	private var name:String;
	
	//interval
	public var int:Number;
	
	//array of output values
	public var outputs:Array;
	 
	/*
	 * Private constructor prevents instantiation
	 */
	private function Process(){
		
		//initialize outputs
		outputs = new Array();
		
		//initialize constant parameters
		initConstParams();
	}
	
	/*
	 * Gets the name of the process
	 * 
	 * @return the name of the process
	 */
	public function getName():String{
		return this.name;
	}
	
	/*
	 * Gets the output value at time t.
	 * 
	 * @param t the index of the semana or year (depending on the type of interval) for
	 * which the output is desired
	 * @return the output value for this week/year
	 */ 
	public function getOutput(t:Number){
		if (this.outputs.length <= t){
			calculateInterval(null, t);
		}
		return this.outputs[t];
	}
	
	/*
	 * Should be overwritten by all subclasses to initialize the initParams and
	 * other constant values that they use in their getOutput function
	 */
	private function initConstParams():Void{
		logger.warning("Method should be overwritten if process uses initial parameters that can be considered constant")
	}
	
	/*
	 * Calculates an interval of output values for the process within initial and final time bounds. The
	 * output values are added to the output array.
	 * 
	 * @param initT the initial time to start calculating the process. If no value
	 * is specified the process is calculated from the most recent previously calculated
	 * value
	 * @param finT the final time for the calculation of the process. If no value is specified
	 * the constant value Const.PROC_YEARS_LIMIT is taken
	 */
	 private function calculateInterval(initTime:Number, finTime:Number):Void{
		//get the starting index, either the initial time or before if other values
		//have not already been calculated
		initTime  = (initTime == null) ? outputs.length : initTime;
		//define the finishing index, either the final time or the limit defined in Cost.PROC_YEARS_LIMIT
		if (finTime == null){
			finTime = (this.int == Const.PROC_INT_WEEK) ? Const.PROC_YEARS_LIMIT*52 : Const.PROC_YEARS_LIMIT;
		}
		//initial current time variable
		var currT = initTime
		//resize the output array if it has elements that are going to be replaced
		outputs.length = currT;
		//for each t add a new output value to the outputs array
		while (currT<=finTime){
			this.outputs[currT] = calculateValue(currT);
			currT++;
		}
	 }
	 
	/*
	 * Gets the output value at time t. This method should be overwridden by each subclass
	 * in order to implement process specific logic
	 * 
	 * @param t the index of the semana or year (depending on the type of interval) for
	 * which the output value is desired
	 * @return the output value for the given t
	 */ 
	private function calculateValue(t:Number):Number{
		//should be overriden by subclasses to implement process specific logic
		return null;
	}
	
	/*
	 * Utility function to help draw result tables, passed to core.comp.ResultTable
	 * as the callback function of a process
	 * 
	 * @param i the week to retreive, if the process has a yearly interval this should be 52*y
	 * otherwise the function returns String(this.getOutput(i))
	 * @param id the id of the column, if id="t" then the function returns String(i+1)
	 * @return the string literal to be drawn in the current cell
	 */
	public function getTableValueWeek(i:Number, id:String):String{
		//define return variable
		var ret:Number;
		
		if (id == "t"){
			ret = i;
		}else{
			if (this.int == Const.PROC_INT_YEAR){
				if (i>0 && i%52==51){
					ret = this.getOutput((i+1)/52-1);
				}else{
					return "";
				}
			}else{
				ret = this.getOutput(i);
			}
		}
		
		return String(ret);
	}
	
	/*
	 * Utility function to help draw result tables, passed to core.comp.ResultTable
	 * as the callback function of a process
	 * 
	 * @param y the year to retreive
	 * @param id the id of the column, if id="t" then the function returns String(i+1)
	 * otherwise the function returns String(this.getAcumAnual(i)) or String(this.getOutput(i))
	 * depending on wether the process has a yearly or weekly interval.
	 * @return the string literal to be drawn in the current cell
	 */
	public function getTableValueYear(y:Number, id:String):String{
		//define return variable
		var ret:Number;
		
		if (id == "t"){
			ret = y+1;
		}else{
			if (this.int == Const.PROC_INT_YEAR){
				ret = this.getOutput(y);
			}else{
				ret = this.getAcumAnual(y);
			}
		}
		
		return String(Utils.roundNumber(ret, 2));
	}	
	
	/*
	 * Simple functionality that gGets the increment in a process between two values of t. 
	 * This method should be overwritten by subclasses to implement more complex behaviour.
	 * 
	 * @param t the week to get the increment for
	 * @param isPos when true the minimum increment returned is 0
	 * @return getOutput(t)-getOutput(t-1)
	 */
	 public function getInc(t:Number, isPos:Boolean):Number{
		 var ret:Number = getOutput(t)-getOutput(t-1);
		 return (isPos) ? Math.max(0, ret) : ret;
	 }
	 
	 /*
	  * Sums all outputs within two time limits
	  *
	  * @param tInit the initial time
	  * @param tFin the final time
	  * @return the sum of all values from tInit to tFin. tInit is included
	  * in the calculation but tFin is not
	  */
	private function getAcumulated(tInit:Number, tFin:Number):Number{
		
		//define return variable
		var ret:Number = 0;
		
		//acumulate sum
		for(var i=tInit;i<tFin;i++){
			ret += getOutput(i);
		}
		
		return ret;
	}
	
	/*
	 * Gets the acumulated value for the given year
	 * 
	 * @param y the year
	 * @return the acumulated value of all the outputs for the year
	 */
	public function getAcumAnual(y:Number){
		//define return variable
		var ret:Number = 0;
		
		if(y>=0){
			if(this.int == Const.PROC_INT_WEEK){
				//if the process interval is weekly
				ret = getAcumulated(y*52, y*52+52)
			}else if(this.int == Const.PROC_INT_YEAR){
				//if the process interval is yearly
				ret = getOutput(y);
			}
		}
		
		return ret;
	}
	
	/*
	 * Clears the output of the process
	 */
	public function clearOutput():Void{
		
		//recreate output array
		this.outputs = new Array();
		
		//reinitialize constant params
		initConstParams();
	}
	
	/*
	 * Gets the array of outputs
	 * 
	 * @return the internal array of outputs
	 */
	public function getOutputs():Array{
		return this.outputs;
	}	
	
	/*
	 * Set the outputs with a new array of outputs
	 * 
	 * @param outputs the new array of outputs
	 */
	public function setOutputs(outputs:Array){
		this.outputs = outputs;
	}
}