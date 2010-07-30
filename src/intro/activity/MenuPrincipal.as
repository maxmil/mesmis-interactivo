import ascb.util.logging.Logger;
import core.comp.EyeBtn;
import core.comp.RainingText;
import core.comp.UserMessage;
import core.util.Utils;
import core.util.Proxy;
import core.util.GenericMovieClip;
import intro.IntroApp;
import intro.Const;
import intro.comp.MesmisMovieLoader;

/*
 * Lindissima activity based on corn model where the only available variable for the user
 * is the level of fertilizer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class intro.activity.MenuPrincipal extends core.controller.GenericActivity{
	 
	 //logger
	public static var logger:Logger = Logger.getLogger("intro.activity.MenuPrincipal");
	
	//animation utils
	private var frameCnt:Number;

	//movie loader
	private var mml:MesmisMovieLoader;
	
	//clip to use for preloading movies
	private var preloadClip;
	
	//clip for all other activity components
	private var contentClip;
	
	/*
	 * Constructor
	 */
	public function MenuPrincipal() {
		
		//call super class constructor
		super();

		//log
		logger.debug("Instantiating MenuPrincipal");
		
		//attach background if not present
		if (!_root.main_bg){
		
			//attach background
			_root.attachMovie("main_bg", "main_bg", 0, {txtTitle:IntroApp.getMsg("general.txtTitle"), txtSubtitle:IntroApp.getMsg("general.txtSubtitle")});
			
			// add fullscreen button
			var btnFs = this["bg"].attachMovie("btn_full_screen", "btn_fs", this["bg"].getNextHighestDepth());
			btnFs._x = 930;
			btnFs._y = -24;
			btnFs.activity = this;
			btnFs.txt = (Stage.displayState == "fullScreen") ? IntroApp.getMsg("btn.leaveFullScreen") : IntroApp.getMsg("btn.goFullScreen");
			btnFs.onRollOver = function(){
				var w:Number = 120;
				IntroApp.getTxtFormat("smallTxtFormat").align = "center";
				Utils.newObject(UserMessage, this.activity, "roll_msg", this.activity.getNextHighestDepth(), {w:w, txt:this.txt, txtFormat:IntroApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
				IntroApp.getTxtFormat("smallTxtFormat").align = "left";
				this.activity["roll_msg"]._x = this._x+this._width-this.activity["roll_msg"]._width;
				this.activity["roll_msg"]._y = this._y+15;
			}
			btnFs.onRollOut = function(){
				this.activity["roll_msg"].removeMovieClip();
			}
			btnFs.onRelease = function(){
				if(Stage.displayState != "fullScreen"){
					Stage.displayState = "fullScreen";
					this.txt = IntroApp.getMsg("btn.leaveFullScreen");
				}else{
					Stage.displayState = "normal";
					this.txt = IntroApp.getMsg("btn.goFullScreen");
				}
			}
		}
		
		//initialize the content clip
		contentClip = this.createEmptyMovieClip("contentClip", getNextHighestDepth());
		
		//initialize the movie loader
		preloadClip = this.createEmptyMovieClip("preloadClip", getNextHighestDepth());
		mml = new MesmisMovieLoader(preloadClip);
		mml.addSubMovie(Const.MOVIE_MESMIS_PROJECT, "PresMESMIS_" + _root.locale + ".swf");
		mml.addSubMovie(Const.MOVIE_MESMIS_STEP_BY_STEP, "cdStepByStep.swf");
		mml.addSubMovie(Const.MOVIE_LINDISSIMA, "cdLindissima.swf");
		mml.addSubMovie(Const.MOVIE_SUSSI, "cdSussi.swf");

		//begin animations
		beginAnimation();
	}

	/*
	 * Creates an animated sequence of initializing components
	 */
	public function beginAnimation():Void{
		
		this.frameCnt = 0;
		this.onEnterFrame = function(){
			
			if(this.frameCnt%10 == 0){
			
				switch(this.frameCnt/10){
					case 1:		
						//create title text underline
						var tu:GenericMovieClip = this.contentClip.createEmptyMovieClip("tu", this.contentClip.getNextHighestDepth());
						tu.lineStyle(2, IntroApp.getTxtFormat("titleTxtFormat").color, 100);
						tu.lineTo(900, 0);
						tu._x = 30;
						tu._y = 0;
						tu.glideTo(30, 50, 5);
						
						//create containing clip
						var cont:GenericMovieClip = this.contentClip.createEmptyMovieClip("titleCont", this.contentClip.getNextHighestDepth());
						cont._x = 30;
						cont._y = 0;
						
						//create mask for title
						var mask:GenericMovieClip = this.contentClip.createEmptyMovieClip("mask", 2);
						mask.beginFill(0x000000, 100);
						mask.lineTo(900, 0);
						mask.lineTo(900, 50);
						mask.lineTo(0, 50);
						mask.lineTo(0, 0);
						mask.endFill();
						cont.setMask(mask);
					
						//create title as raining text
						Utils.newObject(RainingText, cont, "title", 1, {txt:IntroApp.getMsg("menuPrin.title"), initY:-20, finY:50, txtFormat:IntroApp.getTxtFormat("titleTxtFormat"), _order:"normal", bgCol:0xffffff});
					break;
					case 4:
						//create amoeba
						this.contentClip.attachMovie("amoeba", "amoeba", this.contentClip.getNextHighestDepth(), {_x:550, _y:180});
					break;
					case 6:
						//create intro text
						this.createTxtField("txtIntro", this.contentClip, this.contentClip.getNextHighestDepth(), 30, 60, 900, 10, IntroApp.getMsg("menuPrin.intro"));
					break;
					case 7:
						//create intro text 2
						this.createTxtField("txtIntro2", this.contentClip, this.contentClip.getNextHighestDepth(), 30, this.contentClip["txtIntro"]._y+this.contentClip["txtIntro"]._height+10, 600, 10, IntroApp.getMsg("menuPrin.intro2"));
					break;
					case 8:
						//create mesmis project text
						this.createTxtField("txtMesmisProject", this.contentClip, this.contentClip.getNextHighestDepth(), 30, this.contentClip["txtIntro2"]._y+this.contentClip["txtIntro2"]._height+10, 600, 10, IntroApp.getMsg("menuPrin.mesmisProject.desc"));

						//create button mesmis project
						this.drawButton("btn1", Const.MOVIE_MESMIS_PROJECT, IntroApp.getMsg("menuPrin.mesmisProject.btn"), 840, 240, -30, -45, 100);
						this.contentClip["btn1"].alphaTo(100, 30);
					break;
					case 9:
						//create step by step mesmis text
						this.createTxtField("txtStepByStepMesmis", this.contentClip, this.contentClip.getNextHighestDepth(), 30, this.contentClip["txtMesmisProject"]._y+this.contentClip["txtMesmisProject"]._height+10, 600, 10, IntroApp.getMsg("menuPrin.stepByStepMesmis.desc"));

						//create button step by step mesmis
						this.drawButton("btn2", Const.MOVIE_MESMIS_STEP_BY_STEP, IntroApp.getMsg("menuPrin.stepByStepMesmis.btn"), 695, 265, -60, -45, 165);
						this.contentClip["btn2"].alphaTo(100, 30);
					break;
					case 10:
						//create sussi text
						this.createTxtField("txtSussi", this.contentClip, this.contentClip.getNextHighestDepth(), 30, this.contentClip["txtStepByStepMesmis"]._y+this.contentClip["txtStepByStepMesmis"]._height+10, 400, 10, IntroApp.getMsg("menuPrin.sussi.desc"));

						//create button sussi
						this.drawButton("btn3", Const.MOVIE_SUSSI, IntroApp.getMsg("menuPrin.sussi.btn"), 610, 380, -150, -30, 175);
						this.contentClip["btn3"].alphaTo(100, 30);
					break;
					case 11:
						//create lindissima text
						this.createTxtField("txtLindissima", this.contentClip, this.contentClip.getNextHighestDepth(), 30, this.contentClip["txtSussi"]._y+this.contentClip["txtSussi"]._height+10, 400, 10, IntroApp.getMsg("menuPrin.lindissima.desc"));

						//create button lindissima
						this.drawButton("btn4", Const.MOVIE_LINDISSIMA, IntroApp.getMsg("menuPrin.lindissima.btn"), 635, 525, -200, -30, 215);
						this.contentClip["btn4"].alphaTo(100, 30);
					break;
					case 13:
						//create function to open credits window
						var openCredits:Function = function(){

							//if already open then remove and recreate
							if(this.contentClip.credits){
								this.contentClip.credits.removeMovieClip();
							}
							
							var credits:UserMessage = Utils.newObject(UserMessage, this.contentClip, "credits", this.contentClip.getNextHighestDepth(), {_x:230, _y:100, w:500, txt:IntroApp.getMsg("menuPrin.credits.txt"), titleTxt:IntroApp.getMsg("menuPrin.credits.title"), txtFormat:IntroApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:IntroApp.getTxtFormat("defaultTitleTxtFormat")});
							this.contentClip.tweenIn(credits);

							//create user message of 500 pixels height sin text
							//var credits:UserMessage = Utils.newObject(UserMessage, this, "credits", this.getNextHighestDepth(), {_x:250, _y:50, w:500, h:500, txt:"", titleTxt:IntroApp.getMsg("menuPrin.credits.title"), txtFormat:IntroApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:IntroApp.getTxtFormat("defaultTitleTxtFormat")});
//
							//add scroll
							//var sc:Scroll = Utils.newObject(Scroll, credits, "sc", credits.getNextHighestDepth(), {_x:5, _y:30, w:490, h:460});
							//var cont:GenericMovieClip = sc.getContentClip();
//
							//cont.createTextField("tf", cont.getNextHighestDepth(), 0, 0, 490, 100);
							//cont["tf"].html = true;
							//cont["tf"].htmlText = IntroApp.getMsg("menuPrin.credits.txt");
							//cont["tf"].autoSize = true;
							//cont["tf"].wordWrap = true;
							//cont["tf"].selectable = false;
							//sc.init();

						}
						//create credits button
						var credits_btn:EyeBtn = Utils.newObject(EyeBtn, this.contentClip, "btn_credits", this.contentClip.getNextHighestDepth(), {_x:30, _y:550, literal:IntroApp.getMsg("btn.credits"), callBackObj:this, callBackFunc:openCredits, active:true});
						credits_btn._alpha = 0;
						credits_btn.alphaTo(100, 10);
						
						//create exit button
						var exit_btn:EyeBtn = Utils.newObject(EyeBtn, this.contentClip, "btn_exit", this.contentClip.getNextHighestDepth(), {_x:30+credits_btn._width+10, _y:550, literal:IntroApp.getMsg("btn.exit"), callBackObj:null, callBackFunc:Proxy.create(null, IntroApp.quitApp), active:true});
						exit_btn._alpha = 0;
						exit_btn.alphaTo(100, 10);
						
						this.onEnterFrame = null;
						
					break;
				}
			}
			this.frameCnt++;
		}
	}
		
	/*
	 * Creates a button
	 * 
	 * @param id the id of the button clip
	 * @param movieId the id of the movie to load get when clicked
	 * @param txt the text for the button
	 * @param xMc the x coordinate of the button clip
	 * @param yMc the y coordinate of the button clip
	 * @param xTxt the x coordinate of the text field
	 * @para yTxt the y coordinate of the text field
	 */
	private function drawButton(id:String, movieId:Number, txt:String, xMc:Number, yMc:Number, xTxt:Number, yTxt:Number, wTxt:Number):Void{

		//define txt format
		var btnTxtFormat = IntroApp.getTxtFormat("btnTxtFormat");
		
		//create button clip
		var btnMc = this.contentClip.createEmptyMovieClip(id, this.contentClip.getNextHighestDepth());
		btnMc._x = xMc;
		btnMc._y = yMc;
		btnMc._alpha = 0;
		btnMc.movieId = movieId;

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
		btnMc.onRelease = Proxy.create(this.mml, this.mml.doLoadMovie, movieId);
	}
	
	/*
	 * Creates a text field and adds formats defined by span elements
	 * 
	 */
	private function createTxtField(id:String, parentClip:GenericMovieClip, depth:Number, x:Number, y:Number, w:Number, h:Number, txt:String):Void{

		var startInd:Number = 0;
		var ind1:Number;
		var ind2:Number;
		var ind3:Number;
		var ind4:Number;
		var ind5:Number;
		var tfName:Array = new Array();
		var txts:Array = new Array();

		//get index of first span element
		ind1 = txt.indexOf("<span ", startInd);

		//add loop through all span elements adding text and text format names to
		//arrays
		while(ind1!= -1){

			//if there is un spanned text between the start index and ind1 then
			//add to arrays with default txt format
			if(ind1>startInd){
				tfName[tfName.length] = "defaultTxtFormat";
				txts[txts.length] = txt.substring(startInd, ind1);
			}

			//define indexes for this span element
			ind2 = txt.indexOf("class='", ind1)+7;
			ind3 = txt.indexOf("'", ind2);
			ind4 = txt.indexOf(">", ind3);
			ind5 = txt.indexOf("</span>", ind4);

			//add text and text format to array
			tfName[tfName.length] = txt.substring(ind2, ind3);
			txts[txts.length] = txt.substring(ind4+1, ind5);

			//update the start index and find next span element
			startInd = (ind5 != -1 ) ? ind5+7 : txt.length;
			ind1 = txt.indexOf("<span ", startInd);
		}

		//add rest of text as defaultTxtFormat
		if(startInd<txt.length){
			tfName[tfName.length] = "defaultTxtFormat";
			txts[txts.length] = txt.substring(startInd, txt.length);
		}

		//create container clip
		var mc:GenericMovieClip = parentClip.createEmptyMovieClip(id, parentClip.getNextHighestDepth());
		mc._x = x;
		mc._y = y;
		mc._yscale = 0;
		mc.scaleTo(100, 100, 10);

		//create text in text field
		mc.createTextField(id, depth, 0, 0, w, h);

		//add text
		for(var i=0; i<txts.length; i++){
			mc[id].text += txts[i];
		}

		//add format
		var l:Number = 0;
		for(var i=0; i<tfName.length; i++){
			mc[id].setTextFormat(l, l+txts[i].length, IntroApp.getTxtFormat(tfName[i]));
			l += txts[i].length;
		}

		mc[id].embedFonts = true;
		mc[id].autoSize = true;
		mc[id].wordWrap = true;
		mc[id].selectable = false;

	}
}