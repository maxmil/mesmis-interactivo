import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.UserMessage;
import core.comp.Scroll;
import core.comp.TextPane;
import core.comp.EyeBtn;
import stepByStep.StepByStepApp;
import mx.controls.ComboBox;

/*
 * Component Selector. UIComponent that opens in its own text pane and 
 * allows the selection of components
 * 
 * @author Max Pimm
 * @created 22-05-2005
 * @version 1.0
 */ 
class stepByStep.comp.SelectComponents extends core.util.GenericMovieClip{
	
	//logger
	private static var logger :Logger = Logger.getLogger ("stepByStep.comp.SelectComponents");
	
	//component array
	private var comps:Array;
	
	//subsistems array
	private var subsystems:Array;
	
	//array index of currently selected component
	private var currCompInd:Number;

	//function of callback object that is invoked and passed the index of the selected component when the selection is made
	private var addCompFnc:Function;
	
	//function called when close button is pressed
	private var closeFnc:Function;
	
	//user message currently being displayed
	private var usrMsg:UserMessage;
	
	/*
	 * Constructor
	 */
	public function SelectComponents(){
		
		logger.debug("instantiating SelectComponents");
		
		//create container text pane
		var tp:TextPane = Utils.newObject(TextPane, this, "tp", this.getNextHighestDepth(),{titleTxt:StepByStepApp.getMsg("selectComponents.title"), w:500, h:490, doScroll:false});
		var cont:MovieClip = tp.getContent();
		
		//create component text pane
		var scComp:Scroll = Utils.newObject(Scroll, cont, "scComp", cont.getNextHighestDepth(),{_x:20, _y:10, w:100, h:430});
		
		//add components to textpane
		initComponents();
		scComp.init();
		
		//add detail text pane
		initDetailPane();
		
		//add subsytem combo
		initSubsysCombo();
		
		//add butttons
		initBtns();
		
		//init container text pane
		tp.init(true);
		
		//create intro message
		usrMsg = Utils.newObject(UserMessage, tp, "msg", tp.getNextHighestDepth(),{txt:StepByStepApp.getMsg("selectComponents.intro"), _x:160, _y:130, w:300, txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat")});
	}
	
	/*
	 * Initialize the components
	 */
	private function initComponents():Void{

		//reset indice of selected component
		this.currCompInd = null;
		
		//radius of components
		var radius:Number = 30;
		
		//vertical space between components
		var vspace:Number = 10;
		
		//if container clip exists then remove
		var cont:MovieClip = this["tp"].getContent()["scComp"].getContentClip();
		if (cont["mcComps"]){
			cont["mcComps"].removeMovieClip();
		}
		
		//container clip
		var mcComps:MovieClip = cont.createEmptyMovieClip("mcComps", cont.getNextHighestDepth());
		mcComps.selectComponents = this;
		
		//loop through components drawing all those that are not selected
		for (var i = 0; i<comps.length; i++){
			if (!comps[i].getIsSel()){
				
				//create container clip
				var mcComp:MovieClip = mcComps.createEmptyMovieClip("mcComp_"+String(this.comps[i].getId()), mcComps.getNextHighestDepth());
				mcComp._x = 20+radius;
				mcComp._y = mcComps._height+radius+vspace;
				mcComp.ind = i;
				
				//create img clip
				if (this.comps[i].getImg() != null && this.comps[i].getImg().length>0){
					
					var img = mcComp.createEmptyMovieClip("img", mcComp.getNextHighestDepth());
					
					//create mask clip
					var mask = img.createEmptyMovieClip("mask", img.getNextHighestDepth());
					mask.beginFill(0x000000, 100);
					mask.drawCircle(0, 0, radius, 10);
					mask.endFill();
					img.setMask(mask);
					
					//create loader
					var loader = img.createClassObject(mx.controls.Loader, "loader", mcComp.getNextHighestDepth(),{_x:-1.5*radius, _y:-radius, _width:3*radius, _height:2*radius, _alpha:50});
					loader.load("stepByStep/img/components/"+this.comps[i].getImg());
					
					//add rollover functionality
					mcComp.onRollOver = function(){
						this.img.loader._alpha = 100;
					};
					mcComp.onRollOut = function(){
						this.img.loader._alpha = 50;
					};
				}
				
				//create outline clip
				var outline = mcComp.createEmptyMovieClip("outline", mcComp.getNextHighestDepth());
				outline.lineStyle(5, 0xCCFF99, 100);
				outline.drawCircle(0, 0, radius, 10);
				
				//on press show detail
				mcComp.onRelease = function(){
					this._parent.selectComponents.selComp(this.ind);
				};
			}
		}
	}
	
	/*
	 * Initialize the detail pane
	 */
	private function initDetailPane():Void{

		//get detail pane if exists and remove
		var tpDetail:TextPane = this["tp"].getContent()["tpDetail"];
		if (tpDetail){
			tpDetail.removeMovieClip();
		}
		
		//recreate detail pane with intro text
		tpDetail = Utils.newObject(TextPane, this["tp"].getContent(), "tpDetail", this["tp"].getContent().getNextHighestDepth(),{titleTxt:StepByStepApp.getMsg("selectComponents.detailpane.title"), _x:140, _y:10, w:340, h:330});
		tpDetail.init(false);
	}
	
	/*
	 * Initialize the subsystem combo box
	 */
	private function initSubsysCombo():Void{

		//container clip
		var subsysCont:MovieClip = this["tp"].getContent().createEmptyMovieClip("subsysCombo", this["tp"].getContent().getNextHighestDepth());
		
		//create text field
		Utils.createTextField("tf", subsysCont, subsysCont.getNextHighestDepth(), 140, 350, 340, 20, StepByStepApp.getMsg("selectComponents.selectSubsystem"), StepByStepApp.getTxtFormat("defaultMsgTxtFormat"));
		
		//create combo box
		var labelsArray = new Array();
		var dataArray = new Array();
		labelsArray[0] = StepByStepApp.getMsg("combo.select");
		dataArray[0] = 0;
		for (var i = 0; i<this.subsystems.length-1; i++){
			labelsArray[labelsArray.length] = this.subsystems[i].getLiteral();
			dataArray[dataArray.length] = this.subsystems[i].getId();
		}
		var cb:mx.controls.ComboBox = subsysCont.createClassObject(mx.controls.ComboBox, "cb", subsysCont.getNextHighestDepth(),{labels:labelsArray, data:dataArray, dropdownWidth:330, _x:140, _y:370, _width:330});
		cb.setStyle("fontFamily", "Arial");
		cb.setStyle("embedFonts", true);
		cb.rowCount = 5;
		
	}
	
	/*
	 * Initialize the buttons
	 */
	private function initBtns():Void{
		
		//create buttons
		var btn_close:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_close", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.close"), callBackObj:null, callBackFunc:this.closeFnc});
		var btn_add_all:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_add_all", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.addAll"), callBackObj:null, callBackFunc:this.addCompFnc});
		var btn_add:EyeBtn = Utils.newObject(EyeBtn, this["tp"].getContent(), "btn_add", this["tp"].getContent().getNextHighestDepth(),{_y:420, literal:StepByStepApp.getMsg("btn.add"), callBackObj:this, callBackFunc:addComponent});
		
		//position buttons
		btn_close._x = this["tp"]._width-btn_close._width-10;
		btn_add_all._x = btn_close._x-btn_add_all._width-10;
		btn_add._x = btn_add_all._x-btn_add._width-10;
		
	}
	
	/*
	 * Select a component
	 * 
	 * @param ind the index of the component to select
	 */
	public function selComp(ind:Number):Void{

		//remove user message if exists
		if (this.usrMsg){
			this.usrMsg.removeMovieClip();
		}
		
		//define content movieclip
		var cont:MovieClip = this["tp"].getContent();
		
		//update selected component index
		this.currCompInd = ind;
		
		//remove old detail pane
		cont["tpDetail"].removeMovieClip();
		
		//create new detail text pane
		var tpDetail:TextPane = Utils.newObject(TextPane, cont, "tpDetail", cont.getNextHighestDepth(),{titleTxt:this.comps[ind].getLiteral(), _x:140, _y:10, w:340, h:330});
		var contDetail = tpDetail.getContent();
		Utils.createTextField("tf", contDetail, contDetail.getNextHighestDepth(), 0, 0, 320, 250, this.comps[ind].getDescription(), StepByStepApp.getTxtFormat("defaultTxtFormat"));
		
		//create loader and load image
		var loader = contDetail.createClassObject(mx.controls.Loader, "loader", contDetail.getNextHighestDepth(),{_x:70, _y:contDetail["tf"]._height+10, _width:200, _height:133});
		loader.load("stepByStep/img/components/"+this.comps[ind].getImg());
		var listener:Object = new Object();
		listener.tp = this["tp"];
		listener.complete = function(eventObject){
			this.tpDetail.init(true);
		};
		loader.addEventListener("complete", listener);
		tpDetail.init(true);
	}
	
	/*
	 * Adds the selected component by calling the callback function
	 * on the callback object and passing it the selected components id.
	 * 
	 * First it validates that a component has been selected and that the 
	 * correct subsystem is defined
	 */
	public function addComponent():Void{

		//remove user message if exists
		if (this.usrMsg){
			this.usrMsg.removeMovieClip();
		}
		
		//check that component is selected
		if (this.currCompInd == null){
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(),{txt:StepByStepApp.getMsg("selectComponents.error.noCompSelected"), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding component:no component selected");
			return;
		}
		var subsysCombo:ComboBox = this["tp"].getContent().subsysCombo.cb;
		
		//check that subsistem is selected
		if (subsysCombo.value == 0){
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(),{txt:StepByStepApp.getMsg("selectComponents.error.noSubsysSelected", new Array(this.comps[this.currCompInd].getLiteral())), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding component:no subsystem selected");
			return;
		}
		
		//check that component belongs to subsistem
		if (subsysCombo.value != this.comps[this.currCompInd].getSubsystem()){
			var args = new Array(this.comps[this.currCompInd].getLiteral(), subsysCombo.text)
			this.usrMsg = Utils.newObject(UserMessage, this, "usrMsg", this.getNextHighestDepth(),{txt:StepByStepApp.getMsg("selectComponents.error.wrongSubsystem", args), _x:100, _y:200, w:300, txtFormat:StepByStepApp.getTxtFormat("warningTxtFormat")});
			logger.debug("adding component:component " + this.comps[this.currCompInd].getLiteral() + " does not belong to subsystem " + subsysCombo.text);
			return;
		}

		//invoke callback function and pass the selected component index
		this.addCompFnc(this.currCompInd);
		
		//reinitialize components
		this.initComponents();
		
		//re-initialize detail pane
		this.initDetailPane();
		
		//reset subsys combo box
		subsysCombo.selectedIndex = 0;
	}
}
