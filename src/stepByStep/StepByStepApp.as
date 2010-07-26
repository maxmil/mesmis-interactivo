import ascb.util.logging.LogManager;
import ascb.util.logging.Logger;
import core.controller.Nav;
import core.lang.Messages;
import core.util.Utils;
import stepByStep.model.LoadXML;
import stepByStep.util.MTxtFormats;


/*
 * The entry point to the application. Entry should be via the
 * static main function
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class stepByStep.StepByStepApp {
	
	//aplication logger
	public static var logger:Logger = Logger.getLogger("stepByStep.StepByStepApp");
	
	//singleton instance
	private static var instance:StepByStepApp;
	
	//paths
	private var messagesPath:String;
	private var initParamsPath:String;
	
	//navegator
	private var nav:Nav;
	
	//locale
	private var locale:String;
	
	//messages
	private var msgs:Messages;
	
	//data
	public var subsystems:Array;
	public var comps:Array;
	public var flows:Array;
	public var cps:Array;
	public var criterias:Array;
	public var indicators:Array;
	public var tradeOffLevel:Number;
	
	//text formats
	private var txtFormats:MTxtFormats;

	//force compilation of custom formatter which is not in class path
	private static var _importCustomFormatter:Object = core.util.CustomFormatter["a"]();
	
	//boolean flag that denotes whether or not the log has been initialized
	private static var logInit;
	
	//boolean flag that denotes whether or not the app has been initialized
	private static var appInit;
	
	/*
	 * Constructor 
	 */
	public function StepByStepApp(){
		
		//init text formats
		txtFormats = new MTxtFormats();
		
		//create navegator
		nav = new Nav(_root);
		
		//initialize data arrays
		subsystems = new Array();
		comps = new Array();
		flows = new Array();
		cps = new Array();
		criterias = new Array();
		indicators = new Array();
		tradeOffLevel = 0;
		
		//add activities
		addActivities();
		
		//define messages path based on locale
		locale = (_root.locale) ? _root.locale: "es";
		messagesPath = "stepByStep/xml/messages_stepByStep_" + locale + ".xml";
		
		//initialize trade off level
		tradeOffLevel = 0;
		
		//log
		logger.debug("application created");
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getApp():StepByStepApp{
		if (!instance){
			instance = new StepByStepApp();
			return instance;
		}else{
			return instance;
		}
	}
	
	/*
	 * Called from timeline to begin the aplication, starts by initializing the log
	 */
	public static function main():Void{
		
		if (!LogManager.getLogManager().getIsInit()){
			initLog();
		}else if (!_root.pauseApp){
			beginApp();
		}
	}
	
	/*
	 * Initializes log and begins application
	 */
	public static function initLog():Void{
		var logManager:LogManager = LogManager.getLogManager();
		var listener:Object = new Object();
		listener.initialized = beginApp;
		logManager.addEventListener("initialized", listener);
	}
	
	/*
	 * Gets the current locale
	 */
	public static function getLocale():String{
		return getApp().locale;
	}
	
	/*
	 * Start the application
	 */
	private static function beginApp():Void{
		
		if (!LogManager.getLogManager().getIsInit()){
			initLog();
			return;
		}
		
		//init application
		if (!appInit){
			logger.debug("beginning app");
			getApp().nav.getFirst();
			appInit = true;
		}else{
			logger.debug("app already initialized");
		}
	}
	
	/*
	 * Adds all the activities that form this application
	 * 
	 * @param a navegator object where the activities will be stored
	 */
	public function addActivities():Void{
		logger.debug("adding activities");
		
		//define init type
		var initType:String = (_root.initType) ? _root.initType : "full";
		
		//add activities
		this.nav.addActivity(stepByStep.activity.Init, "init", {initType:initType});
		this.nav.addActivity(stepByStep.activity.MenuPrincipal, "menuPrin", {_x:5, _y:137});
		this.nav.addActivity(stepByStep.activity.characterization.DefineSystem, "defineSystem", {_x:5, _y:137, subsystems:subsystems, comps:comps, flows:flows, cps:cps});
		this.nav.addActivity(stepByStep.activity.characterization.StrengthsAndWeaknesses, "strengthsAndWeaknesses", {_x:5, _y:137, cps:cps});
		this.nav.addActivity(stepByStep.activity.characterization.SelectIndicators, "selectIndicators", {_x:5, _y:137, cps:cps, criterias:criterias, indicators:indicators});
		this.nav.addActivity(stepByStep.activity.integration.DefineAmoebas, "defineAmoebas", {_x:5, _y:137, currStep:0});
		this.nav.addActivity(stepByStep.activity.Conclusions, "conclusions", {_x:5, _y:137});
	}
	
	/*
	 * Loads the messages
	 * 
	 * @param a call back function to be executed when the loading completes
	 */
	public static function loadMessages(callBackFunc:Function):Void{
		logger.debug("loading messages from "+StepByStepApp.getApp().messagesPath);
		getApp().msgs = new Messages(callBackFunc);
		getApp().msgs.load(StepByStepApp.getApp().messagesPath);
	}
	
	/*
	 * Loads auxiliar data
	 * 
	 * @param a call back function to be executed when the loading completes
	 */
	public static function loadData(callBackFunc:Function):Void{
		logger.debug("loading data ");
		var loadXML:LoadXML = new LoadXML();
		var listener:Object = new Object();
		listener.loaded = callBackFunc;
		loadXML.addEventListener("loaded", listener);
		loadXML.load();
	}
	
	/*
	 * Gets the navegator for the singleton instance
	 * 
	 * @return the navigator instance
	 */
	public static function getNav():Nav{
		return getApp().nav;
	}
	
	/*
	 * Gets a text format
	 *
	 * @param the variable name of the text format
	 * 
	 * @return the text format
	 */
	public static function getTxtFormat(varName:String):TextFormat{
		return getApp().txtFormats[varName];
	}
	
	/*
	 * Gets the tradeofflevel for the singleton instance
	 * 
	 * @return the trade of level
	 */
	public static function getTradeOffLevel():Number{
		return getApp().tradeOffLevel;
	}
	
	/*
	 * Sets the tradeofflevel for the singleton instance
	 * 
	 * @param tradeOffLevel the new level to set
	 */
	public static function setTradeOffLevel(tradeOffLevel:Number):Void{
		getApp().tradeOffLevel = tradeOffLevel;
	}
	
	/*
	 * Returns the given message which is stored in an external language file replacing arguments
	 * {0},{1},{2},...etc with the values in the array passed.
	 * 
	 * @param key the messages identifier
	 * @param args the arguments to replace {0},{1},{2}... etc for if they exist in the message
	 * @return the message with the strings {0},{1},{2}... etc replaced by the arguments passed as parameters
	 * 
	 */
	public static function getMsg(key:String, args:Array):String{
	 	var str:String = getApp().msgs[key];
		if (!str){
			return "missing message resource: " + key
		}
		str = Utils.replace(str, "$n", "\n");
		str = Utils.replace(str, "$t", "\t");
		str = Utils.replace(str, "$$", "$");
		if (args){
			for (var i = 0; i<args.length; i++){
				str = Utils.replace(str, "{"+String(i)+"}", args[i]);
			}
		}
		return str;
	}
	
	/*
	 * Checks to see whether a message with the given key exists
	 * 
	 * @param key the message key
	 * @return true if the message exists, false otherwise
	 */
	public static function msgExists(key:String):Boolean{
		return (getApp().msgs[key]) ? true : false;
	}
	
	/*
	 * If the application has been loaded into another movie this
	 * method should be called to free up memory
	 */
	public static function destroy():Void{
		appInit = false;
		instance = null;
	}
	
}
