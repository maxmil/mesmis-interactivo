import sussi.utils.SUtils;

/*
 * Container for objects representing unidirrectional relations between species. 
 * 4 relations exist:
 *  (i) Between h1 and h2
 * 	(ii) Between h2 and h1
 * 	(iii) Between c and h1
 * 	(iv) Between c and h2
 * 
 * Each relation has properties:
 * 	varName: represents the initial parameter corresponding to the property
 * 	lowValue: the low value of the relation
 * 	middleValue: the middle value of the relation
 * 	highValue: the high value of the relation
 *  active: a boolean flag
 * 
 * @author Max Pimm
 * @created 29-09-2005
 * @version 1.0
 */
 class sussi.model.Relations {
	
	//internal array object that stores the 4 relations
	private var relations:Array;
	
	//constants to describe the relations
	public static var COMP_H1H2:Number = 0;
	public static var COMP_H2H1:Number = 1;
	public static var CH1:Number = 2;
	public static var CH2:Number = 3;
	public static var LEVEL_LOW:String = "low";
	public static var LEVEL_MEDIUM:String = "medium";
	public static var LEVEL_HIGH:String = "high";	
	
	/*
	 * Constructor
	 */
	public function Relations(){
		
		relations = new Array(5);
		
		//create relations
		initRel(COMP_H1H2, "comp_h1h2", "ap_rel_h1h2");
		initRel(COMP_H2H1, "comp_h2h1", "ap_rel_h2h1");
		initRel(CH1, "dh1_carn", "ap_rel_ch1");
		initRel(CH2, "dh2_carn", "ap_rel_ch2");
	}
	
	/*
	 * Initializes a relation
	 * 
	 * @param i the index of the relation
	 * @param the name of the initial parameter that the relation represents
	 * @param the name of the initial parameter array with the low, medium and high values in
	 */
	private function initRel(i:Number, varName:String, arrayVarName:String):Void{
		
		//sussi.SussiApp.logger.debug(SUtils.getIPArray(arrayVarName, 0))
		
		var relation:Object = new Object();
		relation.varName = varName;
		relation.lowValue = SUtils.getIPArray(arrayVarName)[0];
		relation.mediumValue = SUtils.getIPArray(arrayVarName)[1];
		relation.highValue = SUtils.getIPArray(arrayVarName)[2];
		relation.active = false;
		relations[i] = relation;
	}
	
	/*
	 * Gets a relation
	 * 
	 * @param i the index of the relation, the static variables COMP_H1H2, COMP_H2H1, CH1 and CH2
	 * should be used
	 */
	public function getRelation(i:Number):Object{
		return this.relations[i]
	}
	
	/*
	 * Gets the current level of a relation
	 * 
	 * @param i the index of the relation, the static variables COMP_H1H2, COMP_H2H1, CH1 and CH2
	 * 
	 * @return string corresponding to LEVEL_LOW, LEVEL_MEDIUM, or LEVEL_HIGH
	 */
	public function getLevel(i:Number):String{
		
		var relation:Object = relations[i];
		
		var currVal:Number = SUtils.getIP(relation.varName);

		switch (String(currVal)){
			case String(relation.lowValue):
				return LEVEL_LOW;
				break;
			case String(relation.mediumValue):
				return LEVEL_MEDIUM;
				break;
			case String(relation.highValue):
				return LEVEL_HIGH;
				break;
		}
		
		return null;
	}
	
	/*
	 * Sets the property of a relation
	 * 
	 * @param i the index of the relation, the static variables COMP_H1H2, COMP_H2H1, CH1 and CH2
	 * @param prop the name of the property to set
	 * @parm val the new value of the property
	 */
	public function setRelationProp(i:Number, prop:String, val:Object):Void{
		this.relations[i][prop] = val;
	}
}