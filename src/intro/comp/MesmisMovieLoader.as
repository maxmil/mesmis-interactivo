import ascb.util.logging.Logger;
import core.util.Proxy;
import intro.IntroApp;

/* Wrapper for MovieClipLoader class used to load and unload mesmis sub movies.
 * Movies are loaded into currMovie
 * 
 * @author Max Pimm
 * @created 13-10-2005
 * @version 1.0
 */
 class intro.comp.MesmisMovieLoader {
	 
	//logger
	public static var logger:Logger = Logger.getLogger("intro.comp.MesmisMovieLoader");
	
	//sub movies - array of ids and _urls
	private var subMovies:Array;
	
	//reference to the active movie
	private var currMovie:Object;
	
	//level at which clips are loaded
	private var levelInd:Number;
	
	//movie clip loader and listener object
	private var mcl:MovieClipLoader;
	private var listener:Object;
	
	//loader bar parent clip. If defined a loader bar is generated. Otherwise
	//the sub movie is loaded silenty
	private var loaderBarParent:MovieClip;
	private var contClip:MovieClip;
	
	/*
	 * Constructor
	 */
	public function MesmisMovieLoader(_loaderBarParent:MovieClip){
		
		//initialize
		mcl = new MovieClipLoader();
		loaderBarParent = _loaderBarParent;
		subMovies = new Array();
		currMovie = null;
		levelInd = 2;
	}
	
	/*
	 * Adds a sub movie
	 * 
	 * @param id the id of the sub movie should correspond to Const values
	 * @param __url the url of the movie relative to the parent clip
	 */
	public function addSubMovie(id:Number, __url:String, props:Object):Object{
		subMovies[id] = new Object({__url:__url, props:props});
		return subMovies[id];
	}
	
	/*
	 * Loads a new movie, first unloads the current movie if neccessary
	 * 
	 * @param id the id of the sub movie to load. Should correspond to Const value
	 */
	public function doLoadMovie(movieId:Object):Void{
		
		//unload current movie if defined
		if(currMovie != null){
			
			//end application and unload clip
			currMovie.endApp();
			mcl.unloadClip(levelInd);
			
			//reset current movie to null
			currMovie = null;
		}
		
		//if loaderBarParent is defined then create container clip
		//and attach blinds
		if (loaderBarParent){

			contClip = loaderBarParent.createEmptyMovieClip("contClip", loaderBarParent.getNextHighestDepth());
			contClip._y = -IntroApp.getNav().getCurrActivity_mc()._y 
			var blind:MovieClip = contClip.attachMovie("introMc", "blinds", 1);
			contClip.blindsClosed = Proxy.create(this, initLoader, movieId);
			
			//make contClip clickable to desactivate all actions in other layers
			contClip.onRelease = function(){
				//do nothing
			}
			contClip.useHandCursor = false;
			
		}else{
			startLoading(movieId);
		}
	}
	
	/*
	 * Unloads the currently loaded movie
	 */
	public function doUnloadMovie():Void{
		
		//if no movie loaded then return
		if(currMovie == null){
			return;
		}
			
		//unload movie
		currMovie.endApp();
		this.mcl.unloadClip(levelInd);
		
		//if loaderBarParent present then open blinds
		//else just remove content clip
		if (loaderBarParent){
			
			contClip["blinds"].topBg.loaderBar.removeMovieClip();
			contClip["blinds"].topBg.loaderTxt.removeMovieClip();
			
			//remove content clip on blind open
			contClip.blindsOpen = Proxy.create(contClip, contClip.removeMovieClip);
			
			//open blinds
			contClip["blinds"].gotoAndPlay("openBlind");
			
		}else{
			contClip.removeMovieClip();
		}

		//reset current movie to null
		currMovie = null;
	}
	
	/*
	 * Initialize loader bar and text and starts loading the movie
	 * 
	 * @param id the id of the sub movie to load. Should correspond to Const value
	 */
	private function initLoader(movieId) {
		
		//attach loader
		var loaderBar:MovieClip = contClip.blinds.topBg.attachMovie("loaderBar", "loaderBar", 1, {_x:370, _y:370});
		var txtMc:MovieClip = contClip.blinds.topBg.createEmptyMovieClip("loaderTxt", 2);
		var txt:String = "  0% CARGADO";
		for (var i = 0; i<txt.length; i++) {
			txtMc.attachMovie("Loader Text", "loaderText"+String(i), i+1);
			txtMc["loaderText"+String(i)]._x = 400+10*i;
			txtMc["loaderText"+String(i)]._y = 350;
			txtMc["loaderText"+String(i)].loaderChar.char.text = txt.substring(i, i+1);
		}
		
		//add animation to loader text
		contClip.frameCnt = 0;
		contClip.onEnterFrame = function() {
			if (this.frameCnt%(2*txt.length)<txt.length) {
				this.loaderTxt["loaderText"+String(this.frameCnt%txt.length)].gotoAndPlay(2);
			}
			this.frameCnt++;
		};
		
		//start loading movie
		startLoading(movieId);
	}
	
	/*
	 * Starts loading movie
	 * 
	 * @param id the id of the sub movie to load. Should correspond to Const value
	 */
	private function startLoading(movieId):Void{
		
		//attach listener
		listener = new Object();
		if (loaderBarParent != undefined){
			listener.onLoadProgress = Proxy.create(this, loadProgress);
		}
		listener.onLoadComplete = Proxy.create(this, loadComplete);
		mcl.addListener(listener);
		
		//start loading clip
		mcl.loadClip(subMovies[movieId].__url, levelInd);
	}
	
	/*
	 * Starts the loaded movie
	 */
	private function startMovie():Void{
		
		//set movie initial parameters
		currMovie.initType = "full";
		currMovie.loadLangString = "CARGANDO TEXTOS..."
		currMovie.exitObj = this;
		currMovie.exitFunc = doUnloadMovie;
	
		//start movie
		currMovie.pauseApp = false;
		currMovie.beginApp();
	}
	
	
	/*
	 * Attatched to loader via listener. Exectutes as load progresses. If loaderBarParent
	 * is true the loader bar unpdates via this function
	 * 
	 * @param target_mc the movie clip being loaded
	 * @param loadedBytes the bytes that have been loaded so far
	 * @param totalBytes the total number of bytes to load
	 */
	public function loadProgress(target_mc, loadedBytes, totalBytes):Void{
		
		//calculate loaded percent
		var _loaded:Number = Math.round(loadedBytes/totalBytes*100);
		var units:Number = _loaded%10;
		var tens:Number = (_loaded-units)/10%10;
		var hundreds:Number = Math.floor(_loaded/100);
		
		//update loadText
		if (hundreds>0) {
			contClip.blinds.topBg.loaderTxt.loaderText0.loaderChar.char.text = String(hundreds);
			contClip.blinds.topBg.loaderTxt.loaderText1.loaderChar.char.text = String(tens);
		} else if (tens>0) {
			contClip.blinds.topBg.loaderTxt.loaderText1.loaderChar.char.text = String(tens);
		}
		contClip.blinds.topBg.loaderTxt.loaderText2.loaderChar.char.text = String(units);
		
		//update loaderBarFill width
		contClip.blinds.topBg.loaderBar.loaderBarFill._width = 214/100*_loaded;
		
	}
	
	/*
	 * Attatched to loader via listener. Exectutes when the load is complete. If loaderBarParent
	 * is true the blind is opened and the movie started
	 * 
	 * @param target_mc the movie clip being loaded
	 */
	public function loadComplete(target_mc):Void{
		
		//set current movie
		currMovie = target_mc;
		
		//pause the application
		currMovie.pauseApp = true;
		currMovie.locale = IntroApp.getLocale();
		
		//start movie immediately
		startMovie();
	}
}