import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import sussi.SussiApp;
import sussi.model.Relations;
import sussi.utils.SUtils;

/*
 * Relations table component. Allows user to activate and disactivate relations
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-09-2005
 */
 class sussi.comp.RelationsTable extends GenericMovieClip{
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.comp.RelationsTable");

	//relations object
	public var relations:Relations;
	
	//listener variables
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	/*
	 * Constructor
	 */
	public function RelationsTable(){
		
		logger.debug("instantiating RelationsTable");
		
		//initialize event dispatcher
		mx.events.EventDispatcher.initialize(this);
		
		//initialize texts
		this["col1_title"] = SussiApp.getMsg("relationTable.col1_title");
		this["h1h2_title"] = SussiApp.getMsg("relationTable.h1h2_title");
		this["h2h1_title"] = SussiApp.getMsg("relationTable.h2h1_title");
		this["ch1_title"] = SussiApp.getMsg("relationTable.ch1_title");
		this["ch2_title"] = SussiApp.getMsg("relationTable.ch2_title");
		
		//initialize the relations
		updateRelation("h1h2", Relations.COMP_H1H2);
		updateRelation("h2h1", Relations.COMP_H2H1);
		updateRelation("ch1", Relations.CH1);
		updateRelation("ch2", Relations.CH2);
	}
	
	/*
	 * updates a particular relation
	 * 
	 * @param id the relation button movie clip id prefix
	 * @param relation the index of the relation Relations.COMP_H1H2, Relations.COMP_H2H1
	 * Relations.CH1, or Relations.CH2
	 */
	private function updateRelation(id:String, relation:Number):Void{
		
		//get current values in relation object and in diagram
		var relLevel:String = relations.getLevel(relation);
		
		//get corresponding button
		var btn:MovieClip;
		switch (relLevel){
			case Relations.LEVEL_LOW:
				btn = this[id+"_lt"];
			break;
			case Relations.LEVEL_MEDIUM:
				btn = this[id+"_eq"];
			break;
			case Relations.LEVEL_HIGH:
				btn = this[id+"_gt"];
			break;
		}
		
		//move clip to active positon
		btn.gotoAndStop("active")
	}
	
	/*
	 * Selects a relelation. Updates button, relation and dispatches event "relationsChanged"
	 * 
	 * @param mcName the _name of the button clip that represents the relation value
	 */
	public function select(mcName:String):Void{
		
		//get relation and level from button clip name
		var relation:Object;
		var level:String;
		var s1:String = mcName.substring(0, mcName.indexOf("_"));
		var s2:String = mcName.substring(mcName.indexOf("_")+1, mcName.length);
		
		//get relation
		switch (s1){
			case "h1h2":
				relation = relations.getRelation(Relations.COMP_H1H2);
			break;
			case "h2h1":
				relation = relations.getRelation(Relations.COMP_H2H1);
			break;
			case "ch1":
				relation = relations.getRelation(Relations.CH1);
			break;
			case "ch2":
				relation = relations.getRelation(Relations.CH2);
			break;
		}
		
		//get level
		switch (s2){
			case "lt":
				level = "lowValue";
			break;
			case "eq":
				level = "mediumValue";
			break;
			case "gt":
				level = "highValue";
			break;
		}
		
		//set init param
		SUtils.setIP(relation.varName, relation[level]);
		
		//select button
		this[s1+"_lt"].gotoAndStop("desactive");
		this[s1+"_eq"].gotoAndStop("desactive");
		this[s1+"_gt"].gotoAndStop("desactive");
		this[mcName].gotoAndStop("active");
		
		//dipatch event
		dispatchEvent({type:"relationsChanged", target:this});
		
		
	}

}