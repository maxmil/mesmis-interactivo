import core.util.Proxy;

/*
 * Trails a word from one set of coordinates to another
 * 
 * @autor Max Pimm
 * @created 01-09-2005
 * @version 1.0
 */
class core.comp.TrailingText extends core.util.GenericMovieClip{
	
	//the text string to trail
	private var txt:String;
	
	//the text format
	private var txtFormat:TextFormat;
	private var txtCol:Number;
	private var bgCol:Number;
	
	//initial and final coordinates
	private var initX:Number;
	private var initY:Number;
	private var finX:Number;
	private var finY:Number;
	
	//animation control
	private var speed:Number;//number of frames in which to do movement
	private var delay:Number;//delay before starting
	private var nDuplicates:Number;//number of duplicate clips
	private var wait:Number; //frames between generating duplicates
	private var frameCnt:Number;
	private var doneCnt:Number;
	
	//functions
	private var onComplete:Function;
	
	//total width of text
	public var totalW:Number;
	
	/*
	 * Constructor
	 */
	public function TrailingText() {
		
		//initialize text format
		if (!txtFormat){
			txtFormat = new TextFormat();
			txtFormat.font = "Arial bold";
			txtFormat.bold = true;
			txtFormat.align = "left";
			txtFormat.color = (txtCol) ? txtCol : 0x000000;
		}
		txtCol = txtFormat.color;
		bgCol = (bgCol) ? bgCol : 0xffffff;
		
		//define coordinates
		initX = (initX) ? initX : 0;
		initY = (initY) ? initY : 0;
		finX = (finX) ? finX : initX;
		finY = (finY) ? finY : initY;
		
		//define animation control
		speed = (speed) ? speed : 20;
		delay = (delay) ? delay : 0;
		nDuplicates = (nDuplicates) ? nDuplicates : 5;
		wait = (wait==undefined) ? 2 : wait;
		
		//create and remove movie clip to define total width
		this.createEmptyMovieClip("testLength", this.getNextHighestDepth());
		this["testLength"].createTextField("tf", 1 , 0, 0, 1000, 1);
		this["testLength"].tf.text = this.txt;
		this["testLength"].tf.embedFonts = true;
		this["testLength"].tf.setTextFormat(this.txtFormat);
		this["testLength"].tf.autoSize = true;
		this.totalW = this["testLength"].tf._width;
		this["testLength"].removeMovieClip();
		
		//begin animation
		frameCnt = 0;
		doneCnt = 0;
		this.onEnterFrame = function(){
			
			
			if ((this.frameCnt>=this.delay) && ((this.frameCnt-this.delay)%this.wait==0)){
				
				//create movie clip with text in
				var n:Number = this.nDuplicates-(this.frameCnt-this.delay)/this.wait;
				var id:String = "txt_"+String(this.frameCnt);
				var mc:MovieClip = this.createEmptyMovieClip(id, n);
				mc.createTextField("tf", 1, this.initX, this.initY, this.txt.length*this.txtFormat.size, 1);
				mc["tf"].text = this.txt;
				mc["tf"].setTextFormat(this.txtFormat);
				mc["tf"].embedFonts = true;
				mc["tf"].selectable = false;
				mc["tf"].autoSize = true;
				
				//if is not first clip then create mask
				if (this.frameCnt>this.delay){

					//create mask and fade in
					var mask:MovieClip =  mc.createEmptyMovieClip("mask", 2);
					mask.beginFill(this.bgCol, 100);
					mask.moveTo(mc["tf"]._x, mc["tf"]._y);
					mask.lineTo(mc["tf"]._x+mc["tf"]._width, mc["tf"]._y);
					mask.lineTo(mc["tf"]._x+mc["tf"]._width, mc["tf"]._y+mc["tf"]._height);
					mask.lineTo(mc["tf"]._x, mc["tf"]._y+mc["tf"]._height);
					mask.lineTo(mc["tf"]._x, mc["tf"]._y);
					mask.endFill();
					mask._alpha = (this.nDuplicates-n)/this.nDuplicates*100;
				}
				
				//animate movie clip
				mc.shiftTo(this.finX, this.finY, this.speed, Proxy.create(this, this.done));
			}
			
			if (this.frameCnt>=this.nDuplicates*this.wait+this.delay){
				
				//stop animating
				delete this.onEnterFrame;
				
			}else{
			
				//increment frame counter
				this.frameCnt++
			}
		}
	}
	
	/*
	 * Triggered each time a character movie clip finishes animating
	 * Counts the finished clips. When all clips have finished dispaches the
	 * "onComplete" event
	 */
	public function done():Void{
		
		//count done clips
		doneCnt++;
		if (doneCnt == nDuplicates){
			onComplete();
		}
	}
	
}
