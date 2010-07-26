import ascb.util.logging.Logger;
import core.comp.Graph;
import core.util.GenericMovieClip;
import core.util.Proxy;
import core.util.Utils;
import sussi.Const;
import sussi.SussiApp;
import sussi.utils.SUtils;
import sussi.process.Bh1;
import sussi.process.Ph1;
import sussi.process.Dh1;

/*
 * Phase diagram component for herbivore 1
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 19-07-2005
 */
 class sussi.comp.H1PhaseDiagram extends GenericMovieClip{
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.comp.H1PhaseDiagram");
	
	//internal array of points used to draw the shape of the diagram
	//if is not defined as an initial parameter is calculated via the static
	//method calcPoints
	public var points:Array;
	
	//the space between points
	public var pointsInt:Number;
	
	//graph initial properties
	public var w:Number;
	public var h:Number;
	public var xAxisRange:Number;
	public var xAxisScale:Number;
	public var xAxisLabel:String;
	public var yAxisRange:Number;
	public var yAxisScale:Number;
	public var yAxisLabel:String;
	
	//separatrix
	public var separatrix:Number;
	
	//animation speed, should be the same as in other graphs if syncronization is required
	public var speed:Number;
	
	//birth death rate component
	private var bdrRange:Number;
	private var bdrx:Number;
	private var bdry:Number;
	
	//listener variables
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	/*
	 * Constructor
	 */
	public function H1PhaseDiagram(){
		
		logger.debug("instantiating H1PhaseDiagram");
		
		//init event dispatcher
		mx.events.EventDispatcher.initialize(this);
		
		//define default values if not defined via init Object
		w = (w) ? w : 940;
		h = (h) ? h : 250;
		xAxisRange = (xAxisRange) ? xAxisRange : 800;
		xAxisScale = (xAxisScale) ? xAxisScale : 100;
		xAxisLabel = (xAxisLabel) ? xAxisLabel : SussiApp.getMsg("graph.h1PhaseDiagram.xAxisLabel");
		yAxisRange = (yAxisRange) ? yAxisRange : 1;
		yAxisScale = (yAxisScale) ? yAxisScale : 2;
		yAxisLabel = (yAxisLabel) ? yAxisLabel : "";
		speed = (speed) ? speed : 3;
		pointsInt = (pointsInt==undefined) ? 1 : pointsInt;
		bdrRange = (bdrRange==undefined) ? 20 : bdrRange;
		bdrx = (bdrx==undefined) ? 845 : bdrx;
		bdry = (bdry==undefined) ? 45 : bdry;
		
		//if points not defined then run model to create them
		if (points == undefined){
			points = new Array();
			calcPoints(points, pointsInt, xAxisRange)
		}
		
		//draw diagram
		drawDiagram()
	}
	
	/*
	 * Calculate shape of the phase diagram
	 * 
	 * @param points an empty array that will be transformed into an array of objects repesenting the points
	 * of the phase diagram. The array is modified by the method to return an array of objects. 
	 * Each object has properties x and y where x represents the number of individuals (integer) 
	 * and y the height of the phase diagram at this point
	 * @param xAxisRange the range of the x-axis
	 * 
	 * @return the first separatrix if one exists. 
	 */
	public static function calcPoints(points:Array, pointsInt:Number, xAxisRange:Number):Number{
		
		//redefine xAxisRange if not defined
		xAxisRange = (xAxisRange==undefined) ? 800 : xAxisRange;
		
		//the number of points
		var nPoints:Number = Math.round(xAxisRange/pointsInt);
		
		//inverted phase diagram
		var inv:Array = new Array(nPoints);
		
		//init maximum and min value
		var maxVal:Number = 0;
		var minVal:Number = 0;
		
		//calculate first value as 0, 0
		inv[0] = new Object({x:0,y:0});
		
		//loop through popultation values calculating inverted points
		var o:Object;
		for (var i=1; i<nPoints; i++){
			inv[i] = new Object();
			inv[i].x = i*pointsInt;
			inv[i].y = inv[i-1].y+calcPopInc(i*pointsInt);
			maxVal = Math.max(maxVal, inv[i].y);
			minVal = Math.min(minVal, inv[i].y);
		}
		
		//now that we have maxVal the real array can be calculated
		var separatrix:Number;
		for (var i=0; i<nPoints; i++){
			
			//calulate point
			points[i] = new Object();
			points[i].x = inv[i].x;
			points[i].y = (maxVal-inv[i].y)/(maxVal-minVal);
			
			//check whether is separator
			if(separatrix==undefined && i>1){
				if(points[i-1].y>points[i-2].y && points[i-1].y>points[i].y){
					separatrix = points[i-1].x;
				}
			}
		}
		
		return separatrix;
	}
	
	/*
	 * Calculates the increment in population for a given number
	 * of individuals
	 * 
	 * @param p the númber of individuals
	 */
	private static function calcPopInc(p:Number):Number{
		
		//define dependent processes
		var bh1:Bh1 = Bh1(Bh1.getProcess());
		var dh1:Dh1 = Dh1(Dh1.getProcess());
		
		return p*(bh1.getBirthsByPop(p) - dh1.getDeathsByPop(p));
	}
	
	/*
	 * Draws a phase diagram using the graph component with initial graph properties
	 * 
	 * @param parentMc the parent movieclip
	 * @param id the id
	 * @param depth the depth of the new object in the parent movie clip
	 * @param graphProps an initial object to define graph properties
	 */
	public function drawDiagram(){

		//attach birth death rate component
		var bdr = this.attachMovie("birth_death_rate", "bdr", this.getNextHighestDepth(), {_x:bdrx, _y:bdry, txtBirthLevel:SussiApp.getMsg("graph.h1PhaseDiagram.birthDeathRate.birthLevel"), txtDeathLevel:SussiApp.getMsg("graph.h1PhaseDiagram.birthDeathRate.deathLevel")});

		//create initial condition text
		var initCond = Utils.createTextField("initCond", this, 1, 600, 20, 340, 20, "", null);
		initCond.setNewTextFormat(SussiApp.getTxtFormat("labelTxtFormat"));
		initCond.text = SussiApp.getMsg("graph.h1PhaseDiagram.initCond", new Array("   "));		
		
		//create diagram
		var graph:Graph = Utils.newObject(Graph, this, "graph", 2, {w:w, h:h, xAxisRange:xAxisRange, xAxisScale:xAxisScale, yAxisRange:yAxisRange, yAxisScale:yAxisScale, yAxisLabel:yAxisLabel, xAxisLabel:xAxisLabel, topPadding:40, axesDist:40});
		graph.addGraphicFromArray("graphic", 0x666666, points);
		
		//draw background
		drawEcomomicLimitBg();

		//create marbles
		createMarble();
	}
	
	/*
	 * Reads the birth and death rates from the corresponding processes and sets liquid level
	 * 
	 * @param p the population
	 * @param birthRate the birth rate
	 * @param deathRate the death rate
	 */
	public function setBirthDeathRate(p:Number, birthRate:Number, deathRate:Number):Void{

		//make sure that rates are within limits
		var births = Math.max(0, Math.min(p*birthRate, bdrRange))/bdrRange*80;
		var deaths = Math.max(0, Math.min(p*deathRate, bdrRange))/bdrRange*80;
		
		//set birth rate
		this["bdr"].birthLevel._y = 5+80-births;
		this["bdr"].birthLevel._height = births;
		
		//set death rate
		this["bdr"].deathLevel._y = 5+80-deaths;
		this["bdr"].deathLevel._height = deaths;
	}
	
	/*
	 * Draws background on graph te separate the two sides fo the economic limit
	 */
	private function drawEcomomicLimitBg():Void{

		//define separator and graph
		var graph:Graph = this["graph"]
		var sep:Number = Math.min(SUtils.getIP("fl_lim_pol"), xAxisRange);
		
		//create container clip
		var mc:GenericMovieClip = graph["bg"].createEmptyMovieClip("polinizationBg", graph["bg"].getNextHighestDepth());
		
		//define extremes
		var minY:Number = graph.topPadding;
		var maxY:Number = graph.h-graph.axesDist;
		var minX:Number = graph.axesDist+1;
		var maxX:Number = graph.w-graph.rightPadding;
		var sepX:Number = graph.getXPos(sep);
		
		//create left fill - under economic limit
		mc.beginFill(Const.COLOR_NO_POLINIZATION, 30);
		mc.moveTo(minX, minY);
		mc.lineTo(sepX, minY);
		mc.lineTo(sepX, maxY);
		mc.lineTo(minX, maxY);
		mc.lineTo(minX, minY);
		mc.endFill();
		
		//add text
		var txt:String = SussiApp.getMsg("graph.h1PhaseDiagram.region.canNotPolinate");
		var txtFormat = SussiApp.getTxtFormat("graphBgTxtFormat");
		txtFormat.color = Const.COLOR_NO_POLINIZATION;
		Utils.createTextField("tf_regionCanNotPolinate", mc, 1, 0, 0, 400, 1, txt, txtFormat);
		var txtW:Number = mc["tf_regionCanNotPolinate"]._width;
		var txtH:Number = mc["tf_regionCanNotPolinate"]._height;
		mc["tf_regionCanNotPolinate"]._x = minX + (sepX-minX-txtW)/2;
		mc["tf_regionCanNotPolinate"]._y = minY+(maxY-minY-txtH)/2;

		//if showing then create right fill - above economic limit
		if(xAxisRange>SUtils.getIP("fl_lim_pol")){
			mc.beginFill(Const.COLOR_POLINIZATION, 30);
			mc.moveTo(sepX, minY);
			mc.lineTo(maxX, minY);
			mc.lineTo(maxX, maxY);
			mc.lineTo(sepX, maxY);
			mc.lineTo(sepX, minY);
			mc.endFill();
			
			//add text
			txt = SussiApp.getMsg("graph.h1PhaseDiagram.region.canPolinate");
			txtFormat = SussiApp.getTxtFormat("graphBgTxtFormat");
			txtFormat.color = Const.COLOR_POLINIZATION;
			Utils.createTextField("tf_regionCanPolinate", mc, 2, 0, 0, 400, 1, txt, txtFormat);
			txtW = mc["tf_regionCanPolinate"]._width;
			txtH = mc["tf_regionCanPolinate"]._height;
			mc["tf_regionCanPolinate"]._x = sepX + (maxX-sepX-txtW)/2;
			mc["tf_regionCanPolinate"]._y = minY+(maxY-minY-txtH)/2;
		}
	}
	
	/*
	 * Draws and animates a marble
	 */
	private function createMarble():Void{

		//remove movie if exists
		this["graph"]["marble"].removeMovieClip();

		//create clip
		var m:GenericMovieClip = this["graph"].attachMovie("marble_1", "marble", this["graph"].getNextHighestDepth());
		m.H1pd = this;

		//position marble in center of diagram
		m._x = this["graph"]._width/2;
		m._y = 30;
		
		//add drag capabilities to marble
		m.onPress = function(){
			
			//clear any animation from marble and start drag
			delete this.onEnterFrame;
			clearInterval(this.H1pd.intvl);
			this.startDrag(true, 40+this._width/2, 40-this._height/2, this.H1pd.w-this._width/2, this.H1pd.h-40-this._height/2);
			
			//create on enter frame function
			this.onEnterFrame = function(){
				this.H1pd.setInitCond(Math.round(this.H1pd.graph.getXValue(this._x)));
			}
		}

		m.onRelease = function(){
			
			//stop drag
			this.stopDrag();
			delete this.onEnterFrame;
			
			//get values of where ball needs to be moved to in vertical dirrection to sit on curve
			var xValue:Number = Math.round(this.H1pd.graph.getXValue(this._x));
			var yValue:Number = this.H1pd.points[xValue/this.H1pd.pointsInt].y
			
			//get coordinates
			var xCoord:Number = this.H1pd.graph.getXPos(xValue);
			var yCoord:Number = this.H1pd.graph.getYPos(yValue)-10;
			
			//set new initial condition
			this.H1pd.setInitCond(xValue);
			
			//define function that begins animation
			var fnc:Function = function(animate:Boolean){
				if(animate){
					this["intvl"] = setInterval(Proxy.create(this, this.animateMarble), 500);
				}else{
					this.dispatchEvent({type:"equilibrium", target:this});
				}
			}
			
			//glide the marble onto the curve
			//if the marble is in the separator do not animate
			//otherwise call animation function
			//if(xValue == this.H1pd.separatrix){
				//this.glideTo(xCoord, yCoord, 5, Proxy.create(this.H1pd, fnc, false));
			//}else{
				this.glideTo(xCoord, yCoord, 5, Proxy.create(this.H1pd, fnc, true));
			//}
			
		}
	}
	
	/*
	 * Sets new initial condition
	 * 
	 * @param ini the new initial condition
	 */
	public function setInitCond(ini:Number):Void{
		
		//reset model
		SUtils.setIP("h1_ini", ini);
		SUtils.clearOutputs();
		
		//update text field
		var prms:Array = new Array(1);
		prms[0] = String(ini);
		this["initCond"].text = SussiApp.getMsg("graph.h1PhaseDiagram.initCond", prms);
	}
	
	/*
	 * Starts animating marble and dispaches event "animate"
	 */
	public function animateMarble():Void{
		
		//clear interval
		clearInterval(this["intvl"]);
		
		//get marble
		var m:GenericMovieClip = this["graph"].marble;
		
		//stop any dragging etc
		m.stopDrag();
		delete m.onEnterFrame;
		
		//define useful dynamic properties used in function
		m.cnt = 0;
		
		//define animation function
		m.onEnterFrame = function(){
			
			if(this.cnt*this.H1pd.speed<52*Const.PROC_YEARS_LIMIT){
	
				//get new population
				var p:Number = Ph1.getProcess().getOutput(this.cnt*this.H1pd.speed);
				
				//save old position
				var oldX:Number = this._x;
				var oldY:Number = this._y;

				//reposition marble
				this.H1pd.posMarble(this, p);

				//calculate distance moved
				var dist = Math.sqrt(Math.pow(this._x-oldX,2)+Math.pow(this._y-oldY,2))

				//calculate rotation
				var rotation = dist/(2*Math.PI*this._width)*180
				this._rotation = (this._x>oldX) ? this._rotation+rotation : this._rotation-rotation;
				
				//update birth and death rates
				this.H1pd.setBirthDeathRate(p, Bh1.getProcess().getOutput(this.cnt*this.H1pd.speed), Dh1.getProcess().getOutput(this.cnt*this.H1pd.speed))

			}else{
				delete this.onEnterFrame;
			}

			this.cnt++;
		}
		
		dispatchEvent({type:"animate", target:this});
	}
	
	/*
	 * Positions a marble along the curve acording to the population
	 *
	 * @param marble the marble movie clip to be positioned
	 * @param pop the population level
	 *
	 */
	public function posMarble(marble, p:Number):Void{

		var pointInd:Number = Math.round(p/pointsInt);
		
		if(pointInd>this.points.length){
			pointInd = this.points.length-1;
		}
		
		//get position of current point
		var currX = this.points[pointInd].x;
		var currY = this.points[pointInd].y;

		//move to new position
		marble._x = this["graph"].getXPos(currX);
		marble._y = this["graph"].getYPos(currY)-10;
	}
//	
	///*
	 //* Updates the phase diagram
	 //*/
	//public function update():Void{
//		
		////calculate points for diagram if not already calculated
		//if(this.points.length<this.nPoints){
			//calcPoints();
		//}
//		
		////update graphic if exists
		//if(this.diagram){
			//this.diagram.update();
			//createMarble("high");
			//createMarble("low");
		//}
//		
	//}
}