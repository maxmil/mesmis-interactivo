import core.util.Proxy;
import core.util.GenericMovieClip;

/*
 * Simple drop down list of options. Each option has a text literal and a function
 * that it calls when clicked.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 03-10-2005
 */
class core.comp.DropDownMenu extends core.util.GenericMovieClip {
	
	//dimensions
	public var w:Number
	public var titleH:Number;
	public var opH:Number
	
	//text formats
	public var titleTxtFormat:TextFormat;
	public var opTxtFormat:TextFormat;
	
	//title option
	public var titleTxt:String;
	
	//array of options, each one should be an object with properties labelTxt and callBackFunc
	public var options:Array;
	
	//colors
	public var colTitleBg:Number;
	public var colTitleBorder:Number;
	public var colTitleBgOver:Number;
	public var colTitle:Number;
	public var colTitleOver:Number;
	public var colOpBg:Number;
	public var colOpBgOver:Number;
	public var colOpBorder:Number;
	public var colOp:Number;
	public var colOpOver:Number;
	
	//internal functionality
	private var isOpen:Boolean;
	
	/*
	 * Constructor, creates the header and the empty content clip. In order to 
	 * initialize the scroll the init function should be called once content has
	 * been added
	 */
	public function DropDownMenu(){
		
		//initialize default values
		initDefaultValues();
		
		//create title
		createTitle();
		
		//create options
		createOptions();
		
		//add automatic closing
		this.onMouseMove = function(){
			if(this.isOpen){
				if(this._xmouse<0 || this._xmouse>this.w || this._ymouse<0 || this._ymouse>this.titleH*this.options.length*this.opH){
					this.closeMenu();
				}
			}
		}
		
	}
	
	/*
	 * Creates the title element
	 */
	private function createTitle():Void{
		
		//create container clip
		var titleMc:GenericMovieClip = this.createEmptyMovieClip("title", 2);
		
		//create roll out clip
		var out:GenericMovieClip = titleMc.createEmptyMovieClip("out", 1);
		
		//draw background
		out.lineStyle(1, colTitleBorder, 100);
		out.beginFill(colTitleBg, 100);
		out.lineTo(w, 0);
		out.lineTo(w, titleH);
		out.lineTo(0, titleH);
		out.lineTo(0, 0);
		out.endFill();
		
		//create text field
		out.createTextField("txt", 1, 0, 0, w, titleH);
		out["txt"].text = titleTxt;
		out["txt"].embedFonts = true;
		titleTxtFormat.color = colTitle;
		out["txt"].setTextFormat(titleTxtFormat);
		out["txt"]._y = (titleH-out["txt"]._height)/2
		sussi.SussiApp.logger.debug(out["txt"]._y)
		
		//create roll over clip
		var over:GenericMovieClip = titleMc.createEmptyMovieClip("over", 2);
		over._visible = false;
		
		//draw background
		over.lineStyle(1, colTitleBorder, 100);
		over.beginFill(colTitleBgOver, 100);
		over.lineTo(w, 0);
		over.lineTo(w, titleH);
		over.lineTo(0, titleH);
		over.lineTo(0, 0);
		over.endFill();
		
		//create text field
		over.createTextField("txt", 1, 0, 0, w, titleH);
		over["txt"].text = titleTxt;
		over["txt"].embedFonts = true;
		titleTxtFormat.color = colTitleOver;
		over["txt"].setTextFormat(titleTxtFormat);
		over["txt"]._y = (titleH-over["txt"]._height)/2
		
		//add listener to clips
		titleMc.onRollOver = Proxy.create(this, openMenu);
	}
	
	/*
	 * Initializes the options
	 */
	private function createOptions():Void{
		
		var l:Number = this.options.length;
		var option:Object;
		
		//create container clip
		var container:GenericMovieClip = this.createEmptyMovieClip("optContainer", 1);
		container._y = titleH-opH;
		
		//create options clip and mask clip
		var options:GenericMovieClip = container.createEmptyMovieClip("options", 1);
		var mask:GenericMovieClip = container.createEmptyMovieClip("mask", 2);
		mask.beginFill(0x000000, 100);
		mask.lineTo(w+1, 0);
		mask.lineTo(w+1, opH*(l+1)+1);
		mask.lineTo(0, opH*(l+1)+1);
		mask.lineTo(0, 0);
		container.setMask(mask);
		
		//create options
		var optionMc, out, over:GenericMovieClip;
		for (var i=0; i<l; i++){
			
			//create clip
			option = this.options[i];
			optionMc = options.createEmptyMovieClip("option_"+String(i), l-i);
			optionMc.ind = i;
			//optionMc._y = (i+1)*opH;
			
			//create roll out clip
			out = optionMc.createEmptyMovieClip("out", 1);
			
			//draw background
			out.lineStyle(1, colOpBorder, 100);
			out.beginFill(colOpBg, 100);
			out.lineTo(w, 0);
			out.lineTo(w, opH);
			out.lineTo(0, opH);
			out.lineTo(0, 0);
			out.endFill();
			
			//create text field
			out.createTextField("txt", 1, 0, 0, w, opH);
			out["txt"].text = option.labelTxt;
			out["txt"].embedFonts = true;
			out["txt"].textColor = 0xf006600;
			out["txt"].setTextFormat(opTxtFormat);
			
			//create roll over clip
			over = optionMc.createEmptyMovieClip("over", 2);
			over._visible = false;
			
			//draw background
			over.lineStyle(1, colOpBorder, 100);
			over.beginFill(colOpBgOver, 100);
			over.lineTo(w, 0);
			over.lineTo(w, opH);
			over.lineTo(0, opH);
			over.lineTo(0, 0);
			over.endFill();
			
			//create text field
			over.createTextField("txt", 1, 0, 0, w, opH);
			over["txt"].text = option.labelTxt;
			over["txt"].embedFonts = true;
			over["txt"].textColor = colOpOver;
			over["txt"].setTextFormat(opTxtFormat);
			
			//add listener to clips
			optionMc.onRollOver = function(){
				this.over._visible = true;
			}
			optionMc.onRollOut = function(){
				this.over._visible = false;
			}
			optionMc.onRelease = option.callBackFunc;
		}
	}
	
	/*
	 * Initializes default values if not defined via initial object
	 */
	private function initDefaultValues():Void{
		
		//init variables
		w = (w==undefined) ? 150 : w;
		titleH = (titleH==undefined) ? 20 : titleH;
		opH = (opH==undefined) ? 20 : opH;
		colTitleBg = (colTitleBg==undefined) ? 0xE6E3C6 : colTitleBg;
		colTitleBgOver = (colTitleBgOver==undefined) ? 0x006600 : colTitleBgOver;
		colTitleBorder = (colTitleBorder==undefined) ? 0x006600 : colTitleBorder;
		colTitle = (colTitle==undefined) ? 0x006600 : colTitle;
		colTitleOver = (colTitleOver==undefined) ? 0xffffff : colTitleOver;
		colOpBg = (colOpBg==undefined) ? 0xffffff : colOpBg;
		colOpBgOver = (colOpBgOver==undefined) ? 0xffcc00 : colOpBgOver;
		colOp = (colOp==undefined) ? 0x006600 : colOp;
		colOpOver = (colOpOver==undefined) ? 0xffffff : colOpOver;
		colOpBorder = (colOpBorder==undefined) ? 0x006600 : colOpBorder;
		isOpen = false;
		
		//init text formats
		if (titleTxtFormat==undefined){
			titleTxtFormat = new TextFormat();
			titleTxtFormat.size = 12;
			titleTxtFormat.bold = true;
			titleTxtFormat.font = "Arial bold";
			titleTxtFormat.blockIndent = 5;
		}
		if (opTxtFormat==undefined){
			opTxtFormat = new TextFormat();
			opTxtFormat.size = 12;
			opTxtFormat.font = "Arial";
			opTxtFormat.blockIndent = 5;
		}
		
		
	}
	
	/*
	 * Opens the menu
	 */
	public function openMenu():Void{
		
		//check that not open
		if (isOpen){
			return;
		}
		
		//open options with glide
		var option:GenericMovieClip;
		for(var i=0; i<options.length; i++){
			option = this["optContainer"].options["option_"+String(i)];
			option.glideTo(0, (i+1)*opH, 5);
		}
		
		//show title over clip
		this["title"].over._visible = true;
		
		//reset flag
		isOpen = true;
	}
	
	/*
	 * Closes the menu
	 */
	public function closeMenu():Void{

		//check that is not closed
		if (!isOpen){
			return;
		}
		
		//close options with glide
		var option:GenericMovieClip;
		for(var i=0; i<options.length; i++){
			option = this["optContainer"].options["option_"+String(i)];
			option.glideTo(0, 0, 5);
		}
		
		//hide title over clip
		this["title"].over._visible = false;
		
		//reset flag
		isOpen = false;
	}
	 
}
