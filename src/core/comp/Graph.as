import ascb.util.logging.Logger;
/*
 * Graph drawing component
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 27-06-2005
 */
class core.comp.Graph extends core.util.GenericMovieClip {
	//logger
	public static var logger:Logger = Logger.getLogger("core.comp.Graph");
	//the width of the graph
	public var w:Number = 460;
	//the height of the graph
	public var h:Number = 260;
	//the width of the x-axis
	public var xAxisWidth:Number;
	//the height of the y-axis
	public var yAxisHeight:Number;
	//the text label for the x axis
	public var xAxisLabel:String = "";
	//the text label for the y axis
	public var yAxisLabel:String = "";
	//the range of the x-axis
	public var xAxisRange:Number = 200;
	//the range of the y-axis
	public var yAxisRange:Number = 100;
	//the scale of markers on the x-axis
	public var xAxisScale:Number;
	//the scale of markers on the y-axis
	public var yAxisScale:Number;
	//the color of the axies
	public var lineColor:Number = 0x996633;
	//distance between axes and edge of bg clip
	public var axesDist:Number = 50;
	//distance between graph and top of clip
	public var topPadding:Number = 10;
	//distance between graph and right of clip
	public var rightPadding:Number = 10;
	//length of axis markers
	public var markerHeight:Number = 5;
	//text format for axis markers
	public var tfAxisMarkers:TextFormat;
	//text format for the axis literals
	public var tfAxisLit:TextFormat;
	//text format for rollover text for points
	public var tfPointRollOver:TextFormat;
	//flag that defines whether a border is drawn around the graph
	public var drwBorder:Boolean = false;
	//the initial x value
	public var xInit:Number = 0;
	//an array of graphics
	public var graphics:Array;
	//an array of limits
	public var limits:Array;
	//boolean flag that when true draws the expand button
	public var btnExpnd:Boolean = false;

	/*
	 * Constructor
	 */
	public function Graph() {
		
		//initialize internal variables
		this.graphics  = new Array();
		this.limits = new Array();
		this.xAxisWidth = this.w-this.rightPadding-this.axesDist;
		this.yAxisHeight = this.h-this.topPadding-this.axesDist;
		
		//create sub movie clips, one for background and another for the graphics
		this.createEmptyMovieClip("bg", 1);
		var graphicsCont = this.createEmptyMovieClip("graphicsCont", 2);

		//create mask clip for graphics
		graphicsCont.createEmptyMovieClip("mask", 1);
		graphicsCont["mask"].moveTo(this.axesDist+1, this.topPadding);
		graphicsCont["mask"].beginFill(0x000000, 100);
		graphicsCont["mask"].lineTo(this.xAxisWidth+this.axesDist+1, this.topPadding);
		graphicsCont["mask"].lineTo(this.xAxisWidth+this.axesDist+1, this.topPadding+this.yAxisHeight);
		graphicsCont["mask"].lineTo(this.axesDist+1, this.topPadding+this.yAxisHeight);
		graphicsCont["mask"].lineTo(this.axesDist+1, this.topPadding);
		graphicsCont["mask"].endFill();
		graphicsCont.setMask(graphicsCont["mask"]);

		//define text formats if they have not been defined via the init object
		if (this.tfAxisMarkers == null) {
			this.tfAxisMarkers = new TextFormat();
			this.tfAxisMarkers.color = 0x996633;
			this.tfAxisMarkers.font = "Arial";
			this.tfAxisMarkers.size = 10;
		}
		if (this.tfAxisLit == null) {
			this.tfAxisLit = new TextFormat();
			this.tfAxisLit.color = 0x996633;
			this.tfAxisLit.font = "Arial";
			this.tfAxisLit.size = 12;
			this.tfAxisLit.align = "center";
		}
		if (this.tfPointRollOver == null) {
			this.tfPointRollOver = new TextFormat();
			this.tfPointRollOver.color = 0x996633;
			this.tfPointRollOver.font = "Arial";
			this.tfPointRollOver.size = 10;
		}
		
		//create background
		createBackground();
	}

	/*
	 * Draws the background for the graph
	 */
	private function createBackground() :Void{
		
		//create container clip
		var bg = this["bg"];
		bg.lineStyle(1, this.lineColor, 100);
		
		//create x-axis
		bg.moveTo(0+this.axesDist, this.yAxisHeight+this.topPadding);
		bg.lineTo(this.xAxisWidth+this.axesDist, this.yAxisHeight+this.topPadding);
		
		//draw x-axis markers
		var currX:Number = this.axesDist;
		var i:Number = 0;
		var tfId:String;
		if(this.xAxisScale){			
			while (Math.round(currX)<=this.xAxisWidth+this.axesDist) {
				//create marker line
				bg.moveTo(currX, this.yAxisHeight+this.topPadding);
				bg.lineTo(currX, this.yAxisHeight+this.topPadding+this.markerHeight);
				//create text box
				tfId = "tfx_"+String(i);
				bg.createTextField(tfId, bg.getNextHighestDepth(), 0, this.yAxisHeight+this.topPadding+this.markerHeight+1, 200, 20);
				bg[tfId].text = String(i*this.xAxisScale+this.xInit);
				bg[tfId].setTextFormat(this.tfAxisMarkers);
				bg[tfId].autoSize = true;
				bg[tfId].embedFonts = true;
				bg[tfId]._x = currX-bg[tfId]._width/2;
				currX += this.xAxisWidth/(this.xAxisRange-this.xInit)*this.xAxisScale;
				i++;
			}
		}
		
		//draw x-axis literal
		bg.createTextField("x_label", bg.getNextHighestDepth(), this.axesDist, 0, this.xAxisWidth, 20);
		bg["x_label"].text = this.xAxisLabel;
		bg["x_label"].setTextFormat(this.tfAxisLit);
		bg["x_label"].embedFonts = true;
		bg["x_label"]._y = this.yAxisHeight+this.topPadding+this.axesDist-bg["x_label"]._height;
		
		//create y-axis
		bg.moveTo(0+this.axesDist, this.yAxisHeight+this.topPadding);
		bg.lineTo(0+this.axesDist, this.topPadding);
		
		//draw y-axis markers
		var currY:Number = this.yAxisHeight+this.topPadding;
		var yInc:Number = this.yAxisHeight/this.yAxisRange*this.yAxisScale;
		i = 0;
		if(this.yAxisScale){	
			while (Math.round(currY)>=this.topPadding) {
				//create marker line
				bg.moveTo(this.axesDist, currY);
				bg.lineTo(this.axesDist-this.markerHeight, currY);
				//create text box
				tfId = "tfy_"+String(i);
				bg.createTextField(tfId, bg.getNextHighestDepth(), 0, currY, 200, 20);
				bg[tfId].text = String(i*this.yAxisScale);
				bg[tfId].setTextFormat(this.tfAxisMarkers);
				bg[tfId].autoSize = true;
				bg[tfId].embedFonts = true;
				bg[tfId]._x = this.axesDist-this.markerHeight-bg[tfId]._width-1;
				bg[tfId]._y = currY-bg[tfId]._height/2;
				currY -= yInc;
				i++;
			}
		}
		
		//draw y-axis literal
		bg.createTextField("y_label", bg.getNextHighestDepth(), 0, this.yAxisHeight+this.topPadding, this.yAxisHeight+this.topPadding, 20);
		bg["y_label"].text = this.yAxisLabel;
		bg["y_label"].setTextFormat(this.tfAxisLit);
		bg["y_label"].align = "center";
		bg["y_label"].embedFonts = true;
		bg["y_label"]._rotation = -90;

		//draw border
		if (this.drwBorder){
			bg.moveTo(0,0);
			bg.lineTo(this.w, 0);
			bg.lineTo(this.w, this.h);
			bg.lineTo(0, this.h);
			bg.lineTo(0,0);
		}
	}
	
	/*
	 * Adds a limit line to the background of the graph. When the user passes over the line
	 * with the mouse its title is shown
	 * 
	 * @param id the id of the limit
	 * @param titleTxt the title text of the limit
	 * @param startY the initial y value of the line
	 * @param finY the final y value of the line
	 * @param color the color of the line
	 */
	public function addLimit(id:String, titleTxt:String, startY:Number, endY:Number, col:Number){
		
		//create new limit
		this.limits.push(new Object({id:id, titleTxt:titleTxt, startY:startY, endY:endY, col:col}));
		
		//if start and end points are defined then draw limit
		if(startY && endY){
			drawLimit(this.limits[this.limits.length-1]);
		}
	}
	
	/*
	 * Draws a limit
	 * 
	 * @param limit the limit object to draw
	 */
	private function drawLimit(limit:Object){
		
		//draw limit
		var limitMc:MovieClip = this["bg"].createEmptyMovieClip(limit.id, this["bg"].getNextHighestDepth());
		limitMc._x = getXPos(this.xInit);
		limitMc._y = getYPos(limit.startY);
		limitMc._alpha = 50;
		limitMc.lineStyle(1, limit.col, 100);
		limitMc.lineTo(getXPos(this.xAxisRange)-limitMc._x, getYPos(limit.endY)-limitMc._y);
		
		//add rollover functionality
		limitMc.limit = limit;
		limitMc.onRollOver = function(){
			
			//define graph
			var graph = this._parent._parent;

			//strech line in y direction
			this._yscale = 300;
			this.alphaTo(100,3);

			//create message clip
			var msg = graph.createEmptyMovieClip("msg", graph.getNextHighestDepth());

			//draw text
			msg.createTextField("tf", 2, 0, 0, 1, 1);
			msg["tf"].text = this.limit.titleTxt;
			graph.tfPointRollOver.color = this.limit.col;
			msg["tf"].setTextFormat(graph.tfPointRollOver);
			msg["tf"].autoSize = true;
			msg["tf"].selectable = false;
			msg["tf"].embedFonts = true;

			//draw background
			msg.lineStyle(1, this.limit.col, 100);
			msg.beginFill(0xffffff, 100);
			msg.lineTo(msg["tf"]._width, 0);
			msg.lineTo(msg["tf"]._width, msg["tf"]._height);
			msg.lineTo(0, msg["tf"]._height);
			msg.lineTo(0, 0);
			msg.endFill();
			
			//position message
			msg._x = graph.getXPos(graph.xInit+(graph.xAxisRange-graph.xInit)/2)-msg._width/2;
			msg._y = graph.getYPos((this.limit.startY+this.limit.endY)/2)-msg._height
			
		}
		
		//on roll out remove the message clip
		limitMc.onRollOut = function(){
			this._yscale = 100;
			this.alphaTo(50,3);
			this._parent._parent.msg.removeMovieClip();
		}
	}

	/*
	 * Adds a graphic defined by a function to the graph
	 * 
	 * @param _id the id of the graphic
	 * @param _color the hexidecimal color of the graphic, eg 0xffffff
	 * @param _callBackObj the object to call in order to generate new points for the graphic
	 * @param _callBackFunc the function to call on the callBackObj to generate new points for the graphic
	 * @param _xInc the increment on the x-axis between points
	 * @param _segPerFrame the number of segments per frame that should be drawn when the graph is initialized. Giving this
	 * parameter a value causes the graph to be initialized as an animation, if this parameter is set to null all segments
	 * of the graph are initialized at once
	 * @param _pointRadius when greater than 0 points recording each value are drawn with this radius, when the mouse rolls over 
	 * the point its values are shown
	 * @param noInit when true does not draw the graphic until the graph is updated
	 * @param _pointFrequency draws rollover points each time that _xInc % _pointFrequency == 0 
	 */
	public function addGraphicFromFunc(_id:String, _color:Number, _callBackObj:Object, _callBackFunc:Function, _xInc:Number, _segPerFrame:Number, _pointRadius:Number, noInit:Boolean, _pointFrequency:Number, _pointModulo:Number):Void {
		
		//define point frequency and point modulo if not defined
		_pointFrequency = (_pointRadius>0 && !_pointFrequency) ? 1 :_pointFrequency;
		_pointModulo = (_pointModulo) ? _pointModulo : 0;
		
		//calculate points and save graphic
		var graphic:Object = new Object({id:_id, type:"function", color:_color, callBackObj:_callBackObj, callBackFunc:_callBackFunc, xInc:_xInc, segPerFrame:_segPerFrame, pointRadius:_pointRadius, pointFrequency:_pointFrequency, pointModulo:_pointModulo, liftPencil:true});
		this.graphics[this.graphics.length] = graphic;
		
		//draw graphic
		if (!noInit){
			calculatePoints(graphic);
			drawGraphic(this.graphics.length-1, 0);
		}
	}
	
	/*
	 * Adds a graphic defined by an array of objects. The objects must each have an "x" property and "y" property.
	 * 
	 * @param _id the id of the graphic
	 * @param _color the hexidecimal color of the graphic, eg 0xffffff
	 * @param _points the array of objects that define the points of the graph
	 * @param _segPerFrame the number of segments per frame that should be drawn when the graph is initialized. Giving this
	 * parameter a value causes the graph to be initialized as an animation, if this parameter is set to null all segments
	 * of the graph are initialized at once
	 * @param _pointRadius when greater than 0 points recording each value are drawn with this radius, when the mouse rolls over 
	 * the point its values are shown
	 * @param noInit when true does not draw the graphic until the graph is updated
	 * @param _pointFrequency draws rollover points each time that _xInc % _pointFrequency == 0 
	 */
	public function addGraphicFromArray(_id:String, _color:Number, _points:Array, _segPerFrame:Number, _pointRadius:Number, noInit:Boolean, _pointFrequency:Number, _pointModulo:Number):Void {
		
		//define point frequency and point modulo if not defined
		_pointFrequency = (_pointRadius>0 && !_pointFrequency) ? 1 :_pointFrequency;
		_pointModulo = (_pointModulo) ? _pointModulo : 0;
				
		//save graphic
		var graphic:Object = new Object({id:_id, type:"array", color:_color, points:_points, segPerFrame:_segPerFrame, pointRadius:_pointRadius, pointFrequency:_pointFrequency, pointModulo:_pointModulo, liftPencil:true});
		this.graphics[this.graphics.length] = graphic;
		
		//draw graphic
		if (!noInit){
			drawGraphic(this.graphics.length-1, 0);
		}
	}
	
	/*
	 * Removes the graphic defined by the corresponding id
	 * 
	 * @param _id the id of the graphic
	 */
	public function removeGraphic(_id:String):Void {
		
		for (var i=0; i<this.graphics.length; i++){
			if(this.graphics[i].id == _id){
				this["graphicsCont"][_id].removeMovieClip();
				this.graphics.splice(i, 1);
				return;
			}
		}
	}
	
	/*
	 * Redraws the graphics of the graph
	 * 
	 * @param animateFrom an x value or array index below which animation is not required
	 */
	public function update(animateFrom:Number):Void{
		
		//loop through graphics redrawing each one
		for (var i=0; i<graphics.length; i++){
			
			//for function type graphics convert to array
			if (graphics[i].type == "function"){
				
				//redefine animate from to array index
				if (!isNaN(animateFrom)){
					animateFrom = Math.floor((animateFrom-this.xInit)/graphics[i].xInc);
				}
				
				//calculate array of points
				calculatePoints(graphics[i]);
			}
			
			//define animate from if not previously defined
			if (!animateFrom || isNaN(animateFrom)){
				animateFrom = 0;
			}
			
			//lift pencil to begin and draw graphic
			graphics[i].liftPencil = true;
			drawGraphic(i, animateFrom);
		}
	}
	
	/*
	 * Redraws a limit
	 * 
	 * @param id the id of the limit
	 */
	public function updateLimit(id:String, startY:Number, endY:Number):Void{
		
		//remove old limit
		if (this["bg"][id]){
			this["bg"][id].removeMovieClip();
		}
		
		//if startY and endY are not numbers then retun
		if (isNaN(startY) || isNaN(endY)){
			return;
		}
		
		//find limit and redraw
		for(var i=0; i<this.limits.length; i++){
			if (this.limits[i].id == id){
				this.limits[i].startY = startY;
				this.limits[i].endY = endY;
				drawLimit(this.limits[i])
			}
			
		}
		
	}
	
	/*
	 * Calculates the sequence of points that comprise the graphic. The 
	 * points are stored in the "points" property of the graphic object
	 * 
	 * @param graphic the graphic for which to calculatethe points
	 */
	private function calculatePoints(graphic:Object):Void{
		
		//initialize points array
		var l:Number = Math.floor((this.xAxisRange-this.xInit)/graphic.xInc)+1;
		var points:Array = new Array(l);
		
		//calculate first point
		var prms = new Array(1);
		var xcoord:Number = this.xInit;
		prms[0] = xcoord;
		var ycoord:Number = graphic.callBackFunc.apply(graphic.callBackObj, prms);
		points[0] = new Object({x:xcoord, y:ycoord});

		//calculate all other points
		for (var i=1; i<l; i++){
			xcoord += graphic.xInc;
			prms[0] = xcoord;
			ycoord = graphic.callBackFunc.apply(graphic.callBackObj, prms);
			points[i] = new Object({x:xcoord, y:ycoord});
		}

		//save points
		graphic.points = points;
	}
	
	/*
	 * Draws a graphic
	 * 
	 * @param i the index of the graphic
	 * @param animateFrom an x value or array index below which animation is not required
	 */
	private function drawGraphic(ind:Number, animateFrom:Number){
		
		//define graphic
		var graphic = graphics[ind];
		
		//erase the graphic
		eraseGraphic(graphic.id);
		
		//create graphic clip
		var graphicMc = this["graphicsCont"].createEmptyMovieClip(graphic.id, ind);
		
		//define line style
		graphicMc.lineStyle(1, graphic.color, 100);
		
		//draw points until animate from
		for (var i = 0; i<animateFrom; i++) {
			this.drawPoint("pnt_"+graphic.id + "_" + String(i), graphicMc, graphic, graphic.points[i].x, graphic.points[i].y);
		}

		//if segments per frame is defined then animate the graphic
		//else draw it all at once
		if (graphic.segPerFrame && graphic.segPerFrame>0) {
			
			//attach graphic and graph reference to graphicMc
			graphicMc.graph = this;
			graphicMc.graphic = graphic;
	
			//define the current step
			graphicMc.currStep = animateFrom;
			
			//define on enter frame function to draw varios segments of the graph in each frame
			graphicMc.onEnterFrame = function() {
				
				//coordinates and positions
				var xcoord:Number;
				var ycoord:Number;
				
				//boolean value that draws point or not
				var drawPointRadius:Boolean;
				
				//draw all segments for this frame
				for (var i = 0; i<this.graphic.segPerFrame; i++) {

					//if there are more points to draw draw the next one
					//else remove onEnterFrame and set i so that for ends
					if (this.currStep<this.graphic.points.length) {
						
						//define coordintates
						xcoord = this.graphic.points[this.currStep].x;
						ycoord = this.graphic.points[this.currStep].y;
						
						//define drawPointRadius
						drawPointRadius = false;
						if (this.currStep >= this.graphic.pointModulo){
							drawPointRadius = ((this.currStep - this.graphic.pointModulo) % this.graphic.pointFrequency)== 0;
						}
						
						//draw point
						this.graph.drawPoint("pnt_"+this.graphic.id + "_" + String(this.currStep), this, this.graphic, xcoord, ycoord, drawPointRadius);
						
						//increment current step
						this.currStep++;
						
					} else {
						delete this.onEnterFrame;
						i = this.segPerFrame;
					}
				}
			};
		} else {
			for (var i = animateFrom; i<graphic.points.length; i++) {
				this.drawPoint("pnt_"+graphic.id + "_" + String(i), graphicMc, graphic, graphic.points[i].x, graphic.points[i].y, (i % graphic.pointFrequency == 0));
			}
		}
	}
	
	/*
	 * Erases the graphic
	 * 
	 * @param id the id of the graphic
	 */
	public function eraseGraphic(id:String):Void{
		if (this["graphicsCont"][id]){
			this["graphicsCont"][id].removeMovieClip();
		}
		this["msg"].removeMovieClip();
	}
	
	/*
	 * Given the x-coordinate of a graphic this function translates it into the
	 * x-position of the coordinate relative this (Graph) movie clip
	 * 
	 * @param xcoord the xcoordinate to translate
	 * @return the x position relative to the graph MovieClip
	 */
	public function getXPos(xcoord:Number):Number{
		return (this.axesDist + this.xAxisWidth*(xcoord-this.xInit)/(this.xAxisRange-this.xInit));
	}
	
	/*
	 * Given the y-coordinate of a graphic this function translates it into the
	 * t-position of the coordinate relative this (Graph) movie clip
	 * 
	 * @param xcoord the y-coordinate to translate
	 * @return the y position relative to the graph MovieClip
	 */
	public function getYPos(ycoord:Number):Number{
		return (this.topPadding + this.yAxisHeight - this.yAxisHeight*ycoord/this.yAxisRange);
	}

	/*
	 * Given the x-position in the graph this function translates it into the
	 * value of the x-coordinate of the graph
	 * 
	 * @param xpos the x position to translate
	 * @return the x coordinate
	 */
	public function getXValue(xPos:Number):Number{
		return (xPos-this.axesDist)/this.xAxisWidth*this.xAxisRange;
	}
	
	/*
	 * Given the y-position in the graph this function translates it into the
	 * value of the y-coordinate of the graph
	 * 
	 * @param yPos the y position to translate
	 * @return the y coordinate
	 */
	public function getYValue(yPos:Number):Number{
		return (this.yAxisHeight+this.topPadding-yPos)/this.yAxisHeight*this.yAxisRange;
	}
		
	/*
	 * Draws a point at the coordinates specified in the corresponding  graphic MovieClip.
	 * When the user passes over this point with the mouse information about the coordinates
	 * is shown
	 * 
	 * @param id the id of the point clip
	 * @param graphicMc the movie clip to draw the points in
	 * @param graphic the graphic asociated with the points
	 * @param xcoord the xcoordinate
	 * @param ycoord the ycoordinate
	 * @param drawPointRadius when true draws a circle around the point that when passed over
	 * with the mouse shows the coordinates of the point
	 */
	private function drawPoint(id:String, graphicMc:MovieClip, graphic, xcoord:Number, ycoord:Number, drawPointRadius:Boolean):Void{
		
		//if point is not defined then lift pencil and return
		if(xcoord == null || ycoord == null){
			graphic.liftPencil = true;
			return;
		}
		
		//calculate positions
		var xpos:Number = getXPos(xcoord);
		var ypos:Number = getYPos(ycoord);
		
		//if pencil is lifted then move to point
		//else draw line to point
		if (graphic.liftPencil == true){
			graphicMc.moveTo(xpos, ypos);
		}else{
			graphicMc.lineTo(xpos, ypos);
		}
		
		//redefine lift pencil
		graphic.liftPencil = false;
		
		//draw point radius
		if (drawPointRadius){
		
			//create point clip
			var pnt:MovieClip = graphicMc.createEmptyMovieClip(id, graphicMc.getNextHighestDepth());
			
			//draw point
			pnt.lineStyle(1, graphic.color, 100);
			pnt.beginFill(graphic.color, 10);
			pnt.drawCircle(xpos, ypos, graphic.pointRadius, 10);
			pnt.xcoord = xcoord;
			pnt.ycoord = ycoord;
			pnt.xpos = xpos;
			pnt.ypos = ypos;
			pnt.graphic = graphic;
			
			//on rollover create msg clip
			pnt.onRollOver = function(){
				
				//define graph
				var graph = this._parent._parent._parent;
				
				//create message clip
				var msg = graph.createEmptyMovieClip("msg", graph.getNextHighestDepth());
				
				//draw text
				msg.createTextField("tf", 2, 0, 0, 1, 1);
				msg["tf"].text = String(this.xcoord)+",   "+String(this.ycoord);
				graph.tfPointRollOver.color = this.graphic.color;
				msg["tf"].setTextFormat(graph.tfPointRollOver);
				msg["tf"].autoSize = true;
				msg["tf"].selectable = false;
				msg["tf"].embedFonts = true;
				
				//draw background
				msg.lineStyle(1, this.graphic.color, 100);
				msg.beginFill(0xffffff, 100);
				msg.lineTo(msg["tf"]._width, 0);
				msg.lineTo(msg["tf"]._width, msg["tf"]._height);
				msg.lineTo(0, msg["tf"]._height);
				msg.lineTo(0, 0);
				msg.endFill();
				
				//position message
				msg._x = this.xpos-msg._width/2;
				msg._y = this.ypos-msg._height;
				
			}
			
			//on roll out remove the message clip
			pnt.onRollOut = function(){
				this._parent._parent._parent.msg.removeMovieClip();
			}
		}
	}
	  

}
