import core.comp.TextPane;
import core.util.Proxy;
import core.util.Utils;

/*
 * Opens a component within a text pane
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class core.comp.ComponentWindow extends core.util.GenericMovieClip {
	 
	//dimensions of the text pane
	var w:Number;
	var h:Number;
	
	//the title text and its format
	var titleTxt:String = "";
	var titleTxtFormat:TextFormat;
	
	//boolean flag that when true activates a scroll for the content pane
	var doScroll:Boolean = true;
	
	//boolean flag that when true draws the maximize/minimize button
	var btnMinMax:Boolean = true;
	
	//boolean flag that when true draws the close button
	var btnClose:Boolean = false;
	
	//boolean flag that when true allows vertical resizing
	var resize:Boolean = true;
	
	//boolean flag that when true allows the text pane to be dragged
	var allowDrag:Boolean = true;
	
	//boolean flag that when true animates the opening of the window
	var animate:Boolean = false;
	
	//background transparency and color
	var bgColor:Number = 0xE6E3C6;
	var bgAlpha:Number = 100;
	
	//constructor and initial propertives for internal component
	private var compClass:Function;
	private var compProps:Object;
	
	//reference to internal component
	public var comp:Object;
	
	//necessary for listener and event dispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;

	/*
	 * Constructor
	 */
	public function ComponentWindow(){
		
		//init event dispatcher
		mx.events.EventDispatcher.initialize(this);
		
		//create text pane
		var tp = Utils.newObject(TextPane, this, "tp", 1, {w:w, h:h, titleTxt:titleTxt, titleTxtFormat:titleTxtFormat, doScroll:doScroll, btnMinMax:btnMinMax, btnClose:btnClose, resize:resize, btnMinMax:btnMinMax, allowDrag:allowDrag, bgColor:bgColor, bgAlpha:bgAlpha});
		
		//create close listener for textpane
		var clsLstnr = new Object();
		clsLstnr.closed = Proxy.create(this, closeWindow);
		tp.addEventListener("closed", clsLstnr);
		
		//create component in text pane
		comp = Utils.newObject(compClass, tp.getContent(), "comp", 1, compProps);
		
		//initialize text pane
		tp.init(this.animate);
	}
	
	/*
	 * Closes component and text pane
	 */
	public function closeWindow():Void{
		dispatchEvent({type: "closed", target: this});
		this.removeMovieClip();
	}
	
	/*
	 * Opens the text pane blind
	 */
	public function reopen(){
		this["tp"].openBlind();
	}
	
	
	/*
	 * Returns the relative x positon of the content pane to the
	 * overall text pane object
	 */
	public function getContentX():Number{
		return this["tp"].getContentX();
	}
	
	
	/*
	 * Returns the relative y positon of the content pane to the
	 * overall text pane object
	 */
	public function getContentY():Number{
		return this["tp"].getContentY();
	}
}