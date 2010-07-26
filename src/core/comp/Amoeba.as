import ascb.util.logging.Logger;
import core.util.Utils;

/*
 * Amoeba component, draws varios amoebas over the same background and offers functions to
 * update/hide the different amoebas
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class core.comp.Amoeba extends core.util.GenericMovieClip{
	
	//logger
	public static var logger:Logger = Logger.getLogger("core.comp.Amoeba");
	
	//radius of amoeba
	private var radius:Number;
	
	//position of center
	private var centerX:Number;
	private var centerY:Number;
	
	//array of titles
	private var titles:Array;
	
	//array of amoebas
	private var amoebas:Array;
	
	//text format for index
	private var tfIndex:TextFormat;

	/*
	 * Constructor
	 */
	public function Amoeba() {
		logger.debug("instantiating Amoeba");
		
		//define default properties
		radius = (radius==undefined)?150:radius;
		centerX = (centerX==undefined)?240:centerX;
		centerY = (centerY==undefined)?180:centerY;
		
		//initialize array of amoebas
		this.amoebas = new Array();
		
		//initialize text formats
		if (!tfIndex){
			tfIndex = new TextFormat();
			tfIndex.size = 11;
			tfIndex.font = "Arial";
			tfIndex.color = 0x996633;
		}
		
		//init background
		initBackground();
		
		//init indexes clip
		var indexContainer = this.createEmptyMovieClip("indexContainer", this.getNextHighestDepth());
		indexContainer._x = 10;
		indexContainer._y = 10;
	}
	
	/*
	 * Adds a new amoeba to the component
	 * 
	 * @param id the id of the new amoeba
	 * @param title the title of the new amoeba
	 * @param color the background color of the new amoeba
	 * @para values an array of values for the new amoeba
	 */
	public function addAmoeba(id:String, title:String, color:Number, values:Array) :Void{
		//initialize variables
		var coords = new Array(this.titles.length);
		var size;
		//create new movie clip to contain amoeba
		var newAmoeba = this.createEmptyMovieClip(id, this.getNextHighestDepth());
		newAmoeba._y = 20;
		newAmoeba._alpha = 60;
		//define line style
		var line = new Array(3);
		line[0] = 1;
		line[1] = 0x000000;
		line[2] = 100;
		newAmoeba.line = line;
		//define fill style
		var fill = new Array(2);
		fill[0] = color;
		fill[1] = 70;
		newAmoeba.fill = fill;
		//calculate coordinates of the amoeba
		for (var i = 0; i<values.length; i++) {
			size = values[i]*this.radius*4/500+this.radius/5;
			coords[i] = new Array(size*Math.sin(2*i*Math.PI/values.length), -size*Math.cos(2*i*Math.PI/values.length));
		}
		coords[values.length] = coords[0];
		//draw amoeba
		newAmoeba.drawShape("shape", 10, this.centerX, this.centerY, coords, line, fill);
		//create index for amoeba
		drawIndex(title, newAmoeba, color);
		//add amoeba to array
		this.amoebas[this.amoebas.length] = newAmoeba;
	}
	
	/*
	 * Updates the values of an amoeba and redraws the shape
	 * 
	 * @param id the id of the amoeba
	 * @para values array of new values for the amoeba
	 */
	public function updateAmoeba(id:String, values:Array) :Void{
		//initialize variables
		var coords = new Array(this.titles.length);
		var size;
		//get amoeba
		var amoeba = this[id];
		//remove shape
		amoeba.shape.removeMovieClip();
		//calculate new coords
		for (var i = 0; i<values.length; i++) {
			size = values[i]*this.radius*4/500+this.radius/5;
			coords[i] = new Array(size*Math.sin(2*i*Math.PI/values.length), -size*Math.cos(2*i*Math.PI/values.length));
		}
		coords[values.length] = coords[0];
		//redraw shape
		amoeba.drawShape("shape", 10, this.centerX, this.centerY, coords, amoeba.line, amoeba.fill);
	}

	/*
	 * Hides the given amoeba
	 * 
	 * @param id the id of the amoeba
	 */
	public function hideAmoeba(id:String) :Void{
		this[id]._visible = false;
		this["indexContainer"][id+"_index"]._visible = false;
	}

	/*
	 * Shows the given amoeba
	 * 
	 * @param id the id of the amoeba
	 */
	public function showAmoeba(id:String) :Void{
		this[id]._visible = true;
		this["indexContainer"][id+"_index"]._visible = true;
	}

	/*
	 * Adds a new element to the index corresponding to one of the amoebas. Passing 
	 * over this element with the mouse increases the _alpha of the amoeba.
	 * 
	 * @param title the title to show in the index
	 * @param amoebaClip a reference to the MovieClip containing the amoeba
	 * @param color the color of the square drawn along side the title
	 */
	private function drawIndex(title:String, amoebaClip:MovieClip, color:Number) :Void{
		//create new index clip
		var amoebaId = amoebaClip._name.substring(amoebaClip._name.lastIndexOf("."));
		var newIndex = this["indexContainer"].createEmptyMovieClip(amoebaId+"_index", this["indexContainer"].getNextHighestDepth());
		newIndex._y = this.amoebas.length*20;
		newIndex.amoeba = this;
		//draw square
		var sq = newIndex.createEmptyMovieClip("sq", 10);
		sq.lineStyle(1, 0x996633, 100);
		sq.beginFill(color, 100);
		sq.lineTo(0, 15);
		sq.lineTo(15, 15);
		sq.lineTo(15, 0);
		sq.lineTo(0, 0);
		sq.endFill();
		sq._alpha = 20;
		//draw  text
		Utils.createTextField("txt", newIndex, 20, 20, 0, 200, 20, title, this.tfIndex);
		//add event listeners
		newIndex.onRollOver = function() {
			this.sq.alphaTo(100, 10);
			var id = this._name.substring(0, this._name.indexOf("_index"));
			for (var i = 0; i<this.amoeba.amoebas.length; i++) {
				if (this.amoeba.amoebas[i]._name == id) {
					this.amoeba.amoebas[i].alphaTo(100, 10);
				} else {
					this.amoeba.amoebas[i]._alpha = 0;
					if (this.amoeba.amoebas[i].alpha_mc) {
						this.amoeba.amoebas[i].alpha_mc.removeMovieClip();
					}
				}
			}
		};
		newIndex.onRollOut = function() {
			this.sq.alphaTo(20, 10);
			var id = this._name.substring(0, this._name.indexOf("_index"));
			for (var i = 0; i<this.amoeba.amoebas.length; i++) {
				if (this.amoeba.amoebas[i]._name == id) {
					this.amoeba.amoebas[i].alphaTo(60, 10);
				} else {
					this.amoeba.amoebas[i]._alpha = 60;
					if (this.amoeba.amoebas[i].alpha_mc) {
						this.amoeba.amoebas[i].alpha_mc.removeMovieClip();
					}
				}
			}
		};
	}

	/*
	 * Draws the polygon of an amoeba
	 * 
	 * @param parent the MovieClip that will contain the amoeba
	 * @param id the id of the amoeba
	 * @param depth the depth of the amoeba in the parent clip
	 * @param radius the radius of the amoeba
	 * @param line an 3 dimensional array that contains [lineThickness, lineColor, _alpha]
	 * @param fill an 2 dimensional array that contains [bgcolor, _alpha]
	 */
	private function drawPolygon(parent:MovieClip, id:String, depth:Number, radius:Number, line:Array, fill:Array) :Void{
		var coords = new Array(this.titles.length+1);
		for (var i = 0; i<this.titles.length; i++) {
			coords[i] = new Array(radius*Math.sin(2*i*Math.PI/this.titles.length), -radius*Math.cos(2*i*Math.PI/this.titles.length));
		}
		coords[this.titles.length] = new Array(0, -radius);
		parent.drawShape(id, depth+5, this.centerX, this.centerY, coords, line, fill);
	}
	
	/*
	 * Initializes the background
	 */
	private function initBackground() :Void{
		//create background clip		
		var bg = this.createEmptyMovieClip("bg", this.getNextHighestDepth());
		bg._y = 20;
		//define line style
		var line = new Array(3);
		line[0] = 1;
		line[1] = 0x996633;
		line[2] = 100;
		//draw green bg
		var fill = new Array(2);
		fill[0] = 0x00CC00;
		fill[1] = 100;
		drawPolygon(bg, "bg_1", 10, this.radius, line, fill);
		//draw yellow bg
		fill[0] = 0xFFFF00;
		fill[1] = 100;
		drawPolygon(bg, "bg_2", 20, this.radius*4/5, line, fill);
		//draw orange bg
		fill[0] = 0xFF9900;
		fill[1] = 100;
		drawPolygon(bg, "bg_3", 30, this.radius*3/5, line, fill);
		//draw red bg
		fill[0] = 0xFF5252;
		fill[1] = 100;
		drawPolygon(bg, "bg_4", 40, this.radius*2/5, line, fill);
		//draw white bg
		fill[0] = 0xFFFFFF;
		fill[1] = 100;
		drawPolygon(bg, "bg_5", 50, this.radius*1/5, line, fill);
		//draw radials
		var coords = new Array(2);
		coords[0] = new Array(0, 0);
		for (var i = 0; i<this.titles.length; i++) {
			coords[1] = new Array(this.radius*Math.sin(2*i*Math.PI/this.titles.length), -this.radius*Math.cos(2*i*Math.PI/this.titles.length));
			bg.drawShape("radial"+String(i), bg.getNextHighestDepth(), this.centerX, this.centerY, coords, line);
		}
		//define text format for limits
		var limitTxtFormat = new TextFormat();
		limitTxtFormat.size = 11;
		limitTxtFormat.font = "Arial";
		limitTxtFormat.bold = true;
		limitTxtFormat.align = "right";
		limitTxtFormat.color = 0x006600;
		//draw limits
		var txtFieldId;
		for (var i = 0; i<=4; i++) {
			txtFieldId = "limit_"+String(i);
			Utils.createTextField(txtFieldId, bg, (titles.length+6+i)*10, this.centerX-30, this.centerY-((i+1)*this.radius/5)-10, 30, 20, String(i*25), limitTxtFormat);
		}
		//define text format for titles
		var indicTxtFormat = new TextFormat();
		indicTxtFormat.size = 10;
		indicTxtFormat.font = "Arial";
		indicTxtFormat.bold = false;
		indicTxtFormat.color = 0x006600;
		//draw titles
		var xPos;
		var yPos;
		for (var i = 0; i<this.titles.length; i++) {
			txtFieldId = "indic_"+String(i);
			xPos = this.radius*Math.sin(2*i*Math.PI/this.titles.length);
			if (xPos<0) {
				xPos -= 90;
				indicTxtFormat.align = "right";
			}
			yPos = -this.radius*Math.cos(2*i*Math.PI/this.titles.length);
			if (yPos<0) {
				yPos -= 30;
			}
			Utils.createTextField(txtFieldId, bg, (this.titles.length+12+i)*10, this.centerX+xPos, this.centerY+yPos, 90, 50, this.titles[i], indicTxtFormat);
		}
	}
}
