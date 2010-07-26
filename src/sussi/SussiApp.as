import core.controller.Nav;
import core.util.Utils;
import core.lang.Messages;
import sussi.UserSession;
import sussi.model.InitParams;
import sussi.model.InitParamCollection;
import sussi.utils.STxtFormats;
import ascb.util.logging.LogManager;
import ascb.util.logging.Logger;

/*
 * The entry point to the application Sussi. Entry should be via the
 * static main function
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
class sussi.SussiApp {
	
	//aplication logger
	public static var logger:Logger = Logger.getLogger("sussi.SussiApp");
	
	//singleton instance
	private static var instance:SussiApp;
	
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
	private var txtFormats:STxtFormats;

	//force compilation of custom formatter which is not in class path
	private static var _importCustomFormatter:Object = core.util.CustomFormatter["a"]();
	
	//boolean flag that denotes whether or not the log has been initialized
	private static var logInit;
	
	//boolean flag that denotes whether or not the app has been initialized
	private static var appInit;
	
	/*
	 * Constructor 
	 */
	public function SussiApp(){
		
		//init text formats
		txtFormats = new STxtFormats();

		//create navegator
		nav = new Nav(_root);

		//add activities
		addActivities();

		//create user session
		usrSession = new UserSession();

		//initialize init params collection
		initParamCol = new InitParamCollection();

		//define paths based on locale
		locale = (_root.locale) ? _root.locale: "es";
		messagesPath = "sussi/xml/messages_sussi_" + locale + ".xml";
		initParamsPath = "sussi/xml/initParams_sussi.xml";
		
		//log
		logger.debug("application created");
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getApp():SussiApp{
		if (!instance){
			instance = new SussiApp();
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
		this.nav.addActivity(sussi.activity.Init, "init", {initType:initType});
		this.nav.addActivity(sussi.activity.PopulationEvolution, "popEvolution", {_x:5, _y:137});
		this.nav.addActivity(sussi.test.util.TestActivity, "testActivity", {_x:5, _y:137});
	}
	
	/*
	 * Loads the messages
	 */
	public static function loadMessages(callBackFunc:Function){
		logger.debug("loading messages from path: " + SussiApp.getApp().messagesPath);
		getApp().msgs = new Messages(callBackFunc);
		getApp().msgs.load(SussiApp.getApp().messagesPath);
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
	
}
