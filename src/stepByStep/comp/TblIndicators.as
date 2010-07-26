import ascb.util.logging.Logger;
import core.comp.BubbleBtn;
import core.comp.TextPane;
import core.util.GenericMovieClip;
import core.util.Proxy;
import core.util.Utils;
import stepByStep.StepByStepApp;
import stepByStep.comp.Optimizer;
import stepByStep.model.valueObject.Indicator;

/*
 * Indicator table component
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.comp.TblIndicators extends core.util.GenericMovieClip
{
	//logger
	public static var logger:Logger = Logger.getLogger("stepByStep.comp.TblIndicators");
	
	//the widths of the columns
	var colWidths:Array;
	
	//the titles of the columns
	var colTitles:Array;
	
	//the height of each row
	var lineHeight:Number;
	
	//the height of the title row
	var titleHeight:Number;
	
	//the text format for the title
	var titleTxtFormat:TextFormat;
	
	//the text format for the cells
	var cellTxtFormat:TextFormat;
	
	//the current row
	var rows:Array;
	
	//array of indicators
	private var indicators;
	
	//flag to activate or desactivate the table. When active clicking of a row shows the detail of the corresponding indicator
	var active:Boolean = false;

	/*
	 * Constructor
	 */
	public function TblIndicators (){

		//set indicators and initialize rows
		this.indicators = indicators;
		this.rows = new Array (indicators.length);
		this.lineHeight = (this.lineHeight==undefined)?35:this.lineHeight;
		this.titleHeight = (this.titleHeight==undefined)?35:this.titleHeight;
	
		//initialize column titles
		this.colTitles = new Array();
		for (var i=0; i<10; i++){
			colTitles[i] = StepByStepApp.getMsg("tblIndicators.col"+String(i+1)+".title")
		}
		
		//initialize column widths
		this.colWidths = new Array (210, 120, 70, 55, 55, 55, 55, 55, 55, 100);
		
		//initialize coordinates
		var currX:Number;
		var currY:Number;
		
		//initialize text formats
		initTextFormats ();
		
		//create header
		var header = this.createEmptyMovieClip ("header", this.getNextHighestDepth ());
		header.lineStyle (1, 0xffffff, 100);
		currX = 0;
		
		//create header cells
		for (var i = 0; i < this.colTitles.length; i ++){
			
			//create background
			header.beginFill (0x006600, 90);
			header.moveTo (currX, 0);
			header.lineTo (currX + this.colWidths [i] , 0);
			header.lineTo (currX + this.colWidths [i] , this.titleHeight);
			header.lineTo (currX, this.titleHeight);
			header.lineTo (currX, 0);
			header.endFill ();
			
			//create title text
			var txtField = "title" + String (i);
			Utils.createTextField ("title" + String (i), header,  2+i, currX, 0, this.colWidths [i] , this.titleHeight, this.colTitles [i], this.titleTxtFormat);
			
			//increment current x position
			currX += this.colWidths [i];
		}
		
		//initialze rows
		var rowClip:MovieClip;
		var bgClip:MovieClip;
		var bgOverClip:MovieClip;
		currY = this.titleHeight;
		
		//create rows
		for (var i = 0; i < indicators.length; i ++){
			
			//create new row clip
			rowClip = this.createEmptyMovieClip ("row" + String (i) , this.getNextHighestDepth ());
			rowClip._y = currY;
			rowClip.indicator = indicators [i];
			rowClip.tblIndicators = this;
			currX = 0;
			
			//create background clips
			bgClip = rowClip.createEmptyMovieClip ("bg", 1);
			bgOverClip = rowClip.createEmptyMovieClip ("bgOver", 2);
			bgOverClip._alpha = 0;

			//create cells
			for (var j = 0; j < this.colTitles.length; j ++){
				
				//create background
				with (bgClip){
					lineStyle (1, 0xffffff, 100);
					beginFill (0xC0A47D, 50);
					moveTo (currX, 0);
					lineTo (currX + this.colWidths [j] , 0);
					lineTo (currX + this.colWidths [j] , this.lineHeight);
					lineTo (currX, this.lineHeight);
					lineTo (currX, 0);
					endFill ();
				}
				
				//create roll over background
				with (bgOverClip){
					lineStyle (1, 0xffffff, 100);
					beginFill (0xFFCC00, 50);
					moveTo (currX, 0);
					lineTo (currX + this.colWidths [j] , 0);
					lineTo (currX + this.colWidths [j] , this.lineHeight);
					lineTo (currX, this.lineHeight);
					lineTo (currX, 0);
					endFill ();
				}
				
				//create roll over funcionality
				//rowClip.onRollOver = function (){
					//if (this.tblIndicators.active)
					//{
						//this.bgOver._alpha = 100;
					//}
				//};
				//rowClip.onRollOut = function (){
					//if (this.tblIndicators.active){
						//this.bgOver._alpha = 0;
					//}
				//};
//				
				////create on click functionality
				//rowClip.onRelease = function (){
					//if (this.tblIndicators.active){
						//StepByStepApp.getNav().getCurrActivity_mc ().loadDetail (this.indicator);
					//}
				//};
				
				//create text or button
				if(j<9){
					var txtField = "cellTxt" + String (j);
					var txt:String;
					switch (j){
						case 0:
							txt = indicators [i].getLiteral ();
						break;
						case 1:
							txt = indicators [i].getUnits ();
						break;
						case 2:
							txt = indicators [i].getObjective ();
						break;
						case 3:
							txt = indicators [i].getTradSystem ();
						break;
						case 4:
							txt = indicators [i].getComSystem ();
						break;
						case 5:
							txt = indicators [i].getMin ();
						break;
						case 6:
							txt = indicators [i].getMax ();
						break;
						case 7:
							var calc:Number = indicators [i].getTradSystemCalc();
							txt = (isNaN(calc))?"?":String(calc);
						break;
						case 8:
							var calc:Number = indicators [i].getComSystemCalc();
							txt = (isNaN(calc))?"?":String(calc);
						break;
					}
					Utils.createTextField (txtField, rowClip, 3 + j, currX, 0, this.colWidths [j] , this.lineHeight, txt, this.cellTxtFormat);
				}else if (indicators[i].getIsOptimize()==true){
					var btn:BubbleBtn = Utils.newObject(BubbleBtn, rowClip, "btn_standardizar_"+String(i), rowClip.getNextHighestDepth(), {literal:StepByStepApp.getMsg("defineAmoebas.tblIndic.btn.standardize"), _y:10, callBackObj:this, callBackFunc:Proxy.create(this, openOptimizer, indicators[i])});
					btn._x = currX + (this.colWidths[9]-btn._width)/2;
				}
				
				//increment current x position
				currX += this.colWidths [j];
			}
			
			//add row to global array
			this.rows [i] = rowClip;
			
			//increment current y position
			currY += this.lineHeight;
		}
		
		//create mask
		var mask:GenericMovieClip = GenericMovieClip(this.attachMovie("genericMovieClip", "mask", this.getNextHighestDepth()));
		mask.beginFill(0x000000);
		mask.lineTo(currX, 0);
		mask.lineTo(currX, currY);
		mask.lineTo(0, currY);
		mask.lineTo(0, 0);
		mask.endFill();
		this.setMask(mask);
	}
	
	/*
	 * Opens optimizer for a given indicator
	 * within the step content clip of the current activity
	 * 
	 * @param indicator the indicator to optimize
	 */
	public function openOptimizer(indicator:Indicator):Void{
		var cont = StepByStepApp.getNav().getCurrActivity_mc().mcStep.cont;
		if (!cont["tpOptimizer"]){
			var tpOptimizer = Utils.newObject(TextPane, cont, "tpOptimizer", cont.getNextHighestDepth(), {titleTxt:"Estandarización " + indicator.getLiteral(), _x:40, _y:50, w:880, h:500});
			var optimizer:Optimizer = Optimizer(Utils.newObject(Optimizer, tpOptimizer.getContent(), "optimizer", tpOptimizer.getContent.getNextHighestDepth(), {indicator:indicator, callBackFunc:Proxy.create(this, this.closeOptimizer)}));
			tpOptimizer.init(true);
		}
	}
	
	/*
	 * Closes the optimizer and updates the table
	 * 
	 * @param indicator the indicator to optimize
	 */
	public function closeOptimizer():Void{
		var cont = StepByStepApp.getNav().getCurrActivity_mc().mcStep.cont;
		cont["tpOptimizer"].removeMovieClip();
		this.refreshTable();
	}
	

	/*
	 * Slides mask to show or hide columns
	 * 
	 * @param ind the number of columns to show (from the left)
	 * @param animate flag that when true glides the mask to its new position
	 */
	public function showCols(ind:Number, animate:Boolean):Void{
		
		//calculate new x position of mask
		var x:Number = 0;
		for(var i=0; i<Math.max(ind, 0); i++){
			x += this.colWidths[i];
		}
		x = x-this["mask"]._width;
		
		//reposition mask
		if (animate){
			this["mask"].glideTo(x, this["mask"]._y, 10);
		}else{
			this["mask"].move_mc.removeMovieClip();
			this["mask"]._x = x;
		}		
	}

	/*
	 * Initializes the text formats
	 */
	private function initTextFormats ():Void{
		
		//title text format
		titleTxtFormat = new TextFormat ();
		titleTxtFormat.size = 12;
		titleTxtFormat.font = "Arial";
		titleTxtFormat.bold = true;
		titleTxtFormat.align = "center";
		titleTxtFormat.color = 0xFFFFFF;
		
		//cell text format
		cellTxtFormat = new TextFormat ();
		cellTxtFormat.size = 12;
		cellTxtFormat.font = "Arial";
		cellTxtFormat.bold = false;
		cellTxtFormat.align = "center";
		cellTxtFormat.color = 0x996633;
	}

	/*
	 * Refreshes the values in the table
	 */
	private function refreshTable ():Void{
		
		for (var i = 0; i < this.indicators.length; i ++){
			
			//get row
			var row:MovieClip = this.rows [i];
			
			//loop through columns refreshing values
			for (var j = 0; j < this.colTitles.length; j ++){
				var txtField = row ["cellTxt" + String (j)];
				switch (j){
					case 0:
						txtField.text = indicators [i].getLiteral ();
					break;
					case 1:
						txtField.text = indicators [i].getUnits ();
					break;
					case 2:
						txtField.text = indicators [i].getObjective ();
					break;
					case 3:
						txtField.text = indicators [i].getTradSystem ();
					break;
					case 4:
						txtField.text = indicators [i].getComSystem ();
					break;
					case 5:
						txtField.text = indicators [i].getMin ();
					break;
					case 6:
						txtField.text = indicators [i].getMax ();
					break;
					case 7:
						var calc:Number = indicators [i].getTradSystemCalc();
						txtField.text = (isNaN(calc))?"?":String(calc);
					break;
					case 8:
						var calc:Number = indicators [i].getComSystemCalc();
						txtField.text = (isNaN(calc))?"?":String(calc);
					break;
					default:
					break;
				}
				txtField.setTextFormat (this.cellTxtFormat);
				txtField.wordWrap = true;
			}
		}
	}
}
