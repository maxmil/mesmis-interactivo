import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.EmergingText;
import core.comp.BubbleBtn;
import core.comp.RainingText;
import core.comp.TrailingText;
import core.util.Proxy;
import stepByStep.StepByStepApp;
import ascb.util.logging.Logger;

/*
 * Startup presentation
 * 
 * @autor Max Pimm
 * @created 14-09-2005
 * @version 1.0
 */
class stepByStep.activity.Init extends core.util.GenericMovieClip{
	
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.activity.Init");
	
	//the current step
	private var currStep:Number;
	private var stepPartsDone:Number;
	
	//text formats
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
		
		logger.debug("Instantiating Init, init type = " + initType);
		
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
		
		//attach background
		_root.attachMovie("stepByStep_bg", "bg", 0, {txtTitle:StepByStepApp.getMsg("general.txtTitle")});
		
		//load messages, on load start load data, on finished loading data get next step
		StepByStepApp.loadMessages(Proxy.create(null, StepByStepApp.loadData, Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getNext)));		
	}
	
	/*
	 * Presentation initialization, loads messages and input params and moves step 7 to
	 * initiate presntation
	 * 
	 * Should be used when presentation is not needed and all data is
	 * on local machine
	 */
	private function doPresInit():Void{
		
		//create function that attaches blinds and goes to step 7
		var fnc:Function = function(){
			
			//set title now that messages are loaded
			_root.cdMesmis_bg.titleTxt = StepByStepApp.getMsg("general.mesmisTitle");
			
			//attach curtain
			this.attachMovie("introMc", "curtain", 1);
			
			//define blindsClosed function which is called by the intro movie when the blinds
			//have closed
			this.currStep = 4;
			this["blindsClosed"] = Proxy.create(this, this.nextStep);
		}
		
		//init text formats
		initTxtFormats();
		
		//load messages, on load start load data, on finished loading data calls func
		StepByStepApp.loadMessages(Proxy.create(null, StepByStepApp.loadData, Proxy.create(this, fnc)));	
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
		switch(StepByStepApp.getLocale()){
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
			case 8:
				stepsReq = 2;
				break;
			case 9:
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
	 * Close blinds
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
	 * Load language
	 */
	private function step2():Void{

		//define call back function
		var fnc:Function = function(){
			this["loadLang"].startWait();
		}
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "loadLang", this.getNextHighestDepth(), {txt:loadLangString, initX:-200, initY:400, finX:400, txtCol:0xff9933, onComplete:Proxy.create(this, fnc), _order:"reverse"}));
		
		//load messages
		StepByStepApp.loadMessages(Proxy.create(this, nextStep));
	}
	
	/*
	 * Load data
	 */
	private function step3():Void{

		//define call back function
		var fnc:Function = function(){
			this["loadData"].startWait();
		}
		
		//box previous raining text and move out of the way
		this["loadLang"].showBox();
		this["loadLang"].glideTo(0,-20, 10);
		
		//create raining text
		var rt:RainingText = RainingText(Utils.newObject(core.comp.RainingText, this, "loadData", this.getNextHighestDepth(), {txt:StepByStepApp.getMsg("init.loadData"), initX:960, initY:400, finX:400, txtCol:0x0066ff, onComplete:Proxy.create(this, fnc), _order:"normal"}));

		//load initial parameters
		StepByStepApp.loadData(Proxy.create(this, nextStep));
	}
	
	/*
	 * Clear initializations
	 */
	private function step4():Void{
		this["loadLang"].glideTo(-400, -380, 10);
		this["loadData"].showBox();
		this["loadData"].glideTo(560-this["loadData"]._width, -380, 10);
		nextStep();
	}
	
	/*
	 * Show title
	 */
	private function step5():Void{
		
		//remove initializations
		this["loadLang"].alphaTo(0, 30, this["loadLang"], Proxy.create(this["loadLang"], this["loadLang"].removeMovieClip));
		this["loadData"].alphaTo(0, 30, this["loadData"], Proxy.create(this["loadData"], this["loadData"].removeMovieClip));
				
		//create title and center
		var txt:String = StepByStepApp.getMsg("init.title");
		var title1:EmergingText = Utils.newObject(EmergingText, this["curtain"].topBg, "title1", 1, {txt:txt, _y:70, txtFormat:titleTxtFormat, bgcolor:0x006600, onComplete:Proxy.create(this, this.nextStep)});
		title1._x = (960-title1.totalWidth)/2;
		
		//create skip intro text
		var skipIntro:MovieClip = this["curtain"].bottomBg.createEmptyMovieClip("skipIntro", this["curtain"].bottomBg.getNextHighestDepth());
		Utils.createTextField("txt", skipIntro, 1, 750, 290, 200, 1, StepByStepApp.getMsg("init.skipIntro"), StepByStepApp.getTxtFormat("softTitleTxtFormat"));
		skipIntro.onRelease = Proxy.create(this, getStep, 12);
	}
	
	/*
	 * Show description
	 */
	private function step6():Void{
		var txt:String = StepByStepApp.getMsg("init.description");
		var desc:TrailingText = Utils.newObject(TrailingText, this["curtain"].topBg, "description", 3, {txt:txt, _y:380, finY:-200, txtFormat:bigTxtFormat, bgCol:0x006600, onComplete:Proxy.create(this, this.nextStep)});
		desc._x = (960-desc.totalW)/2;
	}

	
	/*
	 * Set delay
	 */
	private function step7():Void{
		
		this["stepInterval"] = setInterval(Proxy.create(this, this.nextStep), 200);
	}

	
	/*
	 * Authors
	 */
	private function step8():Void{
		
		//remove interval
		clearInterval(this["stepInterval"]);
		
		var txt:String;
		var w:Number;
		var h:Number;
		var mc:GenericMovieClip;
		
		//create text1 and glide in from left
		txt = StepByStepApp.getMsg("init.authors1");
		mc = Utils.newObject(GenericMovieClip, this["curtain"].topBg, "desccription1", this["curtain"].topBg.getNextHighestDepth(), {_y:300});
		Utils.createTextField("tf", mc, 1, 0, 0, 960, 1, txt, medTxtFormat)
		mc._x = -mc._width;
		mc.glideTo((960-mc._width)/2, mc._y, 5, Proxy.create(this, this.stepPartDone, 8));
		
		//create text2 and glide in from right
		txt = StepByStepApp.getMsg("init.authors2");
		mc = Utils.newObject(GenericMovieClip, this["curtain"].topBg, "desccription1", this["curtain"].topBg.getNextHighestDepth(), {_y:320});
		Utils.createTextField("tf", mc, 1, 0, 0, 960, 1, txt, medTxtFormat)
		mc._x = 960 + mc._width;
		mc.glideTo((960-mc._width)/2, mc._y, 5, Proxy.create(this, this.stepPartDone, 8));
	}
	
	/*
	 * Support
	 */
	private function step9():Void{
		
		var xBase:Number = 450;
		
		//create title
		bigTxtFormat.color = 0xff9933;
		bigTxtFormat.align = "left";
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support", 1, {txt:StepByStepApp.getMsg("init.support"), _x:0, _y:60, finX:xBase-50, txtFormat:bigTxtFormat, bgCol:0x004000});		
		
		//create sub texts
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support1", 2, {txt:StepByStepApp.getMsg("init.support.1"), _x:0, _y:90, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:20});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support2", 3, {txt:StepByStepApp.getMsg("init.support.2"), _x:0, _y:110, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:40});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support3", 4, {txt:StepByStepApp.getMsg("init.support.3"), _x:0, _y:130, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:60});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support4", 5, {txt:StepByStepApp.getMsg("init.support.4"), _x:0, _y:150, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:80});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support5", 6, {txt:StepByStepApp.getMsg("init.support.5"), _x:0, _y:170, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:100});
		Utils.newObject(TrailingText, this["curtain"].bottomBg, "support6", 7, {txt:StepByStepApp.getMsg("init.support.6"), _x:0, _y:190, finX:xBase, txtFormat:smallTxtFormat, bgCol:0x004000, onComplete:Proxy.create(this, stepPartDone, 9), delay:120});
		
		//create images
		this.frameCnt = 0;
		this.onEnterFrame = function(){
			if(this.frameCnt%20==0){
				switch (this.frameCnt/20){
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
	 * Enter button and image
	 */
	private function step10():Void{
		
		//image
		var img = this["curtain"].bottomBg.attachMovie("photo_intro", "img", this["curtain"].bottomBg.getNextHighestDepth(), {_x:30, _y:65, _alpha:0});
		img.alphaTo(100, 30);
		
		//enter button
		Utils.newObject(BubbleBtn, this["curtain"].bottomBg, "btn_enter", this["curtain"].bottomBg.getNextHighestDepth(), {literal:StepByStepApp.getMsg("btn.enter"), _x:450, _y:5, callBackObj:this, callBackFunc:this.nextStep});
	}
	
	/*
	 * Close blinds
	 */
	private function step11():Void{
		
		//attach background
		_root.attachMovie("stepByStep_bg", "bg", 0, {txtTitle:StepByStepApp.getMsg("general.txtTitle")});
		
		//remove load texts
		this["loadLang"].removeMovieClip();
		this["loadData"].removeMovieClip();
		
		//clear interval if exists
		clearInterval(this["stepInterval"]);
		
		//define blindsOpen function which is called by the intro movie when the blinds
		//have been opened
		this.blindsOpen = Proxy.create(this, this.nextStep);
		
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
	 * Get next activity
	 */
	private function step12():Void{
		StepByStepApp.getNav().getNext();
	}

}
