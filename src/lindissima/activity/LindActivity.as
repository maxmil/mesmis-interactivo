import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.UserMessage;

import lindissima.LindApp;


/*
 * Helper class for activities
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.activity.LindActivity extends core.controller.GenericActivity {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.activity.LindActivity");
	
	/*
	 * Constructor
	 */
	function LindActivity(){
		
		//call super class constuctor
		super(LindApp);
		
		//add background if not present
		if (!_root.bg){
			//attach background
			_root.attachMovie("lindissima_bg", "bg", 0, {txtTitle:LindApp.getMsg("general.txtTitle")});
		}
		
		//get id of current activity 
		//if not menu principal then add home button
		//and set subtitle to ""
		if (this.activityId != "menuPrin"){
			var btnHome = this["bg"].attachMovie("btn_home", "btn_home", this["bg"].getNextHighestDepth());
			btnHome._x = (_root.exitObj && _root.exitFunc) ? 900 : 930;
			btnHome._y = -24;
			btnHome.onRollOver = function(){
				var txt:String = LindApp.getMsg("btn.gotoLindissimaMenu");
				var w:Number = 120;
				LindApp.getTxtFormat("smallTxtFormat").align = "center";
				Utils.newObject(UserMessage, this._parent._parent, "roll_msg", this._parent._parent.getNextHighestDepth(), {w:w, txt:txt, txtFormat:LindApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
				LindApp.getTxtFormat("smallTxtFormat").align = "left";
				this._parent._parent["roll_msg"]._x = this._x+this._width-this._parent._parent["roll_msg"]._width;
				this._parent._parent["roll_msg"]._y = this._y+15;
			}
			btnHome.onRollOut = function(){
				this._parent._parent["roll_msg"].removeMovieClip();
			}
			btnHome.onRelease = function(){
				LindApp.getNav().getActivity("menuPrin");
			}
			_root.bg.txtSubtitle = ""
		}else{
			_root.bg.txtSubtitle = LindApp.getMsg("general.txtSubtitle");
		}
		
		
		//if movie has been loaded by parent then define exit button
		if(_root.exitObj && _root.exitFunc){
			var btnExit = this["bg"].attachMovie("btn_exit", "btn_exit", this["bg"].getNextHighestDepth());
			btnExit._x = 930;
			btnExit._y = -24;
			btnExit.activity = this;
			btnExit.onRollOver = function(){
				var txt:String = LindApp.getMsg("btn.gotoTopMenu");
				var w:Number = 120;
				LindApp.getTxtFormat("smallTxtFormat").align = "center";
				Utils.newObject(UserMessage, this.activity, "roll_msg", this.activity.getNextHighestDepth(), {w:w, txt:txt, txtFormat:LindApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
				LindApp.getTxtFormat("smallTxtFormat").align = "left";
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
}

