/*
 * Initial parameters for Sussi
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.model.InitParam {
	
	private var id:String;
	private var literal:String;
	private var desc:String;
	private var precision:Number;
	private var arrVal:Array;
	private var numVal:Number;
	private var minVal:Number;
	private var maxVal:Number;
	
	/*
	 * Constructor with all variables
	 * 
	 * @param id the id of the parameters, should correspond with a variable in InitParams
	 * @param literal the name of the parameter
	 * @param desc the description of the parameter
	 * @param precision the precision of the parameter, 0=whole numbers only, x=x decimal points
	 * @param val the value of the parameter, either numeric or an array of numbers
	 * @param minVal the minimum value of the parameter
	 * @param maxVal the maximum value of the parameter
	 */
	function InitParam(id:String, literal:String, desc:String, precision:Number, val:String, minVal:Number, maxVal:Number){
		this.id = id;
		this.literal = literal;
		this.desc = desc;
		this.precision = precision;
		this.setVal(val);
		this.minVal = minVal;
		this.maxVal = maxVal;
	}
	
	/*
	 * Gets the id
	 * 
	 * @return the id of the initial param
	 */
	 public function getId():String{
		 return this.id;
	 }
	 	 
	/*
	 * Gets the literal
	 * 
	 * @return the literal of the initial param
	 */
	 public function getLiteral():String{
		 return this.literal;
	 }
	 
	/*
	 * Gets the description
	 * 
	 * @return the description of the initial param
	 */
	 public function getDesc():String{
		 return this.desc;
	 }

	/*
	 * Gets the precision
	 * 
	 * @return the precision of the initial param
	 */
	 public function getPrecision():Number{
		 return this.precision;
	 }	 

	/*
	 * Gets the value
	 * 
	 * @return the value of the initial param, if the arrayVal is defined this is returned
	 * else the numVal is returned
	 */
	 public function getVal():Object{
		if (arrVal) {
			return arrVal;
		}else{
			return numVal;
		}
	 }
	 
	/*
	 * Gets the minimum value
	 * 
	 * @return the minimum value of the initial param
	 */
	 public function getMinVal():Number{
		 return this.minVal;
	 }
	 
	/*
	 * Gets the maximum value
	 * 
	 * @return the maximum value of the initial param
	 */
	 public function getMaxVal():Number{
		 return this.maxVal;
	 }
	 
	/*
	 * Sets the id
	 * 
	 * @param the id of the initial param
	 */
	 public function setId(id:String):Void{
		 this.id = id;
	 }
	 
	/*
	 * Sets the literal
	 * 
	 * @param the literal of the initial param
	 */
	 public function setLiteral(literal:String):Void{
		 this.literal = literal;
	 }
	 
	/*
	 * Sets the description
	 * 
	 * @param the description of the initial param
	 */
	 public function setDesc(desc:String):Void{
		 this.desc = desc;
	 }
	 
	/*
	 * Sets the precision
	 * 
	 * @param the precision of the initial param
	 */
	 public function setPrecision(precision:Number):Void{
		 this.precision = precision;
	 }
	 
	/*
	 * Sets the value
	 * 
	 * @param the value of the initial param as a string, if it is an array
	 * its values should be split by the ":" delimiter
	 */
	 public function setVal(val:String):Void{
		if (val=="empty"){
			this.arrVal = new Array();
		}else if (val.indexOf(":") != -1){
			this.arrVal = val.split(":");
		}else{
			this.numVal = Number(val);
		}
	 }

	/*
	 * Sets the array value of an init param
	 * 
	 * @param the value of the initial param as an array
	 */
	 public function setArrVal(arrVal:Array):Void{
		this.arrVal = arrVal;
	 }

	/*
	 * Sets the minimum value
	 * 
	 * @param the minimum value of the initial param
	 */
	 public function setMinVal(minVal:Number):Void{
		 this.minVal = minVal;
	 }
	 
	/*
	 * Sets the maximum value
	 * 
	 * @param the maximum value of the initial param
	 */
	 public function setMaxVal(maxVal:Number):Void{
		 this.maxVal = maxVal;
	 }
}