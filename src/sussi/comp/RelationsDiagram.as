import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.UserMessage;
import sussi.SussiApp;
import sussi.model.Relations;
import sussi.utils.SUtils;

/*
 * Relations diagram component
2 * 
 * @author Max Pimm
 * @version 1.0
 * @created 29-09-2005
 */
 class sussi.comp.RelationsDiagram extends GenericMovieClip{
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.comp.RelationsDiagram");
	
	//relations object
	public var relations:Relations;
	
	//listener variables
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	/*
	 * Constructor
	 */
	public function RelationsDiagram(){
		
		logger.debug("instantiating RelationsDiagram");
		
		//initialize the relations
		updateRelations(false);
		
		//initialze relation rollover description texts
		initRelDescs();
	}
	
	/*
	 * Initializes rollover listeners that show a description (tool tip) text
	 * for each relation
	 */
	public function initRelDescs():Void{

		initRelDesc(this["r_h1"].r_h1_tree_1, SussiApp.getMsg("relationDiag.r_h1_tree_1.description"));
		initRelDesc(this["r_h1"].r_h1_tree_2, SussiApp.getMsg("relationDiag.r_h1_tree_2.description"));
		initRelDesc(this["r_h1"].r_tree_h1, SussiApp.getMsg("relationDiag.r_tree_h1.description"));
		initRelDesc(this["r_h1"].r_bacteria_h1, SussiApp.getMsg("relationDiag.r_bacteria_h1.description"));
		initRelDesc(this["r_h1"].r_intra, SussiApp.getMsg("relationDiag.r_h1_intra.description"));
		initRelDesc(this["r_c"].r_ch1, SussiApp.getMsg("relationDiag.r_c_h1.description"));
		initRelDesc(this["r_c"].r_h1_c, SussiApp.getMsg("relationDiag.r_h1_c.description"));
		initRelDesc(this["r_c"].r_bacteria_c, SussiApp.getMsg("relationDiag.r_bacteria_c.description"));
		initRelDesc(this["r_c"].r_intra, SussiApp.getMsg("relationDiag.r_c_intra.description"));
		initRelDesc(this["r_h2"].r_ch2, SussiApp.getMsg("relationDiag.r_c_h2.description"));
		initRelDesc(this["r_h2"].r_h2_c, SussiApp.getMsg("relationDiag.r_h2_c.description"));
		initRelDesc(this["r_h2"].r_h2h1, SussiApp.getMsg("relationDiag.r_h2_h1.description"));
		initRelDesc(this["r_h2"].r_h1h2, SussiApp.getMsg("relationDiag.r_h1_h2.description"));
		initRelDesc(this["r_h2"].r_h2_tree, SussiApp.getMsg("relationDiag.r_h2_tree.description"));
		initRelDesc(this["r_h2"].r_tree_h2, SussiApp.getMsg("relationDiag.r_tree_h2.description"));
		initRelDesc(this["r_h2"].r_bacteria_h2, SussiApp.getMsg("relationDiag.r_bacteria_h2.description"));
		initRelDesc(this["r_h2"].r_intra, SussiApp.getMsg("relationDiag.r_h2_intra.description"));
	}
	
	/*
	 * Initializes a particular relation description
	 * 
	 * @param mc the movie clip to which the description should be attached
	 * @param desc the description
	 */
	private function initRelDesc(mc:MovieClip, desc:String, initObj:Object):Void{

		//save useful references
		mc.rd = this;
		mc.desc = desc;
		
		//create listeners
		mc.onRollOver = function(){
			var x:Number = Math.min(this.rd._xmouse+10, 350);
			var y:Number = Math.min(this.rd._ymouse+10, 200);
			Utils.newObject(UserMessage, this.rd, "roll_msg", this.rd.getNextHighestDepth(), {_x:x, _y:y, w:150, txt:this.desc, txtFormat:SussiApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
		}
		
		mc.onRollOut = function(){
			this.rd["roll_msg"].removeMovieClip();
		}
	}
	
	/*
	 * Updates the relations between components
	 * 
	 * @param animate when true the arrow width and color is changed by
	 * a tween, when false it is changed instantly
	 */
	public function updateRelations(animate:Boolean):Void{
		
		var h1_present:Boolean = SUtils.getIP("h1_ini")>0;
		var h2_present:Boolean = SUtils.getIP("h2_ini")>0;
		var c_present:Boolean = SUtils.getIP("c_ini")>0;
		
		if (!h2_present){
			this["r_h2"]._visible = false;
		}else{		
			if(h2_present && h1_present){
				updateRelation(this["r_h2"].r_h2h1, Relations.COMP_H1H2, animate);
				updateRelation(this["r_h2"].r_h1h2, Relations.COMP_H2H1, animate);
			}
			
			if(h2_present && c_present){
				updateRelation(this["r_h2"].r_ch2, Relations.CH2, animate);
			}
		}
		
		if (!c_present){
			this["r_c"]._visible = false
		}else{
			if(h1_present && c_present){
				updateRelation(this["r_c"].r_ch1, Relations.CH1, animate);
			}
		}
		
	}
	
	/*
	 * Updates a particular relation
	 * 
	 * @param mc the arrow movie clip
	 * @param relation the index of the relation Relations.COMP_H1H2, Relations.COMP_H2H1
	 * Relations.CH1, or Relations.CH2
	 * @param animate when true the arrow width and color is changed by
	 * a tween, when false it is changed instantly
	 */
	private function updateRelation(mc:MovieClip, relation:Number, animate:Boolean):Void{
		
		//check that relation is active
		if (!relations.getRelation(relation).active){
			return;
		}
		
		//get current values in relation object and in diagram
		var relLevel:String = relations.getLevel(relation);
		var diagLevel:String = getDiagLevel(mc);
		
		//if not the same then update
		if(relLevel != diagLevel){
			if(animate && diagLevel != null){
				mc.gotoAndPlay(diagLevel+"_to_"+relLevel);
			}else{
				mc.gotoAndStop(relLevel);
			}
		}
	}
	
	
	/*
	 * Gets the level of the relation from the diagram arrow
	 * 
	 * @param mc an instance of an arrow
	 * 
	 * @param string containing the level
	 */
	private function getDiagLevel(mc:MovieClip):String{
		
		switch (Number(mc._currentframe)){
			case 2:
				return sussi.model.Relations.LEVEL_LOW;
			break;
			case 3:
				return sussi.model.Relations.LEVEL_MEDIUM;
			break;
			case 4:
				return sussi.model.Relations.LEVEL_HIGH;
			break;
		}
		
		return null;
	}
}