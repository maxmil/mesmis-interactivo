import ascb.util.logging.Logger;
import core.comp.UserMessage;
import core.util.Utils;
import lindissima.utils.LUtils;
import lindissima.LindApp;
import core.comp.Graph;
import lindissima.comp.lakeModel.ExploreLakeModel
import lindissima.comp.lakeModel.FindLimitLakeModel
import lindissima.comp.lakeModel.ExploreBistableLakeModel
import lindissima.comp.lakeModel.RandomInitCondLakeModel
import lindissima.process.WeedCon;

/*
 * Lindissima activity based on corn model where the only available variable for the user
 * is the level of fertilizer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class lindissima.activity.LakeModel extends lindissima.activity.LindActivity{
	 
	 //logger
	private static var logger:Logger = Logger.getLogger("lindissima.activity.LakeModel");
	
	//used in simulation
	public var clearPoints:Array;
	public var mirkyPoints:Array;
	
	/*
	 * Constructor
	 */
	public function LakeModel() {
				
		//call super class constructor
		super();

		//log
		logger.debug("instantiating LakeModel");
		
		//get first step
		getStep(1);
	}
	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		//remove component always
		this.currComp.removeMovieClip();
		this.removeQuestions();
		
		return step
	}
	
	/*
	 * Gets clear point for graphic
	 * 
	 * @param d the day to get the point for
	 * @return the concentration of weeds for this day
	 */
	public function getClearPoint(d:Number):Number{
		if (this.clearPoints.length>d){
			return Utils.roundNumber(this.clearPoints[d], 2);
		}else{
			return null;
		}
	}
	
	/*
	 * Gets mirky point for graphic
	 * 
	 * @param d the day to get the point for
	 * @return the concentration of weeds for this day
	 */
	public function getMirkyPoint(d:Number):Number{
		
		if (this.mirkyPoints.length>d){
			return Utils.roundNumber(this.mirkyPoints[d], 2);
		}else{
			return null;
		}
	}
	
	/*
	 * Gets the vegetation for a certain level of weed concentration.
	 * Used to draw the weedConVsVeg graphic
	 * 
	 * @param weedCon the concentration of weeds
	 * @return the vegetation coverage (%) for this concentraction of weeds
	 */
	public function getVegByWeedCon(weedCon:Number):Number{
		var ha:Number = LUtils.getIP("fnva_ha");
		var P:Number = LUtils.getIP("fnva_P");
		var power:Number = Math.pow(ha, P);
		var ret:Number = power/(Math.pow(weedCon, P)+power);
		return 100*ret;
	}
	
	/*
	 * Step 1: Introduction, title, and image
	 * 
	 * @param the container clip for the step
	 */
	private function step1(cont):Void{

		//create title text
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "center";
		Utils.createTextField("intro_txt1", cont, 1, 0, 20, 950, 1, LindApp.getMsg("lakeModel.preamble.intro1"), LindApp.getTxtFormat("bigTitleTxtFormat"));
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "left";
		LindApp.getTxtFormat("bigTxtFormat").align = "center";
		Utils.createTextField("intro_txt2", cont, 2, 0, 100, 950, 1, LindApp.getMsg("lakeModel.preamble.intro2"), LindApp.getTxtFormat("bigTxtFormat"))
		LindApp.getTxtFormat("bigTxtFormat").align = "left";

		//create intro clip
		var img = cont.createEmptyMovieClip("fish", 3);
		img._x = 250;
		img._y = 180;
		img.attachMovie("lm_fish", "lm_fish", 1);
		
		//create buttons
		this.createBtnNext();
		this.createBtnGotoMenuPrin();
	}
	
	/*
	 * Step 2: Story begins with mountain and lake graphic
	 * 
	 * @param the container clip for the step
	 */
	private function step2(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_2", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["rtq_size"].text = "";
		cont.attachMovie("lm_lake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt1"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 3: Enter the tourists
	 * 
	 * @param the container clip for the step
	 */
	private function step3(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_2", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["rtq_size"].text = "";
		cont.attachMovie("lm_lake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_sun", "lm_sun", cont.getNextHighestDepth(), {_x:10, _y:10, _xscale:50, _yscale:50});
		Utils.createTextField("tourists_tf", cont, cont.getNextHighestDepth(), 280, 450, 100, 1, LindApp.getMsg("lakeModel.preamble.story.tourists"), LindApp.getTxtFormat("altTxtFormat"));
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt2"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 4: When the rains arrive and the tourists leave the lake remains clear
	 * 
	 * @param the container clip for the step
	 */
	private function step4(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_2", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["rtq_size"].text = "";
		cont.attachMovie("lm_lake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_cloud", "lm_cloud", cont.getNextHighestDepth(), {_x:170, _y:10});
		Utils.createTextField("tourists_tf", cont, cont.getNextHighestDepth(), 270, 450, 100, 1, LindApp.getMsg("lakeModel.preamble.story.tourists"), LindApp.getTxtFormat("altTxtFormat"));
		cont.attachMovie("mount_arrow", "arrow", cont.getNextHighestDepth(), {_x:335, _y:450, _xscale:50, _yscale:50});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt3"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 5: Due to climatic conditions the lake can become mirky
	 * 
	 * @param the container clip for the step
	 */
	private function step5(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_2", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["rtq_size"].text = "";
		cont.attachMovie("lm_mirkyLake", "lm_mirkyLake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_sun", "lm_sun", cont.getNextHighestDepth(), {_x:10, _y:10});
		Utils.createTextField("tourists_tf", cont, cont.getNextHighestDepth(), 270, 450, 100, 1, LindApp.getMsg("lakeModel.preamble.story.tourists"), LindApp.getTxtFormat("altTxtFormat"));
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt4"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 6: But the rains return the lake to a clear state
	 * 
	 * @param the container clip for the step
	 */
	private function step6(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_2", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["rtq_size"].text = "";
		cont.attachMovie("lm_lake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_cloud", "lm_cloud", cont.getNextHighestDepth(), {_x:170, _y:10});
		Utils.createTextField("tourists_tf", cont, cont.getNextHighestDepth(), 270, 450, 100, 1, LindApp.getMsg("lakeModel.preamble.story.tourists"), LindApp.getTxtFormat("altTxtFormat"));
		cont.attachMovie("mount_arrow", "arrow", cont.getNextHighestDepth(), {_x:335, _y:450, _xscale:50, _yscale:50});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt5"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 7: Enter the corn farmers and their fertilizer
	 * 
	 * @param the container clip for the step
	 */
	private function step7(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_n_in_river", "lm_n_in_river", cont.getNextHighestDepth(), {_x:210, _y:250});
		cont.attachMovie("lm_mirkyLake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt6"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 8: Signs of conflict
	 * 
	 * @param the container clip for the step
	 */
	private function step8(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_n_in_river", "lm_n_in_river", cont.getNextHighestDepth(), {_x:210, _y:250});
		cont.attachMovie("lm_mirkyLake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_bomb", "lm_bomb", cont.getNextHighestDepth(), {_x:400, _y:290});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt7"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 9:
	 * 
	 * @param the container clip for the step
	 */
	private function step9(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_n_in_river", "lm_n_in_river", cont.getNextHighestDepth(), {_x:210, _y:250});
		cont.attachMovie("lm_mirkyLake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt8"));
		this.tweenIn(story)
		
		//create show question function
		var showQuestions:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:300, _y:200, w:400, txt:LindApp.getMsg("lakeModel.preamble.story.questions"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtn("btn_showQuest", LindApp.getMsg("btn.showQuestions"), this, showQuestions, false);
	}
	
	/*
	 * Step 10: Introduce graph and initial levels
	 * 
	 * @param the container clip for the step
	 */
	private function step10(cont):Void{

		//create graph
		var wcvtGraph = Utils.newObject(Graph, cont, "wcvtGraph", cont.getNextHighestDepth(), {_x:20, _y:100, w:500, h:300, xAxisRange:365, xAxisScale:20, xAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.xAxis"), yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		var bg1 = wcvtGraph["bg"].attachMovie("lm_graphbg_1", "lm_graphbg_1:", wcvtGraph["bg"].getNextHighestDepth(), {_x:51, _y:10});
		var bg2 = wcvtGraph["bg"].attachMovie("lm_graphbg_2", "lm_graphbg_2", wcvtGraph["bg"].getNextHighestDepth(), {_x:51, _y:86});
		bg2.mirkyLimit.text = LindApp.getMsg("lakeModel.preamble.story.graphic.mirkyLimit");
		bg2.initCond_mirky.text = LindApp.getMsg("lakeModel.preamble.story.graphic.initCondMirky");
		bg2.initCond_clear.text = LindApp.getMsg("lakeModel.preamble.story.graphic.initCondClear");
		bg1.clearLake.text = LindApp.getMsg("lakeModel.preamble.story.graphic.clearLake");
		bg1.mirkyLake.text = LindApp.getMsg("lakeModel.preamble.story.graphic.mirkyLake");
		wcvtGraph["bg"].attachMovie("lm_dryWet_loop", "lm_dryWet_loop", wcvtGraph["bg"].getNextHighestDepth(), {_x:30, _y:317});
		LUtils.addDryWetAxis(wcvtGraph, 1, 60);
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt9"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 11: Postulate over relationship between algas and time
	 * 
	 * @param the container clip for the step
	 */
	private function step11(cont):Void{

		//create graph
		var wcvtGraph = Utils.newObject(Graph, cont, "wcvtGraph", cont.getNextHighestDepth(), {_x:20, _y:40, w:500, h:300, xAxisRange:3, xAxisScale:0.5, xAxisLabel:LindApp.getMsg("lakeModel.preamble.story.graphic.xAxis"), yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		var bg1 = wcvtGraph["bg"].attachMovie("lm_graphbg_1", "lm_graphbg_1:", wcvtGraph["bg"].getNextHighestDepth(), {_x:51, _y:10});
		var bg2 = wcvtGraph["bg"].attachMovie("lm_graphbg_3", "lm_graphbg_3", wcvtGraph["bg"].getNextHighestDepth(), {_x:45, _y:50});
		bg1.clearLake.text = LindApp.getMsg("lakeModel.preamble.story.graphic.clearLake");
		bg1.mirkyLake.text = LindApp.getMsg("lakeModel.preamble.story.graphic.mirkyLake");
				
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt10"));
		this.tweenIn(story)
		
		//create show weed nitrogen relation function
		var showRelWeedN:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:70, _y:350, w:430, txt:LindApp.getMsg("lakeModel.preamble.story.relWeedsN"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")})
		}
		
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtn("btn_showRelWeedN", LindApp.getMsg("btn.showAnswer"), this, showRelWeedN, false);

	}
	
	/*
	 * Step 12: Introduce weeds
	 * 
	 * @param the container clip for the step
	 */
	private function step12(cont):Void{

		//create image
		var img = cont.attachMovie("lm_weedIntro", "lm_weedIntro", cont.getNextHighestDepth(), {_x:20, _y:0});
		img["light_clear"].text = img["light_mirky"].text = LindApp.getMsg("lakeModel.preamble.story.light");
				
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt11"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}

	/*
	 * Step 13: Simulation with N=0
	 * 
	 * @param the container clip for the step
	 */
	private function step13(cont):Void{
		
		//set the filtered nitrogen in the lake to 0
		LUtils.setIP("nLake", 0);
		
		//define process
		var wc:WeedCon = WeedCon(WeedCon.getProcess());
		
		//get points for clear model
		wc.clearOutput();
		LUtils.setInitialWeeds("low", 0);
		wc.getOutput(365)
		this.clearPoints = wc.getOutputs();
		
		//get points for mirky model
		wc.clearOutput();
		LUtils.setInitialWeeds("high", 0);
		wc.getOutput(365);
		this.mirkyPoints = wc.getOutputs();
		
		//create graph title
		Utils.createTextField("title_tf", cont, cont.getNextHighestDepth(), 100, 60, 500, 1, LindApp.getMsg("lakeModel.preamble.story.simulation"), LindApp.getTxtFormat("bigTitleTxtFormat"));

		//create graph
		var wcvtGraph = Utils.newObject(Graph, cont, "wcvtGraph", cont.getNextHighestDepth(), {_x:20, _y:100, w:500, h:300, xAxisRange:365, xAxisScale:20, xAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.xAxis"), yAxisRange:24, yAxisScale:2, yAxisLabel:LindApp.getMsg("lakeModel.weedConVsTimeGraph.yAxis")});
		var bg1 = wcvtGraph["bg"].attachMovie("lm_graphbg_1", "lm_graphbg_1:", wcvtGraph["bg"].getNextHighestDepth(), {_x:51, _y:10});
		wcvtGraph.addGraphicFromFunc("wcvtClearGraphic", 0x09a6cc, this, this.getClearPoint, 1, 5, 0, false);
		wcvtGraph.addGraphicFromFunc("wcvtMirkyGraphic", 0xcccc00, this, this.getMirkyPoint, 1, 5, 0, false);
		wcvtGraph["bg"].attachMovie("lm_dryWet_loop", "lm_dryWet_loop", wcvtGraph["bg"].getNextHighestDepth(), {_x:30, _y:317});
		LUtils.addDryWetAxis(wcvtGraph, 1, 60);
				
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt12"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}

	/*
	 * Step 14: Evolution of weed concentration with nitrogen
	 * 
	 * @param the container clip for the step
	 */
	private function step14(cont):Void{

		//create image
		var lm_weedConRel = cont.attachMovie("lm_weedConRel", "lm_weedConRel", cont.getNextHighestDepth(), {_x:20, _y:20});
		lm_weedConRel["txt_light"].text = LindApp.getMsg("lakeModel.preamble.weedConRel.light");
		lm_weedConRel["txt_plants"].text = LindApp.getMsg("lakeModel.preamble.weedConRel.plants");
		lm_weedConRel["txt_food"].text = LindApp.getMsg("lakeModel.preamble.weedConRel.food");
		lm_weedConRel["txt_weeds"].text = LindApp.getMsg("lakeModel.preamble.weedConRel.weeds");

		//create graph
		LindApp.getTxtFormat("defaultTxtFormat").align = "center";
		Utils.createTextField("graph_title", cont, cont.getNextHighestDepth(), 120, 250, 300, 1, LindApp.getMsg("lakeModel.preamble.weedConVsVeg.title"), LindApp.getTxtFormat("defaultTxtFormat"));
		LindApp.getTxtFormat("defaultTxtFormat").align = "left";
		var  wcvvGraph:Graph = Utils.newObject(Graph, cont, "wcvvGraph", cont.getNextHighestDepth(), {_x:20, _y:280, w:500, h:230, xAxisRange:30, xAxisScale:5, xAxisLabel:LindApp.getMsg("lakeModel.preamble.weedConVsVeg.xAxis"), yAxisRange:100, yAxisScale:10, yAxisLabel:LindApp.getMsg("lakeModel.preamble.weedConVsVeg.yAxis")});
		wcvvGraph.addGraphicFromFunc("graphic", 0x00ff00, this, this.getVegByWeedCon, 0.2, 1, 0, false);
				
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.preamble.story.txt13"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 15: Clear lake excercise -  explore
	 * 
	 * @param the container clip for the step
	 */
	private function step15(cont):Void{
		
		//create explore lake model component with clear initial conditions
		this.currComp = Utils.newObject(ExploreLakeModel, this, "elmc", this.compDepth, {initCond:"low", active:true});
		
		//init text
		Utils.newObject(UserMessage, cont, "txt", cont.getNextHighestDepth(), {_x:450, _y:350, w:480, txt:LindApp.getMsg("lakeModel.clearLakeExcercise.intructions1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), allowDrag:false, btnClose:false});
		
		//create show answer function
		var showAnswer:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:20, _y:330, w:420, txt:LindApp.getMsg("lakeModel.clearLakeExcercise.answer1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtn("btn_showAns", LindApp.getMsg("btn.showAnswer"), this, showAnswer, false);
	}
	
	/*
	 * Step 16: Clear lake excercise - find limit
	 * 
	 * @param the container clip for the step
	 */
	private function step16(cont):Void{
		
		//create find limit lake model component with clear initial conditions
		this.currComp = Utils.newObject(FindLimitLakeModel, this, "fllmc", this.compDepth, {initCond:"low", active:true});
		this.initQuestions("lakeModel.clearLakeExcercise.questions.question");
		this.quesActive = true;
		
		//create showHelp function
		var showHelp:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:470, _y:10, w:460, txt:LindApp.getMsg("lakeModel.clearLakeExcercise.introductions2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//start with help visible
		showHelp.apply(this);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtnEvalResp();
		this.createBtn("btn_showAns", LindApp.getMsg("btn.howtoExploreNLValues"), this, showHelp, false);
	}
	
	/*
	 * Step 17: Mirky lake excercise -  explore
	 * 
	 * @param the container clip for the step
	 */
	private function step17(cont):Void{
		
		//create explore lake model component with mirky initial conditions
		this.currComp = Utils.newObject(ExploreLakeModel, this, "elmc", this.compDepth, {initCond:"high", active:true});
		
		//init text
		Utils.newObject(UserMessage, cont, "txt", cont.getNextHighestDepth(), {_x:450, _y:350, w:480, txt:LindApp.getMsg("lakeModel.mirkyLakeExcercise.intructions1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), allowDrag:false, btnClose:false});
		
		//create show answer function
		var showAnswer:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:20, _y:330, w:420, txt:LindApp.getMsg("lakeModel.mirkyLakeExcercise.answer1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtn("btn_showAns", LindApp.getMsg("btn.showAnswer"), this, showAnswer, false);
	}

	/*
	 * Step 18: Mirky lake excercise - find limit
	 * 
	 * @param the container clip for the step
	 */
	private function step18(cont):Void{
		
		//create find limit lake model component with mirky initial conditions
		this.currComp = Utils.newObject(FindLimitLakeModel, this, "fllmc", this.compDepth, {initCond:"high", active:true});
		this.initQuestions("lakeModel.mirkyLakeExcercise.questions.question");
		this.quesActive = true;
		
		//create showHelp function
		var showHelp:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:470, _y:10, w:460, txt:LindApp.getMsg("lakeModel.mirkyLakeExcercise.introductions2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//start with help visible
		showHelp.apply(this);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtnEvalResp();
		this.createBtn("btn_showAns", LindApp.getMsg("btn.howtoExploreNLValues"), this, showHelp, false);
	}	
	
	/*
	 * Step 19: Introduce bistability
	 * 
	 * @param the container clip for the step
	 */
	private function step19(cont):Void{

		//create image
		var img = cont.attachMovie("lm_bistable_intro", "lm_bistable_intro", cont.getNextHighestDepth(), {_x:0, _y:70});
		img["tf_title"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.title");
		img["tf_clearStart"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.clearStart");
		img["tf_mirkyStart"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.mirkyStart");
		img["tf_lowerLimitDesc"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.lowerLimitDesc");
		img["tf_lowerLimitVal"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.lowerLimitVal");
		img["tf_upperLimitDesc"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.upperLimitDesc");
		img["tf_upperLimitVal"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.upperLimitVal");
		img["tf_NLInc"].text = LindApp.getMsg("lakeModel.bistable.story.introBiestable.graphic.NLInc");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.bistable.story.introBiestable"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 20: Phase diagram
	 * 
	 * @param the container clip for the step
	 */
	private function step20(cont):Void{

		//create image
		var img = cont.attachMovie("lm_phaseDiag", "lm_phaseDiag", cont.getNextHighestDepth(), {_x:10, _y:70});
		img["tf_txt1"].text = LindApp.getMsg("lakeModel.bistable.story.phaseDiag.graphic.txt1");
		img["tf_txt2"].text = LindApp.getMsg("lakeModel.bistable.story.phaseDiag.graphic.txt2");
		img["tf_unstableEquilib"].text = LindApp.getMsg("lakeModel.bistable.story.phaseDiag.graphic.unstableEquilib");
		img["tf_stableEquilib"].text = LindApp.getMsg("lakeModel.bistable.story.phaseDiag.graphic.stableEquilib");
		img["tf_AValues"].text = LindApp.getMsg("lakeModel.bistable.story.phaseDiag.graphic.AValues");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.bistable.story.phaseDiag"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 21: Bistable excercise
	 * 
	 * @param the container clip for the step
	 */
	private function step21(cont):Void{
		
		//create explore lake model component with clear initial conditions
		this.currComp = Utils.newObject(ExploreBistableLakeModel, this, "eblm", this.compDepth, {active:true});
		this.initQuestions("lakeModel.bistableLakeExcercise.questions.question");
		this.quesActive = true;
		
		//init text
		Utils.createTextField("tf", cont, cont.getNextHighestDepth(), 30, 380, 900, 10, LindApp.getMsg("lakeModel.bistableLakeExcercise.intructions1"), LindApp.getTxtFormat("bigTxtFormat"));
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtnEvalResp();
	}
	
	/*
	 * Step 22: 3d phase diagram
	 * 
	 * @param the container clip for the step
	 */
	private function step22(cont):Void{

		//create image
		var img = cont.attachMovie("lm_bistab_3d", "lm_bistab_3d", cont.getNextHighestDepth(), {_x:20, _y:70, _xscale:130, _yscale:130});
		img["tf_clear"].text = LindApp.getMsg("lakeModel.bistable.story.3d.graphic.clear");
		img["tf_mirky"].text = LindApp.getMsg("lakeModel.bistable.story.3d.graphic.mirky");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.bistable.story.3d"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 23: stability diagram 1
	 * 
	 * @param the container clip for the step
	 */
	private function step23(cont):Void{

		//create image
		var img = cont.attachMovie("lm_bistab_diag", "lm_bistab_diag", cont.getNextHighestDepth(), {_x:10, _y:100});
		img["tf_eq_clear"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.clearEquilib");
		img["tf_eq_mirky"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.mirkyEquilib");
		img["tf_lomo"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.lomo");
		img["tf_clearLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.clearLake");
		img["tf_bistableLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.bistableLake");
		img["tf_mirkyLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.mirkyLake");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.bistable.story.diag"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 24: stability diagram 2
	 * 
	 * @param the container clip for the step
	 */
	private function step24(cont):Void{

		//create image
		var img = cont.attachMovie("lm_bistab_diag2", "lm_bistab_diag2", cont.getNextHighestDepth(), {_x:10, _y:100});
		img.diag["tf_eq_clear"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.clearEquilib");
		img.diag["tf_eq_mirky"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.mirkyEquilib");
		img.diag["tf_lomo"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.lomo");
		img.diag["tf_clearLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.clearLake");
		img.diag["tf_bistableLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.bistableLake");
		img.diag["tf_mirkyLake"].text = LindApp.getMsg("lakeModel.bistable.story.diag.graphic.mirkyLake");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.bistable.story.diag2"));
		this.tweenIn(story)
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 25: Random init condition excercise
	 * 
	 * @param the container clip for the step
	 */
	private function step25(cont):Void{
		
		//create explore lake model component with clear initial conditions
		this.currComp = Utils.newObject(RandomInitCondLakeModel, this, "riclm", this.compDepth, {active:true});
		
		//create function to show intro text
		var showIntro:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:150, w:520, txt:LindApp.getMsg("lakeModel.randomInitCond.intro"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//create function to show answer
		var showAnswer:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:150, w:520, txt:LindApp.getMsg("lakeModel.randomInitCond.answer"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		//show intro by default
		showIntro.apply(this);
				
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnReset();
		this.createBtn("btn_showIntro", LindApp.getMsg("btn.showIntroText"), this, showIntro, false);
		this.createBtn("btn_showAns", LindApp.getMsg("btn.showAnswer"), this, showAnswer, false);
	}
		
	/*
	 * Step 26: Conclusions - 1
	 * 
	 * @param the container clip for the step
	 */
	private function step26(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_n_in_river", "lm_n_in_river", cont.getNextHighestDepth(), {_x:210, _y:250});
		cont.attachMovie("lm_mirkyLake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_bomb", "lm_bomb", cont.getNextHighestDepth(), {_x:400, _y:290});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.conclusions.story.txt1"));
		this.tweenIn(story)
		
		//create function to show answer
		var showAnswer:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:150, w:520, txt:LindApp.getMsg("lakeModel.conclusions.story.txt2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")});
		}
		
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtn("btn_showAns", LindApp.getMsg("btn.showAnswer"), this, showAnswer, false);
	}

	/*
	 * Step 27: Conclusions - 2
	 * 
	 * @param the container clip for the step
	 */
	private function step27(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "lm_mountain", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_n_in_river", "lm_n_in_river", cont.getNextHighestDepth(), {_x:210, _y:250});
		cont.attachMovie("lm_mirkyLake", "lm_lake", cont.getNextHighestDepth(), {_x:25, _y:330});
		cont.attachMovie("lm_bomb", "lm_bomb", cont.getNextHighestDepth(), {_x:400, _y:290});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("lakeModel.conclusions.story.txt3"));
		this.tweenIn(story);
		
		//create buttons
		this.createBtnGotoNextActivity(false, LindApp.getMsg("btn.gotoAct3"));
		this.createBtnBack();
		this.createBtnGotoMenuPrin();
	}
	
}