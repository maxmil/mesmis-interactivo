import ascb.util.logging.Logger;
import core.comp.BubbleBtn;
import core.comp.EmergingText;
import core.comp.Scroll;
import core.comp.UserMessage;
import core.comp.TextPane;
import core.util.GenericMovieClip;
import core.util.Proxy;
import core.util.Utils;
import sussi.SussiApp;
import sussi.utils.SUtils;
import sussi.comp.PopulationGraph;
import sussi.comp.H1PhaseDiagram;
import sussi.comp.RelationsDiagram;
import sussi.comp.RelationsTable;
import sussi.model.Relations;


/*
 * Lindissima activity based on corn model where the only available variable for the user
 * is the level of fertilizer
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class sussi.activity.PopulationEvolution extends sussi.activity.SussiActivity{
	 
	 //logger
	public static var logger:Logger = Logger.getLogger("sussi.activity.PopulationEvolution");
	
	//array of points that describe the h1 phase diagram and the separator
	public var h1pdPoints:Array;
	public var h1pdSep:Number;
	
	//array of points for the alle zoom case
	public var h1pdAllePoints:Array;
	
	//graph options
	public var nIndivLimit:Number = 800;
	public var stepInc:Number = 1;
	
	/*
	 * Constructor
	 */
	public function PopulationEvolution() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating PopulationEvolution");
		
		//calculate h1 phase diagram points
		SUtils.setIP("dh1_epid", 1000);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		h1pdPoints = new Array();
		h1pdSep = H1PhaseDiagram.calcPoints(h1pdPoints, stepInc, nIndivLimit);
		
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
		
		//add glosari button
		var btnGlosari = this["mcStep"].cont.attachMovie("btn_glosari", "btn_glosari", this["mcStep"].cont.getNextHighestDepth());
		btnGlosari._x = (this["bg"]["btn_exit"]) ? 900 : 930;
		btnGlosari._y = -24;
		btnGlosari.activity = this;
		btnGlosari.onRollOver = function(){
			var txt:String = SussiApp.getMsg("btn.openGlosari");
			var w:Number = 100;
			SussiApp.getTxtFormat("smallTxtFormat").align = "center";
			Utils.newObject(UserMessage, this.activity, "roll_msg", this.activity.getNextHighestDepth(), {w:w, txt:txt, txtFormat:SussiApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
			SussiApp.getTxtFormat("smallTxtFormat").align = "left";
			this.activity["roll_msg"]._x = this._x+this._width-this.activity["roll_msg"]._width;
			this.activity["roll_msg"]._y = this._y+15;
		}
		btnGlosari.onRollOut = function(){
			this.activity["roll_msg"].removeMovieClip();
		}
		btnGlosari.onRelease = function(){
			this.activity["roll_msg"].removeMovieClip();
			var tp:TextPane = TextPane(Utils.newObject(TextPane, this.activity, "tp_glosario", this.activity.getNextHighestDepth(), {_x:100, _y:20, w:760, h:500, titleTxt:SussiApp.getMsg("general.glosario.title"), allowDrag:true, btnClose:true}));
			Utils.createTextField("tf", tp.getContent(), 1, 0, 0, 760, 1000, SussiApp.getMsg("general.glosario.content"), SussiApp.getTxtFormat("defaultTxtFormat"));
			tp.init(false);
		}
		
		//get current step
		//if not 1 then add goto start button
		if (step != 1){
			var btnHome = this["mcStep"].cont.attachMovie("btn_home", "btn_home", this["mcStep"].cont.getNextHighestDepth());
			btnHome._x = (this["bg"]["btn_exit"]) ? 870 : 900;
			btnHome._y = -24;
			btnHome.activity = this;
			btnHome.onRollOver = function(){
				var txt:String = SussiApp.getMsg("btn.gotoStart");
				var w:Number = 100;
				SussiApp.getTxtFormat("smallTxtFormat").align = "center";
				Utils.newObject(UserMessage, this.activity, "roll_msg", this.activity.getNextHighestDepth(), {w:w, txt:txt, txtFormat:SussiApp.getTxtFormat("smallTxtFormat"), btnClose:false, allowDrag:false, curveDist:2, shadowLength:5});
				SussiApp.getTxtFormat("smallTxtFormat").align = "left";
				this.activity["roll_msg"]._x = this._x+this._width-this.activity["roll_msg"]._width;
				this.activity["roll_msg"]._y = this._y+15;
			}
			btnHome.onRollOut = function(){
				this.activity["roll_msg"].removeMovieClip();
			}
			btnHome.onRelease = function(){
				this.activity["roll_msg"].removeMovieClip();
				this.activity.getStep(1);
			}
		}
		
		return step
	}
	
	/*
	 * Step 1: Scenery and presentation
	 * 
	 * @param the container clip for the step
	 */
	private function step1(cont):Void{
		
		//create background
		var scenery:MovieClip = cont.attachMovie("scenery", "scenery", cont.getNextHighestDepth(), {_x:-this._x+1, _y:-this._y+133});
		
		//create presentation text
		Utils.createTextField("tf", scenery.pres_text, 1, 10, 0, 550, 1, SussiApp.getMsg("presentation.title"), SussiApp.getTxtFormat("defaultTitleTxtFormat"));
		var sc:Scroll = Utils.newObject(Scroll, scenery.pres_text, "presentation", 2, {_x:10, _y:30, w:570, h:310});
		Utils.createTextField("tf", sc.getContentClip(), sc.getContentClip().getNextHighestDepth(), 0, 0, 550, 1, SussiApp.getMsg("presentation.mainText"), SussiApp.getTxtFormat("defaultTxtFormat"));
		sc.init();
		
		//if movie has been loaded into parent movie create exit button
		if (_root.exitObj && _root.exitFunc){
			createBtn("btn_exit", SussiApp.getMsg("btn.exit"), _root.exitObj, _root.exitFunc);
		}
		
		//create begin button
		createBtn("btn_start", SussiApp.getMsg("btn.start"), this, this.nextStep);
		
		//create credits button
		var openCredits:Function = function(){
			if(this["mcStep"].cont.credits){
				this.credits.removeMovieClip();
			}
			Utils.newObject(UserMessage, this["mcStep"].cont, "credits", this["mcStep"].cont.getNextHighestDepth(), {_x:250, _y:150, w:500, txt:SussiApp.getMsg("presentation.credits.txt"), titleTxt:SussiApp.getMsg("presentation.credits.title"), txtFormat:SussiApp.getTxtFormat("defaultTxtFormat"), titleTxtFormat:SussiApp.getTxtFormat("defaultTitleTxtFormat")});
		}
		this.createBtn("btnCredits", SussiApp.getMsg("btn.credits"), this, openCredits);
	}
	
	/*
	 * Step 2: Start story
	 * 
	 * @param the container clip for the step
	 */
	private function step2(cont):Void{
		
		//create story image
		cont.attachMovie("scenery_thin", "img", cont.getNextHighestDepth(), {_x:20, _y:-40});
		
		//create story text
		createStoryTxt("startStory");
		
		//create buttons
		createBtnNext();
		createBtnBack();
		
	}
	
	/*
	 * Step 3: Introduce the women
	 * 
	 * @param the container clip for the step
	 */
	private function step3(cont):Void{
		
		//create story image
		createStoryImage("women_1");
		
		//create story text
		createStoryTxt("women");
		
		//create buttons
		createBtnNext();
		createBtnBack();
		
	}
	
	/*
	 * Step 4: Introduce the blue insect
	 * 
	 * @param the container clip for the step
	 */
	private function step4(cont):Void{
		
		//create story image
		createStoryAnimation("seq_normal_evolution");
		
		//create story text
		createStoryTxt("blueInsect");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 5: Blue insect - population grows to limit
	 * 
	 * @param the container clip for the step
	 */
	private function step5(cont):Void{
		
		//create story image
		createStoryAnimation("seq_upToTopLimit");
		
		//create story text
		createStoryTxt("blueInsectGrowsToLimit");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 6: Blue insect - population drops to limit
	 * 
	 * @param the container clip for the step
	 */
	private function step6(cont):Void{
		
		//create story image
		createStoryAnimation("seq_downToTopLimit");
		
		//create story text
		createStoryTxt("blueInsectDropsToLimit");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 7: Blue insect - population exstinguish if init condition below allee
	 * 
	 * @param the container clip for the step
	 */
	private function step7(cont):Void{
		
		//create story image
		createStoryAnimation("seq_one_insect");
		
		//create story text
		createStoryTxt("blueInsectBelowAllee");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 8: Model - population grows to natural limit
	 * 
	 * @param the container clip for the step
	 */
	private function step8(cont):Void{
		
		//create story text
		createModelTxt("blueInsectTendsToNaturalLimit");
		
		//create initial conditions
		SUtils.setIP("rp_size", 0);
		SUtils.setIP("dh1_epid", 10000);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, nIndivLimit, 100, h1pdSep);

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 9: Model - population exstinguishes if initial condition is below allee
	 * 
	 * @param the container clip for the step
	 */
	private function step9(cont):Void{
		
		//create story text
		createModelTxt("blueInsectExtinguishBelowAllee");
		
		//create initial conditions
		SUtils.setIP("rp_size", 0);
		SUtils.setIP("dh1_epid", 10000);
		SUtils.setIP("h1_ini", 74);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, nIndivLimit, 100, h1pdSep);

		//create zoom model
		
		//calculate points if not already defined
		if(h1pdAllePoints){
			h1pdAllePoints = new Array();
			H1PhaseDiagram.calcPoints(h1pdAllePoints, 0.1, 100);
		}
		
		//create container clip
		var diag:GenericMovieClip = cont.createEmptyMovieClip("diag", cont.getNextHighestDepth());
		diag._visible = false;
		
		//create phase diagram
		var pd:H1PhaseDiagram = Utils.newObject(H1PhaseDiagram, diag, "pd", 2, {_x:0, _y:-20, points:h1pdAllePoints, pointsInt:0.1, xAxisRange:100, xAxisScale:5, bdrx:45, bdrRange:5,  separatrix:h1pdSep});
	
		//create population graph hidden
		var pg2:PopulationGraph = Utils.newObject(PopulationGraph, cont, "pg2", cont.getNextHighestDepth(), {_x:450, _y:240, yAxisRange:100, yAxisScale:10, init:false, separatrix:h1pdSep, _visible:false});
		
		//attach listener to population graph so that animation starts with H1PhaseDiagram
		var lstnr:Object = new Object();
		lstnr.animate = Proxy.create(pg2, pg2.animate);
		lstnr.equilibrium = Proxy.create(pg2, pg2.reset);
		pd.addEventListener("animate", lstnr);
		pd.addEventListener("equilibrium", lstnr);
	
		//create background
		diag.lineStyle(1, 0xffcc00, 100);
		diag.beginFill(0xffffff, 100);
		diag.moveTo(0, 0);
		diag.lineTo(pd.w, 0);
		diag.lineTo(pd.w, pd.h-20);
		diag.lineTo(0, pd.h-20);
		diag.lineTo(0, 0);
		diag.endFill();

		//create buttons
		createBtnNext();
		createBtnBack();
		createBtn("btn_zoom", SussiApp.getMsg("btn.changeScale"), this, this.zoomIn, false);
	}
	
	/*
	 * Changes scale so that alle may be apreciated
	 */
	private function zoomIn():Void{
		
		//define diagram
		var mc:GenericMovieClip = this["mcStep"].cont.diag;
		
		//rescale graphic
		mc._visible = true;
		mc._xscale = 100/8
		mc._yscale = 1;
		mc._x = 40;
		mc._y = 20;
		mc.scaleTo(100, 100, 30);
		mc.glideTo(0, 0, 10);
		
		//show second population graph and hide first
		this["mcStep"].cont.pg._visible = false;
		this["mcStep"].cont.pg2._visible = true;
		
		//change button function
		this["mcStep"].btns.btn_zoom.callBackFunc = this.zoomOut;
	}
	
	/*
	 * Changes scale so that alle may be apreciated
	 */
	private function zoomOut():Void{

		//define diagram
		var mc:GenericMovieClip = this["mcStep"].cont.diag;
		
		//rescale graphic
		var fnc:Function = function(){
			this._visible = false;
		}
		mc.scaleTo(100/8, 1, 30, Proxy.create(mc, fnc));
		mc.glideTo(40, 20, 10);
		
		//hide and show
		this["mcStep"].cont.pg2._visible = false;
		this["mcStep"].cont.pg._visible = true;
		
		//change button function
		this["mcStep"].btns.btn_zoom.callBackFunc = this.zoomIn;
	}
	
	/*
	 * Step 10: Story - Pertubations
	 * 
	 * @param the container clip for the step
	 */
	private function step10(cont):Void{
		
		//create story image
		createStoryAnimation("seq_pertubation");
		
		//create story text
		createStoryTxt("pertubations");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 11: Model - Pertubations
	 * 
	 * @param the container clip for the step
	 */
	private function step11(cont):Void{
		
		//create initial conditions
		SUtils.setIP("rp_size", -100);
		SUtils.setIP("rp_prob", 0.015);
		SUtils.setIP("dh1_epid", 10000);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create story text
		createModelTxt("pertubations");
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, nIndivLimit, 100, h1pdSep);

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 12: Story - Pertubations below allee
	 * 
	 * @param the container clip for the step
	 */
	private function step12(cont):Void{
		
		//create story image
		createStoryAnimation("seq_pertubation_allee");
		
		//create story text
		createStoryTxt("pertubationsBelowAllee");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 13: Model - Pertubations below allee
	 * 
	 * @param the container clip for the step
	 */
	private function step13(cont):Void{
		
		//create story text
		createModelTxt("pertubationsBelowAllee");
		
		//create initial conditions
		SUtils.setIP("rp_size", -100);
		SUtils.setIP("rp_prob", 0.015);
		SUtils.setIP("dh1_epid", 10000);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, nIndivLimit, 100, h1pdSep);

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 14: Model - First Conclusions
	 * 
	 * @param the container clip for the step
	 */
	private function step14(cont):Void{
		
		//create story text
		createModelTxt("firstConclusions");
		
		//create initial conditions
		SUtils.setIP("rp_size", -20);
		SUtils.setIP("rp_prob", 0.002);
		SUtils.setIP("dh1_epid", 10000);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, nIndivLimit, 100, h1pdSep);

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 15: Story - Disease
	 * 
	 * @param the container clip for the step
	 */
	private function step15(cont):Void{
		
		//create story image
		createStoryAnimation("seq_spread_disease");
		
		//create story text
		createStoryTxt("disease");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 16: Story - Disease prevents sufficient polinization
	 * 
	 * @param the container clip for the step
	 */
	private function step16(cont):Void{
		
		//create story image
		createStoryAnimation("seq_illness_no_polin");
		
		//create story text
		createStoryTxt("diseaseNoPolinization");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 17: Model - Disease
	 * 
	 * @param the container clip for the step
	 */
	private function step17(cont):Void{
		
		//create story text
		createModelTxt("disease");
		
		//create initial conditions
		SUtils.setIP("rp_size", -20);
		SUtils.setIP("rp_prob", 0.002);
		SUtils.setIP("dh1_epid", 240);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 0);
		SUtils.clearOutputs();
		
		//create components
		createPopulationModel(h1pdPoints, stepInc, nIndivLimit, 250, 100, h1pdSep);

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 18: Story - Discussion 1
	 * 
	 * @param the container clip for the step
	 */
	private function step18(cont):Void{
		
		//create story image
		createStoryImage("women_2");
		
		//create story text
		createStoryTxt("discussion1");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 19: Story - Discussion 2
	 * 
	 * @param the container clip for the step
	 */
	private function step19(cont):Void{
		
		//create story image
		createStoryImage("women_1");
		
		//create story text
		createStoryTxt("discussion2");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Story - Enter the carnivore
	 * 
	 * @param the container clip for the step
	 */
	private function step20(cont):Void{
		
		//create story image
		createStoryAnimation("seq_c_h1_fruit");
		
		//create story text
		createStoryTxt("carnivore");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
		
	/*
	 * Model - Enter the carnivore
	 * 
	 * @param the container clip for the step
	 */
	private function step21(cont):Void{
		
		//create initial conditions
		var relations:Relations = SussiApp.getUserSession().getRelations();
		SUtils.setIP("rp_prob", 0.002);
		SUtils.setIP("rp_size", -20);
		SUtils.setIP("dh1_epid", 240);
		SUtils.setIP("dh2_epid", 240);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 0);
		SUtils.setIP("c_ini", 20);
		SUtils.setIP("comp_h1h2", relations.getRelation(Relations.COMP_H1H2).mediumValue);
		SUtils.setIP("comp_h2h1", relations.getRelation(Relations.COMP_H2H1).mediumValue);
		SUtils.setIP("dh1_carn", relations.getRelation(Relations.CH1).mediumValue);
		SUtils.setIP("dh2_carn", relations.getRelation(Relations.CH2).mediumValue);
		SUtils.clearOutputs();
		
		//create relation model
		relations.setRelationProp(Relations.CH1, "active", false);
		createRelationModel(false);
		
		//create story text
		createModelTxt("carnivore");

		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Story - What to do, biological solution fails
	 * 
	 * @param the container clip for the step
	 */
	private function step22(cont):Void{
		
		//create story image
		createStoryAnimation("seq_h2_no_polin");
		
		//create story text
		createStoryTxt("biologicalSolutionFails");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}

	/*
	 * Model - Enter the carnivore
	 * 
	 * @param the container clip for the step
	 */
	private function step23(cont):Void{
		
		//create initial conditions
		var relations:Relations = SussiApp.getUserSession().getRelations();
		SUtils.setIP("rp_prob", 0.002);
		SUtils.setIP("rp_size", -20);
		SUtils.setIP("dh1_epid", 240);
		SUtils.setIP("dh2_epid", 240);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 120);
		SUtils.setIP("c_ini", 20);
		SUtils.setIP("comp_h1h2", relations.getRelation(Relations.COMP_H1H2).mediumValue);
		SUtils.setIP("comp_h2h1", relations.getRelation(Relations.COMP_H2H1).mediumValue);
		SUtils.setIP("dh1_carn", relations.getRelation(Relations.CH1).mediumValue);
		SUtils.setIP("dh2_carn", relations.getRelation(Relations.CH2).mediumValue);
		SUtils.clearOutputs();
		
		//create relation model
		relations.setRelationProp(Relations.CH1, "active", false);
		relations.setRelationProp(Relations.CH2, "active", false);
		relations.setRelationProp(Relations.COMP_H1H2, "active", false);
		relations.setRelationProp(Relations.COMP_H2H1, "active", false);
		createRelationModel(false);
		
		//create story text
		createModelTxt("h2");

		//create buttons
		createBtnNext();
		createBtnBack();
	}	
	
	/*
	 * Story - Solved by itself, but why?
	 * 
	 * @param the container clip for the step
	 */
	private function step24(cont):Void{
		
		//create story image
		createStoryImage("tree_flower_to_fruit_bottom");
		
		//create story text
		createStoryTxt("solvedByItself");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Model - Excercise
	 * 
	 * @param the container clip for the step
	 */
	private function step25(cont):Void{
		
		//create initial conditions
		var relations:Relations = SussiApp.getUserSession().getRelations();
		SUtils.setIP("rp_prob", 0.002);
		SUtils.setIP("rp_size", -20);
		SUtils.setIP("dh1_epid", 240);
		SUtils.setIP("dh2_epid", 240);
		SUtils.setIP("h1_ini", 180);
		SUtils.setIP("h2_ini", 120);
		SUtils.setIP("c_ini", 20);
		SUtils.setIP("comp_h1h2", relations.getRelation(Relations.COMP_H1H2).mediumValue);
		SUtils.setIP("comp_h2h1", relations.getRelation(Relations.COMP_H2H1).mediumValue);
		SUtils.setIP("dh1_carn", relations.getRelation(Relations.CH1).mediumValue);
		SUtils.setIP("dh2_carn", relations.getRelation(Relations.CH2).mediumValue);
		SUtils.clearOutputs();
		
		//create relation model
		relations.setRelationProp(Relations.CH1, "active", true);
		relations.setRelationProp(Relations.CH2, "active", true);
		relations.setRelationProp(Relations.COMP_H1H2, "active", true);
		relations.setRelationProp(Relations.COMP_H2H1, "active", true);
		createRelationModel(true);
		
		//create story text
		createModelTxt("excercise");
		
		//create function see solution
		var func:Function = function(){
			
			//remove previous messages
			this.removeMsg();
			
			//create function to show solution
			var runSol:Function = function(){
				
				//remove previous messages
				this.removeMsg();
				
				//create callback button
				var btn_generate:Object = new Object({callBackObj:this["mcStep"].cont.btn_generate, callBackFunc:this["mcStep"].cont.btn_generate.onRelease, literal:SussiApp.getMsg("btn.seeGraph")})
				
				//show answer
				Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:0, _y:250, w:940, txt:SussiApp.getMsg("model.excercise.answer"), txtFormat:SussiApp.getTxtFormat("defaultMsgTxtFormat"), callBack_btns:new Array(btn_generate)});
				
				//select correct relations
				var rt:RelationsTable = this["mcStep"].cont.rt;
				rt.select("h1h2_lt");
				rt.select("h2h1_lt");
				rt.select("ch1_lt");
				rt.select("ch2_gt");
			}
			
			//create callback buttons
			var btn_seeSol:Object = new Object({callBackObj:this, callBackFunc:runSol, literal:SussiApp.getMsg("btn.seeSolutionNow")});
			var btn_contTrying:Object = new Object({callBackObj:this, callBackFunc:this.removeMsg, literal:SussiApp.getMsg("btn.continueTrying")});
			
			//create msg
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:150, w:400, txt:SussiApp.getMsg("model.excercise.clue"), txtFormat:SussiApp.getTxtFormat("defaultMsgTxtFormat"), callBack_btns: new Array(btn_seeSol, btn_contTrying)});
		}

		//create buttons
		createBtnNext();
		createBtnBack();
		createBtn("btn_seeSolution", SussiApp.getMsg("btn.seeSolution"), this, func, false);
	}

	/*
	 * Perform blind close before conclusions
	 * 
	 * @param the container clip for the step
	 */
	private function step26(cont):Void{

		cont.attachMovie("introMc", "curtain", cont.getNextHighestDepth(), {_x:-this._x, _y:-this._y});
		
		var fnc1:Function = function(){
			
			var fnc2:Function = function(){
			
				//define container
				var _cont:GenericMovieClip = this["mcStep"].cont;
				
				//create animate button when conclusion is initialized
				_cont.conclusionInitialized = function(){
					
					//create animate function
					var fnc:Function = function(){
						this.playAll = true;
						this.gotoAndPlay("step_1");
					}
					
					//create animate button
					Utils.newObject(BubbleBtn, _cont, "btn", _cont.getNextHighestDepth(), {_x:675, _y:40, literal:SussiApp.getMsg("btn.animate"), callBackObj:_cont.bg.seq_solution, callBackFunc:fnc});
		
				}
			
				//create background
				var bg:MovieClip = cont.attachMovie("conclusion", "bg", cont.getNextHighestDepth(), {_x:-this._x+1, _y:-this._y+133});
		
				//create conclusion text
				Utils.createTextField("tf", bg.text_area, 1, 10, 0, 550, 1, SussiApp.getMsg("story.conclusion.title"), SussiApp.getTxtFormat("defaultTitleTxtFormat"));
				var sc:Scroll = Utils.newObject(Scroll, bg.text_area, "conclusionTxt", 2, {_x:10, _y:30, w:570, h:220});
				Utils.createTextField("tf", sc.getContentClip(), sc.getContentClip().getNextHighestDepth(), 0, 0, 550, 1, SussiApp.getMsg("story.conclusion.text"), SussiApp.getTxtFormat("defaultTxtFormat"));
				sc.init();
				
				//create buttons
				this.createBtnNext();
				this.createBtnBack();
				
				//move blind to foreground
				_cont.curtain.swapDepths(_cont.getNextHighestDepth());
				
				//open blind
				_cont.curtain.gotoAndPlay("openBlind");
			}
			
			var txt:String = SussiApp.getMsg("story.conclusion.title").toUpperCase();
			var tf:TextFormat = new TextFormat();
			tf.size = 16;
			tf.font = "Arial";
			tf.bold = true;
			tf.color = 0xffffff;
			var et:EmergingText = Utils.newObject(EmergingText, this["mcStep"].cont.curtain.topBg, "txt", 1, {txt:txt, _y:380, txtFormat:tf, bgcolor:0x006600, onComplete:Proxy.create(this, fnc2)});
			et._x = (960 - et.totalWidth)/2;
		}
		
		cont["blindsClosed"] = Proxy.create(this, fnc1);
	}
	
	/*
	 * Perform blind close before conclusions
	 * 
	 * @param the container clip for the step
	 */
	private function step27(cont):Void{

		//create background
		var bg:MovieClip = cont.attachMovie("conclusion", "bg", cont.getNextHighestDepth(), {_x:-this._x+1, _y:-this._y+133});
		bg.gotoAndStop("staticImage");

		//create conclusion text
		Utils.createTextField("tf", bg.text_area, 1, 10, 0, 550, 1, SussiApp.getMsg("story.corrollary.title"), SussiApp.getTxtFormat("defaultTitleTxtFormat"));
		var sc:Scroll = Utils.newObject(Scroll, bg.text_area, "conclusionTxt", 2, {_x:10, _y:30, w:570, h:220});
		Utils.createTextField("tf", sc.getContentClip(), sc.getContentClip().getNextHighestDepth(), 0, 0, 550, 1, SussiApp.getMsg("story.corrollary.text"), SussiApp.getTxtFormat("defaultTxtFormat"));
		sc.init();
		
		//create buttons
		createBtnBack();
	}
	
	/*
	 * Create relation model component
	 * 
	 * @param createTable boolean value indicating whether the relation table should be created
	 */
	private function createRelationModel(createTable:Boolean):Void{
		
		var cont = this["mcStep"].cont;
		var relations:Relations = SussiApp.getUserSession().getRelations();
		
		//create relations diagram
		var rd:RelationsDiagram = cont.attachMovie("relation_diagram", "rd", cont.getNextHighestDepth(), {relations:relations});		
		
		//create relations table
		if(createTable){
			var rtInitObj = new Object();
			rtInitObj._x = 530;
			rtInitObj._y = 20;
			rtInitObj.relations = SussiApp.getUserSession().getRelations();
			var rt:RelationsTable = cont.attachMovie("relationship_table", "rt", cont.getNextHighestDepth(), rtInitObj);

			//attach listener to relation tables that updates relations diagram
			var lstnr:Object = new Object();
			lstnr.relationsChanged = Proxy.create(rd, rd.updateRelations, true);
			rt.addEventListener("relationsChanged", lstnr);
		}else{
			rd._x = (950-rd._width)/2;
		}
		
		//create population graph
		var pg:PopulationGraph = Utils.newObject(PopulationGraph, cont, "pg", cont.getNextHighestDepth(), {_x:450, _y:250, yAxisRange:250, yAxisScale:25, init:false, separatrix:h1pdSep});

		//create generate button
		var fnc:Function = function(){
			this.removeMsg();
			SUtils.clearOutputs();
			this["mcStep"].cont.pg.animate();
		}
		var btn:BubbleBtn = Utils.newObject(BubbleBtn, cont, "btn_generate", cont.getNextHighestDepth(), {_y:230, literal:SussiApp.getMsg("btn.generate"), callBackFunc:Proxy.create(this, fnc)});
		btn._x = 930-btn._width;
	}

	/*
	 * Create population model
	 */
	private function createPopulationModel(points:Array, _stepInc:Number, xAxisRangePD:Number, yAxisRangePG:Number, yScale:Number, sep:Number):Void{
		
		//get container clip
		var cont:MovieClip = this["mcStep"].cont;
		
		//create h1 phase diagram
		var h1pd:H1PhaseDiagram = Utils.newObject(H1PhaseDiagram, cont, "h1pd", cont.getNextHighestDepth(), {_x:0, _y:-20, points:points, pointsInt:_stepInc, separatrix:sep, xAxisRange:xAxisRangePD});
		
		//create population graph
		var pg:PopulationGraph = Utils.newObject(PopulationGraph, cont, "pg", cont.getNextHighestDepth(), {_x:450, _y:240, yAxisRange:yAxisRangePG, yAxisScale:yScale, init:false, separatrix:sep});
		
		//attach listener to population graph so that animation starts with H1PhaseDiagram
		var lstnr:Object = new Object();
		lstnr.animate = Proxy.create(pg, pg.animate);
		lstnr.equilibrium = Proxy.create(pg, pg.reset);
		h1pd.addEventListener("animate", lstnr);
		h1pd.addEventListener("equilibrium", lstnr);
	} 
}