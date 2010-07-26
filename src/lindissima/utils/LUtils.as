import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.model.InitParam;
import lindissima.model.InitParams;
import core.comp.Graph;
import lindissima.process.*;

/*
 * Static utility functions for lindissima
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class lindissima.utils.LUtils {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.utils.LUtils");
	
	/*
	 * Prevent instantiation
	 */
	private function LUtils(){
	}
	
	/*
	 * Checks whether a root prune is due for this week
	 * 
	 * @param t the index of the week to examine
	 * @return true if a prune is due in the week t acording to the inital parameter ip
	 */
	public static function isRootPruneWeek(ips:InitParams, t:Number):Boolean{
		return (t==0 && getIP("podasRaiz")!=0)
	}
	
	/*
	 * Checks whether a folliage prune is due for this week
	 * 
	 * @param t the index of the week to examine
	 * @return true if a prune is due in the week t acording to the inital parameter ip
	 */
	public static function isFolPruneWeek(t:Number):Boolean{
		//define return variable
		var ret:Boolean = false;
		//get array of weeks when pruning ocurrs
		var folPrun:Array = LindApp.getInitParamCol().getSelInitParams().getInitParamVal("podasTallo");
		
		if (getIP("densA") == 0 || folPrun.length == 0){
			//if there are no shrubs or no pruning weeks defined return false
			return false;
		}else{
			//check to see if week belongs to folprune array
			for (var i=0;i<folPrun.length; i++){
				if (folPrun[i] == t){
					ret = true;
				}
			}
		}
		//logger.debug("t="+t+" isFolPruneWeek="+ret);
		return ret;
	}
	
	/*
	 * Defines the weeks that a foliage prune will ocur given the number
	 * of prunes that should ocur each year and the total number of years
	 * 
	 * @param nPrunes the number of prunes to execute each year. These will be as evenly
	 * spaced as possible between the start and end of the corn cycle
	 * @param nYears the number of years to generate weeks for
	 * @return an array with length nPrunes*nYears of integers where each integer represents
	 * a week where pruning ocurrs
	 */
	public static function definePruneDates(nPrunes:Number, nYears:Number):Array{
		
		//define return array
		var ret:Array = new Array();
		
		//define length of corn cycle
		//TODO: Should use length of cycle and not 24 which is what excel uses
		//var cycle:Number = Const.WEEK_END_CORN_CYCLE - Const.WEEK_BEGIN_CORN_CYCLE;
		var cycle:Number = 24;
		
		//define the interval in weeks between each prune
		var intvl:Number = Math.floor(cycle/nPrunes);
		
		//generate weeks
		var firstWeek:Number;
		for (var i=0; i<nYears; i++){
			firstWeek = i*52 + Const.WEEK_BEGIN_CORN_CYCLE;
			for (var j=1; j<=nPrunes; j++){
				ret[ret.length] = firstWeek+j*intvl;
			}
		}
		
		//logger.debug("prune dates: " + ret);
		return ret;
	}
	
	/*
	 * Clears outputs of all processes
	 */
	public static function clearOutputs():Void{
		NFiltered.getProcess().clearOutput();
		NInSoil.getProcess().clearOutput();
		NAvailCorn.getProcess().clearOutput();
		FNCorn.getProcess().clearOutput();
		CornBiomass.getProcess().clearOutput();
		NExtractCorn.getProcess().clearOutput();
		FarmerNetProfit.getProcess().clearOutput();
		LakeNetProfit.getProcess().clearOutput();
		ExtShrubRoots.getProcess().clearOutput();
		FNShrub.getProcess().clearOutput();
		FolPruneBiomass.getProcess().clearOutput();
		FolPruneOnGround.getProcess().clearOutput();
		NAvailShrub.getProcess().clearOutput();
		NExtractShrub.getProcess().clearOutput();
		NInPrune.getProcess().clearOutput();
		ShrubBiomass.getProcess().clearOutput();
		WeedCon.getProcess().clearOutput();
	}
	
	/*
	 * Gets an init param object
	 * 
	 * @param id the id of the parameter to retreive
	 * @return the init param
	 */
	public static function getIPObj(id:String):InitParam{
		return LindApp.getInitParamCol().getSelInitParams()[id];
	}
	
	/*
	 * Sets an init param object
	 * 
	 * @param id the id of the parameter to set
	 * @param the new init param object
	 */
	public static function setIPObj(id:String, ip:InitParam):Void{
		LindApp.getInitParamCol().getSelInitParams()[id] = ip;
	}
	
	/*
	 * Gets the value of a numeric init param
	 * 
	 * @param id the id of the parameter to retreive
	 * @param i the index of the array to retreive if the parameter is an array. If the parameter
	 * is not an array this should be null or undefined 
	 * @return the value of the init param converted to a number
	 */
	public static function getIP(id:String, i:Number):Number{
		//define return variable
		var ret:Number;
		
		if (i==undefined || i==null){
			ret = Number(LindApp.getInitParamCol().getSelInitParams().getInitParamVal(id));
		}else{
			ret = Number(LindApp.getInitParamCol().getSelInitParams().getInitParamVal(id)[i]);
		}

		//logger.debug("getIP: id="+id+", i="+i+" ret="+ret.toString());
		return ret;
	}
	
	/*
	 * Sets the value of a numeric init param
	 * 
	 * @param id the id of the parameter to retreive
	 * @param val the new value of the parameter
	 * @param i the index of the array to set if the parameter is an array. If the parameter
	 * is not an array this should be null or undefined 
	 */
	public static function setIP(id:String, val:Number, i:Number):Void{
		LindApp.getInitParamCol().getSelInitParams().setInitParamVal(id, val, i);
	}
	
	/*
	 * Gets the array value of an init param (init param must be defined as an array)
	 * 
	 * @param id the id of the parameter to retreive
	 * @return the array value of the init param
	 */
	public static function getIPArray(id:String):Array{
		return LindApp.getInitParamCol().getSelInitParams().getInitParamVal(id);
	}
	
	/*
	 * Sets the value of the initial weed concentration
	 * 
	 * @param key valid values are "low" or "high"
	 * @param year the year to set (first year is 0)
	 */
	public static function setInitialWeeds(key:String, y:Number):Void{
		switch (key){
			case "low":
				setIP("algasIni", Const.WEED_CONCENTRATION_LOW, y);
			break;
			case "high":
				setIP("algasIni", Const.WEED_CONCENTRATION_HIGH, y);
			break;
			case "custom":
				setIP("algasIni", Const.WEED_CONCENTRATION_CUSTOM, y);
			break;
		}
	}
	
	/*
	 * Adds rain and dry season graphic to x-axis of graph
	 * 
	 * @param graph the graph object
	 * @param y the number of years
	 * @param yOffset the offset value of the graphic from the xAxis
	 */
	public static function addDryWetAxis(graph:Graph, y:Number, yOffset:Number){
		
		//if yOffset not defined replace by 0
		if(!yOffset || isNaN(yOffset)){
			yOffset = 0;
		}
		
		//create empty container clip
		var mc = graph["bg"].createEmptyMovieClip("dryWetAxis", graph["bg"].getNextHighestDepth());
		mc._x = graph.axesDist;
		mc._y = graph.yAxisHeight+graph.topPadding+yOffset;
		
		//calculate initial variables
		var w:Number = (graph.w-graph.axesDist-graph.rightPadding)/y
		
		//for each year
		for(var i=0; i<y; i++){

			//draw wet season background
			mc.lineStyle(1, Const.DEFAULT_BORDER_COLOR, 100);
			mc.beginFill(0x0000ff, 100);
			mc.moveTo(i*w, 0);
			mc.lineTo(i*w+w/2, 0);
			mc.lineTo(i*w+w/2, 15);
			mc.lineTo(i*w, 15);
			mc.lineTo(i*w, 0);
			mc.endFill();
			
			//draw wet season text
			LindApp.getTxtFormat("lakeModelXAxisTxtFormat").color = 0x9EDDFE;
			Utils.createTextField("xAxisWetLit_"+String(i), mc, mc.getNextHighestDepth(), i*w, 0, w/2, 15, LindApp.getMsg("lakeModel.weedConVsTimeGraph.wetSeason"), LindApp.getTxtFormat("lakeModelXAxisTxtFormat"));
			
			//draw dry season background
			mc.lineStyle(1, Const.DEFAULT_BORDER_COLOR, 100);
			mc.beginFill(0xff9900, 100);
			mc.moveTo(i*w+w/2, 0);
			mc.lineTo((i+1)*w, 0);
			mc.lineTo((i+1)*w, 15);
			mc.lineTo(i*w+w/2, 15);
			mc.lineTo(i*w+w/2, 0);
			mc.endFill();
			
			//draw dry season text
			LindApp.getTxtFormat("lakeModelXAxisTxtFormat").color = 0xffff00;
			Utils.createTextField("xAxisDryLit_"+String(i), mc, mc.getNextHighestDepth(), i*w+w/2, 0, w/2, 15, LindApp.getMsg("lakeModel.weedConVsTimeGraph.drySeason"), LindApp.getTxtFormat("lakeModelXAxisTxtFormat"));
		}
	}
	
	/*
	 * Adds clear and turbid background to graph
	 * 
	 * @param graph the graph object
	 * @param type valid values are "horizontal" and "vertical"
	 */
	public static function addClearTurbidBg(graph:Graph, bgType:String){
		
		//define vars
		var turbLim:Number;
		var minY:Number = graph.topPadding;
		var maxY:Number = graph.h-graph.axesDist-1;
		var minX:Number = graph.axesDist+1;
		var maxX:Number = graph.w-graph.rightPadding;
		var clear_bg;
		var mirky_bg;
		
		//create empty container clip
		var mc = graph["bg"].createEmptyMovieClip("clearTurbidBg", graph["bg"].getNextHighestDepth());
		
		if(bgType == "horizontal"){
				
			//define coordinates
			turbLim = graph.getYPos(getIP("umbTurb"));
			
			//create clear bg
			clear_bg = mc.createEmptyMovieClip("clear_bg", 1);
			//clear_bg.lineStyle(1, Const.CLEAR_LAKE_COLOR, 100);
			clear_bg.beginFill(Const.CLEAR_LAKE_COLOR, 20);
			clear_bg.moveTo(minX, turbLim);
			clear_bg.lineTo(maxX, turbLim);
			clear_bg.lineTo(maxX, maxY);
			clear_bg.lineTo(minX, maxY);
			clear_bg.lineTo(minX, turbLim);
			clear_bg.endFill();
			
			//create mirky bg
			mirky_bg = mc.createEmptyMovieClip("mirky_bg", 2);
			//mirky_bg.lineStyle(1, Const.MIRKY_LAKE_COLOR, 100);
			mirky_bg.beginFill(Const.MIRKY_LAKE_COLOR, 20);
			mirky_bg.moveTo(minX, minY);
			mirky_bg.lineTo(maxX, minY);
			mirky_bg.lineTo(maxX, turbLim);
			mirky_bg.lineTo(minX, turbLim);
			mirky_bg.lineTo(minX, minY);
			mirky_bg.endFill();
			
		}else if(bgType == "vertical"){
			
			//define coordinates
			turbLim = graph.getXPos(getIP("umbTurb"));
			
			//create clear bg
			clear_bg = mc.createEmptyMovieClip("clear_bg", 1);
			//clear_bg.lineStyle(1, Const.CLEAR_LAKE_COLOR, 100);
			clear_bg.beginFill(Const.CLEAR_LAKE_COLOR, 20);
			clear_bg.moveTo(minX, minY);
			clear_bg.lineTo(turbLim, minY);
			clear_bg.lineTo(turbLim, maxY);
			clear_bg.lineTo(minX, maxY);
			clear_bg.lineTo(minX, minY);
			clear_bg.endFill();
			
			//create mirky bg
			mirky_bg = mc.createEmptyMovieClip("mirky_bg", 2);
			//mirky_bg.lineStyle(1, Const.MIRKY_LAKE_COLOR, 100);
			mirky_bg.beginFill(Const.MIRKY_LAKE_COLOR, 20);
			mirky_bg.moveTo(turbLim, minY);
			mirky_bg.lineTo(maxX, minY);
			mirky_bg.lineTo(maxX, maxY);
			mirky_bg.lineTo(turbLim, maxY);
			mirky_bg.lineTo(turbLim, minY);
			mirky_bg.endFill();
		}
	}
}