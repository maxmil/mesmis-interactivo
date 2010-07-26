import core.controller.Nav;
import core.util.Utils;
import core.lang.Messages;
import lindissima.UserSession;
import lindissima.model.InitParams;
import lindissima.model.InitParamCollection;
import lindissima.utils.LTxtFormats;
import ascb.util.logging.LogManager;
import ascb.util.logging.Logger;

/*
 * The entry point to the application. Entry should be via the
 * static main function
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class lindissima.LindApp {
	
	//aplication logger
	public static var logger:Logger = Logger.getLogger("lindissima.LindApp");
	
	//singleton instance
	private static var instance:LindApp;
	
	//paths
	private var messagesPath:String;
	private var initParamsPath:String;
	
	//navegator
	private var nav:Nav;
	
	//locale
	private var locale:String;
	
	//messages
	private var msgs:Messages;
	
	//user session
	private var usrSession:UserSession;
	
	//initial parameters
	private var initParamCol:InitParamCollection;
	
	//text formats
	private var txtFormats:LTxtFormats;

	//force compilation of custom formatter which is not in class path
	private static var _importCustomFormatter:Object = core.util.CustomFormatter["a"]();
	
	//boolean flag that denotes whether or not the log has been initialized
	private static var logInit;
	
	//boolean flag that denotes whether or not the app has been initialized
	private static var appInit;
	
	/*
	 * Constructor 
	 */
	public function LindApp(){
		
		//init text formats
		txtFormats = new LTxtFormats();
		
		//create navegator
		nav = new Nav(_root);
		
		//add activities
		addActivities();
		
		//create user session
		usrSession = new UserSession();
		
		//initialize init params collection
		initParamCol = new InitParamCollection();
		
		//define messages path based on locale
		locale = (_root.locale) ? _root.locale: "es";
		messagesPath = "lindissima/xml/messages_lindissima_" + locale + ".xml";
		initParamsPath = "lindissima/xml/initParams.xml";
		
		//log
		logger.debug("application created");
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getApp():LindApp{
		if (!instance){
			instance = new LindApp();
			return instance;
		}else{
			return instance;
		}
	}
	
	/*
	 * Called from timeline to begin the aplication, starts by initializing the log
	 */
	public static function main():Void{

		if(!_root.pauseApp){
			if (!LogManager.getLogManager().getIsInit()){
				initLog();
			}else{
				beginApp();
			}
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
		
		//add activities to navegator
		this.nav.addActivity(lindissima.activity.Init, "init", {initType:initType});
		this.nav.addActivity(lindissima.activity.MenuPrincipal, "menuPrin", {_x:0, _y:137});
		this.nav.addActivity(lindissima.activity.CornModel, "cornModel", {_x:5, _y:137}, "blind");
		this.nav.addActivity(lindissima.activity.LakeModel, "lakeModel", {_x:5, _y:137}, "blind");
		this.nav.addActivity(lindissima.activity.CornShrubModel, "cornShrubModel", {_x:5, _y:137}, "blind");
	}
	
	/*
	 * Loads the messages
	 */
	public static function loadMessages(callBackFunc:Function){
		getApp().msgs = new Messages(callBackFunc);
		getApp().msgs.load(LindApp.getApp().messagesPath);
	}
	
	/*
	 * Loads the initial parameters
	 */
	public static function loadInitParams(callBackFunc:Function){
		var ips:InitParams = new InitParams(callBackFunc);
		getApp().initParamCol.addInitParams(ips, "initial_ips");
		getApp().initParamCol.selectInitParams("initial_ips");
		ips.load(getApp().initParamsPath);
	}
	
	/*
	 * Gets the navegator for the singleton instance
	 */
	public static function getNav():Nav{
		return getApp().nav;
	}
	
	/*
	 * Gets the initial parameter collection for the singleton instance
	 */
	public static function getInitParamCol():InitParamCollection{
		return getApp().initParamCol;
	}
	
	/*
	 * Selects the initial parameters with the id specified within the initial parameters of the instance
	 * 
	 * @param id the id of the initial parameters to select
	 */
	public static function selInitParams(id:String):Void{
		getApp().initParamCol.selectInitParams(id);
	}
	
	/*
	 * Gets the user session
	 */
	public static function getUserSession():UserSession{
		return getApp().usrSession;
	}
	
	/*
	 * Gets a text format
	 *
	 * @param the variable name of the text format
	 */
	public static function getTxtFormat(varName:String){
		return getApp().txtFormats[varName];
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
	
	/*
	 * Brings down curtain and removes all visible content
	 */
	public static function endApp():Void{
		
		var blinds = _root.attachMovie("introMc", "blinds", _root.getNextHighestDepth());
		
	}
	
}
