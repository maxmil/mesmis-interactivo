import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.BubbleBtn;
import core.comp.TextPane;
import core.comp.UserMessage;
import sussi.SussiApp;


/*
 * Helper class for activities
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class sussi.activity.SussiActivity extends core.controller.GenericActivity {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.activity.SussiActivity");
	
	/*
	 * Constructor
	 */
	function SussiActivity(){
		
		//call super class constuctor
		super(SussiApp);
		
		//if movie has been loaded by parent then define exit button
		if(_root.exitObj && _root.exitFunc){
			var btnExit = this["bg"].attachMovie("btn_exit", "btn_exit", this["bg"].getNextHighestDepth());
			btnExit._x = 930;
			btnExit._y = -24;
			btnExit.activity = this;
			btnExit.onRollOver = function(){
				var txt:String = SussiApp.getMsg("btn.gotoTopMenu");
				var w:Number = 120;
				SussiApp.getTxtFormat("smallTxtFormat").align = "center";
				Utils.newObject(UserMessage, this.activity, "roll_msg", this.activity.getNextHighestDepth(), {w:w, txt:txt, txtFormat:SussiApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
				SussiApp.getTxtFormat("smallTxtFormat").align = "left";
				this.activity["roll_msg"]._x = this._x+this._width-this.activity["roll_msg"]._width;
				this.activity["roll_msg"]._y = this._y+15;
			}
			btnExit.onRollOut = function(){
				this.activity["roll_msg"].removeMovieClip();
			}
			btnExit.onRelease = function(){
				this.activity["roll_msg"].removeMovieClip();
				this.activity["activateSteps"] = false;
				_root["blindsClosed"] = function(){
					_root.exitFunc.apply(_root.exitObj);
				}
				var blinds = _root.attachMovie("introMc", "blinds", _root.getNextHighestDepth());
			}
		}
	
	}
	
	/*
	 * Creates story text box
	 * 
	 * @param key the key for the story message resources
	 * 
	 * @return the story board
	 */
	public function createStoryTxt(key:String):TextPane{
		
		//get text
		var txtFormat:TextFormat = SussiApp.getTxtFormat("storyTxtFormat");
		var txt:String = SussiApp.getMsg("story."+key+".text");
		
		//get text extent sometimes fails
		var h:Number = (txtFormat.getTextExtent(txt, 400).textFieldHeight);
		if (h){
			h = Math.max(100, Math.min(h+40, 520));
		} else {
			h = 520;
		}
		var y:Number = 20+(520-h)/2;
		
		//define text pane
		var tp:TextPane = Utils.newObject(TextPane, this["mcStep"].cont, "story", this["mcStep"].cont.getNextHighestDepth(), {_x:520, _y:y, w:410, h:h, titleTxt:SussiApp.getMsg("story."+key+".title"), btnClose:false})
		var cont:MovieClip = tp.getContent();
		Utils.createTextField("txt", cont, cont.getNextHighestDepth(), 0, 0, 400, 1, txt, txtFormat);
		tp.init(true);
		return tp;
	}
	
	/*
	 * Creates model text box
	 * 
	 * @param key the key for the model message resources
	 * 
	 * @return the story board
	 */
	public function createModelTxt(key:String):TextPane{
		
		var y:Number;
		var h:Number;
		if(this["mcStep"].cont.rd){
			y = 250;
			h = 290;
		}else{
			y = 240;
			h = 300;
		}
		
		var txtFormat:TextFormat = SussiApp.getTxtFormat("storyTxtFormat");
		var txt:String = SussiApp.getMsg("model."+key+".text");
		var tp:TextPane = Utils.newObject(TextPane, this["mcStep"].cont, "story", this["mcStep"].cont.getNextHighestDepth(), {_x:40, _y:y, w:400, h:h, titleTxt:SussiApp.getMsg("model."+key+".title"), btnClose:false})
		var cont:MovieClip = tp.getContent();
		Utils.createTextField("txt", cont, cont.getNextHighestDepth(), 0, 0, 370, 1, txt, txtFormat);
		tp.init(false);
		return tp;
	}
	
	/*
	 * Creates story image and centers it
	 * 
	 * @param the id of the image clip
	 */
	public function createStoryImage(id:String):Void{
		
		var img:MovieClip = this["mcStep"].cont.attachMovie(id, "img", this["mcStep"].cont.getNextHighestDepth());
		img._x = (500-img._width)/2;
		img._y = 20+(520-img._height)/2
	}
	
	/*
	 * Creates an animation clip with a button to start the animation
	 * 
	 * @returns the containing clip
	 */
	public function createStoryAnimation(id:String):GenericMovieClip{
		
		//create container
		var anim:GenericMovieClip = Utils.newObject(GenericMovieClip, this["mcStep"].cont, "animation", this["mcStep"].cont.getNextHighestDepth(), {_x:20, _y:20});
		
		//attach animation
		var animation:MovieClip = anim.attachMovie(id, id, 1, {_y:20, _x:120});
		animation.activity = this;
		if(animation._width>400){
			animation._x = (950-animation._width)/2;
		}

		//create "animate" button
		var fnc:Function = function(){
			this.playAll = true;
			this.gotoAndPlay("step_1");
			if(this._width>400){
				this.activity.mcStep.cont.story.glideTo(520, 10, 10);
				this.activity.mcStep.cont.story.closeBlind();
			}
		}
		Utils.newObject(BubbleBtn, anim, "btn", 2, {literal:SussiApp.getMsg("btn.animate"), callBackObj:animation, callBackFunc:fnc});
		
		////create menu options
		//var menuOpts:Array = new Array();
//		
		////create menu options for each part
		//var i:Number = 1;
		//var msgKey = "story."+id+".step_"+String(i);
		//while(SussiApp.msgExists(msgKey)){
			//menuOpts[i-1] = new Object({labelTxt:SussiApp.getMsg(msgKey), callBackFunc:Proxy.create(anim[id], gotoAndPlay, "step_"+String(i))});
			//i++;
			//msgKey = "story."+id+".step_"+String(i);
		//}
//		
		////add last option that plays whole sequence
		//var fnc:Function = function(){
			//this.playAll = true;
			//this.gotoAndPlay("step_1");
		//}
		//menuOpts[i-1] = new Object({labelTxt:SussiApp.getMsg("story.animation.playAll"), callBackFunc:Proxy.create(anim[id], fnc)});
//		
		////create menu
		//Utils.newObject(DropDownMenu, this["mcStep"].cont, "menu", this["mcStep"].cont.getNextHighestDepth(), {_x:20, _y:10, titleTxt:SussiApp.getMsg("story.animation.seeAnimation"), options:menuOpts});		
//		
		//return container
		return anim;
	
	}
}

