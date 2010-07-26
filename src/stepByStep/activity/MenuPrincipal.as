import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.util.Proxy;
import core.comp.EyeBtn;
import core.comp.TextPane;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;

/*
 * Prinpal menu for stepByStep
 * 
 * @autor Max Pimm
 * @created 05-09-2005
 * @version 1.0
 */
class stepByStep.activity.MenuPrincipal extends stepByStep.activity.StepByStepActivity{
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.MenuPrincipal");
	
	//text formats
	private var btnTxtFormat:TextFormat;
	private var titleTxtFormat:TextFormat;
	private var welcomeTxtFormat:TextFormat;
	
	//animation utils
	private var frameCnt:Number;
	
	//exit objects
	private var exitObj:Object;
	private var exitFunc:Function;
	
	/*
	 * Constructor
	 */
	public function MenuPrincipal() {
		
		super();
		
		logger.debug("Instantiating MenuPrincipal");
		
		//init text formats
		btnTxtFormat = new TextFormat();
		btnTxtFormat.font = "Arial bold";
		btnTxtFormat.size = 18;
		titleTxtFormat = new TextFormat();
		titleTxtFormat.font = "Arial bold";
		titleTxtFormat.size = 26;
		titleTxtFormat.color = 0xD0CC86;
		titleTxtFormat.align = "center";
		welcomeTxtFormat = new TextFormat();
		welcomeTxtFormat.font = "Arial bold";
		welcomeTxtFormat.align = "center";
		welcomeTxtFormat.size = 12;
		welcomeTxtFormat.color = 0xffffff;
		
		//if movie has been loaded into parent then creat exit objects
		exitObj =  _root.exitObj;
		exitFunc = _root.exitFunc;
		
		//create mask
		var mask:MovieClip = this.createEmptyMovieClip("actMask", this.getNextHighestDepth());
		mask.beginFill(0x000000, 100);
		mask.moveTo(-5, -137)
		mask.lineTo(955, -137);
		mask.lineTo(955, 583);
		mask.lineTo(-5, 583);
		mask.lineTo(-5, -137);
		mask.endFill();
		this.setMask(mask);
		
		beginAnimation();

	}

	/*
	 * Creates an animated sequence of initializing components
	 */
	public function beginAnimation():Void{
		
		this.frameCnt = 0;
		this.onEnterFrame = function(){
			
			if(this.frameCnt%30 == 0 && this["activateSteps"]){
			
				switch(this.frameCnt/30){
					case 0:		
						//create welcome text
						this.createWelcomeText();
						
						//create slides
						var slides = this.attachMovie("mp_slides", "slides", this.getNextHighestDepth(), {_x:960, _y:20, _width:470, _height:90});
						slides.glideTo(480, slides._y, 10);
					break;
					case 1:
						//create title
						var titleMc = this.createEmptyMovieClip("titleMc", this.getNextHighestDepth());
						titleMc._alpha = 0;
						Utils.createTextField("title_tf", titleMc, 1, 20, 70, 430, 300, StepByStepApp.getMsg("menuPrin.title"), this.titleTxtFormat);
						titleMc.alphaTo(100, 30);
					break;
					case 2:
						//create step menu
						var mc:GenericMovieClip = this.attachMovie("mp_step_menu", "step_menu", this.getNextHighestDepth(), {_x:20, _y:180, _alpha:0});
						mc.alphaTo(100, 10);
						
						//define button texts
						mc.txtStep1 = StepByStepApp.getMsg("menuPrin.btn1.txt");
						mc.txtStep1a = StepByStepApp.getMsg("menuPrin.btn1a.txt");
						mc.txtStep2 = StepByStepApp.getMsg("menuPrin.btn2.txt");
						mc.txtStep3 = StepByStepApp.getMsg("menuPrin.btn3.txt");
						mc.txtStep4 = StepByStepApp.getMsg("menuPrin.btn4.txt");
						mc.txtStep5 = StepByStepApp.getMsg("menuPrin.btn5.txt");
						mc.txtStep6 = StepByStepApp.getMsg("menuPrin.btn6.txt");
						
						//define button actions
						mc.btn_1.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "defineSystem");
						mc.btn_1a.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "defineSystem");
						mc.btn_2.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "strengthsAndWeaknesses");
						mc.btn_3.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "selectIndicators");
						mc.btn_4.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "selectIndicators");
						mc.btn_5.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "defineAmoebas");
						mc.btn_6.onRelease = Proxy.create(StepByStepApp.getNav(), StepByStepApp.getNav().getActivity, "conclusions");
						
					break;
					case 3:

						//create navegation buttons container
						var btns = this.createEmptyMovieClip("btns", this.getNextHighestDepth());
						btns._y = 550;
						
						//create goto first step button
						var fnc:Function = function(){
							this.app.getNav().getActivity("defineSystem");
						}
						this.createEyeBtn("btn_gotoStep1", StepByStepApp.getMsg("btn.gotoStep1"), this, fnc);
						
						//create exit button if defined
						if(this.exitObj && this.exitFunc){
							this.createEyeBtn("btn_exit", StepByStepApp.getMsg("btn.exit"), this.exitObj, this.exitFunc);
						}
						
						//create credits button
						var openCredits:Function = function(){
							if(this.credits){
								this.credits.removeMovieClip();
							}
							Utils.newObject(UserMessage, this, "credits", this.getNextHighestDepth(), {_x:250, _y:150, w:500, txt:StepByStepApp.getMsg("menuPrin.credits.txt"), titleTxt:StepByStepApp.getMsg("menuPrin.credits.title"), txtFormat:StepByStepApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat")});
						}
						this.createEyeBtn("btnCredits", StepByStepApp.getMsg("btn.credits"), this, openCredits);

						//create text pane
						var tp:TextPane = TextPane(Utils.newObject(TextPane, this, "tp", this.getNextHighestDepth(), {_x:480, _y:120, w:470, h:420, titleTxt:StepByStepApp.getMsg("menuPrin.preface.title"), allowDrag:true}));
						Utils.createTextField("tf", tp.getContent(), 1, 0, 0, 450, 1000, StepByStepApp.getMsg("menuPrin.preface.txt"), StepByStepApp.getTxtFormat("defaultTxtFormat"));
						tp.init(true);
						
						//stop animation
						delete this.onEnterFrame;
					break;
				}
			}
			this.frameCnt++;
		}
		
	}
	
	
	/*
	 * Creates and animates the welcome text
	 */
	private function createWelcomeText():Void{
		
		//create container clip
		var mc:MovieClip = this.createEmptyMovieClip("welcomeTxt", this.getNextHighestDepth());
		mc._x = -450;
		mc._y = 40;
		
		//draw text
		var txt:String = StepByStepApp.getMsg("menuPrin.welcome");
		Utils.createTextField("tf", mc, 2, 0, 0, 100, 1, txt, welcomeTxtFormat);
		var w:Number = mc["tf"]._width;
		var h:Number = mc["tf"]._height;
		mc["tf"]._x = 455 - w;
		mc["tf"]._y = - h/2;
		
		//draw bg
		mc.lineStyle(1, 0x996633, 100);
		mc.beginFill(0xff9900, 100);
		mc.lineTo(450-w, 0);
		mc.lineTo(450-w, -h/2);
		mc.lineTo(450, -h/2);
		mc.lineTo(450, h/2);
		mc.lineTo(450-w, h/2);
		mc.lineTo(450-w, 0);
		mc.endFill();
		
		//animate
		mc.glideTo(0, mc._y, 10);
	}
	
	/*
	 * Creates any eye button
	 * 
	 * @param id the id of the button clip
	 * @param literal the text literal to display on the button
	 * @param callBackObj the call back object
	 * @param callBackFunc the call back function
	 * @param desactiviate when true the button is disactivated
	 */
	public function createEyeBtn(id:String, literal:String, callBackObj:Object, callBackFunc:Function, desactivate:Boolean):Void{
		var xcoord:Number = 950 - this["btns"]._width;
		var btn:EyeBtn = Utils.newObject(EyeBtn, this["btns"], id, this["btns"].getNextHighestDepth(), {literal:literal, callBackObj:callBackObj, callBackFunc:callBackFunc, active:!desactivate});
		btn._x = (xcoord==950) ? xcoord-btn._width : xcoord-btn._width-10;
	}

}
