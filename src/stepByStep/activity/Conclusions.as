import ascb.util.logging.Logger;
import core.util.GenericMovieClip;
import core.util.Utils;
import core.comp.UserMessage;
import stepByStep.StepByStepApp;

/*
 * Step 6: Conclusions and Recomendations
 * 
 * @autor Max Pimm
 * @created 14-12-2005
 * @version 1.0
 */
class stepByStep.activity.Conclusions extends stepByStep.activity.StepByStepActivity{
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.activity.Conclusions");

	/*
	 * Constructor
	 */
	public function Conclusions() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating Conclusions");
		
		//get first step
		getStep(1);
	}
	
	/*
	 * Step dependent initializations. Overriddes method in super class
	 * 
	 * @param step the number of the step to initialize
	 */
	public function doStepDependencies(step:Number):Number{
		
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
		Utils.createTextField("title", titleCont, 1, 0, 0, 900, 10, StepByStepApp.getMsg("conclusions.intro.title"), bigTitleTxtFormat);
		titleCont._x = 960;
		titleCont._y = 20;
		titleCont.glideTo(20, 20, 10);
		
		//add graphic
		var img:GenericMovieClip = GenericMovieClip(cont.attachMovie("slides_conclusions", "img", cont.getNextHighestDepth(), {_x:50, _y:80, _alpha:100}));
		var img2:GenericMovieClip = GenericMovieClip(cont.attachMovie("conclusions_step_menu", "img2", cont.getNextHighestDepth(), {_x:50, _y:200, _alpha:100}));
		
		//add story
		var msg:UserMessage = Utils.newObject(UserMessage, cont, "story", cont.getNextHighestDepth(), {_x:500, w:400, txt:StepByStepApp.getMsg("conclusions.intro.text"), txtFormat:StepByStepApp.getTxtFormat("defaultMsgTxtFormat"), allowDrag:false, btnClose:false});
		msg._y = (550-msg._height)/2;
		tweenIn(msg);
		
		//create goto first step button
		var fnc:Function = function(){
			this.app.getNav().getActivity("defineSystem");
		}
		createBtn("btn_gotoStep1", StepByStepApp.getMsg("btn.gotoStep1"), this, fnc);
						
		//create goto principal menu button
		createBtnGotoMenuPrin();
	}
}
