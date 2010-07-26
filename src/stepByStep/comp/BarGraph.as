class stepByStep.comp.BarGraph extends core.util.GenericMovieClip{
	private var barCont:MovieClip;
	private var barMask:MovieClip;
	private var barLitCont:MovieClip;
	private var indicators:Array;
	private var radius:Number = 150;
	private var centerX:Number = 240;
	private var centerY:Number = 180;
	private var bars:Array;
	private var w:Number;
	private var h:Number;
	private var yRange:Number;
	private var xBase:Number = 40;
	private var yBase:Number = 120;
	private var line:Array;
	private var txtFormat:TextFormat;
	private var colWidth:Number = 60;
	private var colIndent:Number = 10;
	private var xLabel:String;
	private var yScale:Number;
	//
	public function BarGraph() {
		//init background
		var bg = this.createEmptyMovieClip("bg", this.getNextHighestDepth());
		//crate axis
		bg.lineStyle(1, 0x996633, 100);
		bg.moveTo(this.xBase, this.yBase);
		bg.lineTo(this.xBase, this.yBase-this.h);
		bg.moveTo(this.xBase, this.yBase);
		bg.lineTo(this.xBase+this.w, this.yBase);
		//define text format
		this.txtFormat = new TextFormat();
		this.txtFormat.font = "Arial";
		this.txtFormat.color = 0x996633;
		//create y axis label
		bg.createTextField("y_axis_title", 1, 0, this.yBase, this.h, 20);
		bg["y_axis_title"].embedFonts = true;
		bg["y_axis_title"]._rotation = -90;
		bg["y_axis_title"].text = "Satisfacción";
		this.txtFormat.size = 11;
		this.txtFormat.align = "center";
		this.txtFormat.bold = true;
		bg["y_axis_title"].setTextFormat(this.txtFormat);
		//create x axis label
		bg.createTextField("x_axis_title", 2, this.xBase, this.yBase, this.w, 20);
		bg["x_axis_title"].embedFonts = true;
		bg["x_axis_title"].text = this.xLabel;
		bg["x_axis_title"].setTextFormat(this.txtFormat);
		//create y axis markers
		this.txtFormat.align = "right";
		this.txtFormat.bold = false;
		for (var i = 0; i<=this.yRange/this.yScale; i++) {
			bg.moveTo(this.xBase-5, this.yBase-(i*this.yScale)*this.h/this.yRange);
			bg.lineTo(this.xBase+this.w, this.yBase-(i*yScale)*this.h/this.yRange);
			var txtFieldId = "txtField_"+String(i);
			bg.createTextField("txtField_"+String(i), 3+i, this.xBase-30, this.yBase-(i*this.yScale)*this.h/this.yRange-7, 25, 20);
			bg[txtFieldId].text = i*this.yScale;
			bg[txtFieldId].embedFonts = true;
			bg[txtFieldId].setTextFormat(this.txtFormat);
		}
		//init bar container with mask
		this.barCont = this.createEmptyMovieClip("barCont", this.getNextHighestDepth());
		this.barCont._x = this.xBase;
		this.barCont._y = this.yBase;
		this.barMask = this.barCont.createEmptyMovieClip("mask", 10);
		this.barMask.beginFill(0x000000);
		this.barMask.moveTo(0, 0);
		this.barMask.lineTo(this.w, 0);
		this.barMask.lineTo(this.w, this.h+50);
		this.barMask.lineTo(0, this.h+50);
		this.barMask.lineTo(0, 0);
		this.barMask.endFill();
		this.barMask._y = this.h;
		this.barCont.setMask(this.barMask);
		this.bars = new Array();
		//init bar literals container
		this.barLitCont = this.createEmptyMovieClip("this.barLitCont", this.getNextHighestDepth());
	}
	//
	public function addBar(literal:String, val:Number, color:Number) {
		var i = this.bars.length;
		//create bar
		this.barCont.lineStyle(1, color, 100);
		var fillColors = [color, color];
		var alphas = [100, 0];
		var ratios = [0, 32];
		var matrix = {matrixType:"box", x:i*this.colWidth+this.colIndent, y:0, w:10*(this.colWidth-2*this.colIndent), h:-val*this.h/this.yRange, r:0};
		this.barCont.beginGradientFill("linear", fillColors, alphas, ratios, matrix);
		this.barCont.moveTo(i*this.colWidth+this.colIndent, 0);
		this.barCont.lineTo(i*this.colWidth+this.colIndent, -val*this.h/this.yRange);
		this.barCont.lineTo((i+1)*this.colWidth-this.colIndent, -val*this.h/this.yRange);
		this.barCont.lineTo((i+1)*this.colWidth-this.colIndent, 0);
		this.barCont.lineTo(i*this.colWidth+this.colIndent, 0);
		//define text format
		var txtFormat = new TextFormat();
		txtFormat.font = "Arial";
		txtFormat.color = 0x996633;
		txtFormat.size = 10;
		txtFormat.align = "center";
		//create text
		this.barCont.createTextField("barLit_" + String(i), i+11, i*this.colWidth, -val*this.h/this.yRange,this.colWidth, 30);
		this.barCont["barLit_" + String(i)].autoSize = true;
		this.barCont["barLit_" + String(i)].wordWrap = true;
		this.barCont["barLit_" + String(i)].text = literal + "\n" + String(val);
		this.barCont["barLit_" + String(i)].embedFonts = true;
		this.barCont["barLit_" + String(i)].setTextFormat(txtFormat);
		this.barCont["barLit_" + String(i)]._y -= this.barCont["barLit_" + String(i)]._height;
		//add bar to array
		this.bars[this.bars.length] = new Array("literal", val, color);
	}
	//
	public function init(){
		this.barMask.glideTo(0, -this.h-50., 10);
	}
}
