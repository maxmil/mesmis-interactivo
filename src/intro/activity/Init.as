import core.util.Utils;
import core.comp.RainingText;
import core.util.Proxy;
import intro.IntroApp;
import ascb.util.logging.Logger;


/*
 * Startup presentation
 * 
 * @autor Max Pimm
 * @created 12-10-2005
 * @version 1.0
 */
class intro.activity.Init extends core.util.GenericMovieClip{
	
	//logger
	public static var logger:Logger = Logger.getLogger("intro.activity.Init");
	
	//the current step
	private var currStep:Number;
	private var stepPartsDone:Number;
	
	//default title text format
	private var titleTxtFormat:TextFormat;
	private var bigTxtFormat:TextFormat;
	private var smallTxtFormat:TextFormat;
	
	//functions
	public var blindsClosed:Function;
	public var blindsOpen:Function;
	
	//animation utils
	private var frameCnt:Number;
	
	//type of initialization, valid values are "full", "presentation", "minimal"
	private var initType:String;
	
	//language loading text, all other texts are included in language file
	private var loadLangString:String;
	
	//force compilation of photoGrid
	private static var _importPhotoGrid:Object = intro.comp.MesmisPhotoGrid["a"]();
	
	/*
	 * Constructor
	 */
	public function Init() {
		
		logger.debug("Instantiating Init, init type = " + initType);
		
		switch (initType){
			case "minimal":
				doMinimalInit();
			break;
			default:
				doFullInit();
			break
		}
	}
	
	/*
	 * Initializes the text formats
	 */
	private function initTxtFormats():Void{
		
		smallTxtFormat = new TextFormat();
		smallTxtFormat.font = "Arial bold";
		smallTxtFormat.color = 0xff6633;
		smallTxtFormat.size = 12;
	}
	
	/*
	 * Minimal initialization, loads messages and input params and moves to next
	 * activity without rendering any graphics.
	 * 
	 * Should be used for quick access when presentation is not needed and all data is
	 * on local machine
	 */
	private function doMinimalInit():Void{
		
		var fnc:Function = function(){
			
			//attach photo grid
			this.attachMovie("photoGrid", "photoGrid", this.getNextHighestDepth());
	
			//create skip intro text
			var skipIntro:MovieClip = this.createEmptyMovieClip("skipIntro", this.getNextHighestDepth());
			Utils.createTextField("txt", skipIntro, 1, 750, 690, 200, 1, IntroApp.getMsg("photoGrid.skipIntro"), IntroApp.getTxtFormat("softTitleTxtFormat"));
			skipIntro.onRelease = function(){
				this._parent.photoGrid.destroy();
				IntroApp.getNav().getNext();
			}
		}
		
		//load messages and when done add the intro clip
		IntroApp.loadMessages(Proxy.create(this, fnc));	
	}
	
	/*
	 * Full initialization, goes through all steps
	 * 
	 * Should be used when all data is not on local machine. For example if the
	 * application is being accessed via the Internet
	 */
	private function doFullInit():Void{
		
		//init text formats
		initTxtFormats();
		
		//get language loading text
		switch(InitApp.getLocale()){
			case "es":
				loadLangString = "CARGANDO TEXTOS";
			break;
			default:
				loadLangString = "LOADING TEXTS";
			break;
		}
		
		//init curr step and get first step
		currStep = 0;
		nextStep();		
	}
	
	/*
	 * Triggered while step is being carried out, contains
	 * a counter of all required sub parts of step. When all
	 * have been completed the next step is called
	 * 
	 * @param step the parent step number
	 */
	public function stepPartDone(step:Number):Void{
		
		var stepsReq:Number;
		
		switch (step){
			case 2:
				stepsReq = 1;
				break;
			default:	
				stepsReq = 1;
				break;
		}
		stepPartsDone++;
		
		logger.debug("step part done - stepPartsDone: " + stepPartsDone + ", stepsReq = " + stepsReq);
		
		if(stepPartsDone == stepsReq){
			currStep = step;
			nextStep();
		}
	}
	
	/*
	 * Gets next step
	 */
	public function nextStep(){
		
		currStep++;
		stepPartsDone = 0;
		this["step"+String(currStep)]();
	}
	
	/*
	 * Goes to a particular step
	 * 
	 * @param step
	 */
	public function getStep(step:Number){
		
		currStep = step;
		stepPartsDone = 0;
		this["step"+String(currStep)]();
	}
	
	
	/*
	 * Step 1 Close blinds
	 */
	private function step1():Void{

		//attach curtain
		this.attachMovie("introMc", "curtain", 3);
		
		//define blindsClosed function which is called by the intro movie when the blinds
		//have closed
		this["blindsClosed"] = Proxy.create(this, this.nextStep);
	}
	
	/*
	 * Step 2 Load language
	 */
	private function step2():Void{

		//define call back function
		var fnc:Function = function(){
			this["loadLang"].startWait();
			//this.stepPartDone(2);
		}
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "loadLang", this.getNextHighestDepth(), {txt:loadLangString, speed:5, initX:-200, initY:398, finX:400, txtCol:0xff9933, onComplete:Proxy.create(this, fnc), _order:"reverse"}));
		
		//load messages
		IntroApp.loadMessages(Proxy.create(this, stepPartDone, 2));
	}
	
	/*
	 * Step 14 - Remove clips and open curtain
	 */
	private function step3():Void{
		
		//remove load texts
		this["loadLang"].removeMovieClip();
		
		//remove clips so that curtain opens easily
		for (var prop in this["curtain"].bottomBg){
			if (typeof this["curtain"].bottomBg[prop] == "movieclip"){
				this["curtain"].bottomBg[prop].removeMovieClip();
			}
		}
		for (var prop in this["curtain"].topBg){
			if (typeof this["curtain"].topBg[prop] == "movieclip"){
				this["curtain"].topBg[prop].removeMovieClip();
			}
		}
		
		//attach photo grid behind curtain
		this.attachMovie("photoGrid", "photoGrid", 1);
	
		//create skip intro text
		var skipIntro:MovieClip = this.createEmptyMovieClip("skipIntro", 2);
		Utils.createTextField("txt", skipIntro, 1, 750, 690, 200, 1, IntroApp.getMsg("photoGrid.skipIntro"), IntroApp.getTxtFormat("softTitleTxtFormat"));
		skipIntro.onRelease = function(){
			this._parent.photoGrid.destroy();
			IntroApp.getNav().getNext();
		}
		
		//create fullscreen text
		if(!_root.isStandAlone){
			var fullScreen:MovieClip = this.createEmptyMovieClip("fullScreen", 3);
			Utils.createTextField("txt", fullScreen, 1, 0, 690, 200, 1, IntroApp.getMsg("btn.goFullScreen") + " >", IntroApp.getTxtFormat("softTitleTxtFormat"));
			fullScreen.onRelease = function(){
				Stage.displayState = "fullscreen";
			}
		}
		
		//open curtain
		this["curtain"].gotoAndPlay(40);
	}
	
	/*
	 * Step 15 - get next activity
	 */
	private function step4():Void{
		IntroApp.getNav().getNext();
	}
}
