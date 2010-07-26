import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;

/*
 * Characterization of the system Agrosilvopastoril. The user builds the system in 
 * this activitiy composing the subsistems, components, flows and critical points (strengths
 * and weaknesses)
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.activity.characterization.StrengthsAndWeaknesses extends stepByStep.activity.StepByStepActivity {
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.activity.characterization.StrengthsAndWeaknesses");
	
	//array of critical points
	private var cps:Array;

	/*
	 * Constructor
	 */
	public function StrengthsAndWeaknesses() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating StrengthsAndWeaknesses");
		
		//get first step
		getStep(1);
	}
	

	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		if((step<2) && this["swComp"]){
			
			//remove component
			this["swComp"].removeMovieClip();
			
		}else if(step>1){
			
			//create component if neccesarry
			if(!this["swComp"]){
				createSwComp();
			}else {
				this["swComp"]._visible = true;
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
		Utils.createTextField("title", titleCont, 1, 0, 0, 900, 10, StepByStepApp.getMsg("strengthsAndWeaknesses.intro.title"), bigTitleTxtFormat);
		titleCont._x = 960;
		titleCont._y = 20;
		titleCont.glideTo(20, 20, 10);
		
		//add graphic
		var img:MovieClip = MovieClip(cont.attachMovie("sw_intro", "img", cont.getNextHighestDepth(), {_x:150, _y:100, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:600, w:300, txt:StepByStepApp.getMsg("strengthsAndWeaknesses.intro.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnGotoMenuPrin();
	}
	
	/*
	 * Step 2: Introduce strengths and weaknessness for case study - 1
	 * 
	 * @param cont the container clip for the step
	 */
	public function step2(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 1);
		this["swComp"].gotoAndPlay("showSw1");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 3: Introduce strengths and weaknessness for case study - 2
	 * 
	 * @param cont the container clip for the step
	 */
	public function step3(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 2);
		this["swComp"].gotoAndPlay("showSw2");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 4: Introduce strengths and weaknessness for case study - 3
	 * 
	 * @param cont the container clip for the step
	 */
	public function step4(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 3);
		this["swComp"].gotoAndPlay("showSw3");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 5: Introduce strengths and weaknessness for case study - 4
	 * 
	 * @param cont the container clip for the step
	 */
	public function step5(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 4);
		this["swComp"].gotoAndPlay("showSw4");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 6: Introduce strengths and weaknessness for case study - 5
	 * 
	 * @param cont the container clip for the step
	 */
	public function step6(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 5);
		this["swComp"].gotoAndPlay("showSw5");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 7: Introduce strengths and weaknessness for case study - 6
	 * 
	 * @param cont the container clip for the step
	 */
	public function step7(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 6);
		this["swComp"].gotoAndPlay("showSw6");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 8: Introduce strengths and weaknessness for case study - 7
	 * 
	 * @param cont the container clip for the step
	 */
	public function step8(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 7);
		this["swComp"].gotoAndPlay("showSw7");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 9: Introduce strengths and weaknessness for case study - 8
	 * 
	 * @param cont the container clip for the step
	 */
	public function step9(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 8);
		this["swComp"].gotoAndPlay("showSw8");
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 10: Introduce strengths and weaknessness for case study - 9
	 * 
	 * @param cont the container clip for the step
	 */
	public function step10(cont:GenericMovieClip):Void{
		
		//add component message and show bubble
		createCompMsg(cont, 9);
		this["swComp"].gotoAndPlay("showSw9");
		
		//create buttons
		var fnc:Function = function(){
			this.app.getNav().getActivity("selectIndicators");
		}
		createBtn("btn_gotoStep3", this.app.getMsg("btn.gotoStep3And4"), this, fnc);
		createBtnGotoMenuPrin();
		createBtnBack();
	}	
	/*
	 * Auxiliar function to create the strength and weakness component for the case study
	 */
	private function createSwComp():Void{
		
		var swComp:MovieClip = MovieClip(this.attachMovie("sw_main", "swComp", this.compDepth, {_x:180, _y:50}));
		
		swComp.txtTitle = StepByStepApp.getMsg("strengthsAndWeaknesses.component.title");
		
		swComp.systems_asp.txtFamilyUnit = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.familyUnit");
		swComp.systems_asp.txtExterior = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.exterior");
		swComp.systems_asp.txtExteriorElmnts = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.exteriorElmnts");
		swComp.systems_asp.txtWork = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.work");
		swComp.systems_asp.txtCorn = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.corn");
		swComp.systems_asp.txtCorn2 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.corn");
		swComp.systems_asp.txtSubsid = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.subsid");
		swComp.systems_asp.txtCultivatedField = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.cultivatedField");
		swComp.systems_asp.txtRestingField = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.restingField");
		swComp.systems_asp.txtCattle = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.cattle");
		swComp.systems_asp.txtNutrients1 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.nutrients1");
		swComp.systems_asp.txtNutrients2 = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.nutrients2");
		swComp.systems_asp.txtSoil = StepByStepApp.getMsg("defineSystem.systemCasasBlancas.soil");
		
		for(var i=0; i<this.cps.length;i++){
			swComp["sw"+String(i+1)+"Literal"]=cps[i].getLiteral();
		}
	}
	
	/*
	 * Auxiliar function to create message for component and tween in
	 * 
	 * @param cont the container clip
	 * @param ind the index of the message
	 */
	private function createCompMsg(cont:MovieClip, ind:Number):Void{
		var titleTxt:String = this.cps[ind-1].getShortTitle();
		var descTxt:String = this.cps[ind-1].getDescription();
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:730, _y:280, w:210, txt:descTxt, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), titleTxt:titleTxt, titleTxtFormat:StepByStepApp.getTxtFormat("defaultTitleTxtFormat"), allowDrag:false, btnClose:false});
		tweenIn(msg);
	}
	

}
