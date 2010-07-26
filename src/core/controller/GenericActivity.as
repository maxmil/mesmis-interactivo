import ascb.util.logging.Logger;
import core.util.Utils;
import core.util.GenericMovieClip;
import core.comp.UserMessage;
import core.comp.EyeBtn;
import mx.transitions.easing.Back
import mx.transitions.easing.Regular
import mx.transitions.Tween;
import mx.transitions.Zoom;

/*
 * Super class for activities
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 28-06-2005
 */
 class core.controller.GenericActivity extends GenericMovieClip {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("core.controller.GenericActivity");
	
	//the asosiated application, is constructor for static application class
	private var app:Function;
	
	//the activity
	private var activityId:String;
	
	//questions
	private var questionKey:String;
	private var questions:Array;
	private var currQuestion:Number;
	public var quesInProc:Boolean;
	public var quesActive:Boolean;
	
	//depths
	public var bgDepth:Number;
	public var stepDepth:Number;
	public var compDepth:Number;
	public var questionDepth:Number;
	public var msgDepth:Number;
	
	//current step counter
	public var currStep:Number;
	
	//current component
	public var currComp;
	
	//allows steps to be stopped or started
	public var activateSteps:Boolean;
	
	/*
	 * Constructor
	 */
	function GenericActivity(_app:Function){
		
		//initialize depths
		bgDepth = 1;
		compDepth = 2;
		questionDepth = 3;
		stepDepth = 4;
		msgDepth = 5
		
		//activate steps
		activateSteps = true;
		
		//define application
		this.app = _app;
		
		//define activity id
		this.activityId = this.app.getNav().getCurrActivity_id();
		
		//create bg clip
		this.createEmptyMovieClip("bg", bgDepth);
	}
	
	/*
	 * Gets the given step. Removes the current step container and creates a new
	 * container with the elements of the given step
	 * 
	 * @param step the step to retrieve
	 */
	public function getStep(step:Number):Void {
		
		//if steps not activated then don't do anything
		if (!activateSteps){
			return;
		}
		
		//remove messages
		removeMsg();
		
		//remove container clip if exists
		if (this["mcStep"]) {
			this["mcStep"].removeMovieClip();
		}
		
		//create step, container, and buttons clip
		var mcStep = this.createEmptyMovieClip("mcStep", this.stepDepth);
		var cont = mcStep.createEmptyMovieClip("cont", mcStep.getNextHighestDepth());
		var btns = mcStep.createEmptyMovieClip("btns", mcStep.getNextHighestDepth());
		btns._y = 550;
		
		//draw title
		var txt:String = "";
		if (this.app.msgExists(this.activityId+".title.text")){
			txt = this.app.getMsg(this.activityId+".title.text") + " > ";
		}
		txt +=  this.app.getMsg(this.activityId+".step"+String(step)+".text")
		if (this["bg"]["titleTxt"]){
			this["bg"]["titleTxt"].text = txt;
		}else{
			Utils.createTextField("titleTxt", this["bg"], this["bg"].getNextHighestDepth(), 0, -25, 700, 20, txt, this.app.getTxtFormat("stepTitleTxtFormat"));
			this["bg"]["titleTxt"].setNewTextFormat(this.app.getTxtFormat("stepTitleTxtFormat"));
		}
		
		//step dependent initializations
		step = doStepDependencies(step);
		
		//execute step function
		this["step"+String(step)](this["mcStep"].cont);
		
		//save step
		this.currStep = step;
	}
	
	/*
	 * Carries out step dependent operations, should be overridden by subclasses
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		return step;
	}
	
	/*
	 * Gets the previous step
	 */
	public function previousStep():Void {
		this.currStep--;
		getStep(this.currStep);
	}

	/*
	 * Gets the next step♥
	 */
	public function nextStep():Void {
		this.currStep++;
		getStep(this.currStep);
	}
	
	/*
	 * Alpha tweens the given movie clip into the stage using a zoom transition
	 * 
	 * @param mc the movie clip to be tweened in
	 */
	public function tweenIn(mc):Void{
		mx.transitions.TransitionManager.start(mc,{type:Zoom, direction:0, duration:1, easing:Back.easeInOut,startPoint:1});
		var tween:Tween = new Tween(mc, "_alpha", Regular.easeIn, 0, 100, 1, true);
	}
	
	/*
	 * Removes current message
	 */
	public function removeMsg():Void{
		this["msg"].removeMovieClip()
	}
	
	/*
	 * Removes the current component
	 */
	public function removeCurrComp():Void{
		if(this.currComp){
			this.currComp.removeMovieClip();
		}
	}
	
	/*
	 * Removes the questions
	 */
	public function removeQuestions():Void{
		if(this["quesCont"]){
			this["quesCont"].removeMovieClip();;
		}
		this.quesInProc = false;
	}
	
	/*
	 * Initializes the questions for this step
	 * 
	 * @param questionKey the message resource question key for this set of questions
	 */
	public function initQuestions(questionKey:String){
		
		//save parameters
		this.questionKey = questionKey;
		
		//add questions to internal array
		this.questions = new Array();
		var i:Number = 0;
		var key:String = questionKey+String(i+1);
		while (this.app.msgExists(key + ".text")){
			questions[i] = new Object({question:this.app.getMsg(key + ".text"), answerMin:Number(this.app.getMsg(key + ".answer.min")), answerMax:Number(this.app.getMsg(key + ".answer.max")), explication:this.app.getMsg(key + ".explication"), answerExact:this.app.getMsg(key + ".answer.exact")});
			i++;
			key = questionKey+String(i+1);
		}
		
		//create container clip
		var quesCont = this.createEmptyMovieClip("quesCont", this.questionDepth);
		quesCont._x = 20;
		quesCont._y = 480;
		
		//create question textfield
		Utils.createTextField("quesText", quesCont, this.questionDepth, 0, 0, 830, 40, "", null);
		this.app.getTxtFormat("bigAltTxtFormat").align="right"
		quesCont["quesText"].setNewTextFormat(this.app.getTxtFormat("bigAltTxtFormat"));
		this.app.getTxtFormat("bigAltTxtFormat").align="left"
		
		//create answer textfield
		quesCont.createTextField("ansText", 2, 840, 0, 60, 25);
		quesCont["ansText"].text = "";
		quesCont["ansText"].setNewTextFormat(this.app.getTxtFormat("bigAltTxtFormat"));
		quesCont["ansText"].embedFonts = true;
		quesCont["ansText"].border = true;
		quesCont["ansText"].borderColor = this.app.getTxtFormat("bigAltTxtFormat").color;
		quesCont["ansText"].type = "input";
		quesCont["ansText"].maxChars = 5;
		
		//in question process
		this.quesInProc = true;
		
		//init currQuestion to first question
		this.currQuestion = 0;
		
		//load first question
		this.loadQuestion();
	}
	
	/*
	 * Loads question with index equal to this.currQuestion
	 */
	public function loadQuestion(){
		
		//remove messages
		removeMsg();
		
		//set question text
		this["quesCont"].quesText.text = this.questions[this.currQuestion].question;
		
		//reset answer text
		this["quesCont"].ansText.text = "";
	}
	
	/*
	 * Test the current answer to the current question and shows the user a message acordingly
	 */
	public function evalResponse():Void{
		
		//remove any messages being displayed
		removeMsg();
		
		//get answer
		var ans:Number = Number(this["quesCont"].ansText.text);
		
		//check that answer is numeric
		if(isNaN(ans)){
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:250, _y:200, w:400, txt:this.app.getMsg("error.isNaN"), txtFormat:this.app.getTxtFormat("warningTxtFormat")});
			return;
		}
		
		//get question object
		var question = this.questions[this.currQuestion];
		
		//check whether answer is incorrect
		if(ans<question.answerMin || ans>question.answerMax){
			var btn_seeSol:Object = new Object({callBackObj:this, callBackFunc:showSolution, literal:this.app.getMsg("btn.seeSolution")});
			var btn_contTrying:Object = new Object({callBackObj:this, callBackFunc:removeMsg, literal:this.app.getMsg("btn.continueTrying")});
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:250, _y:200, w:400, txt:this.app.getMsg("general.questions.answerIncorrect", new Array(String(ans))), txtFormat:this.app.getTxtFormat("warningTxtFormat"), callBack_btns: new Array(btn_seeSol, btn_contTrying)});
			return;
		}
		
		//answer is correct!! Save it in globals
		this.app.getUserSession().getAnswers()[this.questionKey + String(this.currQuestion) + ".userAnswer"] = ans;
		
		//if is not the last question
		if (this.currQuestion < this.questions.length-1){
			
			//show message
			var txt:String = this.app.getMsg("general.questions.answerCorrect", new Array(String(ans))) + "\n\n" + this.app.getMsg(this.questionKey+String(this.currQuestion+1)+".explication") + "\n\n" + this.app.getMsg("general.questions.nextQuestion");
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:200, w:400, txt:txt, txtFormat:this.app.getTxtFormat("defaultMsgTxtFormat")});
		
		}else{
			
			//no longer in question process
			this.quesInProc = false;
			
			//show all messages correctly answered text
			var txt:String = this.app.getMsg("general.questions.answerCorrect", new Array(String(ans))) + "\n\n" + question.explication + "\n\n" + this.app.getMsg("general.questions.excerciseComplete");
			Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:200, w:400, txt:txt, txtFormat:this.app.getTxtFormat("defaultMsgTxtFormat")});
		}
	}
	
	/*
	 * Shows the solution to a question
	 */
	public function showSolution():Void{
		
		//remove previous user message
		removeMsg();
		
		//get question object
		var question = this.questions[this.currQuestion];
		
		//show message
		var txt:String = this.app.getMsg("general.questions.answer", new Array(String(question.answerExact)));
		Utils.newObject(UserMessage, this, "msg", this.getNextHighestDepth(), {_x:250, _y:200, w:400, txt:txt, txtFormat:this.app.getTxtFormat("defaultMsgTxtFormat")});
	}
	
	/*
	 * Executes when next button is clicked
	 */
	public function next(){
		if(this.quesInProc && this.quesActive && this.app.getUserSession().getAnswers()[this.questionKey + String(this.currQuestion) + ".userAnswer"] == undefined){
			Utils.newObject(UserMessage, this, "msg", this.msgDepth, {_x:250, _y:200, w:400, txt:this.app.getMsg("general.questions.answerBeforeContinue"), txtFormat:this.app.getTxtFormat("warningTxtFormat")});
		}else if(this.quesInProc && this.quesActive && this.currQuestion < this.questions.length-1){
			this.currQuestion++;
			loadQuestion();
		}else{
			nextStep();
		}
	}
	
	/*
	 * Executes when back button is clicked
	 */
	public function back(){
		if(this.quesInProc && this.currQuestion){
			this.currQuestion--;
			loadQuestion();
		}else{
			previousStep();
		}
	}
	
	/*
	 * Executes when goto menu prin button is clicked
	 */
	public function gotoMenuPrin(){
		this.app.getNav().getActivity("menuPrin");
	}
	
	/*
	 * Creates any button
	 * 
	 * @param id the id of the button clip
	 * @param literal the text literal to display on the button
	 * @param callBackObj the call back object
	 * @param callBackFunc the call back function
	 * @param desactiviate when true the button is disactivated
	 */
	public function createBtn(id:String, literal:String, callBackObj:Object, callBackFunc:Function, desactivate:Boolean):Void{
		var xcoord:Number = 950 - this["mcStep"].btns._width;
		var btn:EyeBtn = Utils.newObject(EyeBtn, this["mcStep"].btns, id, this["mcStep"].btns.getNextHighestDepth(), {literal:literal, callBackObj:callBackObj, callBackFunc:callBackFunc, active:!desactivate});
		btn._x = (xcoord==950) ? xcoord-btn._width : xcoord-btn._width-10;
	}
	
	/*
	 * Creates the button "Next"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnNext(desactivate:Boolean):Void {
		createBtn("btn_next", this.app.getMsg("btn.next"), this, this.next, desactivate);
	}

	/*
	 * Creates the button "Back"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnBack(desactivate:Boolean):Void {
		createBtn("btn_back", this.app.getMsg("btn.previous"), this, this.back, desactivate);
	}
	
	/*
	 * Creates the button "Go to principal menu"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnGotoMenuPrin(desactivate:Boolean):Void {
		createBtn("btn_gotoMenuPrin", this.app.getMsg("btn.principalMenu"), this, this.gotoMenuPrin, desactivate);
	}
	
	/*
	 * Creates the button "Skip Tutorial"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 * @param stepNum the number of the step to skip to
	 */
	public function createBtnSkipTutorial(desactivate:Boolean, stepNum:Number):Void {		
		var func:Function = function(){
			this.getStep(stepNum);
		}
		createBtn("btn_skipTut", this.app.getMsg("btn.skipTutorial"), this, func, desactivate);
	}
	
	/*
	 * Creates the button "Goto next activity"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 * @param lit the literal text to display on the button
	 */
	public function createBtnGotoNextActivity(desactivate:Boolean, lit:String):Void {
		createBtn("btn_gotoNextActiv", lit, this.app.getNav(), this.app.getNav().getNext, desactivate);
	}
	
	/*
	 * Creates the button "Evaluate Response"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnEvalResp(desactivate:Boolean):Void {
		createBtn("btn_eval_resp", this.app.getMsg("btn.evaluateResponse"), this, this.evalResponse, desactivate);
	}
	
	/*
	 * Creates the button "Reset"
	 * 
	 * @param desactivate a boolean flag that desactivates or not the button
	 */
	public function createBtnReset(desactivate:Boolean):Void {
		createBtn("btn_reset", this.app.getMsg("btn.reset"), this.currComp, this.currComp.reset, desactivate);
	}
	
	/*
	 * Activates or desactivates all buttons
	 * 
	 * @param active when true activates otherwise desactivates
	 */
	public function activateBtns(active):Void{
		var btns:MovieClip = this["mcStep"].btns;
		for(var o in btns){
			if(typeof(btns[o])=="movieclip"){
				EyeBtn(btns[o]).setActive(active);
			}
		}
	}
	
	/*
	 * Creates story text box
	 * 
	 * @param txt the story text to write
	 * 
	 * @return the story board
	 */
	public function createStoryTxt(txt:String):UserMessage{
		var um:UserMessage = Utils.newObject(UserMessage, this["mcStep"].cont, "txt", this["mcStep"].cont.getNextHighestDepth(), {_x:540, w:390, txt:txt, txtFormat:this.app.getTxtFormat("storyTxtFormat"), btnClose:false, bgColor:0xEBE2DC})
		this["mcStep"].cont["txt"]._y = (550-this["mcStep"].cont["txt"]._height)/2;
		return um;
	}
	
	/*
	 * Draws border of specified dimensions and with the specified id in the content clip
	 * 
	 * @param id the id of the border clip
	 * @param x the x coordinate of the border clip
	 * @param y the y coordinate of the border clip
	 * @param h the height of the border clip
	 * @param w the width of the border clip
	 */
	public function drawBorder(id:String, x:Number, y:Number, w:Number, h:Number):Void{
		Utils.drawBorder(id, this["mcStep"].cont, 3, 0xff6600, x, y, w, h);
	}
}

