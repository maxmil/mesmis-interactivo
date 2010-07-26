import ascb.util.logging.Logger;
import core.comp.BubbleBtn;
import core.comp.ComponentWindow;
import core.comp.UserMessage;
import core.comp.EmergingText;
import core.comp.TextPane;
import core.util.Utils;
import core.util.Proxy;
import core.comp.EyeBtn;
import lindissima.comp.cornShrubModel.ExploreCornShrubModel;
import lindissima.comp.cornShrubModel.ExploreCornShrubModelAnualDetail;
import lindissima.comp.cornShrubModel.ExploreCornShrubModelAuxGraphs;
import lindissima.LindApp;

/*
 * Lindissima activity based on corn shrub model where the user can vary model parameters
 * to find a solution for the lake worker and corn farmer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 07-08-2005
 */
 class lindissima.activity.CornShrubModel extends lindissima.activity.LindActivity{
	 
	 //logger
	private static var logger:Logger = Logger.getLogger("lindissima.activity.CornShrubModel");
	
	/*
	 * Constructor
	 */
	public function CornShrubModel() {
		
		//call super class constructor
		super();
		
		//log
		logger.debug("instantiating CornShrubModel");
		
		//create model
		this.currComp = Utils.newObject(ExploreCornShrubModel, this, "ecsm", this.compDepth, {active:false});

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
		// - no model
		// - inactive model
		// - active model
		if (step<3 || (step>16 && step<23) || step>26){
			removeECSM();
		}else if ((step>2 && step<15) || (step>22 && step<26)){
			createECSM(false);
		}else if ((step>14 && step<17) || step==26){
			createECSM(true);
		}
		
		return step
	}
	
	/*
	 * Creates the explore corn shrub model component if not present
	 * 
	 * @param active when true the model is active
	 */
	private function createECSM(active:Boolean):Void{
		if (this["ecsm"].active != active){
			(active) ? this["ecsm"].activate() : this["ecsm"].desactivate();
		}
		this["ecsm"]._visible = true;
	}
	
	/*
	 * Removes the explore corn shrub model component if present
	 * 
	 * @param active when true the model is active
	 */
	private function removeECSM(active:Boolean):Void{
		this["ecsm"]._visible = false;
	}

	/*
	 * Creates the button "Evaluate Response"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnEvalResp(func:Function, desactivate:Boolean):Void {
		this.createBtn("btn_eval_resp", LindApp.getMsg("btn.evaluateResponse"), this, func, desactivate);
	}
	
	/*
	 * Creates the button "Auxiliar Graphs"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	private function createBtnAuxGraphs(desactivate:Boolean):Void {
		
		//define function
		var fnc:Function = function(){
			this["ecsm"].openAuxGraphs();
		}
		
		//create button aux graphs
		this.createBtn("btn_aux_graphs", LindApp.getMsg("btn.auxGraphs"), this, fnc, desactivate);
	}

	/*
	 * Creates the button "Monocultive Curve"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	private function createBtnMonoCurve(desactivate:Boolean):Void {
		
		//define function
		var fnc:Function = function(){
			this["ecsm"].doMonoCurve();
		}
		
		//create button aux graphs
		this.createBtn("btn_mono_curve", LindApp.getMsg("btn.monocultiveCurve"), this, fnc, desactivate);
	}
	
	/*
	 * Creates the button "See Solution"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	private function createBtnSeeSolution(desactivate:Boolean):Void {
		
		//define function
		var fnc:Function = function(){
			this["ecsm"].seeSol();
		}
		
		//create button
		this.createBtn("btn_see_sol", LindApp.getMsg("btn.seeSolution"), this, fnc, desactivate);
	}
	
	/*
	 * Creates all the model buttons
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	private function createModelButtons(desactivate:Boolean):Void {
		this.createBtnReset(desactivate);
		createBtnAuxGraphs(desactivate);
		createBtnMonoCurve(desactivate);
	}
	
	/*
	 * Step 1: Title
	 * 
	 * @param the container clip for the step
	 */
	private function step1(cont):Void{

		//create title text
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "center";
		Utils.createTextField("intro_txt1", cont, 1, 100, 20, 800, 1, LindApp.getMsg("cornShrubModel.preamble.intro1"), LindApp.getTxtFormat("bigTitleTxtFormat"));
		LindApp.getTxtFormat("bigTitleTxtFormat").align = "left";
		LindApp.getTxtFormat("bigTxtFormat").align = "center";
		Utils.createTextField("intro_txt2", cont, 2, 100, 100, 800, 1, LindApp.getMsg("cornShrubModel.preamble.intro2"), LindApp.getTxtFormat("bigTxtFormat"))		
		LindApp.getTxtFormat("bigTxtFormat").align = "left";
		
		//create imgs
		var img = cont.attachMovie("csm_principal", "img1", cont.getNextHighestDepth(), {_x:250, _y:110});
		
		//create buttons
		this.createBtnNext();
		this.createBtnGotoMenuPrin();
	}
	
	/*
	 * Step 2: Introduction Lixiviation
	 * 
	 * @param the container clip for the step
	 */
	private function step2(cont):Void{

		//create images
		var img = cont.attachMovie("csm_intro", "csm_intro", cont.getNextHighestDepth(), {_x:20, _y:70});
		img["tf_NFert"].text = LindApp.getMsg("cornShrubModel.preamble.intro.graphic.nFert");
		img["tf_NLix"].text = LindApp.getMsg("cornShrubModel.preamble.intro.graphic.nLix");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble.story.txt1"));
		
		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}

	/*
	 * Step 3: Excercise presentation - random initial conditions
	 *
	 * @param the container clip for the step
	 */
	private function step3(cont):Void{
		
		//reinicialize model and generate random
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:0, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.randomInitCond"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		msg._y = 430-msg._height;

		//create border around random initial conditions and generate
		this.drawBorder("border", 10, 445, 420, 94);

		//tween in all
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnSkipTutorial(false, 15);
		createModelButtons(true);

	}
	
	/*
	 * Step 4: Excercise presentation - generate
	 *
	 * @param the container clip for the step
	 */
	private function step4(cont):Void{
		
		//reinicialize model and generate random
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:430, _y:20, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.generate"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//create borders
		this.drawBorder("border_1", 361, 46, 50, 20);
		this.drawBorder("border_2", 289, 272, 103, 21);
		this.drawBorder("border_3", 14, 365, 412, 40);

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 5: Excercise presentation - const values
	 *
	 * @param the container clip for the step
	 */
	private function step5(cont):Void{
		
		//reinicialize model and generate random
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:450, _y:280, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.remindConstVals"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//open const vals
		var tp:TextPane = Utils.newObject(TextPane, cont, "const_vals_tp", cont.getNextHighestDepth(), {_x:200, _y:20, w:580, h:250, titleTxt:LindApp.getMsg("cornShrubModel.excercise.constVals.title"), allowDrag:false, resize:false, btnClose:false, btnMinMax:false, bgAlpha:90, bgColor:0xffffff});
		Utils.createTextField("tf", tp.getContent(), 1, 0, 0, 580, 1, LindApp.getMsg("cornShrubModel.excercise.constVals.text"), LindApp.getTxtFormat("defaultTxtFormat"));
		tp.init(false);

		//create borders
		this.drawBorder("border_1", 200, 20, 580, 250);
		this.drawBorder("border_2", 260, 300, 160, 15);

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}

	/*
	 * Step 6: Excercise presentation - anual detail
	 *
	 * @param the container clip for the step
	 */
	private function step6(cont):Void{
	
		//reinicialize model and generate random
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:450, _y:280, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.anualDetail"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//open detail table
		var cw:ComponentWindow = Utils.newObject(ComponentWindow, cont, "anualDetail", cont.getNextHighestDepth(), {_x:200, _y:100, w:572, h:170, compClass:ExploreCornShrubModelAnualDetail, btnMinMax:false, btnClose:false, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.anualDetail.title"), animate:false});
		cw.comp.update();
		
		//create borders
		this.drawBorder("border_1", 200, 100, 572, 165);
		var tp = this["ecsm"].detail_tp;
		var btn:BubbleBtn = this["ecsm"].detail_tp.getContent().btn_anual_res;
		this.drawBorder("border_2", btn._x+tp.getContentX()+tp._x-1, btn._y+tp.getContentY()+tp._y, btn._width+3, btn._height+2);

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 7: Excercise presentation - graph
	 *
	 * @param the container clip for the step
	 */
	private function step7(cont):Void{
	
		//reinicialize model, generate random and first point
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:20, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.graphic"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		
		//open detail table
		var cw:ComponentWindow = Utils.newObject(ComponentWindow, cont, "anualDetail", cont.getNextHighestDepth(), {_x:400, _y:300, w:572, h:170, compClass:ExploreCornShrubModelAnualDetail, btnMinMax:false, btnClose:false, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.anualDetail.title"), animate:false, allowDrag:false});
		cw.comp.update();
		
		//create roll over effect on point
		this["ecsm"].npvnGraph.graphicsCont.npvnGraphic.pnt_npvnGraphic_0.onRollOver();
		
		//create borders
		this.drawBorder("border_1", 146, 385, 80, 20);
		this.drawBorder("border_2", 686, 357, 80, 20);
		this.drawBorder("border_3", 580, 150, 80, 30);

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 8: Excercise presentation - additional graphics 1
	 *
	 * @param the container clip for the step
	 */
	private function step8(cont):Void{

		//reinicialize model, generate random and first point for N=6.2
		this["ecsm"].reset();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "6.2";
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//open aditional graphics
		var cw:ComponentWindow = Utils.newObject(ComponentWindow, cont, "auxGraphs", cont.getNextHighestDepth(), {_x:150, _y:50, w:770, h:455, compClass:ExploreCornShrubModelAuxGraphs, allowDrag:false, btnMinMax:false, btnClose:false, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.auxiliarGraphs"), animate:false});
				
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:90, w:380, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.additionalGraphics.1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		
		//create numbers
		Utils.createTextField("tf_1", cw["comp"].bmvtGraph, cw["comp"].nisvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(2)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].fpgvtGraph, cw["comp"].nfvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(3)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].fnvtGraph, cw["comp"].nfvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(5)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].fnvnGraph, cw["comp"].nfvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(6)", LindApp.getTxtFormat("warningTxtFormat"));

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
		
		//create borders
		this.drawBorder("border_1", 411, 87, 250, 200);
		this.drawBorder("border_2", 411, 292, 250, 200);
		this.drawBorder("border_3", 666, 292, 250, 200);
		var btn:BubbleBtn = this["mcStep"].btns.btn_aux_graphs;
		var btns = this["mcStep"].btns;
		this.drawBorder("border_4", btns._x+btn._x-2, btns._y+btn._y-2, btn._width, btn._height);
	}	
	
	/*
	 * Step 9: Excercise presentation - additional graphics 2
	 *
	 * @param the container clip for the step
	 */
	private function step9(cont):Void{

		//reinicialize model, generate random and first point for N=6.2
		this["ecsm"].reset();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "6.2";
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//open aditional graphics
		var cw:ComponentWindow = Utils.newObject(ComponentWindow, cont, "auxGraphs", cont.getNextHighestDepth(), {_x:50, _y:50, w:770, h:455, compClass:ExploreCornShrubModelAuxGraphs, allowDrag:false, btnMinMax:false, btnClose:false, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.auxiliarGraphs"), animate:false});
				
		//initialize message
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:350, _y:60, w:450, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.additionalGraphics.2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		
		//create numbers
		Utils.createTextField("tf_1", cw["comp"].nisvtGraph, cw["comp"].nisvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(1)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].nfvtGraph, cw["comp"].nfvtGraph.getNextHighestDepth(), 200, 20, 40, 1, "(4)", LindApp.getTxtFormat("warningTxtFormat"));

		//tween in msg
		this.tweenIn(msg);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
		
		//create borders
		this.drawBorder("border_1", 56, 87, 250, 200);
		this.drawBorder("border_2", 56, 292, 250, 200);
		var btn:BubbleBtn = this["mcStep"].btns.btn_aux_graphs;
		var btns = this["mcStep"].btns;
		this.drawBorder("border_5", btns._x+btn._x-2, btns._y+btn._y-2, btn._width, btn._height);
	}
	
	/*
	 * Step 10: Excercise presentation - satisfaction
	 *
	 * @param the container clip for the step
	 */
	private function step10(cont):Void{
		
		//initialize messages
		var msg1:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg1", cont.getNextHighestDepth(), {_x:0, _y:-100, w:440, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.satisfaction.1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		var msg2:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg2", cont.getNextHighestDepth(), {_x:0, _y:430, w:440, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.satisfaction.2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//reinicialize model, and generate first point
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//create borders
		this.drawBorder("border_1", 14, 365, 412, 40);
		this.drawBorder("border_2", 444, 305, 492, 140);
		this.drawBorder("border_3", 444, 473, 212, 39);
		this.drawBorder("border_4", 796, 473, 140, 39);
		var amoeba:ComponentWindow = this["ecsm"].amoeba;
		var btn:BubbleBtn = this["ecsm"].amoeba.comp.btn_show_details;
		this.drawBorder("border_5", amoeba._x+amoeba.getContentX()+btn._x-1, amoeba._y+amoeba.getContentY()+btn._y, btn._width+3, btn._height+2);

		//tween in msg
		this.tweenIn(msg1);
		this.tweenIn(msg2);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 11: Excercise presentation - amoeba
	 *
	 * @param the container clip for the step
	 */
	private function step11(cont):Void{

		//reinicialize model, generate first point and show amoeba without back button
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		this["ecsm"].amoeba.comp.showDetails();
		this["ecsm"].amoeba_details.btn_back_amoeba._visible = false;
		this["mcStep"].btns._visible = true;
		
		//create borders
		this.drawBorder("border_1", 240, 150, 80, 210);
		this.drawBorder("border_2", 405, 55, 530, 470);
		
		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:20, w:600, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.amoeba"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		
		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
		
	/*
	 * Step 12: Excercise presentation - amoeba 2
	 *
	 * @param the container clip for the step
	 */
	private function step12(cont):Void{

		//reinicialize model, generate first point and show amoeba without back button
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		this["ecsm"].amoeba.comp.showDetails();
		this["ecsm"].amoeba_details.btn_back_amoeba._visible = false;
		this["mcStep"].btns._visible = true;
		
		//create borders
		this.drawBorder("border_1", 320, 150, 80, 210);
		var btn:BubbleBtn = this["ecsm"].amoeba_details.btn_update;
		this.drawBorder("border_2", btn._x-2, btn._y-2, btn._width+3, btn._height+2);
		this.drawBorder("border_3", 280, 450, 120, 60);

		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:-30, w:600, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.amoeba.2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 13: Excercise presentation - satisfaction
	 *
	 * @param the container clip for the step
	 */
	private function step13(cont):Void{

		//reinicialize model, generate two points updating the reference amoeba
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		this["ecsm"].amoeba.comp.updateRef();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "6";
		this["ecsm"].runModel();
		
		//create borders
		this.drawBorder("border_1", 656, 305, 280, 207);
		var amoeba:ComponentWindow = this["ecsm"].amoeba;
		var btn:BubbleBtn = this["ecsm"].amoeba.comp.btn_update_ref;
		this.drawBorder("border_5", amoeba._x+amoeba.getContentX()+btn._x-1, amoeba._y+amoeba.getContentY()+btn._y, btn._width+3, btn._height+2);

		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:0, _y:230, w:450, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.satisfaction.3"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}

	/*
	 * Step 14: Excercise presentation - amoeba 3
	 *
	 * @param the container clip for the step
	 */
	private function step14(cont):Void{
		
		//reinicialize model, generate two points updating the reference amoeba and show amoeba details
		this["ecsm"].reset();
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		this["ecsm"].amoeba.comp.updateRef();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "6";
		this["ecsm"].runModel();
		this["ecsm"].amoeba.comp.showDetails();
		this["ecsm"].amoeba_details.btn_back_amoeba._visible = false;
		this["mcStep"].btns._visible = true;
		
		//create borders
		this.drawBorder("border_1", 405, 65, 130, 45);
		
		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:20, _y:140, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.presentation.amoeba.3"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//tween in msg
		this.tweenIn(msg);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
		
	/*
	 * Step 15 - begin first preliminary question
	 *
	 * @param the container clip for the step
	 */
	private function step15(cont):Void{

		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:50, w:500, txt:LindApp.getMsg("cornShrubModel.excercise.prelimQuest.quest1"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//initialize component
		this["ecsm"].reset();
		
		//create eval respuesta function
		var evalResp:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:200, w:500, txt:LindApp.getMsg("cornShrubModel.excercise.prelimQuest.ans1"), titleTxt:LindApp.getMsg("general.questions.answer.title"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:LindApp.getTxtFormat("bigTxtFormat")});
			//reactivate next button
			this["mcStep"].btns.btn_next.callBackObj = this;
			this["mcStep"].btns.btn_next.callBackFunc = this.next;
		}
		
		//create temporary function for next buttton
		var nxt:Function = function(){
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:300, _y:200, w:300, txt:LindApp.getMsg("general.questions.evaluateBeforeContinue"), txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
		}
		
		//create buttons
		this.createBtnNext();
		this["mcStep"].btns.btn_next.callBackObj = this;
		this["mcStep"].btns.btn_next.callBackFunc = nxt;
		this.createBtnBack();
		createModelButtons(false);
		createBtnEvalResp(evalResp);
	}
	
	/*
	 * Step 16 - second preliminary question
	 *
	 * @param the container clip for the step
	 */
	private function step16(cont):Void{

		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:200, w:500, txt:LindApp.getMsg("cornShrubModel.excercise.prelimQuest.quest2"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//initialize component
		this["ecsm"].reset();
		
		//create eval respuesta function
		var evalResp:Function = function(){
			this.removeMsg();
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:200, _y:200, w:500, txt:LindApp.getMsg("cornShrubModel.excercise.prelimQuest.ans2"), titleTxt:LindApp.getMsg("general.questions.answer.title"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:LindApp.getTxtFormat("bigTxtFormat")});
			//reactivate next button
			this["mcStep"].btns.btn_next.callBackObj = this;
			this["mcStep"].btns.btn_next.callBackFunc = this.next;
		}
		
		//create temporary function for next buttton
		var nxt:Function = function(){
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:300, _y:200, w:300, txt:LindApp.getMsg("general.questions.evaluateBeforeContinue"), txtFormat:LindApp.getTxtFormat("warningTxtFormat")});
		}
		
		//create buttons
		this.createBtnNext();
		this["mcStep"].btns.btn_next.callBackObj = this;
		this["mcStep"].btns.btn_next.callBackFunc = nxt;
		this.createBtnBack();
		createModelButtons(false);
		createBtnEvalResp(evalResp);
	}
	
	/*
	 * Step 17: No solution to conflict
	 * 
	 * @param the container clip for the step
	 */
	private function step17(cont):Void{

		//create images
		var mount = cont.attachMovie("mountain_3", "mount", cont.getNextHighestDepth(), {_x:20, _y:70});
		mount["reserve_size"].text = mount["anual_size"].text = "";
		cont.attachMovie("lm_mirkyLake", "mirkyLake", cont.getNextHighestDepth(), {_x:20, _y:335});
		cont.attachMovie("lm_bomb", "bomb_1", cont.getNextHighestDepth(), {_x:70, _y:250});
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.story.txt1"));
		
		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 18: Introduce shrub
	 * 
	 * @param the container clip for the step
	 */
	private function step18(cont):Void{

		//create images
		var img = cont.attachMovie("csm_shrub_intro", "img", cont.getNextHighestDepth(), {_x:20, _y:20});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");
		img["tf_fol1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_fol2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		
		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.shrubIntro.strory"));
		
		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 19: Introduce foliage prune
	 * 
	 * @param the container clip for the step
	 */
	private function step19(cont):Void{

		//create images
		var img = cont.attachMovie("csm_folPrune", "img", cont.getNextHighestDepth(), {_x:20, _y:20});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nFol1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_nFol2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");

		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.folPrune.story"));

		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}	
	
	/*
	 * Step 20: Introduce root prune
	 * 
	 * @param the container clip for the step
	 */
	private function step20(cont):Void{

		//create images
		var img = cont.attachMovie("csm_rootPrune", "img", cont.getNextHighestDepth(), {_x:20, _y:20});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nFol1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_nFol2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");

		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.rootPrune.story"));

		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 21: Introduce root prune
	 * 
	 * @param the container clip for the step
	 */
	private function step21(cont):Void{

		//create images
		var img = cont.attachMovie("csm_folRootPrune", "img", cont.getNextHighestDepth(), {_x:20, _y:20});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nFol1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_nFol2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");

		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.dayWorkers.story"));

		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}
	
	/*
	 * Step 22: Introduce foliage prune with root prune
	 * 
	 * @param the container clip for the step
	 */
	private function step22(cont):Void{

		//create images
		var img = cont.attachMovie("csm_folRootPrune", "img", cont.getNextHighestDepth(), {_x:20, _y:20});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nFol1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_nFol2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFoliage");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");

		//create story text
		var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.preamble2.folRootPrune.story"));

		//tween in all
		this.tweenIn(story);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
	}

	/*
	 * Step 23: Excercise second presentation - input params
	 *
	 * @param the container clip for the step
	 */
	private function step23(cont):Void{

		//generate width specific init params
		this["ecsm"].reset();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "0.3";
		this["ecsm"].inPrms_tp.getContent().shrubDensity_ib.text = "0.2";
		this["ecsm"].inPrms_tp.getContent().nFolPrune_ib.text = "2";
		this["ecsm"].inPrms_tp.getContent().percentRootPrune_ib.text = "50";
		this["ecsm"].inPrms_tp.getContent().aidFolPrune_ib.text = "30";
		this["ecsm"].inPrms_tp.getContent().aidRootPrune_ib.text = "40";
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();

		//open combobox
		this["ecsm"].inPrms_tp.getContent().rp_cb.open();
						
		//create borders
		this.drawBorder("border_1", 10, 75, 420, 145);
		this.drawBorder("border_2", 10, 230, 420, 72);
		
		//initialize messages
		var msg1:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg1", cont.getNextHighestDepth(), {_x:440, _y:75, w:500, txt:LindApp.getMsg("cornShrubModel.excercise.presentation2.inputParams"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));
		
		//tween in msgs
		this.tweenIn(msg1);
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		this.createBtnSkipTutorial(false, 26);
		createModelButtons(true);
	}
	
	/*
	 * Step 24: Excercise second presentation - additional graphics
	 *
	 * @param the container clip for the step
	 */
	private function step24(cont):Void{

		//generate model
		this["ecsm"].reset();
		this["ecsm"].inPrms_tp.getContent().nitrogen_ib.text = "0.3";
		this["ecsm"].inPrms_tp.getContent().shrubDensity_ib.text = "0.2";
		this["ecsm"].inPrms_tp.getContent().nFolPrune_ib.text = "2";
		this["ecsm"].inPrms_tp.getContent().percentRootPrune_ib.text = "50";
		this["ecsm"].inPrms_tp.getContent().aidFolPrune_ib.text = "30";
		this["ecsm"].inPrms_tp.getContent().aidRootPrune_ib.text = "40";
		this["ecsm"].generateRandom();
		this["ecsm"].runModel();
		
		//open aditional graphics
		var cw:ComponentWindow = Utils.newObject(ComponentWindow, cont, "auxGraphs", cont.getNextHighestDepth(), {_x:180, _y:50, w:770, h:455, compClass:ExploreCornShrubModelAuxGraphs, allowDrag:false, btnMinMax:false, btnClose:false, resize:false, titleTxt:LindApp.getMsg("cornShrubModel.excercise.auxiliarGraphs"), animate:false});

		//create numbers
		Utils.createTextField("tf_1", cw["comp"].bmvtGraph, cw["comp"].nisvtGraph.getNextHighestDepth(), 215, 5, 40, 1, "(2)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].fpgvtGraph, cw["comp"].nfvtGraph.getNextHighestDepth(), 215, 5, 40, 1, "(3)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_1", cw["comp"].fnvtGraph, cw["comp"].fnvtGraph.getNextHighestDepth(), 215, 5, 40, 1, "(5)", LindApp.getTxtFormat("warningTxtFormat"));
		Utils.createTextField("tf_2", cw["comp"].fnvnGraph, cw["comp"].fnvnGraph.getNextHighestDepth(), 215, 5, 40, 1, "(6)", LindApp.getTxtFormat("warningTxtFormat"));
		
		//create borders
		this.drawBorder("border_1", 441, 87, 250, 200);
		this.drawBorder("border_2", 696, 87, 250, 200);
		this.drawBorder("border_3", 441, 292, 250, 200);
		this.drawBorder("border_4", 696, 292, 250, 200);
		
		//initialize messages
		var msg2:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg2", cont.getNextHighestDepth(), {_x:0, _y:100, w:435, txt:LindApp.getMsg("cornShrubModel.excercise.presentation2.additionalGraphics"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat")}));

		//tween in msgs
		this.tweenIn(msg2);

		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
	}
	
	/*
	 * Step 25: Excercise second presentation - monocurve
	 *
	 * @param the container clip for the step
	 */
	private function step25(cont):Void{

		//reset model and generate random
		this["ecsm"].reset();
		this["ecsm"].generateRandom();

		//initialize messages
		var msg:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:0, _y:20, w:430, txt:LindApp.getMsg("cornShrubModel.excercise.presentation2.monoCurve"), txtFormat:LindApp.getTxtFormat("defaultTxtFormat"), onInitFunc:Proxy.create(this["ecsm"], this["ecsm"].doMonoCurve)}));
		
		//create buttons
		this.createBtnNext();
		this.createBtnBack();
		createModelButtons(true);
		
		//create borders
		var tp:TextPane = this["ecsm"].rg_tp;
		var btn:BubbleBtn = this["ecsm"].rg_tp.getContent().btn_rg;
		this.drawBorder("border_1", tp._x+tp.getContentX()+btn._x-1, tp._y+tp.getContentY()+btn._y, btn._width+3, btn._height+2);
		var btns = this["mcStep"].btns;
		var btn2:EyeBtn = this["mcStep"].btns.btn_mono_curve;
		this.drawBorder("border_2", btns._x+btn2._x-2, btns._y+btn2._y-2, btn2._width, btn2._height);
	}
	
	/*
	 * Step 26: Begin excercise
	 *
	 * @param the container clip for the step
	 */
	private function step26(cont):Void{

		//reset model
		this["ecsm"].reset();

		//initialize messages
		LindApp.getTxtFormat("bigAltTxtFormat").align = "center";
		var msg1:UserMessage = UserMessage(Utils.newObject(UserMessage, cont, "msg1", cont.getNextHighestDepth(), {_x:250, _y:-50, w:500, h:590, txt:LindApp.getMsg("cornShrubModel.excercise.presentation2.begin"), txtFormat:LindApp.getTxtFormat("bigAltTxtFormat"), fadeOutAfter:4000, fadeOutSpeed:1}));
		LindApp.getTxtFormat("bigAltTxtFormat").align = "left";
		var img = msg1.attachMovie("csm_shrub_intro", "img", msg1.getNextHighestDepth(), {_y:40});
		img["tf_nFert"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nFert");
		img["tf_nAir1"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_nAir2"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nAir");
		img["tf_lix"].text = LindApp.getMsg("cornShrubModel.preamble2.graphic.nLix");
		
		//tween in msg
		this.tweenIn(msg1);

		//create custom next function
		var nextFnc:Function = function(){
			
			//remove previous messages
			this.removeMsg();
			
			//create callback buttons
			var btn_yes:Object = new Object({callBackObj:this, callBackFunc:this.nextStep, literal:LindApp.getMsg("btn.yes")});
			var btn_no:Object = new Object({callBackObj:this, callBackFunc:this.removeMsg, literal:LindApp.getMsg("btn.no")});
			
			//create msg
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:200, w:400, txt:LindApp.getMsg("cornShrubModel.excercise.solution.confirm"), txtFormat:LindApp.getTxtFormat("defaultMsgTxtFormat"), callBack_btns: new Array(btn_yes, btn_no)});
		}

		//create buttons
		createBtn("btn_next", LindApp.getMsg("btn.next"), this, nextFnc);
		createBtnBack();
		createModelButtons(false);
		createBtnSeeSolution();
		
	}
	
	
	/*
	 * Step 27: Perform blind close before conclusions
	 * 
	 * @param the container clip for the step
	 */
	private function step27(cont):Void{
		
		//remove intro if present
		this["curtain"].removeMovieClip();

		this.attachMovie("introMc", "curtain", this.getNextHighestDepth(), {_x:-this._x, _y:-this._y});
		
		var fnc1:Function = function(){
			
			var fnc2:Function = function(){
				
				//define container clip for step
				var _cont = this["mcStep"].cont;
			
				//create images
				var img2 = _cont.attachMovie("csm_maize_shrubs", "csm_maize_shrubs", _cont.getNextHighestDepth(), {_x:70, _y:100, _xscale:60, _yscale:60});
				var img1 = _cont.attachMovie("csm_reserve", "csm_reserve", _cont.getNextHighestDepth(), {_x:200, _y:10});
				var img3 = _cont.attachMovie("lm_lake", "lm_lake", _cont.getNextHighestDepth(), {_x:120, _y:350});
				
				//create story text
				var story:UserMessage = this.createStoryTxt(LindApp.getMsg("cornShrubModel.conclusion.story"));
				
				//create buttons
				this.createBtnBack();
				this.createBtnGotoMenuPrin();
				
				//open blind
				this["curtain"].gotoAndPlay(40);
				
			}
			
			var txt:String = LindApp.getMsg("cornShrubModel.conclusion.title");
			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.font = "Arial";
			tf.bold = true;
			tf.color = 0xffffff;
			var w:Number = tf.getTextExtent(txt).textFieldWidth*1.2;
			Utils.newObject(EmergingText, this["curtain"].topBg, "txt", 1, {txt:LindApp.getMsg("cornShrubModel.conclusion.title"), _x:(960-w)/2, _y:380, txtFormat:tf, bgcolor:0x006600, onComplete:Proxy.create(this, fnc2)});
		}
		
		this["blindsClosed"] = Proxy.create(this, fnc1);
	}
}