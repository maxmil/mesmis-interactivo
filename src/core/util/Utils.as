
//***********************************************
//	Utility functions used throughout the movie
//***********************************************
//
class core.util.Utils {
	/*
	 * String replace function
	 * Replaces every occurence of the text findTxt with the text replaceTxt
	 * in the string strTxt.
	 */
	public static function replace(strTxt:String, findTxt:String, replaceTxt:String) {
		var i;
		while ((i=strTxt.indexOf(findTxt)) != -1) {
			strTxt = strTxt.substring(0, i)+replaceTxt+strTxt.substring(i+findTxt.length, strTxt.length);
		}
		return (strTxt);
	}
	//
	/*
	 * Removes all formating characters from str
	 */
	public static function removeFormat(str:String) {
		str = replace(str, "\n", "");
		str = replace(str, "\t", "");
		str = replace(str, "\r", "");
		return str;
	}
	//
	/*
	 *	Round a number to the given number of decimal places
	 */
	public static function roundNumber(n:Number, scale:Number) {
		var mult:Number = Math.pow(10, scale);
		return ((Math.round(mult*n))/mult);
	}
	//
	
	/*
	 * Returns true if the array contains a given object and false
	 * otherwise
	 */
	public static function arrayContains(a:Array, v:Object) {
		for (var i = 0; i<a.length; i++) {
			if (a[i]==v) {
				return true;
			}
		}
		return false;
	}
	//
	/*
	 * Registers a new class that extends core.util.GenericMovieClip with the symbol 
	 * "emptyMovieClip" and creates an object of the given class
	 */
	public static function newObject(contructor:Function, parentClip:MovieClip, id:String, depth:Number, initObject:Object){

		Object.registerClass("emptyMovieClip", contructor);
		var o = parentClip.attachMovie("emptyMovieClip", id, depth, initObject);
		o.prototype = new MovieClip();
		return(o);
	}
	//
	 /*
	  * Creates a text field with the given properties. Some default properties are added:
	  * embedFonts = true;
	  * autoSize = true;
	  * wordWrap = true
	  */
	public static function createTextField(id:String, parentClip:MovieClip, depth:Number, x:Number, y:Number, w:Number, h:Number, txt:String, txtFormat:TextFormat):TextField{
		
		parentClip.createTextField(id, depth, x, y, w, h);
		parentClip[id].text = txt;
		parentClip[id].setTextFormat(txtFormat);
		parentClip[id].embedFonts = true;
		parentClip[id].autoSize = true;
		parentClip[id].wordWrap = true;
		parentClip[id].selectable = false;

		return parentClip[id];
	}
	
	/*
	 * Draws a border around the component
	 * 
	 * @param id the id of the border clip created, the depth of the clip is defined via
	 * uiComp.getNextHighestDepth
	 * @param uiComp the component to attach the border clip to
	 * @param thickness the pixel thickness of the border
	 * @param rgb the color
	 * @param x the starting x coordinate of the border, if this value is undefined 0 is used
	 * @param y the starting y coordinate of the border, if this value is undefined 0 is used
	 * @param w the width of the border, if this value is left blank the _width property
	 * of the uiComp is used
	 * @param h the height of the border, if this value is left blank the _height property
	 * of the uiComp is used
	 */
	public static function drawBorder(id:String, uiComp:Object, thickness:Number, rgb:Number, x:Number, y:Number, w:Number, h:Number){
		
		//create container clip
		var mc:MovieClip = uiComp.createEmptyMovieClip(id, uiComp.getNextHighestDepth());
		
		//save border style
		mc.thcknss = thickness-1;
		mc.rgb = rgb;
		
		//save dimensions
		mc.x = (x) ? x : 0;
		mc.y = (y) ? y : 0;
		mc.w = (w) ? w : uiComp._width;
		mc.h = (h) ? h : uiComp._height;
		
		//create animation
		mc.cnt = 1;
		mc.onEnterFrame = function(){

			this.clear();

			//draw border with alpha varying acording to count
			//var currThcknss:Number = 1+this.thcknss*(1+Math.sin(this.cnt/10))/2;
			var  currThcknss:Number = 1+this.thcknss;
			mc.lineStyle(currThcknss, this.rgb, 100);
			mc.moveTo(this.x, this.y);
			mc.lineTo(this.x+this.w, this.y);
			mc.lineTo(this.x+this.w, this.y+this.h);
			mc.lineTo(this.x, this.y+this.h);
			mc.lineTo(this.x, this.y);

			this.cnt++;
			
			delete this.onEnterFrame;
		}
	}
}
