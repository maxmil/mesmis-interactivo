import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.Scroll;
import core.comp.TextPane;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;
import stepByStep.model.valueObject.CriticalPoint;
import stepByStep.model.valueObject.DiagnosticCriteria;
import stepByStep.model.valueObject.Indicator;

/*
 * Characterization of the system Agrosilvopastoril. The user builds the system in 
 * this activitiy composing the subsistems, components, flows and critical points (strengths
 * and weaknesses)
 * 
 * @autor Max Pimm
 * @created 23-05-2005
 * @version 1.0
 */
class stepByStep.activity.characterization.SelectIndicators extends stepByStep.activity.StepByStepActivity {
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.activity.characterization.SelectIndicators");
	
	//array of subsistems
	private var subsystems:Array;

	//array of critical points
	private var cps:Array;

	//array of criterias
	private var criterias:Array;

	//array of indicators
	private var indicators:Array;

	/*
	 * Constructor
	 */
	public function SelectIndicators() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating SelectIndicators");
		
		//get first step
		getStep(1);
	}
	

	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
		if((step<2) && this.currComp){
			
			//remove component
			this.currComp.removeMovieClip();
			this.currComp = undefined;
			
		}else if(step>1){
			
			//create component if neccesarry
			if(!this.currComp){
				initComp();
			}else {
				this.currComp._visible = true;
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
		Utils.createTextField("title", titleCont, 1, 0, 0, 900, 10, StepByStepApp.getMsg("selectIndicators.intro.title"), bigTitleTxtFormat);
		titleCont._x = 960;
		titleCont._y = 20;
		titleCont.glideTo(20, 20, 10);
		
		//add graphic
		var img:MovieClip = MovieClip(cont.attachMovie("selInd_intro", "img", cont.getNextHighestDepth(), {_x:50, _y:100, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("selectIndicators.intro.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnGotoMenuPrin();
	}
	
	
	/*
	 * Step 2: Show criteria
	 * 
	 * @param cont the container clip for the step
	 */
	public function step2(cont:GenericMovieClip):Void{
		
		//show attributes
		showElements("criteria");
		
		//create message
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:500, _y:230, w:300, txt:StepByStepApp.getMsg("selectIndicators.comp.presentCriteria"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 3: Show critical points
	 * 
	 * @param cont the container clip for the step
	 */
	public function step3(cont:GenericMovieClip):Void{
		
		//show attributes
		showElements("cps");
		
		//create message
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:720, _y:200, w:200, txt:StepByStepApp.getMsg("selectIndicators.comp.presentStrenthsAndWeakenesses"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
		tweenIn(msg);
		
		//create buttons
		createBtnNext();
		createBtnBack();
	}
	
	/*
	 * Step 4: Show indicators
	 * 
	 * @param cont the container clip for the step
	 */
	public function step4(cont:GenericMovieClip):Void{

		//show attributes
		showElements("indicators");	
		
		//create message
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:350, _y:200, w:300, txt:StepByStepApp.getMsg("selectIndicators.comp.presentIndicators"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
		tweenIn(msg);
				
		//create buttons
		var fnc:Function = function(){
			this.app.getNav().getActivity("selectIndicators");
		}
		createBtnNext();
		createBtnBack();
	}

	/*
	 * Step 5: Press indicators for description
	 * 
	 * @param cont the container clip for the step
	 */
	public function step5(cont:GenericMovieClip):Void{

		//show attributes
		showElements("indicators");
		
		//create message
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "msg", cont.getNextHighestDepth(), {_x:350, _y:200, w:300, txt:StepByStepApp.getMsg("selectIndicators.comp.pressIndicators"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
		tweenIn(msg);
				
		//create buttons
		var fnc:Function = function(){
			this.app.getNav().getActivity("defineAmoebas");
		}
		createBtn("btn_gotoStep5", this.app.getMsg("btn.gotoStep5"), this, fnc);
		createBtnGotoMenuPrin();
		createBtnBack();
	}
	
	/*
	 * Initializes the attributes
	 */
	private function initAttributes() :Void {
		this.currComp["scroll"].getContentClip()["base"]["attributes"].txtAtribTitle = StepByStepApp.getMsg("selectIndicators.comp.atributesTitle");
		this.currComp["scroll"].getContentClip()["base"]["attributes"].txtAtribs = StepByStepApp.getMsg("selectIndicators.comp.atributes");
	}

	/*
	 * Initializes the critical points (strengths and weaknesses)
	 */
	private function initCriticalPoints() :Void {

		var l:Number = this.cps.length;
		var cp:CriticalPoint;
		var mcCp:MovieClip;
		var tfId:String;

		//create text format
		var txtFormat = new TextFormat();
		txtFormat.font = "Arial";
		txtFormat.size = 13;
		txtFormat.bold = true;
		txtFormat.align = "center";

		//loop through critical points adding text field for each one. Ids should correspond to symbol ids
		for (var i = 0; i<l; i++) {
			
			//get next critical point
			cp = this.cps[i];
			mcCp = this.currComp["scroll"].getContentClip()["base"]["cp_"+String(cp.getId())];
			tfId = "cp_tf"+String(cp.getId());
			
			//define color acording to type
			if (cp.getType() == "strength") {
				txtFormat.color = 0x000066;
			} else {
				txtFormat.color = 0x660000;
			}
			
			//create text field
			Utils.createTextField(tfId, this.currComp["scroll"].getContentClip()["texts"], this.currComp["scroll"].getContentClip()["texts"].getNextHighestDepth(), 0, 0, 130, 100, cp.getLiteral(), txtFormat);
			this.currComp["scroll"].getContentClip()["texts"][tfId]._x = mcCp._x+(mcCp._width-this.currComp["scroll"].getContentClip()["texts"][tfId]._width)/2;
			this.currComp["scroll"].getContentClip()["texts"][tfId]._y = mcCp._y+(mcCp._height-this.currComp["scroll"].getContentClip()["texts"][tfId]._height)/2;
		}
	}

	/*
	 * Initializes the diagnostic criteria
	 */
	private function initDiagnosticCriteria() :Void {
	
	var l:Number = this.criterias.length;
		var criteria:DiagnosticCriteria;
		var mcCd:MovieClip;
		var tfId:String;
		
		//create text format
		var txtFormat = new TextFormat();
		txtFormat.font = "Arial";
		txtFormat.size = 13;
		txtFormat.color = 0xff6600;
		txtFormat.bold = true;
		txtFormat.align = "center";
		
		//loop through criteria drawing text field for each one. Ids should correspond to symbol ids
		for (var i = 0; i<l; i++) {
			
			//get next criteria
			criteria = this.criterias[i];
			mcCd = this.currComp["scroll"].getContentClip()["base"]["dc_"+String(criteria.getId())];
			tfId = "dc_tf"+String(criteria.getId());
			
			//create text field
			Utils.createTextField(tfId, this.currComp["scroll"].getContentClip()["texts"], this.currComp["scroll"].getContentClip()["texts"].getNextHighestDepth(), 0, 0, 120, 100, criteria.getLiteral(), txtFormat);
			this.currComp["scroll"].getContentClip()["texts"][tfId]._x = mcCd._x+(mcCd._width-this.currComp["scroll"].getContentClip()["texts"][tfId]._width)/2;
			this.currComp["scroll"].getContentClip()["texts"][tfId]._y = mcCd._y+(mcCd._height-this.currComp["scroll"].getContentClip()["texts"][tfId]._height)/2;
		}
	}

	/*
	 * Initializes the indicators
	 */
	private function initIndicators() :Void {

		var l:Number = this.indicators.length;
		var indicator:Indicator;
		var mcInd:MovieClip;
		var tfId:String;

		//create text format
		var txtFormat = new TextFormat();
		txtFormat.font = "Arial";
		txtFormat.size = 10;
		txtFormat.color = 0xff6600;
		txtFormat.bold = false;
		txtFormat.align = "center";

		//loop through indicators drawing text field for each one. Ids should correspond to symbol ids
		for (var i = 0; i<l; i++) {
			
			//get next indicator
			indicator = this.indicators[i];
			mcInd = this.currComp["scroll"].getContentClip()["base"]["indic_"+String(indicator.getId())];
			mcInd.selInd = this;
			tfId = "indic_tf"+String(indicator.getId());
			
			//create text field
			Utils.createTextField(tfId, this.currComp["scroll"].getContentClip()["texts"], this.currComp["scroll"].getContentClip()["texts"].getNextHighestDepth(), 0, 0, 70, 100, indicator.getLiteral(), txtFormat);
			this.currComp["scroll"].getContentClip()["texts"][tfId]._x = mcInd._x+(mcInd._width-this.currComp["scroll"].getContentClip()["texts"][tfId]._width)/2;
			this.currComp["scroll"].getContentClip()["texts"][tfId]._y = mcInd._y+(mcInd._height-this.currComp["scroll"].getContentClip()["texts"][tfId]._height)/2;
			
			//create on release action
			mcInd.onRelease = function() {
				this.selInd.openDetail("indicator", this._name.substring(this._name.lastIndexOf("_")+1));
			};
		}
	}

	/*
	 * Opens the detail pane
	 * 
	 * @param type the type of element to open. Valid values are "attributes", "criteria" and "indicator"
	 * @para ind the index of the element in its corresponding array
	 */
	public function openDetail(type:String, ind:Number) :Void {

		var titleTxt:String;
		var bodyTxt:String;
		var x,y,w,h:Number;

		//remove detail pane if already exists
		if (this.currComp["tpDetail"]) {
			x = this.currComp["tpDetail"]._x;
			y = this.currComp["tpDetail"]._y;
			w = this.currComp["tpDetail"].w;
			h = this.currComp["tpDetail"].h;
			this.currComp["tpDetail"].removeMovieClip();
		}else{
			x = 0;
			y = 0;
			w = 320;
			h = 250;
		}

		//treat different cases
		switch (type) {
		case "indicator":
			titleTxt = this.indicators[ind-1].getLiteral();
			bodyTxt = this.indicators[ind-1].getDescription();			
			break;
		}

		//open detail pan
		Utils.newObject(TextPane, this.currComp, "tpDetail", this.currComp.getNextHighestDepth(), {titleTxt:titleTxt, _x:x, _y:y, w:w, h:h});
		var cp = this.currComp["tpDetail"].getContent();
		Utils.createTextField("tf", cp, cp.getNextHighestDepth(), 0, 0, 300, 250, bodyTxt, StepByStepApp.getTxtFormat("defaultTxtFormat"));
		this.currComp["tpDetail"].init(true);
	}

	/*
	 * Creates the mask to hide the elements. Initially it hides all elements
	 */
	private function createMask() :Void {
		if(this.currComp["mask"]){
			this.currComp["mask"].removeMovieClip();
		}
		var mask = this.currComp.createEmptyMovieClip("mask", this.currComp.getNextHighestDepth());
		mask.beginFill(0x000000, 100);
		mask.lineTo(0, this.currComp["scroll"]._height);
		mask.lineTo(this.currComp["scroll"].getContentClip()._width, this.currComp["scroll"]._height);
		mask.lineTo(this.currComp["scroll"].getContentClip()._width, 0);
		mask.lineTo(0, 0);
		mask.endFill();
		mask._x = this.currComp["scroll"]._x-mask._width;
		this.currComp["scroll"].getContentClip().setMask(mask);
	}

	/*
	 * Shows elements by sliding the mask to the right
	 * 
	 * @param type the type of element to show. Valid values are "attributes", "criteria", "cps" and "indicators"
	 */
	private function showElements(type:String) :Void {
		var x:Number;
		switch (type) {
		case "none" :
			x = 0;
			break;
		case "attributes" :
			x = 106;
			break;
		case "criteria" :
			x = 464;
			break;
		case "cps" :
			x = 714;
			break;
		case "indicators" :
			x = 908;
			break;
		}
		this.currComp["mask"].glideTo(this.currComp["scroll"]._x-this.currComp["mask"]._width+x, this.currComp["mask"]._y, 5);
	}
	
	/*
	 * Initializes component
	 */
	private function initComp():Void{

		//create scroll container
		this.currComp = this.createEmptyMovieClip("scrollCont", this.compDepth);

		//create background
		this.currComp.attachMovie("selInd_bg", "bg", this.currComp.getNextHighestDepth(), {_alpha:30});

		//create scroll
		Utils.newObject(Scroll, this.currComp, "scroll", this.currComp.getNextHighestDepth(), {_x:0, _y:0, w:945, h:545, speed:20});
		var cont:MovieClip = this.currComp["scroll"].getContentClip();
		
		//attach base movie
		cont.attachMovie("selIndicators", "base", cont.getNextHighestDepth());
		
		//create movie for texts
		var texts:MovieClip = cont.createEmptyMovieClip("texts", cont.getNextHighestDepth());
		texts._x = this.currComp["scroll"].getContentClip()["base"]._x;
		texts._y = this.currComp["scroll"].getContentClip()["base"]._y;
		
		//init texts
		initAttributes();
		initCriticalPoints();
		initDiagnosticCriteria();
		initIndicators();
		createMask();
		showElements("none");
		
		//init scroll
		this.currComp["scroll"].init();
	}
}
