import ascb.util.logging.Logger;
import core.comp.UserMessage;
import core.util.Utils;
import core.comp.Graph;
import core.comp.ResultTable;
import lindissima.comp.cornModel.ExploreCornModel
import lindissima.Const;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import lindissima.process.CornBiomass;
import lindissima.process.FarmerNetProfit;
import lindissima.process.NInSoil;

/*
 * Lindissima activity based on corn model where the only available variable for the user
 * is the level of fertilizer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class lindissima.activity.CornModel extends lindissima.activity.LindActivity{
	 
	 //logger
	public static var logger:Logger = Logger.getLogger("lindissima.activity.CornModel");
	
	//processes
	private var nis:NInSoil;
	private var fnp:FarmerNetProfit;
	private var cb:CornBiomass;
	
	/*
	 * Constructor
	 */
	public function CornModel() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating CornModel");

		//initialize processes
		nis = NInSoil(NInSoil.getProcess());
		fnp = FarmerNetProfit(FarmerNetProfit.getProcess());
		cb = CornBiomass(CornBiomass.getProcess());

		//get first step
		getStep(1);
	}
	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		//step dependent initializations
		if (step<12 || step>21){
			removeECM();
		}else if (step<22){
			createECM(false);
			this.quesInProc = false;
		}
		
		return step;
	}
	
	/*
	 * Creates the explore corn model component if not present
	 * 
	 * @param active when true the model is active
	 */
	private function createECM(active:Boolean):Void{
		if (!this["ecm"]){
			Utils.newObject(ExploreCornModel, this, "ecm", this.compDepth, {active:active});
			initQuestions("cornModel.excercise.questions.question");
		}
		this.quesActive = active;
	}

	/*
	 * Removes the explore corn model component if present
	 * 
	 * @param active when true the model is active
	 */
	private function removeECM(active:Boolean):Void{
		if (this["ecm"]){
			this["ecm"].removeMovieClip();
			this["quesCont"].removeMovieClip();
		}
	}
	
	/*
	 * Creates the button "Auxiliar Graphs"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	private function createBtnAuxGraphs(desactivate:Boolean):Void {
		
		//define function
		var fnc:Function = function(){
			this["ecm"].openAuxGraphs();
		}
		
		//create button aux graphs
		this.createBtn("btn_aux_graphs", LindApp.getMsg("btn.auxGraphs"), this, fnc, desactivate);
	}
	
	/*
	 * Auxiliar function to draw values for farmer net profit in graph. Must shift the values by -1.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getFarmerNetProfit(y:Number):Number{
		return Utils.roundNumber(this.fnp.getOutput(y-1), 2);
	}
	
	/*
	 * Auxiliar function to draw values for nitrogen in soil in table. Must shift the values by -1.
	 * 
	 * @param y the year for which the net profit is required
	 * @return the farmers net profit 
	 */
	public function getNInSoil(y:Number):Number{
		return Utils.roundNumber(this.nis.getOutput((y)*52), 2);
	}
	
	/*
	 * Auxiliar function to calculate the average profit over a five year period.
	 * 
	 * @return the farmers average profit 
	 */
	public function getAvrgeProfit():Number{
		
		var totProfit:Number = 0;
		for (var y=1; y<6;y++){
			totProfit += getFarmerNetProfit(y);
		}
		return Utils.roundNumber(totProfit/5, 2);
	}
	
	/*
	 * Auxiliar function to draw values for grain biomass in table.
	 * 
	 * @param y the year for which the biomass is required
	 * @param id the id of the column, not used
	 * @return the biomass of grain harvested
	 */
	public function getGrainBiomass(y:Number, id:String):String{
		return Utils.roundNumber(this.cb.getAcumAnual(y)*Const.HECTARES_CORN*LUtils.getIP("indCosecha"), 2).toString();
	}	

	/*
	 * Step 1
	 * 
	 * @param the container clip for the step
	 */
	private function step1(cont):Void{
		
		//create title text
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "center";
		Utils.createTextField("intro_txt1", cont, 1, 0, 20, 950, 1, LindApp.getMsg("cornModel.preamble.intro1"), LindApp.getTxtFormat("bigTitleTxtFormat"));
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "left";
		LindApp.getTxtFormat("bigTxtFormat").align = "center";
		Utils.createTextField("intro_txt2", cont, 2, 0, 100, 950, 1, LindApp.getMsg("cornModel.preamble.intro2"), LindApp.getTxtFormat("bigTxtFormat"));
		LindApp.getTxtFormat("bigTxtFormat").align = "left";

		//create img
		cont.attachMovie("cm_intro", "img", cont.getNextHighestDetph(), {_x:300, _y:170});

		//create buttons
		createBtnNext();
		createBtnGotoMenuPrin();
	}
	
	/*
	 * Step 2
	 * 
	 * @param the container clip for the step
	 */
	private function step2(cont):Void{
		
		//create mountain clip
		var mount = cont.attachMovie("mountain_1", "mount", cont.getNextHighestDepth(), {_x:20, _y:100});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount["rtq_size"].text  = LindApp.getMsg("cornModel.preamble.graphic.mountain.rtqSize");
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt1"));
		tweenIn(story);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 3
	 * 
	 * @param the container clip for the step
	 */
	private function step3(cont):Void{

		//create mountain clip
		var mount = cont.attachMovie("mountain_2", "mount", cont.getNextHighestDepth(), {_x:20, _y:100});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize2");
		mount["rtq_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.rtqSize2");
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt2"));
		tweenIn(story);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 4
	 * 
	 * @param the container clip for the step
	 */
	private function step4(cont):Void{

		//create mountain clip
		var mount = cont.attachMovie("mountain_3", "mount", cont.getNextHighestDepth(), {_x:20, _y:100});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount["anual_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.anualSize");
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt3"));
		tweenIn(story);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 5
	 * 
	 * @param the container clip for the step
	 */
	private function step5(cont):Void{
		
		//reset processes
		LUtils.clearOutputs();
		
		//calculate average net profit
		var anp_perHectare:Number = Math.round(getAvrgeProfit());
		var anp:Number = anp_perHectare*Const.HECTARES_CORN;
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt4", new Array(String(anp))));
		tweenIn(story);
		
		//create the net profit vs time graph
		var npvtGraph = Utils.newObject(Graph, cont, "npvtGraph", cont.getNextHighestDepth(), {_x:20, _y:50, w:500, h:250, xInit:1, xAxisRange:5, xAxisScale:1, xAxisLabel:LindApp.getMsg("cornModel.preamble.intro.netProfitVsTimeGraph.xAxis"), yAxisRange:2500, yAxisScale:400, yAxisLabel:LindApp.getMsg("cornModel.preamble.intro.netProfitVsTimeGraph.yAxis"), drwBorder:false});
		npvtGraph.addGraphicFromFunc("npvtGraphic", 0x006600, this, this.getFarmerNetProfit, 1, 1, 5);
		
		//create detail table
		var detailTbl = Utils.newObject(ResultTable, cont, "detailTbl", cont.getNextHighestDepth(),{_x:20, _y:330, nRows:5, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8});
		detailTbl.addCol("t", LindApp.getMsg("tbl.col.years"), nis, nis.getTableValueYear, 125);
		detailTbl.addCol("nis", LindApp.getMsg("tbl.col.nInSoil"), this, this.getNInSoil, 125);
		detailTbl.addCol("cb", LindApp.getMsg("tbl.col.grainBiomass"), this, this.getGrainBiomass, 125);
		detailTbl.addCol("fnp", LindApp.getMsg("tbl.col.netProfit"), fnp, fnp.getTableValueYear, 125);
		
		//create average net profit per hectare y total
		LindApp.getTxtFormat("altTxtFormat").align = "right";
		Utils.createTextField("anp_ph", cont, cont.getNextHighestDepth(), 20, 460, 500, 20, LindApp.getMsg("cornModel.preamble.intro.average5yearlyNetProfitPerHectare", new Array(String(anp_perHectare))), LindApp.getTxtFormat("altTxtFormat"))
		Utils.createTextField("anp_tot", cont, cont.getNextHighestDepth(), 20, 480, 500, 20, LindApp.getMsg("cornModel.preamble.intro.average5yearlyNetProfit", new Array(String(Const.HECTARES_CORN), String(anp))), LindApp.getTxtFormat("altTxtFormat"))
		LindApp.getTxtFormat("altTxtFormat").align = "left";
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 6
	 * 
	 * @param the container clip for the step
	 */
	private function step6(cont):Void{
		
		//create mountain clip
		var mount = cont.attachMovie("mountain_3", "mount", cont.getNextHighestDepth(), {_x:20, _y:100});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount["anual_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.anualSize");

		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt5", new Array(String(LUtils.getIP("cstUrea")))));
		tweenIn(story);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 7
	 * 
	 * @param the container clip for the step
	 */
	private function step7(cont):Void{
		
		//create mountain  1 clip
		var mount1 = cont.attachMovie("mountain_2", "mount1", cont.getNextHighestDepth(), {_x:20, _y:80});
		mount1["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize2");
		mount1["rtq_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.rtqSize2");

		//create mountain  2 clip
		var mount2 = cont.attachMovie("mountain_3", "mount1", cont.getNextHighestDepth(), {_x:450, _y:200});
		mount2["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount2["anual_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.anualSize");
		
		//create arrow
		var arrow = cont.attachMovie("mount_arrow", "mount_arrow", cont.getNextHighestDepth(), {_x:400, _y:160});
		
		//create texts
		var story1 = Utils.createTextField("txt1", cont, cont.getNextHighestDepth(), 20, 10, 900, 20, LindApp.getMsg("cornModel.preamble.intro.txt6"), LindApp.getTxtFormat("storyTxtFormat"));
		var story2 = Utils.createTextField("txt2", cont, cont.getNextHighestDepth(), 20, 430, 400, 20, LindApp.getMsg("cornModel.preamble.intro.txt7"), LindApp.getTxtFormat("storyTxtFormat"));
		
		//tween in all
		tweenIn(mount1);
		tweenIn(mount2);
		tweenIn(arrow);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 8
	 * 
	 * @param the container clip for the step
	 */
	private function step8(cont):Void{
		
		//create economics text field
		Utils.newObject(UserMessage, cont, "ec_txt", cont.getNextHighestDepth(), {_x:20, _y:40, w:450, txt:LindApp.getMsg("cornModel.preamble.systemRQ.anualProfit.txt"), txtFormat:LindApp.getTxtFormat("altTxtFormat"), titleTxt:LindApp.getMsg("cornModel.preamble.systemRQ.anualProfit.title"), titleTxtFormat:LindApp.getTxtFormat("bigAltTxtFormat"), btnClose:false, isTransparent:true})
		
		//create nitrogen text field
		Utils.newObject(UserMessage, cont, "n_txt", cont.getNextHighestDepth(), {_x:20, _y:380, w:450, txt:LindApp.getMsg("cornModel.preamble.systemRQ.nitrogen.txt"), txtFormat:LindApp.getTxtFormat("altTxtFormat"), titleTxt:LindApp.getMsg("cornModel.preamble.systemRQ.nitrogen.title"), titleTxtFormat:LindApp.getTxtFormat("bigAltTxtFormat"), btnClose:false, isTransparent:true})

		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.systemRQ.storyTxt"));
		tweenIn(story);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 9
	 * 
	 * @param the container clip for the step
	 */
	private function step9(cont):Void{
		
		//create mountain clip
		var mount = cont.attachMovie("mountain_3", "mount", cont.getNextHighestDepth(), {_x:20, _y:150});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount["anual_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.anualSize");
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt8"));
		tweenIn(story);
		
		//create question
		Utils.newObject(UserMessage, cont, "txt_2", cont.getNextHighestDepth(), {_x:20, _y:40, w:400, txt:LindApp.getMsg("cornModel.preamble.intro.txt9"), txtFormat:LindApp.getTxtFormat("storyTxtFormat"), btnClose:false, isTransparent:true})

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 10
	 * 
	 * @param the container clip for the step
	 */
	private function step10(cont):Void{
		
		//create mountain clip
		var mount = cont.attachMovie("mountain_3", "mount", cont.getNextHighestDepth(), {_x:20, _y:150});
		mount["reserve_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.reserveSize");
		mount["anual_size"].text = LindApp.getMsg("cornModel.preamble.graphic.mountain.anualSize");

		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt10"));
		tweenIn(story);
		
		//create question
		Utils.newObject(UserMessage, cont, "txt_2", cont.getNextHighestDepth(), {_x:20, _y:40, w:400, txt:LindApp.getMsg("cornModel.preamble.intro.txt11"), txtFormat:LindApp.getTxtFormat("storyTxtFormat"), btnClose:false, isTransparent:true})
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 11
	 * 
	 * @param the container clip for the step
	 */
	private function step11(cont):Void{
		
		//create model clip
		var cm = cont.attachMovie("corn_model", "cm", cont.getNextHighestDepth(), {_x:20, _y:150});
		
		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.preamble.intro.txt12"));
		tweenIn(story);
		
		//create question
		Utils.newObject(UserMessage, cont, "txt_2", cont.getNextHighestDepth(), {_x:20, _y:40, w:400, txt:LindApp.getMsg("cornModel.preamble.intro.txt13"), txtFormat:LindApp.getTxtFormat("storyTxtFormat"), btnClose:false, isTransparent:true})

		//create buttons
		createBtnNext();
		createBtnBack();
	}

	/*
	 * Step 12
	 * 
	 * @param the container clip for the step
	 */
	private function step12(cont):Void{

		//create message
		var story = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt1"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		
		//create border around questions
		drawBorder("border", 20, 470, 930, 60);
		
		//tween in story
		tweenIn(story);

		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnSkipTutorial(false, 21);
		createBtnEvalResp(true);
		createBtnAuxGraphs(true);
		
		
	}
	
	/*
	 * Step 13
	 * 
	 * @param the container clip for the step
	 */
	private function step13(cont):Void{

		//create message
		var story = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt2"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(story);
		
		//create border around nitrogen input box
		drawBorder("border", 40, 10, 360, 70);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
	}
		
	/*
	 * Step 14
	 * 
	 * @param the container clip for the step
	 */
	private function step14(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt3"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create border around questions
		drawBorder("border", 40, 300, 360, 120);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
	}
	
	/*
	 * Step 15
	 * 
	 * @param the container clip for the step
	 */
	private function step15(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt4"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create border around questions
		drawBorder("border", 450, 250, 250, 200);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
	}
	
	/*
	 * Step 16
	 * 
	 * @param the container clip for the step
	 */
	private function step16(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt5"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create border around questions
		drawBorder("border", 700, 250, 250, 200);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
	}
	
	/*
	 * Step 17
	 * 
	 * @param the container clip for the step
	 */
	private function step17(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt6"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
		
		//create border around aux graphs button
		drawBorder("border", this["mcStep"].btns.btn_aux_graphs._x-5, 547, this["mcStep"].btns.btn_aux_graphs._width+5, 28);
	}

	/*
	 * Step 18
	 * 
	 * @param the container clip for the step
	 */
	private function step18(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt7"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create borders
		drawBorder("border", 40, 80, 360, 30);
		drawBorder("border", 450, 0, 500, 250);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
	}

	/*
	 * Step 19
	 * 
	 * @param the container clip for the step
	 */
	private function step19(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt8"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create borders
		
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
		
		//create borders
		drawBorder("border", this["mcStep"].btns.btn_eval_resp._x-5, 547, this["mcStep"].btns.btn_eval_resp._width+5, 28);
		drawBorder("border", 20, 470, 930, 60);
	}	
	
	/*
	 * Step 19
	 * 
	 * @param the container clip for the step
	 */
	private function step20(cont):Void{

		//create message
		Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:30, w:370, txt:LindApp.getMsg("cornModel.preamble.presentExcercise.txt9"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), btnClose:false});
		cont["msg"]._y = 110+(190-cont["msg"]._height)/2;
		tweenIn(cont["msg"]);
		
		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs(true);
		createBtnEvalResp(true);
		
		//create borders
		drawBorder("border", this["mcStep"].btns.btn_back._x-5, 547, this["mcStep"].btns.btn_back._width+5, 28);
		drawBorder("border", this["mcStep"].btns.btn_next._x-5, 547, this["mcStep"].btns.btn_next._width+5, 28);
	}
	
	/*
	 * Step 21
	 *
	 * @param the container clip for the step
	 */
	private function step21(cont):Void{

		//create message
		var story = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:400, _y:200, w:250, txt:LindApp.getMsg("cornModel.excercise.start"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), fadeOutAfter:4000});
		tweenIn(story);

		//activate explore corn model
		this["ecm"].reset();
		this["ecm"].activate();
		
		//reinitialize questions
		initQuestions("cornModel.excercise.questions.question");
		quesActive = true;

		//create buttons
		createBtnNext();
		createBtnBack();
		createBtnAuxGraphs();
		createBtnEvalResp();
	}

	/*
	 * Step 21
	 * 
	 * @param the container clip for the step
	 */
	private function step22(cont):Void{
		
		//create title text
		Utils.createTextField("txt1", cont, cont.getNextHighestDepth(), 20, 10, 450, 20, LindApp.getMsg("cornModel.conclusion.txt1"), LindApp.getTxtFormat("storyTxtFormat"));

		//create story text
		var story:UserMessage = createStoryTxt(LindApp.getMsg("cornModel.conclusion.txt2"));
		tweenIn(story);
		
		//create graphic
		cont.attachMovie("cm_conclusion", "graphic", cont.getNextHighestDepth(), {_x:20, _y:100, xAxis:LindApp.getMsg("cornModel.conclusion.xAxis"), yAxis:LindApp.getMsg("cornModel.conclusion.yAxis")});
		
		//create buttons
		createBtnGotoNextActivity(false, LindApp.getMsg("btn.gotoAct2"));
		createBtnBack();
		createBtnGotoMenuPrin();
		
	}
	
}