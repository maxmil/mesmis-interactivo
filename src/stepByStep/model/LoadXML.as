import ascb.util.logging.Logger;
import core.util.Utils;
import stepByStep.StepByStepApp;
import stepByStep.model.valueObject.Indicator;
import stepByStep.model.valueObject.Comp;
import stepByStep.model.valueObject.CriticalPoint;
import stepByStep.model.valueObject.DiagnosticCriteria;
import stepByStep.model.valueObject.Flow;
import stepByStep.model.valueObject.Subsystem;

/*
 * Loads all xml data for components, flows, subsystems, indicators, critical points, diagnostic criteria
 * 
 * @author Max Pimm
 */
class stepByStep.model.LoadXML{
	
	//logger
	private static var logger:Logger = Logger.getLogger("stepByStep.model.LoadXML");
	
	//xml objects
	private var xmlSubsys:XML;
	private var xmlComponents:XML;
	private var xmlFlows:XML;
	private var xmlCriticalPoints:XML;
	private var xmlDiagnosticCriteria:XML;
	private var xmlIndicators:XML;
	
	//list of the xml's that have already been parsed
	private var parsed:Array;
	
	//listener variables
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	
	/*
	 * Constructor
	 */
	public function LoadXML(){
		
		//init event dispatcher
		mx.events.EventDispatcher.initialize(this);
		
		//init xmls
		xmlSubsys = new XML();
		xmlSubsys.ignoreWhite = true;
		xmlSubsys["loadXML"] = this;
		xmlComponents = new XML();
		xmlComponents.ignoreWhite = true;
		xmlComponents["loadXML"] = this;
		xmlFlows = new XML();
		xmlFlows.ignoreWhite = true;
		xmlFlows["loadXML"] = this;
		xmlCriticalPoints = new XML();
		xmlCriticalPoints.ignoreWhite = true;
		xmlCriticalPoints["loadXML"] = this;
		xmlDiagnosticCriteria = new XML();
		xmlDiagnosticCriteria.ignoreWhite = true;
		xmlDiagnosticCriteria["loadXML"] = this;
		xmlIndicators = new XML();
		xmlIndicators.ignoreWhite = true;
		xmlIndicators["loadXML"] = this;
		
		//init parsed
		parsed = new Array();
		
		//define on load function for subsystems
		xmlSubsys.onLoad = function(){
			
			//xml node objects
			var subsysNode:XMLNode;
			
			//action script objects
			var subsys:Subsystem;
			
			//wipe array
			StepByStepApp.getApp().subsystems.splice(0);
			
			//get subsystems
			for(var i = 0; i < this.childNodes.length; i++){
				
				var j = 0;
				subsysNode = this.childNodes[i];
				
				//create new comp
				subsys = new Subsystem();
				subsys.setId(subsysNode.childNodes[j++].firstChild.nodeValue);
				subsys.setLiteral(subsysNode.childNodes[j++].firstChild.nodeValue);
				subsys.setDescription(subsysNode.childNodes[j++].firstChild.nodeValue);
				subsys.setImg(subsysNode.childNodes[j++].firstChild.nodeValue);
				
				//add to array
				StepByStepApp.getApp().subsystems[i] = subsys;
			}
			this["loadXML"].xmlParsed("subsystems");
		};
		
		//define on load function for components
		xmlComponents.onLoad = function(){
			
			//xml node objects
			var compNode:XMLNode;
			
			//action script objects
			var comp:Comp;
			var initObj:Object;
			
			//wipe array
			StepByStepApp.getApp().comps.splice(0);
			
			//get components
			for(var i = 0; i < this.childNodes.length; i++){
				
				var j = 0;
				compNode = this.childNodes[i];
				
				//create new comp
				comp = new Comp();
				comp.setId(compNode.childNodes[j++].firstChild.nodeValue);
				comp.setLiteral(compNode.childNodes[j++].firstChild.nodeValue);
				comp.setSubsystem(compNode.childNodes[j++].firstChild.nodeValue);
				comp.setDescription(compNode.childNodes[j++].firstChild.nodeValue);
				comp.setImg(compNode.childNodes[j++].firstChild.nodeValue);
				
				//add to array
				StepByStepApp.getApp().comps[i] = comp;
			}
			this["loadXML"].xmlParsed("comps");
		};
		
		//define on load function for flows
		xmlFlows.onLoad = function(){
			
			//xml node objects
			var flowNode:XMLNode;
			
			//action script objects
			var flow:Flow;
			
			//wipe array
			StepByStepApp.getApp().flows.splice(0);
			
			//get flows
			for(var i = 0; i < this.childNodes.length; i++){
				
				var j = 0;
				flowNode = this.childNodes[i];
				
				//create new flow
				flow = new Flow();
				flow.setId(Number(flowNode.childNodes[j++].firstChild.nodeValue));
				flow.setLiteral(flowNode.childNodes[j++].firstChild.nodeValue);
				flow.setDescription(flowNode.childNodes[j++].firstChild.nodeValue);
				flow.setSubsysExit(Number(flowNode.childNodes[j++].firstChild.nodeValue));
				flow.setSubsysEntry(Number(flowNode.childNodes[j++].firstChild.nodeValue));
				flow.setImg(flowNode.childNodes[j++].firstChild.nodeValue);
				
				//add new flow to array
				StepByStepApp.getApp().flows[i] = flow;
			}
			this["loadXML"].xmlParsed("flows");
		};
		
		//define on load function for critical points
		xmlCriticalPoints.onLoad = function(){
			
			//xml node objects
			var cpNode:XMLNode;
			
			//action script objects
			var cp;
			
			//wipe array
			StepByStepApp.getApp().cps.splice(0);
			
			//get critical points
			for(var i = 0; i < this.childNodes.length; i++){
				
				var j = 0;
				cpNode = this.childNodes[i];
				
				//create new cp
				cp = new CriticalPoint();
				cp.setId(cpNode.childNodes[j++].firstChild.nodeValue);
				cp.setLiteral(cpNode.childNodes[j++].firstChild.nodeValue);
				cp.setShortTitle(cpNode.childNodes[j++].firstChild.nodeValue);
				cp.setDescription(cpNode.childNodes[j++].firstChild.nodeValue);
				cp.setImg(cpNode.childNodes[j++].firstChild.nodeValue);
				cp.setType(cpNode.childNodes[j++].firstChild.nodeValue);
				
				//add new cp to array
				StepByStepApp.getApp().cps[i] = cp;
			}
			this["loadXML"].xmlParsed("cps");
		};
		
		//define on load function for diagnostic criteria
		xmlDiagnosticCriteria.onLoad = function(){
			
			//xml node objects
			var dcNode:XMLNode;
			
			//action script objects
			var dc;
						
			//wipe array
			StepByStepApp.getApp().criterias.splice(0);
			
			//get diagnostic criteria
			for(var i = 0; i<this.childNodes.length; i++){
				
				var j = 0;
				dcNode = this.childNodes[i];
				
				//create new cp
				dc = new DiagnosticCriteria();
				dc.setId(dcNode.childNodes[j++].firstChild.nodeValue);
				dc.setLiteral(dcNode.childNodes[j++].firstChild.nodeValue);
				dc.setDescription(dcNode.childNodes[j++].firstChild.nodeValue);
				dc.setImg(dcNode.childNodes[j++].firstChild.nodeValue);
				
				//add new dc to array
				StepByStepApp.getApp().criterias[i] = dc;
			}
			this["loadXML"].xmlParsed("criterias");
		};
		
		//define on load function for indicators
		xmlIndicators.onLoad = function(){
			
			//xml node objects
			var indicadorNode:XMLNode;
			
			//action script objects
			var indicator:Indicator;
								
			//wipe array
			StepByStepApp.getApp().indicators.splice(0);
			
			//get indicadores
			for(var i = 0; i < this.childNodes.length; i++){
				
				var j = 0;
				indicadorNode = this.childNodes[i];
				
				//create new indicator
				indicator = new Indicator();
				indicator.setId(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setType(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setLiteral(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setDescription(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setAtrib(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setUnits(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setObjective(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setTradSystem(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setComSystem(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setAreaEval(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setMeasureMethod(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setMeasureDesc(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setMin(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setMax(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setMaxLimit(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setTradSystemCalc(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setComSystemCalc(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setIsSel(new Boolean(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setIsOptimize(new Boolean(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setOptimizeDesc(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setTradeOffQuotient(Number(indicadorNode.childNodes[j++].firstChild.nodeValue));
				indicator.setImg(indicadorNode.childNodes[j++].firstChild.nodeValue);
				indicator.setGraphic(indicadorNode.childNodes[j++].firstChild.nodeValue);
				
				//add new indicator to array
				StepByStepApp.getApp().indicators[i] = indicator;
			}
			this["loadXML"].xmlParsed("indicators");
		};
	}
	
	/*
	 * Load the xmls
	 */
	public function load():Void{
		xmlSubsys.load("stepByStep/xml/subsystems_" + StepByStepApp.getLocale() + ".xml");
		xmlComponents.load("stepByStep/xml/components_" + StepByStepApp.getLocale() + ".xml");
		xmlFlows.load("stepByStep/xml/flows_" + StepByStepApp.getLocale() + ".xml");
		xmlIndicators.load("stepByStep/xml/indicators_" + StepByStepApp.getLocale() + ".xml");
		xmlCriticalPoints.load("stepByStep/xml/criticalPoints_" + StepByStepApp.getLocale() + ".xml");
		xmlDiagnosticCriteria.load("stepByStep/xml/diagnosticCriteria_" + StepByStepApp.getLocale() + ".xml");
	}
	
	/*
	 * Called by each xml when finished parsing. When all xml's have registered with
	 * this method the loaded event is dispatched
	 */
	public function xmlParsed(id):Void{
		
		logger.debug("Parsed XML: " + id);
		
		//if not already in the array of parsed ids add the id
		if( ! Utils.arrayContains(parsed, id)){
			parsed[parsed.length] = id;
		}
		
		//if all have been parsed then copy data to application and dispatch event
		if(parsed.length == 6){
			logger.debug("Finished parsing XML");			
			dispatchEvent({type:"loaded", target:this});
		}
	}


	/*
	function testXMLParse()
	{
	for(i = 0; i < subsystems.length; i++)
	{
	var subsys = subsystems[i];
	trace("id = " + subsys.getId());
	trace("literal = " + subsys.getLiteral());
	trace("description = " + subsys.getDescription());
	trace("img = " + subsys.getImg());
	trace("");
	}
	for(i = 0; i < comps.length; i++)
	{
	var comp = comps[i];
	trace("id = " + comp.getId());
	trace("literal = " + comp.getLiteral());
	trace("description = " + comp.getDescription());
	trace("subsystem = " + comp.getSubsystem());
	trace("img = " + comp.getImg());
	trace("");
	}
	for(i = 0; i < flows.length; i++)
	{
	var flow = flows[i];
	trace("id = " + flow.getId());
	trace("literal = " + flow.getLiteral());
	trace("description = " + flow.getDescription());
	trace("subsysEntry = " + flow.getSubsysEntry());
	trace("subsysExit = " + flow.getSubsysExit());
	trace("img = " + flow.getImg());
	trace("");
	}
	for(i = 0; i < cps.length; i++)
	{
	var cp = cps[i];
	trace("id = " + cp.getId());
	trace("literal = " + cp.getLiteral());
	trace("description = " + cp.getDescription());
	trace("img = " + cp.getImg());
	trace("type = " + cp.getType());
	trace("");
	}
	for(i = 0; i < indicators.length; i++)
	{
	var indicator = indicators[i];
	trace("id = " + indicator.getId());
	trace("type = " + indicator.getType());
	trace("literal = " + indicator.getLiteral());
	trace("description = " + indicator.getDescription());
	trace("units = " + indicator.getUnits());
	trace("objective = " + indicator.getObjective());
	trace("trad system = " + indicator.getTradSystem());
	trace("com system = " + indicator.getComSystem());
	trace("area eval = " + indicator.getAreaEval());
	trace("measure method = " + indicator.getMeasureMethod());
	trace("min = " + indicator.getMin());
	trace("max = " + indicator.getMax());
	trace("maxLimit = " + indicator.getMaxLimit());
	trace("isSel = " + indicator.getIsSel());
	trace("isOptimize = " + indicator.getIsOptimize());
	trace("tradeOffQuotient = " + indicator.getTradeOffQuotient());
	trace("img = " + indicator.getImg());
	trace("graphic = " + indicator.getGraphic());
	trace("");
	}
	for(var i = 0; i < criterias.length; i++)
	{
	var criteria = criterias[i];
	trace("id = " + criteria.getId());
	trace("literal = " + criteria.getLiteral());
	trace("description = " + criteria.getDescription());
	trace("img = " + criteria.getImg());
	trace("");
	}
	}
	*/
}
