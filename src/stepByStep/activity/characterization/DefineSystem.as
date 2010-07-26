import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;
import stepByStep.comp.DefineSystemComp;

/*
 * Characterization of the system Agrosilvopastoril. The user builds the system in 
 * this activitiy composing the subsistems, components, flows and critical points (strengths
 * and weaknesses)
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.activity.characterization.DefineSystem extends stepByStep.activity.StepByStepActivity {
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.activity.characterization.DefineSystem");
	
	//array of subsistems
	private var subsystems:Array;
	
	//array of components
	private var comps:Array;
	
	//array of flows
	private var flows:Array;

	/*
	 * Constructor
	 */
	public function DefineSystem() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating DefineSystem");
		
		//get first step
		getStep(1);
	}
	

	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		if((step<=4) && this["defineSystemComp"]){
			
			//remove component
			this["defineSystemComp"].removeMovieClip();
			
		}else if (step>8){
			
			//hide component
			this["defineSystemComp"]._visible = false;
			
		}else if(step>4){
			
			//create component if neccesarry
			if(!this["defineSystemComp"]){
				Utils.newObject(DefineSystemComp, this, "defineSystemComp", this.compDepth, {subsystems:subsystems, comps:comps, flows:flows, activity:this});
			}else {
				this["defineSystemComp"]._visible = true;
			}
			
			//hide or show subsystems
			if(step<6){
				this["defineSystemComp"].hideSubsystems();
			}else{
				this["defineSystemComp"].showSubsystems();
			}
			
			//hide or show components
			if(step<7){
				this["defineSystemComp"].hideComponents();
			}else{
				this["defineSystemComp"].showComponents();
			}
			
			//hide or show flows
			if(step<8){
				this["defineSystemComp"].hideFlows();
			}else{
				this["defineSystemComp"].showFlows();
			}
		}
		
		return step;
	}
	
	/*
	 * Step 1: Introduction
	 * 
	 * @param cont the container clip for the step
	 */
	public function step1(cont:GenericMovieClip):Void{
		
		var bigTitleTxtFormat:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		
		//create title text underline
		var tu:GenericMovieClip = cont.createEmptyMovieClip("tu", cont.getNextHighestDepth());
		tu.lineStyle(2, 0xC0A47D, 100);
		tu.lineTo(900, 0);
		tu._x = -900;
		tu._y = 50;
		tu.glideTo(20, 50, 10);
	
		//create title as raining text
		var titleCont:GenericMovieClip = cont.createEmptyMovieClip("titleCont", cont.getNextHighestDepth());
		Utils.createTextField("title", titleCont, 1, 0, 0, 900, 10, StepByStepApp.getMsg("defineSystem.intro.title"), bigTitleTxtFormat);
		titleCont._x = 960;
		titleCont._y = 20;
		titleCont.glideTo(20, 20, 10);
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("char_intro", "img", cont.getNextHighestDepth(), {_x:50, _y:170, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineSystem.intro.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnGotoMenuPrin();
	}
	
	/*
	 * Step 2: Localization
	 * 
	 * @param cont the container clip for the step
	 */
	public function step2(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineSystem.localization.title"), tf);
		tf.align = "left";
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("localization", "img", cont.getNextHighestDepth(), {_x:100, _y:20, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineSystem.localization.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxt:StepByStepApp.getMsg("defineSystem.localization.title"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 3: Socio economic conditions
	 * 
	 * @param cont the container clip for the step
	 */
	public function step3(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineSystem.localization2.title"), tf);
		tf.align = "left";
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("photo_casas_blancas_comp", "img", cont.getNextHighestDepth(), {_x:50, _y:100, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineSystem.localization2.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxt:StepByStepApp.getMsg("defineSystem.localization2.title"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	
	/*
	 * Step 4: Production unit
	 * 
	 * @param cont the container clip for the step
	 */
	public function step4(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineSystem.productionUnit.title"), tf);
		tf.align = "left";
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("agrosilvopastoril", "img", cont.getNextHighestDepth(), {_x:50, _y:200, _width:400, _height:220}));
		
		//add instruction
		Utils.createTextField("instruction", cont, cont.getNextHighestDepth(), 50, 100, 400, 10, StepByStepApp.getMsg("defineSystem.productionUnit.instruction"), StepByStepApp.getTxtFormat("altTxtFormat"));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineSystem.productionUnit.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxt:StepByStepApp.getMsg("defineSystem.productionUnit.title"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 5: Begin to build system - Add subsystems
	 * 
	 * @param cont the container clip for the step
	 */
	public function step5(cont:GenericMovieClip):Void{
		
		//add msg
		var msg:UserMessage = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:280, w:400, txt:StepByStepApp.getMsg("defineSystem.excercise.intro"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtn("btn_addSubsystem", StepByStepApp.getMsg("btn.addSubsystem"), this["defineSystemComp"], this["defineSystemComp"].addSubsystem, false);
		createBtnBack();
	}
	
	/*
	 * Step 6: Add components
	 * 
	 * @param cont the container clip for the step
	 */
	public function step6(cont:GenericMovieClip):Void{
		
		//add msg
		var msg:UserMessage = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:280, w:400, txt:StepByStepApp.getMsg("defineSystem.excercise.addComponents"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:true, btnClose:true});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
				
		//create buttons
		createBtn("btn_addComponents", StepByStepApp.getMsg("btn.addComponents"), this["defineSystemComp"], this["defineSystemComp"].openCompSelector, false);
		createBtnBack();
	}
	
	/*
	 * Step 7: Add flows
	 * 
	 * @param cont the container clip for the step
	 */
	public function step7(cont:GenericMovieClip):Void{
		
		//add msg
		var msg:UserMessage = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:280, w:400, txt:StepByStepApp.getMsg("defineSystem.excercise.addFlows"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:true, btnClose:true});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
				
		//create buttons
		createBtn("btn_addFlows", StepByStepApp.getMsg("btn.addFlows"), this["defineSystemComp"], this["defineSystemComp"].openFlowSelector, false);
		createBtnBack();
	}
	
	/*
	 * Step 8: Finished building system
	 * 
	 * @param cont the container clip for the step
	 */
	public function step8(cont:GenericMovieClip):Void{
		
		//add msg
		var msg:UserMessage = Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:280, w:400, txt:StepByStepApp.getMsg("defineSystem.excercise.complete"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:true, btnClose:true});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
				
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	
	/*
	 * Step 9: Evaluation object
	 * 
	 * @param cont the container clip for the step
	 */
	public function step9(cont:GenericMovieClip):Void{
		
		//add title
		var tf:TextFormat = StepByStepApp.getTxtFormat("bigTitleTxtFormat");
		tf.align = "center";
		Utils.createTextField("title", cont, cont.getNextHighestDepth(), 50, 20, 900, 20, StepByStepApp.getMsg("defineSystem.evaluationObject.title"), tf);
		tf.align = "left";
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("photo_eval_obj", "img", cont.getNextHighestDepth(), {_x:100, _y:100, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("defineSystem.evaluationObject.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxt:StepByStepApp.getMsg("defineSystem.evaluationObject.title"), titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 10: SAR System - 1
	 * 
	 * @param cont the container clip for the step
	 */
	public function step10(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem1.text"), true);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 11: SAR System - 2
	 * 
	 * @param cont the container clip for the step
	 */
	public function step11(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem2.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 12: SAR System - 3
	 * 
	 * @param cont the container clip for the step
	 */
	public function step12(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem3.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 13: SAR System - 4
	 * 
	 * @param cont the container clip for the step
	 */
	public function step13(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem4.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 14: SAR System - 5
	 * 
	 * @param cont the container clip for the step
	 */
	public function step14(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem5.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 15: SAR System - 6
	 * 
	 * @param cont the container clip for the step
	 */
	public function step15(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem6.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 16: SAR System - 7
	 * 
	 * @param cont the container clip for the step
	 */
	public function step16(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.SARSystem.title"), StepByStepApp.getMsg("defineSystem.SARSystem7.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 16: Alt System - 1
	 * 
	 * @param cont the container clip for the step
	 */
	public function step17(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.AltSystem.title"), StepByStepApp.getMsg("defineSystem.AltSystem1.text"), true);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 17: Alt System - 2
	 * 
	 * @param cont the container clip for the step
	 */
	public function step18(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.AltSystem.title"), StepByStepApp.getMsg("defineSystem.AltSystem2.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 18: Alt System - 3
	 * 
	 * @param cont the container clip for the step
	 */
	public function step19(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.AltSystem.title"), StepByStepApp.getMsg("defineSystem.AltSystem3.text"), false);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 19: Alt System - 4
	 * 
	 * @param cont the container clip for the step
	 */
	public function step20(cont:GenericMovieClip):Void{
		
		//create graphic
		createASPCasasBlancas(cont, StepByStepApp.getMsg("defineSystem.AltSystem.title"), StepByStepApp.getMsg("defineSystem.AltSystem4.text"), false);
		
		//create buttons
		var fnc:Function = function(){
			this.app.getNav().getActivity("strengthsAndWeaknesses");
		}
		createBtn("btn_gotoStep3", this.app.getMsg("btn.gotoStep2"), this, fnc);
		createBtnGotoMenuPrin();
		createBtnBack();
	}	
	
	
	/*
	 * Auxiliar function to create the agro silvo pastoril system for casas blancas
	 */
	private function createASPCasasBlancas(cont:GenericMovieClip, titleTxt:String, storyTxt:String, animateTitle:Boolean):Void{
		
		//add system graphic
		var img:MovieClip = MovieClip(cont.attachMovie("systems_asp", "img", cont.getNextHighestDepth(), {_x:50, _y:50, _alpha:100}));
		img.txtFamilyUnit = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.familyUnit");
		img.txtExterior = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.exterior");
		img.txtExteriorElmnts = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.exteriorElmnts");
		img.txtWork = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.work");
		img.txtCorn = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.corn");
		img.txtCorn2 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.corn");
		img.txtSubsid = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.subsid");
		img.txtCultivatedField = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.cultivatedField");
		img.txtRestingField = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.restingField");
		img.txtCattle = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.cattle");
		img.txtNutrients1 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.nutrients1");
		img.txtNutrients2 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.nutrients2");
		img.txtSoil = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.soil");
		
		//add title
		var mc:GenericMovieClip = cont.createEmptyMovieClip("titleTxtmc", this.getNextHighestDepth());
		Utils.createTextField("title", mc, mc.getNextHighestDepth(), 0, 0, 300, 100, titleTxt, StepByStepApp.getTxtFormat("bigTitleTxtFormat"));
		mc._x = 600;
		mc._y = 50;
		if (animateTitle==true){
			mc._x = 1000;
			mc.glideTo(600, 50, 10);
		}
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:storyTxt, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
	}
}
