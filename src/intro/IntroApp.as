import core.controller.Nav;
import core.util.Utils;
import core.lang.Messages;
import intro.UserSession;
import intro.utils.IntroTxtFormats;
import ascb.util.logging.LogManager;
import ascb.util.logging.Logger;
import flash.external.ExternalInterface;

/*
 * The entry point to the application Sussi. Entry should be via the
 * static main function
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-10-2005
 */
class intro.IntroApp {
	
	//aplication logger
	public static var logger:Logger = Logger.getLogger("intro.IntroApp");
	
	//singleton instance
	private static var instance:IntroApp;
	
	//paths
	private var messagesPath:String;
	
	//navegator
	private var nav:Nav;
	
	//locale
	private var locale:String;
	
	//messages
	private var msgs:Messages;
	
	//user session
	private var usrSession:UserSession;
	
	//text formats
	private var txtFormats:IntroTxtFormats;

	//force compilation of custom formatter which is not in class path
	private static var _importCustomFormatter:Object = core.util.CustomFormatter["a"]();
	
	//boolean flag that denotes whether or not the log has been initialized
	private static var logInit;
	
	//boolean flag that denotes whether or not the app has been initialized
	private static var appInit;
	
	/*
	 * Constructor 
	 */
	public function IntroApp(){
		
		//init text formats
		txtFormats = new IntroTxtFormats();

		//create navegator
		nav = new Nav(_root);

		//add activities
		addActivities();

		//create user session
		usrSession = new UserSession();

		//define messages path based on locale
		if(!_root.locale){
			_root.locale = "es";
		}
		locale = _root.locale;
		messagesPath = "intro/xml/messages_intro_" + locale + ".xml";
		
		//log
		logger.debug("application created");
	}
	
	/*
	 * Access to the singleton instance
	 * 
	 * @return the singleton instance
	 */
	public static function getApp():IntroApp{
		if (!instance){
			instance = new IntroApp();
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
	 * Gets the current locale
	 */
	public static function getLocale():String{
		return getApp().locale;
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
		this.nav.addActivity(intro.activity.Init, "init", {initType:initType});
		this.nav.addActivity(intro.activity.MenuPrincipal, "menuPrin", {_x:5, _y:137});
	}
	
	/*
	 * Loads the messages
	 */
	public static function loadMessages(callBackFunc:Function){
		logger.debug("loading messages from path: " + IntroApp.getApp().messagesPath);
		getApp().msgs = new Messages(callBackFunc);
		getApp().msgs.load(IntroApp.getApp().messagesPath);
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
	 * Closes the projector, which quits the application
	 */
	public static function quitApp():Void{
		if(_root.isStandAlone){
			fscommand("quit");
		}else{
			ExternalInterface.call("closeApp");
		}
	}
	
	/*
	 * If the application has been loaded into another movie this
	 * method should be called to free up memory
	 */
	public static function destroy():Void{
		instance = null;
	}
	
}
