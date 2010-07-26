import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.utils.LUtils;
import core.comp.Graph;

/*
 * Phase diagram component
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 19-07-2005
 */
 class lindissima.comp.lakeModel.LMPhaseDiagram {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.lakeModel.LMPhaseDiagram");
	
	//internal array of points
	public var points:Array;
	
	//the increment between points
	private var inc:Number = 0.1;
	
	//the maximum value of the concentration of weeds
	private var cMax:Number = 30;
	
	//the number of points to draw
	private var nPoints:Number;
	
	//the maximum value of the points
	private var maxVal:Number;
	
	//the value of the separator
	private var sep:Number;
	
	//the value of nitrogen
	private var nLevel:Number;
	
	//reference to graph object
	private var diagram:Graph;
	
	//reference to component hosting the phase diagram
	public var parentComp:Object;
	public var segPerFrame:Number;
	 
	/*
	 * Constructor
	 */
	public function LMPhaseDiagram(){
		
		//calculate number of points
		 this.nPoints = cMax/inc;
		 
		 //initialize internal parameters
		 this.points = new Array();
	}
	
	/*
	 * Calculate phase diagram values
	 * 
	 * @param cMax the maximum value of concentration of weeds
	 * @param n the level of nitrogen in the lake
	 * 
	 * @return an array of objects. Each object has properties x and y
	 * where x represents the amount of nitrogen and y the height of the 
	 * phase diagram at this point
	 */
	public function calcPoints(){
		
		//inverted phase diagram
		var inv:Array = new Array(this.nPoints);
		this.points.splice(0);
		
		//init maximum value
		this.maxVal= 0;
		
		//init separator
		this.sep = null;
		
		//calculate first value as 0, 0
		inv[0] = new Object({x:0,y:0});
		
		//loop through weed concentration values calculating inverted points
		var o:Object;
		for (var i=1; i<this.nPoints; i++){
			inv[i] = new Object();
			inv[i].x = i*this.inc;
			inv[i].y = inv[i-1].y+this.calcIncWeeds(inv[i-1].x);
			maxVal = Math.max(this.maxVal, inv[i].y);
		}
		
		//now that we have maxVal the real array can be calculated
		maxVal++;
		for (var i=1; i<this.nPoints; i++){
			
			//calulate point
			this.points[i] = new Object();
			this.points[i].x = inv[i].x;
			this.points[i].y = this.maxVal-inv[i].y;
			
			//check if point is separator
			if (i<nPoints-1 && inv[i-1].y>inv[i].y && inv[i+1].y>inv[i].y){
				this.sep = this.points[i].x;
			}
			
		}
	}
	
	/*
	 * Calculates the increment in weed concentration given an previous value and
	 * the concentration of nitrogen
	 * 
	 * @param weedPrev the previous concentration of weeds
	 */
	private function calcIncWeeds(weedPrev:Number):Number{
		
		var nTerm:Number = this.nLevel/(this.nLevel+LUtils.getIP("fnva_hn"));
		var hap:Number = Math.pow(LUtils.getIP("fnva_ha"), LUtils.getIP("fnva_P"));
		var veg:Number = hap/(Math.pow(weedPrev, LUtils.getIP("fnva_P"))+hap);
		var hv:Number = LUtils.getIP("fnva_hv");
		
		return LUtils.getIP("fnva_r")*weedPrev*nTerm*hv/(hv+veg)-LUtils.getIP("fnva_c")*Math.pow(weedPrev, 2);
	}
	
	/*
	 * Gets the weed concentration that corresponds to the separator for the current nitrogen level
	 */
	public function getSeparator(){
		
		if(this.points.length<this.nPoints){
			calcPoints();
		}
		
		return this.sep;
	}
	
	/*
	 * Sets the level of nitrogen
	 * 
	 * @param nLevel the new level of nitrogen
	 */
	public function setNLevel(nLevel:Number):Void{
		this.nLevel = nLevel
	}
	
	/*
	 * Resets the component
	 */
	public function reset():Void{
		this.points.splice(0);
		this.nLevel = null;
		this.sep = null;
	}
	
	/*
	 * Draws a phase diagram using the graph component with initial graph properties
	 * 
	 * @param parentMc the parent movieclip
	 * @param id the id
	 * @param depth the depth of the new object in the parent movie clip
	 * @param graphProps an initial object to define graph properties
	 */
	public function drawDiagram(parentMc, id:String, depth:Number, graphProps:Object){
		
		//calculate points for diagram if not already calculated
		if(this.points.length<this.nPoints){
			calcPoints();
		}
		
		//create diagram
		this.diagram = Utils.newObject(Graph, parentMc, id, depth, graphProps);
		this.diagram.addGraphicFromArray("graphic", 0x666666, this.points, 0, 0, false);
		LUtils.addClearTurbidBg(this.diagram, "vertical");

		//create marbles
		createMarble("high");
		createMarble("low");
	}
	
	/*
	 * Draws and animates a marble
	 * 
	 * @param initCond valid values are "high" and "low"
	 */
	private function createMarble(initCond:String):Void{

		//remove movie if exists
		if(this.diagram["marble_"+initCond]){
			this.diagram["marble_"+initCond].removeMovieClip();
		}
		
		//define level and create clip
		var nLevel:Number;
		var m;
		if(initCond=="high"){
			nLevel =  LUtils.getIP("algasIniAlta");
			m= this.diagram.attachMovie("marble_2", "marble_"+initCond, this.diagram.getNextHighestDepth(), {_alpha:100});
		}else{
			nLevel = LUtils.getIP("algasIniBaja");
			m= this.diagram.attachMovie("marble_1", "marble_"+initCond, this.diagram.getNextHighestDepth(), {_alpha:100});
		}
		
		//position marble
		posMarble(m, nLevel);
		
		//create sycronized animation for marble
		m.LMpd = this;
		m.initCond = initCond;
		m.cnt = 0;
		m.onEnterFrame = function(){
			if(this.LMpd.segPerFrame*this.cnt<365){
				
				//calculate new nitrogen level
				var n:Number;
				if (this.initCond == "high"){
					n = Utils.roundNumber(this.LMpd.parentComp.getMirkyPoint(this.LMpd.segPerFrame*this.cnt),1);
				}else{
					n = Utils.roundNumber(this.LMpd.parentComp.getClearPoint(this.LMpd.segPerFrame*this.cnt),1);
				}
				
				//save old position
				var oldX:Number = this._x;
				var oldY:Number = this._y;
				
				//reposition marble
				this.LMpd.posMarble(this, n);
				
				//calculate distance moved
				var dist = Math.sqrt(Math.pow(this._x-oldX,2)+Math.pow(this._y-oldY,2))

				//calculate rotation
				var rotation = dist/(2*Math.PI*this._width)*180
				this._rotation = (this._x>oldX) ? this._rotation+rotation : this._rotation-rotation;
				
			}else{
				delete this.onEnterFrame;
			}
			this.cnt++;
		}
	}
	
	/*
	 * Positions a marble acording to a value of nitrogen
	 * 
	 * @param marble the marble movie clip to be positioned
	 * @param n the level of nitrogen
	 * 
	 */
	public function posMarble(marble, n:Number):Void{
		
		//get position of current point
		var currX = this.points[n/this.inc].x;
		var currY = this.points[n/this.inc].y;		
		
		//move to new position
		marble._x = this.diagram.getXPos(currX);
		marble._y = this.diagram.getYPos(currY)-10;
	}
	
	/*
	 * Updates the phase diagram
	 */
	public function update():Void{
		
		//calculate points for diagram if not already calculated
		if(this.points.length<this.nPoints){
			calcPoints();
		}
		
		//update graphic if exists
		if(this.diagram){
			this.diagram.update();
			createMarble("high");
			createMarble("low");
		}
		
	}
}