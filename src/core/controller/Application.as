import core.controller.Nav;
import core.util.Utils;
import core.lang.Messages;
//import lindissima.UserSession;
//import lindissima.model.InitParams;
//import lindissima.model.InitParamCollection;
//import lindissima.utils.LTxtFormats;
import ascb.util.logging.LogManager;
import ascb.util.logging.Logger;

/*
 * Superclass defining an application. Each application should extend this class
 * and the main entry to the application should be via the static main method
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class core.controller.Application {
	
	//aplication logger
	private static var logger:Logger = Logger.getLogger("core.controller.Application");
	
	//singleton instance
	private static var instance:Application;
	
	//paths
	private var messagesPath:String;
	private var initParamsPath:String;
	
	//navegator
	private var nav:Nav;
	
	//messages
	private var msgs:Messages;
	
	//user session
	//private var usrSession:UserSession;
//	
	////text formats
	//private var txtFormats:LTxtFormats;

	//force compilation of custom formatter which is not in class path
	private static var _importCustomFormatter:Object = core.util.CustomFormatter["a"]();
	
	//boolean flag that denotes whether or not the log has been initialized
	private static var logInit;
	
	//boolean flag that denotes whether or not the app has been initialized
	private static var appInit;
	
	/*
	 * Constructor 
	 */
	public function Application(){
		
		//init text formats
		//this.txtFormats = new LTxtFormats();
		
		//create navegator
		nav = new Nav();
		
		//add activities
		addActivities();
		
		//create user session
		//this.usrSession = new UserSession();
		
		//define paths
		messagesPath = (_root.messagesPath) ? _root.messagesPath : "lindissima/xml/messages_lindissima.xml";
		initParamsPath = (_root.initParamsPath) ? _root.initParamsPath : "lindissima/xml/initParams.xml";
	}
	
	/*
	 * Access to the singleton instance should be overwritten by subclasses to call
	 * their specific constructors
	 * 
	 * @return the singleton instance
	 */
	public static function getApp():Application{
		logger.debug("getting Application")
		if (!instance){
			instance = new Application();
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
		listener.initialized = beginApp
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
			getApp().nav.getFirst();
			appInit = true;
			logger.debug("beginning application");
		}else{
			logger.debug("application already begun");
		}
	}
	
	/*
	 * Adds activities, should be overwritten by subclass
	 * 
	 * @param a navegator object where the activities will be stored
	 */
	public function addActivities():Void{
	}
	
	/*
	 * Loads the messages
	 */
	public static function loadMessages(callBackFunc:Function){
		logger.debug("loading messages");
		getApp().msgs = new Messages(callBackFunc);
		getApp().msgs.load(getApp().messagesPath);
	}
	
	/*
	 * Gets the navegator for the singleton instance
	 */
	public static function getNav():Nav{
		return getApp().nav;
	}
	
	/*
	 * Gets the user session
	 */
	//public static function getUserSession():UserSession{
		//return getApp().usrSession;
	//}
	
	/*
	 * Gets a text format
	 *
	 * @param the variable name of the text format
	 */
	//public static function getTxtFormat(varName:String){
		//return getApp().txtFormats[varName];
	//}
	
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
		logger.debug("destroying application");
		instance = null;
	}
	
}
