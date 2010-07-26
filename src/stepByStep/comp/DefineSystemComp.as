import ascb.util.logging.Logger;
import core.controller.GenericActivity;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.util.Proxy;
import core.comp.TextPane;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;
import stepByStep.model.valueObject.Comp;
import stepByStep.model.valueObject.Flow;
import stepByStep.model.valueObject.Subsystem;
import stepByStep.comp.SelectComponents;
import stepByStep.comp.SelectFlows;

/*
 * Graphic component that allows the user to define the system by adding components and flows
 *
 * @author Max Pimm
 * @created 27-09-2005
 * @version 1.0
 */
 class stepByStep.comp.DefineSystemComp extends GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.comp.DefineSystemComp");
	
	//array of subsistems
	private var subsystems:Array;
	
	//array of components
	private var comps:Array;
	
	//array of flows
	private var flows:Array;
	
	//current system index
	private var currSysInd:Number;
	
	//reference to activity hosting the component
	private var activity:GenericActivity
	
	//flag that activates or disactivates the component
	private var active:Boolean;

	/*
	 * Constructor
	 */
	public function DefineSystemComp(){
		
		logger.debug("Instantiating DefineSystemComp")
		
		//draw background
		this.attachMovie("system", "bg", 1, {_y:90});
		this.attachMovie("exterior", "exterior", 2, {_x:350, _y:10});
		
		//initialize hidden elements
		initSubsystems();
		initComps();
		initFlows();
	}
	
	/*
	 * Initializes the components
	 */
	private function initComps():Void {
		
		//radius of component circles
		var radius:Number = 40;
		
		//unselect all components
		for (var i=0; i<this.comps.length; i++){
			this.comps[i].setIsSel(false)
		}
		
		//create component containerclip
		var mcComps:MovieClip = this.createEmptyMovieClip("mcComps", this.getNextHighestDepth());
		
		//define coordinates for components
		var coords:Array = new Array(110, 395, 210, 395, 490, 220, 815, 445, 750, 515, 880, 515, 430, 290, 555, 290, 440, 500, 545, 500);
		var cnt:Number = 0;
		var comp:Comp;
		
		//create components
		for (var i = 0; i<this.comps.length; i++) {
			comp = this.comps[i];
			
			//create container clip
			var mcComp:MovieClip = mcComps.createEmptyMovieClip("mcComp_"+String(comp.getId()), mcComps.getNextHighestDepth());
			mcComp._x = coords[cnt++]-radius/2;
			mcComp._y = coords[cnt++]-radius/2;
			mcComp.ind = i;
			mcComp._visible = false;
			
			//create img clip
			if (comp.getImg() != null && comp.getImg().length>0) {
				
				var img = mcComp.createEmptyMovieClip("img", mcComp.getNextHighestDepth());
				
				//create mask clip
				var mask = img.createEmptyMovieClip("mask", img.getNextHighestDepth());
				mask.beginFill(0x000000, 100);
				mask.drawCircle(0, 0, radius, 10);
				img.setMask(mask);
				
				//create loader
				var loader = img.createClassObject(mx.controls.Loader, "loader", mcComp.getNextHighestDepth(), {_x:-1.5*radius, _y:-radius, _width:3*radius, _height:2*radius, _alpha:50});
				loader.load("stepByStep/img/components/"+comp.getImg());
				
				//add rollover functionality
				mcComp.onRollOver = function() {
					if (!this._parent._parent._parent.busy) {
						this.img.loader._alpha = 100;
					}
				};
				mcComp.onRollOut = function() {
					if (!this._parent._parent._parent.busy) {
						this.img.loader._alpha = 50;
					}
				};
				
				//on release show detail
				mcComp.onRelease = Proxy.create(this, this.createDetailText, "component", i);
			}
			
			//create outline clip
			var outline = mcComp.createEmptyMovieClip("outline", mcComp.getNextHighestDepth());
			outline.lineStyle(5, 0xCCFF99, 100);
			outline.drawCircle(0, 0, radius, 10);
			
		};
	}
	
	/*
	 * Initializes the flows
	 */
	private function initFlows():Void {

		var x_coords:Array = new Array(30, 40, 87, 150, 273, 400, 0, 272, 510, 400, 603, 603, 585, 585, 603, 603, 603, 585, 200, 603, 510);
		var y_coords:Array = new Array(460, 10, 460, 460, 410, 317, 10, 280, 320, 54, 255, 150, 10, 10, 410, 470, 510, 30, 30, 203, 54);
		var flow:Flow;
		
		//unselect all flows
		for (var i=0; i<this.flows.length; i++){
			this.flows[i].setIsSel(false);
		}
		
		//attatch flows (hidden)
		var mcFlows:MovieClip = this.createEmptyMovieClip("mcFlows", this.getNextHighestDepth());
		var flowId:String;
		for (var i = 0; i<this.flows.length; i++) {
			flow = this.flows[i];
			flowId = "mcFlow_"+String(flow.getId())
			mcFlows.attachMovie("flow_"+String(flow.getId()), flowId, mcFlows.getNextHighestDepth(), {_x:x_coords[flow.getId()-1], _y:y_coords[flow.getId()-1], _visible:false});
			mcFlows[flowId].activity = this.activity;
			mcFlows[flowId].literal = flow.getLiteral();
			mcFlows[flowId].onRelease = Proxy.create(this, this.createDetailText, "flow", i);
			mcFlows[flowId].onRollOver = function(){
				this.activity["flowMsg"].removeMovieClip();
				var txtFormat:TextFormat = StepByStepApp.getTxtFormat("altSmallTxtFormat");
				var x:Number = Math.min(this.activity._xmouse+10, 830);
				var y:Number = Math.min(this.activity._ymouse+10, 520);
				Utils.newObject(UserMessage, this.activity, "flowMsg", this.activity.getNextHighestDepth(), {w:120, _x:x, _y:y, txt:this.literal, txtFormat:txtFormat, bgColor:0xffffff, fgColor:txtFormat.color, btnClose:false})
			}
			mcFlows[flowId].onRollOut = function(){
				this.activity["flowMsg"].removeMovieClip();
			}
		}
	}
	
	/*
	 * Initializes the subsystems
	 */
	private function initSubsystems():Void {

		//create container clip
		var cont:GenericMovieClip = this.createEmptyMovieClip("mcSubsystems", this.getNextHighestDepth());

		var coords:Array = new Array(670, 355, 20, 270, 350, 130, 350, 380);
		var cnt:Number = 0;
		var subsys:MovieClip;
		var id:String;
		for (var i = 0; i<this.subsystems.length-1; i++) {

			//attach subsystem (with _alpha = 0)
			subsys = cont.attachMovie("subsystem", "subsyst_"+String(this.subsystems[i].getId()), cont.getNextHighestDepth(), {_x:coords[cnt++], _y:coords[cnt++], title:this.subsystems[i].getLiteral(), _alpha:0});
			subsys["ind"] = i;
			subsys.attachMovie("subsys_over", "over", 1, {_visible:false});

			//add listeners
			subsys.onRollOver = function() {
				this["over"]._visible = true;
			};
			subsys.onRollOut = function() {
				this["over"]._visible = false;
			};
			subsys.onRelease = Proxy.create(this, this.createDetailText, "subsystem", i);
		}
		
		//initialze counter
		this.currSysInd = 0;
	}
	
	/*
	 * Creates the detail pane for a subsistem, component or flow
	 *
	 * @param type the type of element("component", "subsystem" or "flow").
	 * @param ind the index of the element in the corresponding array
	 */
	public function createDetailText(type:String, ind:Number):Void {
		
		var x:Number = 620;
		var y:Number = 10;
		var w:Number = 320;
		var h:Number = 340;
		
		//remove text pane if already exists
		if(this["tp"]){
			x = this["tp"]._x;
			y = this["tp"]._y;
			w = this["tp"].w;
			h = this["tp"].h;
			this["tp"].removeMovieClip();
		}
		
		
		//depending on the type define title, text, image path
		var titleTxt:String;
		var txt:String;
		var imgPath:String;
		switch (type) {
			case "component" :
				titleTxt = this.comps[ind].getLiteral()
				txt = this.comps[ind].getDescription();
				imgPath = "stepByStep/img/components/"+this.comps[ind].getImg();
			break;
			case "subsystem" :
				titleTxt = this.subsystems[ind].getLiteral()
				txt = this.subsystems[ind].getDescription();
				imgPath = "stepByStep/img/subsystems/"+this.subsystems[ind].getImg();
			break;
			case "flow" :
				titleTxt = this.flows[ind].getLiteral()
				txt = this.flows[ind].getDescription();
				imgPath = "stepByStep/img/flows/"+this.flows[ind].getImg();
			break;
		}
		
		//create text pane
		Utils.newObject(TextPane, this, "tp", this.getNextHighestDepth(), {titleTxt:titleTxt, _x:x, _y:y, w:w, h:h, btnClose:true});
		var cp = this["tp"].getContent();
		Utils.createTextField("tf", cp, cp.getNextHighestDepth(), 0, 0, 300, 250, txt, StepByStepApp.getTxtFormat("defaultTxtFormat"));
		
		//create loader and load image
		var loader = cp.createClassObject(mx.controls.Loader, "loader", cp.getNextHighestDepth(), {_x:60, _y:cp["tf"]._height+10, _width:200, _height:133});
		loader.load(imgPath);
		var listener:Object = new Object();
		listener.complete = Proxy.create(this["tp"], this["tp"].init, true);
		loader.addEventListener("complete", listener);
	}

	/*
	 * Hides subsystems
	 */
	public function hideSubsystems():Void{

		var subsys:Subsystem;
		for (var i = 0; i<this.subsystems.length-1; i++) {
			subsys = this.subsystems[i];
			this["mcSubsystems"]["subsyst_"+String(subsys.getId())]._alpha = 0;
		}
		
		this.currSysInd = 0;
	}
	
	/*
	 * Shows subsystems
	 */
	public function showSubsystems():Void{

		logger.debug("showing Subsystems");
		
		var subsys:Subsystem;
		for (var i = 0; i<this.subsystems.length-1; i++) {
			subsys = this.subsystems[i];
			this["mcSubsystems"]["subsyst_"+String(subsys.getId())]._alpha = 100;
		}
		
		this.currSysInd = this.subsystems.length-1;
	}
	
	/*
	 * Adds a subsystem, if all subsystems have been added then the next step is requested from parent activity
	 */
	public function addSubsystem():Void {
		
		//remove any messages from parent activity
		this.activity.removeMsg();
		
		//show next system
		var subsys:Subsystem = this.subsystems[this.currSysInd];
		this["mcSubsystems"]["subsyst_"+String(subsys.getId())].alphaTo(100, 30);
		this.createDetailText("subsystem", this.currSysInd);
		
		//increment current
		this.currSysInd++;
		
		//if there are no more subsystems remove add systems button and replace with add components button
		if (this.currSysInd == this.subsystems.length-1) {	
			this.activity.nextStep();
		}
	}

	/*
	 * Hides all components
	 */
	public function hideComponents():Void{

		var comp:Comp;
		for (var i = 0; i<this.comps.length; i++) {
			comp = this.comps[i];
			this["mcComps"]["mcComp_"+String(comp.getId())]._visible = false;
			comp.setIsSel(false);
		}
	}
	
	/*
	 * Shows selected components
	 */
	public function showComponents():Void{

		var comp:Comp;
		for (var i = 0; i<this.comps.length; i++) {
			comp = this.comps[i];
			if (comp.getIsSel()){
				this["mcComps"]["mcComp_"+String(comp.getId())]._visible = true;
			}
		}
	}
	
	/*
	 * Opens ths component selector
	 */
	public function openCompSelector():Void {

		//remove any messages from parent activity
		this.activity.removeMsg();
		
		//disable buttons in parent activity
		this.activity.activateBtns(false);
		
		//disable this component
		this.setActive(false);
		
		//open selector
		Utils.newObject(SelectComponents, this.activity, "selectComponents", this.activity.getNextHighestDepth(), {_x:200, _y:20, w:520, h:400, comps:this.comps, subsystems:this.subsystems, addCompFnc:Proxy.create(this, this.addComponent), closeFnc:Proxy.create(this, this.closeCompSel)});
	}
	
	/*
	 * Closes the component selector and reactivates this component
	 */
	public function closeCompSel():Void{
		
		//minimize detail pane
		this["tp"].closeBlind();
		
		//close the selector and reactivate the component
		this.activity["selectComponents"].removeMovieClip();
		this.setActive(true);
		this.activity.activateBtns(true);
		
		//if not all components added then show message
		if (!allComponentsAdded()){
			var msg:UserMessage = Utils.newObject(UserMessage, this.activity, "msg", this.activity.msgDepth, {_x:280, txt:StepByStepApp.getMsg("defineSystem.excercise.addRestOfComponents"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), w:400});
			msg._y = (550-msg._height)/2;
		}
	}
		
	/*
	 * Adds a component, if all components have been added then the next step is requested
	 * 
	 * @param the index of the component to add if no index is given all components are added and the selector closed
	 */
	public function addComponent(ind:Number):Void {
		
		//if ind is undefined add all components and goto next step of parent ativity
		if(isNaN(ind)){
			addAllComponents();
			closeCompSel();
			this.activity.nextStep();
			return;
		}
		
		//show component
		this["mcComps"]["mcComp_"+this.comps[ind].getId()]._visible = true;
		
		//select component
		this.comps[ind].setIsSel(true);
		
		//if all components have been added then goto next step of parent activity
		if (allComponentsAdded()) {
			closeCompSel();
			this.activity.nextStep();
		}
	}
	
	/*
	 * Adds all components to system
	 */
	private function addAllComponents() :Void{
		for (var i = 0; i<this.comps.length; i++) {
			this["mcComps"]["mcComp_"+this.comps[i].getId()]._visible = true;
			this.comps[i].setIsSel(true);
		}
	}
	
	/*
	 * Checks to see if all the components have been added to the system
	 *
	 * @return true if all components have been added. False otherwise
	 */
	private function allComponentsAdded():Boolean {
		var cnt:Number = 0;
		var found:Boolean = true;
		while (cnt<this.comps.length && found) {
			if (!comps[cnt].getIsSel()) {
				found = false;
			}
			cnt++;
		}
		return found;
	}

	/*
	 * Hides all flows
	 */
	public function hideFlows():Void{

		var flow:Flow;
		for (var i = 0; i<this.flows.length; i++) {
			flow = this.flows[i];
			this["mcFlows"]["mcFlow_"+String(flow.getId())]._visible = false;
			flow.setIsSel(false);
		}
	}
	
	/*
	 * Shows selected flows
	 */
	public function showFlows():Void{

		var flow:Flow;
		for (var i = 0; i<this.flows.length; i++) {
			flow = this.flows[i];
			if (flow.getIsSel()){
				this["mcFlows"]["mcFlow_"+String(flow.getId())]._visible = true;
			}
		}
	}
	
	/*
	 * Opens ths flow selector
	 */
	public function openFlowSelector():Void {

		//remove any messages from parent activity
		this.activity.removeMsg();
		
		//disable buttons in parent activity
		this.activity.activateBtns(false);
		
		//disable this component
		this.setActive(false);
		
		//open selector
		Utils.newObject(SelectFlows, this.activity, "selectFlows", this.activity.getNextHighestDepth(), {_x:200, _y:20, w:520, h:400, flows:this.flows, subsystems:this.subsystems, addFlowFnc:Proxy.create(this, this.addFlow), closeFnc:Proxy.create(this, this.closeFlowSel)});
	}
	
	/*
	 * Closes the flow selector and reactivates this component
	 */
	public function closeFlowSel():Void{
		
		//minimize detail pane
		this["tp"].closeBlind();
		
		//close the selector and reactivate the component
		this.activity["selectFlows"].removeMovieClip();
		this.setActive(true);
		this.activity.activateBtns(true);
		
		//if not all flows added then show message
		if (!allFlowsAdded()){
			var msg:UserMessage = Utils.newObject(UserMessage, this.activity, "msg", this.activity.msgDepth, {_x:280, txt:StepByStepApp.getMsg("defineSystem.excercise.addRestOfFlows"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), w:400});
			msg._y = (550-msg._height)/2;
		}
	}
		
	/*
	 * Adds a flow, if all flow have been added then the next step is requested
	 * 
	 * @param the index of the flow to add if no index is given all flows are added and the selector closed
	 */
	public function addFlow(ind:Number):Void {
		
		//if ind is undefined add all components and goto next step of parent ativity
		if(isNaN(ind)){
			addAllFlows();
			closeFlowSel();
			this.activity.nextStep();
			return;
		}
		
		//show flow
		this["mcFlows"]["mcFlow_"+this.flows[ind].getId()]._visible = true;
		
		//select flow
		this.flows[ind].setIsSel(true);
		
		//if all components have been added then goto next step of parent activity
		if (allFlowsAdded()) {
			closeFlowSel();
			this.activity.nextStep();
		}
	}
	
	/*
	 * Adds all flows to system
	 */
	private function addAllFlows() :Void{
		
		for (var i = 0; i<this.flows.length; i++) {
			this["mcFlows"]["mcFlow_"+this.flows[i].getId()]._visible = true;
			this.flows[i].setIsSel(true);
		}
	}
	
	/*
	 * Checks to see if all the flows have been added to the system
	 *
	 * @return true if all flows have been added. False otherwise
	 */
	private function allFlowsAdded():Boolean {
		
		var cnt:Number = 0;
		var found:Boolean = true;
		while (cnt<this.flows.length && found) {
			if (!flows[cnt].getIsSel()) {
				found = false;
			}
			cnt++;
		}
		return found;
	}
	
	/*
	 * Activates and disactivates the component
	 * 
	 * @param active a boolean value, true activates the component
	 */
	public function setActive(active:Boolean):Void{
		if(!active){
			this.onRollOver = function(){};
			this.useHandCursor = false;
		}else{
			delete this.onRollOver;
			this.useHandCursor = true;
		}
		this.active = active;
	}

}