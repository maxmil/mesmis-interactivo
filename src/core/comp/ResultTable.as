import ascb.util.logging.Logger;
/*
 * ResultTable drawing component
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 27-06-2005
 */
class core.comp.ResultTable extends core.util.GenericMovieClip {
	//logger
	private static var logger:Logger = Logger.getLogger("core.comp.ResultTable");
	//the height of a row
	private var rHeight:Number = 20;
	//the color of column separators and title underline
	private var separatorColor:Number = 0x006600;
	//text format for axis markers
	private var tfTitle:TextFormat;
	//text format for the axis literals
	private var tfCell:TextFormat;
	//current table width
	private var currWidth:Number = 0;
	//number of rows
	private var nRows:Number = 0;
	//background color of odd rows
	private var bgColorROdd:Number = null;
	//background color of even rows
	private var bgColorREven:Number = null;
	//background color of header
	private var bgColorHeader:Number = null;
	//the starting index to generate row values
	private var startInd:Number = 0;
	//an array of columns
	private var columns:Array;
	//boolean variable that when true does not draw cell values until graph is updated
	private var noInit:Boolean;
	//padding for input fields
	private var inputPaddingHoriz:Number = 10;
	private var inputPaddingVert:Number = 5;

	/*
	 * Constructor
	 */
	public function ResultTable() {
		
		//initialize
		 this.columns = new Array()
		
		//define line style
		this.lineStyle(1, this.separatorColor, 100);
		
		//define text formats if they have not been defined via the init object
		if (this.tfTitle == null) {
			this.tfTitle = new TextFormat();
			this.tfTitle.color = 0xffffff;
			this.tfTitle.font = "Arial";
			this.tfTitle.size = 12;
			this.tfTitle.bold = true;
			this.tfTitle.align = "center";
		}
		if (this.tfCell == null) {
			this.tfCell = new TextFormat();
			this.tfCell.color = 0x19271F;
			this.tfCell.font = "Arial";
			this.tfCell.size = 10;
			this.tfCell.bold = false;
			this.tfCell.align = "center";
		}		
	}

	/*
	 * Adds a column to the table
	 */
	public function addCol(id:String, titleTxt:String, callBackObj:Object, callBackFunc:Function, colWidth:Number, isInput:Boolean){
		
		//create column object and add to array of columns
		var col:Object = {id:id, callBackObj:callBackObj, callBackFunc:callBackFunc};
		this.columns[this.columns.length] = col;
		
		//if background color defined then draw background for title
		if (this.bgColorHeader != null){
			this.moveTo(this.currWidth, 0);
			this.beginFill(this.bgColorHeader, 100);
			this.lineTo(this.currWidth+colWidth, 0);
			this.lineTo(this.currWidth+colWidth, this.rHeight);
			this.lineTo(this.currWidth, this.rHeight);
			this.lineTo(this.currWidth, 0);
			this.endFill();
		}
		
		//draw title
		var tfId:String = id+"_title";
		this.createTextField(tfId, this.getNextHighestDepth(), this.currWidth, 0 , colWidth, 1);
		this[tfId].text = titleTxt;
		this[tfId].setTextFormat(this.tfTitle);
		this[tfId].embedFonts = true;
		this[tfId].autoSize = true;
		this[tfId]._y = (this.rHeight-this[tfId]._height)/2;
		this[tfId]._x = this.currWidth + (colWidth -this[tfId]._width)/2;
		
		//underline title
		this.moveTo(this.currWidth, this.rHeight);
		this.lineTo(this.currWidth+colWidth, this.rHeight);
		
		//if is not the first column then draw separator on left
		if (this.currWidth > 0){
			this.moveTo(this.currWidth, 0);
			this.lineTo(this.currWidth, (this.nRows+1)*this.rHeight);
		}
		
		//draw cells
		var prms:Array;
		var txt:String;
		
		for (var i=0; i<this.nRows; i++){
			
			//initialize parameters for callback function
			prms = new Array(1);
			prms[0] = i+this.startInd;
			prms[1] = id;
			
			//if background color defined then draw background
			var bgColor = (i%2==0) ? this.bgColorREven : this.bgColorROdd;
			if (bgColor != null){
				this.moveTo(this.currWidth, this.rHeight*(i+1));
				this.beginFill(bgColor, 100);
				this.lineTo(this.currWidth+colWidth, this.rHeight*(i+1));
				this.lineTo(this.currWidth+colWidth, this.rHeight*(i+2));
				this.lineTo(this.currWidth, this.rHeight*(i+2));
				this.lineTo(this.currWidth, this.rHeight*(i+1));
				this.endFill();
			}
						
			//create text field
			tfId = id + "_row_" + String(i);
			txt = (this.noInit) ? "" : callBackFunc.apply(callBackObj, prms).toString();
			if (isInput){
				this.createTextField(tfId, this.getNextHighestDepth(), this.currWidth+this.inputPaddingHoriz, (i+1)*this.rHeight+this.inputPaddingVert, colWidth-20, this.rHeight-10);
				this[tfId].type = "input";
				this[tfId].border = true;
				this[tfId].borderColor = this.tfCell.color;
				this[tfId].hscroll = 0;
				this[tfId].embedFonts = true;
				this[tfId].setNewTextFormat(this.tfCell);
				this[tfId].text = txt;
				this[tfId].isInput = true;
			}else{
				this.createTextField(tfId, this.getNextHighestDepth(), this.currWidth, (i+1)*this.rHeight, colWidth, 1);
				this[tfId].embedFonts = true;
				this[tfId].setNewTextFormat(this.tfCell);
				this[tfId].text = txt;
				this[tfId].autoSize = true;
				this[tfId]._x += (colWidth-this[tfId]._width)/2;
				this[tfId]._y += (this.rHeight-this[tfId]._height)/2;
			}
			this[tfId].colWidth = colWidth;
			this[tfId].xbase = this.currWidth;
			this[tfId].ybase = (i+1)*this.rHeight;
		}
		//increment current with
		this.currWidth += colWidth;
	}
	
	/*
	 * Updates the values in a table, regenerates the text in each cell
	 */
	public function update():Void{
		
		//the current text field
		var tf:TextField;
		
		//the id of the current column
		var id:String
		
		//the current diemensions of the text field
		var currW:Number;
		var currH:Number;
		
		//the callback obj and function for the current column
		var callBackObj:Object;
		var callBackFunc:Function;
		var prms:Array;
		
		//loop through columns updating text cell values
		for (var i=0; i<this.columns.length; i++){
			
			//define current column data
			id = this.columns[i].id
			callBackObj = this.columns[i].callBackObj;
			callBackFunc = this.columns[i].callBackFunc;
			
			//loop through rows
			for (var j=0; j<this.nRows; j++){
				
				//get text field
				tf = this[id + "_row_" + String(j)];
				
				//update text
				prms = new Array(j+this.startInd, id);
				tf.text = callBackFunc.apply(callBackObj, prms).toString();
				tf.setTextFormat(this.tfCell);
				
				//recenter
				tf._x = tf.xbase + (tf.colWidth - tf._width) / 2;
				tf._y = tf.ybase + (this.rHeight - tf._height) / 2;
			
			}
		}
	}
	
	/*
	 * Clears the values in a table
	 */
	public function clearValues():Void{
		
		//the current text field
		var tf:TextField;
		
		//the id of the current column
		var id:String
		
		//the callback obj and function for the current column
		var callBackObj:Object;
		var callBackFunc:Function;
		var prms:Array;
		
		//loop through columns updating text cell values
		for (var i=0; i<this.columns.length; i++){
			
			//define current column data
			id = this.columns[i].id
			
			//loop through rows
			for (var j=0; j<this.nRows; j++){
				
				//get text field
				tf = this[id + "_row_" + String(j)];
				
				//update text
				prms = new Array(j+this.startInd, id);
				tf.text = "";
				tf.setTextFormat(this.tfCell);
			}
		}
	}
	
}

