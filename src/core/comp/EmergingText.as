import core.util.GenericMovieClip;

/*
 * Emerges letters
 * 
 * @autor Max Pimm
 * @created 01-09-2005
 * @version 1.0
 */
class core.comp.EmergingText extends GenericMovieClip{
	
	//the text to emerge
	private var txt:String;
	
	//the text format
	private var txtFormat:TextFormat;
	
	//the current xposition of the cursor
	private var currX:Number = 0;
	
	//the wait inbetween characters
	private var delay:Number = 1;
	
	//the number of frames to wait before begining
	private var startFrame:Number = 1;
	
	//the background color
	private var bgcolor:Number;
	
	//frame counter
	private var cnt:Number = 0;
	
	//functions
	public var onComplete:Function;
	
	//total width of emerging text
	public var totalWidth:Number;
	
	/*
	 * Constructor
	 */
	public function EmergingText() {
		
		//calculate total width of text
		this.createEmptyMovieClip("testLength", this.getNextHighestDepth());
		this["testLength"].createTextField("tf", 1 , 0, 0, 1000, 1);
		this["testLength"].tf.text = this.txt;
		this["testLength"].tf.embedFonts = true;
		this["testLength"].tf.setTextFormat(this.txtFormat);
		this["testLength"].tf.autoSize = true;
		this.totalWidth = this["testLength"].tf._width;
		this["testLength"].removeMovieClip();
		
		
		//initiate animation
		this.onEnterFrame = function() {
			
			if (this.cnt>=this.startFrame && this.cnt<this.startFrame+this.delay*this.txt.length && (this.cnt-this.startFrame)%(this.delay) == 0) {
				
				//define character index
				var ind:Number = (this.cnt-this.startFrame)/this.delay;
				
				//create character container
				var charClip = this.createEmptyMovieClip("char_"+String(ind), this.getNextHighestDepth());
				charClip._x = this.currX;
				charClip._xscale = 400;
				charClip._yscale = 400;
				charClip.scaleTo(100, 100, 2);
				
				// create character
				var char = charClip.createEmptyMovieClip("char", 10);
				char.createTextField("txt", 2, 0, 0, 100, 100);
				char.txt.text = this.txt.substring(ind, ind+1);
				char.txt.setTextFormat(this.txtFormat);
				char.txt.embedFonts = true;
				char.txt.selectable = false
				char.txt.autoSize = true;
				
				// create mask
				var charMask = charClip.createEmptyMovieClip("mask", 11);
				charMask.lineStyle(1, this.txtFormat.color, 100);
				charMask.beginFill(this.bgcolor, 100);
				charMask.lineTo(char.txt._width, 0);
				charMask.lineTo(char.txt._width, char.txt._height);
				charMask.lineTo(0, char.txt._height);
				charMask.lineTo(0, 0);
				charMask.endFill();
				charMask._alpha = 100;
				
				//if is last character call complete function when alpha finishes
				if(ind == this.txt.length-1){
					charMask.alphaTo(0, 10, this.onComplete);
					delete this.onEnterFrame;
				}else{
					charMask.alphaTo(0, 10);	
				}
				
				// position clip and increment currentX
				this.currX += char.txt._width - 4;
			
			}
			
			this.cnt++;
		};
	}
}
