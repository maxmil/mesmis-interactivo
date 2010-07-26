import core.util.Utils;
import core.comp.EmergingText;
import core.comp.BubbleBtn;
import core.comp.RainingText;
import core.comp.TrailingText;
import core.util.Proxy;
import lindissima.LindApp;
import ascb.util.logging.Logger;

/*
 * Startup presentation
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class lindissima.activity.Init extends core.util.GenericMovieClip{
	
	//logger
	public static var logger:Logger = Logger.getLogger("lindissima.activity.Init");
	
	//the current step
	private var currStep:Number;
	private var stepPartsDone:Number;
	
	//default text formats
	private var titleTxtFormat:TextFormat;
	private var bigTxtFormat:TextFormat;
	private var medTxtFormat:TextFormat;
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
	
	/*
	 * Constructor
	 */
	public function Init() {
		
		logger.debug("Instantiating Init");
		
		switch (initType){
			case "minimal":
				doMinimalInit();
			break;
			case "presentation":
				doPresInit();
			break
			default:
				doFullInit();
			break
		}
	}
	
	/*
	 * Initializes the text formats
	 */
	private function initTxtFormats():Void{
		
		titleTxtFormat = new TextFormat();
		titleTxtFormat.font = "Arial";
		titleTxtFormat.color = 0xffffff;
		titleTxtFormat.size = 24;
		
		bigTxtFormat = new TextFormat();
		bigTxtFormat.font = "Arial";
		bigTxtFormat.color = 0x33ff99;
		bigTxtFormat.size = 20;
		bigTxtFormat.align = "center";
		
		medTxtFormat = new TextFormat();
		medTxtFormat.font = "Arial";
		medTxtFormat.color = 0x66ccff;
		medTxtFormat.size = 16;
		medTxtFormat.align = "center";
		
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
		
		//create function load initparams
		var loadInitParams:Function = function(){
			LindApp.loadInitParams(Proxy.create(LindApp.getNav(), LindApp.getNav().getNext, 3));
		}
		
		//load messages
		LindApp.loadMessages(Proxy.create(this, loadInitParams, 2));		
	}
	
	/*
	 * Presentation initialization, loads messages and input params and moves step 7 to
	 * initiate presntation
	 * 
	 * Should be used when presentation is not needed and all data is
	 * on local machine
	 */
	private function doPresInit():Void{
		
		//create function load initparams
		var loadInitParams:Function = function(){
			
			//create function add blind
			var fnc:Function = function(){
				
				//attach curtain
				this.attachMovie("introMc", "curtain", 1);
				
				//define blindsClosed function which is called by the intro movie when the blinds
				//have closed
				this.currStep = 6;
				this["blindsClosed"] = Proxy.create(this, this.nextStep);
			}
			
			LindApp.loadInitParams(Proxy.create(this, fnc));
		}
		
		//init text formats
		initTxtFormats();
		
		//load messages
		LindApp.loadMessages(Proxy.create(this, loadInitParams, 2));		
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
		loadLangString = (_root.loadLangString) ? _root.loadLangString : "CARGANDO TEXTOS...";
		
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
			case 3:
				stepsReq = 2;
				break;
			case 6:
				stepsReq = 4;
				break;
			case 11:
				stepsReq = 6;
				break;
			default:	
				stepsReq = 0;
				break;
		}
		stepPartsDone++;
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
		this.attachMovie("introMc", "curtain", 1);
		
		//define blindsClosed function which is called by the intro movie when the blinds
		//have closed
		this["blindsClosed"] = Proxy.create(this, this.nextStep);
		
		
		//currStep = 12;
	}
	
	/*
	 * Step 2 Load language
	 */
	private function step2():Void{

		//define call back function
		var fnc:Function = function(){
			this["loadLang"].startWait();
			this.stepPartDone(2);
		}
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "loadLang", this.getNextHighestDepth(), {txt:loadLangString, initX:-200, initY:398, finX:400, txtCol:0xff9933, onComplete:Proxy.create(this, fnc), _order:"reverse"}));
		
		//load messages
		LindApp.loadMessages(Proxy.create(this, stepPartDone, 2));
	}
	
	/*
	 * Step 2 Load data
	 */
	private function step3():Void{

		//define call back function
		var fnc:Function = function(){
			this["loadData"].startWait();
			this.stepPartDone(3);
		}
		
		//box previous raining text and move out of the way
		this["loadLang"].showBox();
		this["loadLang"].glideTo(0,-20, 10);
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "loadData", this.getNextHighestDepth(), {txt:LindApp.getMsg("init.loadData"), initX:960, initY:398, finX:400, txtCol:0x0066ff, onComplete:Proxy.create(this, fnc), _order:"normal"}));

		//load initial parameters
		LindApp.loadInitParams(Proxy.create(this, stepPartDone, 3));
	}
	
	/*
	 * Step 4 Initialize global variables
	 */
	private function step4():Void{
		
		//box previous raining text and move out of the way
		this["loadLang"].glideTo(0,-40, 10);
		this["loadData"].showBox();
		this["loadData"].glideTo(0,-20, 10);
		

		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "initGlobals", this.getNextHighestDepth(), {txt:LindApp.getMsg("init.initializeGlobals"), initX:-300, initY:398, finX:400, txtCol:0xff6633, onComplete:Proxy.create(this, nextStep), _order:"reverse"}));
		
	}		
	
	/*
	 * Step 5 Initialize activities
	 */
	private function step5():Void{
		
		//box previous raining text and move out of the way
		this["loadLang"].glideTo(0,-60, 10);
		this["loadData"].glideTo(0,-40, 10);
		this["initGlobals"].showBox();
		this["initGlobals"].glideTo(0,-20, 10);
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "initActivities", this.getNextHighestDepth(), {txt:LindApp.getMsg("init.initializeActivities"), initX:960, initY:398, finX:400, txtCol:0x33ff99, onComplete:Proxy.create(this, nextStep), _order:"normal"}));
		
	}
	
	/*
	 * Step 6 Clear initializations
	 */
	private function step6():Void{
		this["loadLang"].glideTo(-400, -380, 10, Proxy.create(this, this.stepPartDone, 6));
		this["loadData"].glideTo(560-this["loadData"]._width, -380, 10, Proxy.create(this, this.stepPartDone, 6));
		this["initGlobals"].glideTo(-400, 320, 10, Proxy.create(this, this.stepPartDone, 6));
		this["initActivities"].showBox();
		this["initActivities"].glideTo(560-this["initActivities"]._width, 320, 10, Proxy.create(this, this.stepPartDone, 6));	}
	
	/*
	 * Step 7 Show fist half of title
	 */
	private function step7():Void{
		
		//remove initializations
		this["loadLang"].alphaTo(0, 30, this["loadLang"], Proxy.create(this["loadLang"], this["loadLang"].removeMovieClip));
		this["loadData"].alphaTo(0, 30, this["loadData"], Proxy.create(this["loadData"], this["loadData"].removeMovieClip));
		this["initGlobals"].alphaTo(0, 30, this["initGlobals"], Proxy.create(this["initGlobals"], this["initGlobals"].removeMovieClip));
		this["initActivities"].alphaTo(0, 30, this["initActivities"], Proxy.create(this["initActivities"], this["initActivities"].removeMovieClip));
		
		//get width of title
		var txt:String = LindApp.getMsg("init.title.1");
		var w:Number = titleTxtFormat.getTextExtent(txt).textFieldWidth*1.2;
		
		//create first half of title
		Utils.newObject(EmergingText, this["curtain"].topBg, "title1", 1, {txt:txt, _x:(960-w)/2, _y:70, txtFormat:titleTxtFormat, bgcolor:0x006600, onComplete:Proxy.create(this, this.nextStep)});
		
		//create skip intro text
		var skipIntro:MovieClip = this["curtain"].bottomBg.createEmptyMovieClip("skipIntro", this["curtain"].bottomBg.getNextHighestDepth());
		Utils.createTextField("txt", skipIntro, 1, 750, 290, 200, 1, LindApp.getMsg("init.skipIntro"), LindApp.getTxtFormat("softTitleTxtFormat"));
		skipIntro.onRelease = Proxy.create(this, getStep, 13);

	}
	
	/*
	 * Step 8 Show second half of title
	 */
	private function step8():Void{
		
		//get width of title
		var txt:String = LindApp.getMsg("init.title.2");
		var w:Number = titleTxtFormat.getTextExtent(txt).textFieldWidth*1.2;
		
		//create second half of title
		Utils.newObject(EmergingText, this["curtain"].topBg, "title2", 2, {txt:txt, _x:(960-w)/2, _y:100, txtFormat:titleTxtFormat, bgcolor:0x006600, onComplete:Proxy.create(this, this.nextStep)});
	}	
	
	/*
	 * Step 9 - Interactive work
	 */
	private function step9():Void{
		var txt:String = LindApp.getMsg("init.interactiveWork");
		var w:Number = bigTxtFormat.getTextExtent(txt).textFieldWidth*1.2;
		var h:Number = bigTxtFormat.getTextExtent(txt).textFieldHeight*1.2;
		Utils.newObject(TrailingText, this["curtain"].topBg, "interactiveWork", 3, {txt:txt, _x:(960-w)/2, _y:400-h, finY:-200, txtFormat:bigTxtFormat, bgCol:0x006600, onComplete:Proxy.create(this, this.nextStep)});
	}
	
	/*
	 * Step 10 - Authors
	 */
	private function step10():Void{
		var txt:String = LindApp.getMsg("init.authors");
		var w:Number = medTxtFormat.getTextExtent(txt).textFieldWidth*1.2;
		var h:Number = medTxtFormat.getTextExtent(txt).textFieldHeight*1.2;
		Utils.newObject(TrailingText, this["curtain"].topBg, "authors", 4, {txt:txt, _x:(960-w)/2, _y:400-h, finY:-100, txtFormat:medTxtFormat, bgCol:0x006600, onComplete:Proxy.create(this, this.nextStep)});
	}
	
	/*
	 * Step 11 - Support
	 */
	private function step11():Void{
		
		var xBase:Number = 450;
		
		//create title
		bigTxtFormat.color = 0xff9933;
		bigTxtFormat.align = "left";
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support", 1, {txt:LindApp.getMsg("init.support"), _x:0, _y:60, finX:xBase-50, txtFormat:bigTxtFormat, bgCol:0x004000});		
		
		//create sub texts
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support1", 2, {txt:LindApp.getMsg("init.support.1"), _x:0, _y:90, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:30});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support2", 3, {txt:LindApp.getMsg("init.support.2"), _x:0, _y:110, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:60});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support3", 4, {txt:LindApp.getMsg("init.support.3"), _x:0, _y:130, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:90});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support4", 5, {txt:LindApp.getMsg("init.support.4"), _x:0, _y:150, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:120});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support5", 6, {txt:LindApp.getMsg("init.support.5"), _x:0, _y:170, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:150});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support6", 7, {txt:LindApp.getMsg("init.support.6"), _x:0, _y:190, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 11), delay:180});
		
		//create images
		this.frameCnt = 0;
		this.onEnterFrame = function(){
			if(this.frameCnt%30==0){
				switch (this.frameCnt/30){
					case 1:
						this["curtain"].bottomBg.attachMovie("logo_cica", "logo_1", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase, _y:220});
						break;
					case 2:
						this["curtain"].bottomBg.attachMovie("logo_cieco", "logo_2", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase+125, _y:220});
						break;
					case 3:
						this["curtain"].bottomBg.attachMovie("logo_conacyt", "logo_3", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase+190, _y:220});
						break;
					case 4:
						this["curtain"].bottomBg.attachMovie("logo_ecosur", "logo_4", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase+255, _y:220});
						break;
					case 5:
						this["curtain"].bottomBg.attachMovie("logo_gira", "logo_5", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase+320, _y:220});
						break;
					case 6:
						this["curtain"].bottomBg.attachMovie("logo_semarnat", "logo_6", this["curtain"].bottomBg.getNextHighestDepth(), {_x:xBase+385, _y:220});
						break;
				}
			}else if (this.frameCnt>180){
				delete this.onEnterFrame;
			}
			this.frameCnt++;
		}
	}
	
	/*
	 * Step 12 - Enter button and agro forestal image
	 */
	private function step12():Void{
		
		//agro forestal image
		var img = this["curtain"].bottomBg.attachMovie("sistAgroFor", "sistAgroFor", this["curtain"].bottomBg.getNextHighestDepth(), {_x:50, _y:60, _alpha:0});
		img.alphaTo(100, 30);
		
		//enter button
		Utils.newObject(BubbleBtn, this["curtain"].bottomBg, "btn_enter", this["curtain"].bottomBg.getNextHighestDepth(), {literal:LindApp.getMsg("btn.enter"), _x:450, _y:5, callBackObj:this, callBackFunc:this.nextStep});
	}
	
	/*
	 * Step 14 - Remove clips and open curtain
	 */
	private function step13():Void{
		
		//remove load texts
		this["loadLang"].removeMovieClip();
		this["loadData"].removeMovieClip();
		this["initGlobals"].removeMovieClip();
		this["initActivities"].removeMovieClip();
		
		//define blindsOpen function which is called by the intro movie when the blinds
		//have been opened
		this.blindsOpen = nextStep;
		
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
		
		//open curtain
		this["curtain"].gotoAndPlay(40);
	}
	
	/*
	 * Step 15 - get next activity
	 */
	private function step14():Void{
		LindApp.getNav().getNext();
	}

}
