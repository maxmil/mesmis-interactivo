import ascb.util.logging.Logger;
import core.comp.EmergingText;
import core.comp.RainingText;
import core.comp.BubbleBtn;
import core.util.GenericMovieClip;
import core.util.Proxy;
import core.util.Utils;
import intro.IntroApp;

/* Photo grid component. Should be linked to photoGrid movieClip to produce a
 * flickering grid of photos.
 * 
 * 
 * @author Max Pimm
 * @created 17-10-2005
 * @version 1.0
 */
 class intro.comp.MesmisPhotoGrid extends GenericMovieClip {
	 
	//logger
	public static var logger:Logger = Logger.getLogger("intro.comp.MesmisPhotoGrid");
	
	//array of grid squares
	private var gsArray:Array;
	
	//array of indexes currently showing
	private var nowShowing:Array;
	
	//coordinates of grid
	private var gridX:Number;
	private var gridY:Number;
	
	//size of photo
	private var photoLength:Number;
	
	//dimensions (in photos) of the grid
	private var _size:Number;
	
	//interval between changing photos in frames
	private var interval:Number;
	
	//the speed that the photos are faded when swapping (in frames)
	private var fadeSpeed:Number;
	
	//current step in the animation
	private var currStep:Number;
	
	//the interval between steps, redefined by each step
	private var stepInt:Number
	
	//text format for background messages
	private var txtFormat:TextFormat;
	
	/*
	 * Constructor
	 */
	public function MesmisPhotoGrid(){
		
		//define initial variables
		gridX = 230;
		gridY = 110;
		photoLength = 125;
		_size = 4;
		interval = 7;
		fadeSpeed = 10;
		currStep = 0;
		gsArray = new Array(_size*_size);
		nowShowing = new Array(_size*_size);
		
		//init text format
		txtFormat = new TextFormat();
		txtFormat.font = "Arial Bold";
		txtFormat.size = 24;
		txtFormat.color = 0xffffff;
		
		
		
		//create container clips
		this.createEmptyMovieClip("gridSquares", this.getNextHighestDepth());
		this.createEmptyMovieClip("fg", this.getNextHighestDepth());
		
	}
	
	/*
	 * Initializes the array of grid sqares
	 */
	private function initGridSquares():Void{
		
		var initObj:Object;
		var gridSquares = this["gridSquares"];
		drawGrid(this["gridSquares"], 0xffffff, false);
		for (var i=0; i<16; i++){
			this["gs_"+String(i+1)]._visible = false;
			initObj = new Object();
			initObj._x = gridX + photoLength*(i%_size);
			initObj._y = 110 + photoLength*Math.floor(i/_size);
			var gs = gridSquares.attachMovie("gridSquare_"+String(i+1), "gridSquare_"+String(i)+"_"+String(i), i, initObj);
			gsArray[i] = gs;
			nowShowing[i] = i;
		}
	}
	
	/*
	 * Changes one grid square for another
	 * 
	 * @param idPrefix the prefix for the linkage ids of the grid squares. The id's should be of
	 * the form idPrefix_1, idPrefix_2,...etc
	 * @param i the index of the grid square to change (number from 0 to _size*_size-1)
	 * @param j the index of the id new grid sqare to replace the previous one (number from 0 to nPhotos-1)
	 * if j == null then the square is faded out and removed without another square being added
	 * if i == null then the new square is faded in directly
	 */
	private function swapGs(idPrefix:String, i:Number, j:Number):Void{
		
		//define function to fade in new grid square
		var fnc:Function = function(_idPrefix, k, l){
			
			//get name of faded out clip
			var oldName = this.gsArray[k]._name;
			
			//remove faded out clip
			if(this.gsArray[k]){
				this.gsArray[k].removeMovieClip();
			}
			
			if(l!=null){

				//create new clip
				var id:String = _idPrefix+"_"+String(k)+"_"+String(l);
				if (id==oldName){
					id = id + "_";
				}
				var initObj = new Object();
				initObj._alpha = 0;
				initObj._x = this.gridX + this.photoLength*(k%this._size);
				initObj._y = this.gridY + this.photoLength*Math.floor(k/this._size);
				initObj.busy = true;
				this.gsArray[k] = this["gridSquares"].attachMovie(_idPrefix+"_"+String(l+1), id, k, initObj);
				
				//fade in new clip
				var fnc2:Function = function(){
					this.busy = false;
				}
				this.gsArray[k].alphaTo(100, this.fadeSpeed, Proxy.create(this.gsArray[k], fnc2));
			}else{
				this.gsArray[k] = null;
			}
			
		}
		
		if(gsArray[i]!=null){
			gsArray[i].busy = true;
			gsArray[i].alphaTo(0, this.fadeSpeed, Proxy.create(this, fnc, idPrefix, i, j));
		}else{
			fnc.apply(this, new Array(idPrefix, i,j));
		}
		
		//update the currenty showing clip
		nowShowing[i] = j;
	}
	
	/*
	 * Starts interchanging photos 
	 * 
	 * @param idPrefix the prefix for the linkage ids of the grid squares. The id's should be of
	 * the form idPrefix_1, idPrefix_2,...etc
	 * @param order the order in which the clips are changed, valid values are "random" and "normal"
	 * @param nPhotos the number of phtotos to chose from
	 */
	public function flicker(idPrefix:String, order:String, nPhotos:Number):Void{

		//create onEnterFrame function
		this["frameCnt"] = 0;
		this["currClip"] = 0;
		this["order"] = order;
		this["nPhotos"] = nPhotos;
		this["idPrefix"] = idPrefix;
		delete this.onEnterFrame;
		this.onEnterFrame = function(){

			if(this.frameCnt%this.interval==0){
				
				//reset frame count
				this.frameCnt = 0;
				
				//get grid square to change
				var i:Number;
				if (this.order == "random"){
					//find a clip to change that is not currently being changed
					i = Math.floor(Math.random()*this._size*this._size);
					while(this.gsArray[i].busy == true){
						i = Math.floor(Math.random()*this._size*this._size);
					}
				}else{
					//get next clip
					i = this["currClip"];
					this["currClip"] = (this["currClip"]+1)%(this._size*this._size);
				}

				//find a clip to replace it
				var j:Number = Math.floor(Math.random()*this.nPhotos);
				while(Utils.arrayContains(this.nowShowing, j)){
					j = Math.floor(Math.random()*this.nPhotos);
				}
				
				//swap grid squares
				this.swapGs(idPrefix, i, j);
			}

			//increment frame count
			this.frameCnt++;
		}

	}
	
	/*
	 * Starts blanking out of photos to reveal background image
	 * 
	 * @param order the order in which the clips are changed, valid values are "random" and "normal"
	 * @param nPhotos the number of phtotos to chose from
	 */
	public function blankOut(order:String, nPhotos:Number):Void{
		
		//create onEnterFrame function
		delete this.onEnterFrame;
		this["frameCnt"] = 0;
		this["currClip"] = 0;
		this["order"] = order;
		this["nPhotos"] = nPhotos;
		this.onEnterFrame = function(){

			//if there are more clips to remove
			if(this.frameCnt<this.interval*this._size*this._size){
				
				if(this.frameCnt%this.interval==0){
					
					var i:Number;
					if (this.order == "random"){
						//find a clip to change that is not currently being changed
						i = Math.floor(Math.random()*this._size*this._size);
						while((this.gsArray[i]==null || this.gsArray[i].busy == true)){
							i = Math.floor(Math.random()*this._size*this._size);
						}
					}else{
						//get next clip
						i = this["currClip"];
						this["currClip"] = (this["currClip"]+1)%(this._size*this._size);
					}
	
					//swap grid squares
					this.swapGs(null, i, null);
				}
	
				//increment frame count
				this.frameCnt++;
				
			}else{
				delete this.onEnterFrame;
			}

		}
	}
	
	/*
 	 * Fills the grid with photos
	 * 
	 * @param idPrefix the prefix for the linkage ids of the grid squares. The id's should be of
	 * the form idPrefix_1, idPrefix_2,...etc
	 * @param order the order in which the clips are changed, valid values are "random" and "normal"
	 * @param nPhotos the number of phtotos to chose from
	 * @param callBackFunc the function to execute when the fill completes if not present the fill repeats
	 */
	public function fill(idPrefix:String, order:String, nPhotos:Number, callBackFunc:Function):Void{
		
		//create onEnterFrame function
		delete this.onEnterFrame;
		this["frameCnt"] = 0;
		this["currClip"] = 0;
		this["order"] = order;
		this["nPhotos"] = nPhotos;
		this["idPrefix"] = idPrefix;
		this["callBackFunc"] = callBackFunc;
		this.nowShowing = new Array();
		this.onEnterFrame = function(){
			
			//if there are more clips to add
			if(this.frameCnt<this.interval*this._size*this._size){
				
				if(this.frameCnt%this.interval==0){
					
					var i:Number;
					if (this.order == "random"){
						//find a square
						i = Math.floor(Math.random()*this._size*this._size);
						while(this.nowShowing[i]!=undefined){
							i = Math.floor(Math.random()*this._size*this._size);
						}
					}else{
						//get next clip
						i = this["currClip"];
						this["currClip"] = (this["currClip"]+1)%(this._size*this._size);
					}
	
					//swap grid squares
					this.swapGs(idPrefix, i, i%this.nPhotos);
				}
	
				//increment frame count
				this.frameCnt++;
				
			}else{
				
				//if callback function present then end otherwise repeat
				if(this.callBackFunc){
					delete this.onEnterFrame;
					this.callBackFunc();
				}else{
					this.nowShowing = new Array();
					this.frameCnt = 0;
				}
			}
		}
	}
	
	/*
	 * Begins the animation sequence
	 */
	public function beginAnimation():Void{
		
		//initialize the grid
		initGridSquares();
		
		//currStep = 1;
		
		//get next step
		nextStep();
		
	}
	
	/*
	 * Executes the next step in the animation
	 */
	public function nextStep():Void{
		
		
		//cancel interval and increment step
		clearInterval(stepInt);
		currStep++;
		
		switch (currStep){
			case 1:
				flicker("gridSquare", "random", 32);
				stepInt = setInterval(Proxy.create(this, nextStep), 10000);
			break;
			case 2:
				fill("logoSquare", "random", 16, Proxy.create(this, this.nextStep));
			break;
			case 3:
				stepInt = setInterval(Proxy.create(this, nextStep), 1000);
			break;
			case 4:
				this["gridSquares"].alphaTo(50, 20);
				var txt:String = IntroApp.getMsg("photoGrid.presents");
				Utils.newObject(RainingText, this["fg"], "presentsText", this["fg"].getNextHighestDepth(), {txt:txt, _y:-50, finY:gridY+(_size*photoLength)/2, txtFormat:txtFormat, bgCol:0xffffff, onComplete:Proxy.create(this, this.nextStep)});
				this["fg"].presentsText._x = gridX+(_size*photoLength-this["fg"].presentsText._width)/2;
			break;
			case 5:
				this["gridSquares"].alphaTo(100, 20);
				this["fg"].presentsText.alphaTo(0, 50, Proxy.create(this["fg"].presentsText, this["fg"].presentsText.removeMovieClip))
				fill("gridSquare", "normal", 16, Proxy.create(this, nextStep));
			break;
			case 6:
				var grid:GenericMovieClip = this["fg"].createEmptyMovieClip("grid", this["fg"].getNextHighestDepth());
				drawGrid(grid, 0xffffff, false);
				fill("logoMesmisSquare", "random", 16, Proxy.create(this, this.nextStep));
			break;
			case 7:
				this["fg"].grid.alphaTo(0, 60, Proxy.create(this["fg"].grid, this["fg"].grid.removeMovieClip));
				var txt:String = IntroApp.getMsg("photoGrid.interactiveMesmis");
				txtFormat.color = 0xffffff;
				var mt:EmergingText = Utils.newObject(EmergingText, this["fg"], "mesmisTxt", this["fg"].getNextHighestDepth(), {txt:txt, _y:gridY+400, txtFormat:txtFormat, onComplete:Proxy.create(this, this.nextStep)});
				mt._x = gridX+(_size*photoLength-mt.totalWidth)/2
				
			break;
			case 8:
				var fnc:Function = function(){
					IntroApp.getNav().getNext();
					this.destroy();
				}
				var btn_enter:BubbleBtn = Utils.newObject(BubbleBtn, this["fg"], "btn_enter", this["fg"].getNextHighestDepth(), {literal:IntroApp.getMsg("btn.enter"), _y:gridY+450, callBackObj:this, callBackFunc:fnc, _alpha:0});
				btn_enter._x = gridX+(_size*photoLength-btn_enter._width)/2
				btn_enter.alphaTo(100, 30);
				
			break;
		}
	}
	
	/*
	 * Draws a grid or solo the outline of a grid
	 */
	private function drawGrid(parentClip:MovieClip, col:Number, outlineOnly:Boolean):Void{
		parentClip.lineStyle(1, col, 100);
		parentClip.moveTo(gridX, gridY);
		parentClip.lineTo(gridX+_size*photoLength, gridY);
		parentClip.lineTo(gridX+_size*photoLength, gridY+_size*photoLength);
		parentClip.lineTo(gridX, gridY+_size*photoLength);
		parentClip.lineTo(gridX, gridY);
		if(!outlineOnly){
			for(var i=1; i<_size; i++){
				parentClip.moveTo(gridX+i*photoLength, gridY);
				parentClip.lineTo(gridX+i*photoLength, gridY+_size*photoLength);
				parentClip.moveTo(gridX, gridY+i*photoLength);
				parentClip.lineTo(gridX+_size*photoLength, gridY+i*photoLength);
			}
		}
	}
	
	/*
	 * Unloads the photo grid from memory
	 */
	public function destroy():Void{
		clearInterval(stepInt);
		this.removeMovieClip();
	}


}