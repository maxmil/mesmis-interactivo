import ascb.util.logging.Logger;
import core.controller.Activity;
import core.util.Utils;
import core.util.Proxy;


/*
 * Navegation handler
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class core.controller.Nav{
	
	//define logger
	private static var logger:Logger = Logger.getLogger("core.controller.Nav");
	
	//define activities
	public var activities:Array;
	private var currActivity_mc:Object;
	private var currActivity_ind:Number;
	private var activityDepth:Number;
	private var maskDepth:Number;
	private var blindDepth:Number;
	
	//appRoot clip for the aplication
	private var appRoot:MovieClip;
	
	/*
	 * Constructor
	 * 
	 * @param appRoot the root clip for the application
	 */
	public function Nav(appRoot:MovieClip) {
		
		this.appRoot = appRoot;		
		this.activities = new Array();
		this.activityDepth = 1;
		this.blindDepth = 3;		
	}
	
	/*
	 * Adds an activity to the array of activites
	 */
	public function addActivity(constructor:Function, id:String, initObj:Object, _type:String):Void {
		var newActiv:Activity = new Activity(constructor, id, initObj, _type);
		this.activities[this.activities.length] = newActiv;
	}
	
	/*
	 * Loads an activity by its id
	 * 
	 * @param id the id of the activity to load
	 */
	public function getActivity(id:String):Void {
		var found:Boolean = false;
		var i:Number = 0;
		var l:Number = this.activities.length;
		
		//find activity by id
		while (!found && i<l) {
			if (this.activities[i].getId() == id) {
				this.currActivity_ind = i;
				found = true;
			}
			i++;
		}
		
		//if found then load activity
		if(found){
			beginLoadActivity();
		}
	}
	
	/*
	 * Gets the next activity
	 */
	public function getNext():Void{
		
		if (this.currActivity_ind<this.activities.length-1) {
			
			//get new activity
			this.currActivity_ind++;
			
			//load new activity
			beginLoadActivity();
		}
	}
	
	/*
	 * Gets the previous activity
	 */
	public function getPrevious():Void{
		
		if (this.currActivity_ind>0) {
			
			//get new activity
			this.currActivity_ind--;
			
			//load new activity
			beginLoadActivity();
		}
	}
	
	/*
	 * Gets the first activity
	 */
	public function getFirst(){
		
		//get new activity
		this.currActivity_ind = 0;
			
		//load new activity
		beginLoadActivity();
	}
	
	/*
	 * Returns the current activity movie clip
	 * 
	 * @return the current activity
	 */
	public function getCurrActivity_mc():Object {
		return this.currActivity_mc;
	}
	
	/*
	 * Returns the current activity id
	 * 
	 * @return the current activity id
	 */
	public function getCurrActivity_id():String {
		return activities[this.currActivity_ind].getId();
	}
	
	/*
	 * begins loading an acitivity
	 */
	private function beginLoadActivity():Void{
		
		if (activities[this.currActivity_ind].get_type() == "blind"){
			appRoot.attachMovie("introMc", "blinds", this.blindDepth);
			appRoot.blindsClosed = Proxy.create(this, loadActivity, true)
			appRoot.blindsOpen = Proxy.create(appRoot.blinds, appRoot.blinds.removeMovieClip);
			
		}else{
			loadActivity();
		}
	}
	
	/*
	 * Unloads the current activity and the loads a new one
	 * 
	 * @param whether to open the blinds after loading the activity
	 */
	private function loadActivity(openBlinds:Boolean):Void{
		
		logger.debug("loading activity "+ activities[this.currActivity_ind].getId())
		
		//get new activity
		var newActiv:Activity = activities[this.currActivity_ind];
		
		if (newActiv) {
			//remove old activity
			this.currActivity_mc.removeMovieClip();
			//create new activity_mc
			this.currActivity_mc = Utils.newObject(newActiv.getConstructor(), appRoot, newActiv.getId(), activityDepth, newActiv.getInitObj());
		}
		
		//reopen blinds
		if(openBlinds){
			appRoot.blinds.gotoAndPlay(40);
		}
	}
}
