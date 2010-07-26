import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.EyeBtn;
import core.comp.TextPane;
import core.comp.UserMessage;
import lindissima.LindApp;

/*
 * Prinpal menu for lindissima
 * 
 * @autor Max Pimm
 * @created 05-09-2005
 * @version 1.0
 */
class lindissima.activity.MenuPrincipal extends lindissima.activity.LindActivity{
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.MenuPrincipal");
	
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
		titleTxtFormat.size = 22;
		titleTxtFormat.color = 0xD0CC86;
		titleTxtFormat.align = "center";
		welcomeTxtFormat = new TextFormat();
		welcomeTxtFormat.font = "Arial bold";
		welcomeTxtFormat.size = 12;
		welcomeTxtFormat.color = 0xffffff;
		
		//if movie has been loaded into parent then creat exit objects
		exitObj =  _root.exitObj;
		exitFunc = _root.exitFunc;
		
		var mask:MovieClip = this.createEmptyMovieClip("actMask", this.getNextHighestDepth());
		mask.beginFill(0x000000, 100);
		mask.moveTo(0, -137)
		mask.lineTo(960, -137);
		mask.lineTo(960, 583);
		mask.lineTo(0, 583);
		mask.lineTo(0, -137);
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
			
			if(this.frameCnt%15 == 0 && this["activateSteps"]){
			
				switch(this.frameCnt/15){
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
						Utils.createTextField("title_tf", titleMc, 1, 20, 70, 430, 300, LindApp.getMsg("menuPrin.title"), this.titleTxtFormat);
						titleMc.alphaTo(100, 30);
					break;
					case 2:
						//create amoeba
						this.attachMovie("mp_menu_amoeba", "amoeba", this.getNextHighestDepth(), {_x:-50, _y:250});
					break;
					case 4:
						//create first button
						this.drawButton("btn1", "cornModel", LindApp.getMsg("menuPrin.btn1.txt"), 145, 235, 40, 0, 80);
						this["btn1"].alphaTo(100, 30);
					break;
					case 5:
						//create second button
						this.drawButton("btn2", "lakeModel", LindApp.getMsg("menuPrin.btn2.txt"), 270, 305, 40, 0, 85);
						this["btn2"].alphaTo(100, 30);
					break;
					case 6:
						//create third button
						this.drawButton("btn3", "cornShrubModel", LindApp.getMsg("menuPrin.btn3.txt"), 310, 445, 40, 0, 90);
						this["btn3"].alphaTo(100, 30);
					break;
					case 7:

						//create navegation buttons container
						var btns = this.createEmptyMovieClip("btns", this.getNextHighestDepth());
						btns._y = 550;
						
						//create exit button if defined
						if(this.exitObj && this.exitFunc){
							this.createEyeBtn("btn_exit", LindApp.getMsg("btn.exit"), this.exitObj, this.exitFunc);
						}
						
						//create start first act button
						var getFirstAct:Function = function(){
							LindApp.getNav().getActivity("cornModel");
						}
						this.createEyeBtn("btnFirstAct", LindApp.getMsg("btn.gotoAct1"), this, getFirstAct);
						
						//create credits button
						var openCredits:Function = function(){
							if(this.credits){
								this.credits.removeMovieClip();
							}
							Utils.newObject(UserMessage, this, "credits", this.getNextHighestDepth(), {_x:250, _y:150, w:500, txt:LindApp.getMsg("menuPrin.credits.txt"), titleTxt:LindApp.getMsg("menuPrin.credits.title"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:LindApp.getTxtFormat("defaultTitleTxtFormat")});
						}
						this.createEyeBtn("btnCredits", LindApp.getMsg("btn.credits"), this, openCredits);

						//create text pane
						var tp:TextPane = TextPane(Utils.newObject(TextPane, this, "tp", this.getNextHighestDepth(), {_x:480, _y:120, w:470, h:420, titleTxt:LindApp.getMsg("menuPrin.preface.title"), allowDrag:true}));
						Utils.createTextField("tf", tp.getContent(), 1, 0, 0, 450, 1000, LindApp.getMsg("menuPrin.preface.txt"), LindApp.getTxtFormat("defaultTxtFormat"));
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
		var mc = this.createEmptyMovieClip("welcomeTxt", this.getNextHighestDepth());
		mc._x = -450;
		mc._y = 40;
		
		//define metrics
		var txt:String = LindApp.getMsg("menuPrin.welcome");
		var w:Number = 90;
		var h:Number = 18;
		
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
		
		//draw text
		Utils.createTextField("tf", mc, 1, 455-w, -h/2, w+20, h, txt, welcomeTxtFormat);
		
		//animate
		mc.glideTo(0, mc._y, 10);
	}
	
	/*
	 * Creates a button
	 * 
	 * @param id the id of the button clip
	 * @param activityId the id of the activity to get when clicked
	 * @param txt the text for the button
	 * @param xMc the x coordinate of the button clip
	 * @param yMc the y coordinate of the button clip
	 * @param xTxt the x coordinate of the text field
	 * @param yTxt the y coordinate of the text field
	 * @param wTxt the width of the text, necessary to avoid using getTextExtent
	 */
	private function drawButton(id:String, activityId:String, txt:String, xMc:Number, yMc:Number, xTxt:Number, yTxt:Number, wTxt:Number):Void{
				
		//create button clip
		var btnMc = this.createEmptyMovieClip(id, this.getNextHighestDepth());
		btnMc._x = xMc;
		btnMc._y = yMc;
		btnMc._alpha = 0;
		btnMc.activityId = activityId;
		
		//create default layer
		var defaultMc = btnMc.createEmptyMovieClip("default", 1);
		defaultMc.attachMovie("eye_button", "eye", 1,{_xscale:200, _yscale:200});
		btnTxtFormat.color = 0x009966;
		Utils.createTextField("btnTxt", defaultMc, 2, xTxt, yTxt, wTxt, 1, txt, btnTxtFormat);
		
		//create rollover layer
		var rollMc = btnMc.createEmptyMovieClip("roll", 2);
		rollMc._alpha = 0;
		rollMc.attachMovie("eye_button_over", "eye", 1,{_xscale:200, _yscale:200});
		btnTxtFormat.color = 0xff6600;
		Utils.createTextField("btnTxt", rollMc, 2, xTxt, yTxt, wTxt, 1, txt, btnTxtFormat);
		
		//create events
		btnMc.onRollOver = function(){
			this.roll.alphaTo(100, 20);
		}
		btnMc.onRollOut = function(){
			this.roll.alphaTo(0, 20);
		}
		btnMc.onRelease = function(){
			LindApp.getNav().getActivity(this.activityId);
		}
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
