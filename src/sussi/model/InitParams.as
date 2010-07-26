import ascb.util.logging.Logger;
import sussi.model.InitParam;
/*
 * Inicial parameters for Sussi
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.model.InitParams {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.InitParams");
	
	//functions
	private var onComplete:Function;
	 
	//xml object used to load parameters
	private var _xml:XML;
	
	/*
	 * Constructor
	 */
	public function InitParams(onComplete:Function){
		
		this.onComplete = onComplete;
		
		//init xml
		_xml= new XML ();
		_xml.ignoreWhite = true;
		_xml.onLoad = core.util.Proxy.create(this, initialize);
	}
	
	/*
	 * Triggers loading of init params
	 * 
	 * @param path the path of the xml file that contains the params,
	 * relative to the path of the executing swf
	 */
	public function load(path:String):Void{
		_xml.load(path);
	}
	
	/*
	 * Triggered when xml file has loaded. Parses xml file into init params
	 */
	private function initialize(){
		
		var ipNode:XMLNode;
		var ip:InitParam;
		var strVal:String;
		
		for (var i = 0; i < _xml.childNodes.length; i ++){
			var j = 0;
			ipNode = _xml.childNodes [i];
			//create new init param
			ip = new InitParam ();
			ip.setId(ipNode.attributes.id);
			ip.setLiteral(ipNode.childNodes[j++].firstChild.nodeValue);
			ip.setDesc(ipNode.childNodes[j++].firstChild.nodeValue);
			ip.setPrecision(Number(ipNode.childNodes[j++].firstChild.nodeValue));
			strVal = ipNode.childNodes[j++].firstChild.nodeValue;
			ip.setVal(strVal);
			ip.setMinVal(Number(ipNode.childNodes[j++].firstChild.nodeValue));
			ip.setMaxVal(Number(ipNode.childNodes[j++].firstChild.nodeValue));

			//add to init params
			this[ip.getId()] = ip;
			//logger.debug(this[ip.getId()].getLiteral() + ":" + this[ip.getId()].getVal().toString());
			//logger.debug("		ips.setInitParam(\""+ip.getId()+"\", new InitParam(\""+ip.getId()+"\", \""+ip.getLiteral()+"\", \""+ip.getDesc()+"\", "+ip.getPrecision()+", \""+strVal+"\", "+ip.getMinVal()+", "+ip.getMaxVal()+" ));");
		}
		
		onComplete();
	}
	
	/*
	 * Sets an init param object
	 * 
	 * @param id the id of the init param to set
	 * @param initParam the new init param
	 */
	public function setInitParam(id:String, initParam:InitParam):Void{
		this[id] = initParam;
	}
	
	/*
	 * Gets the value of an init param
	 * 
	 * @param id the id of the init param to retreive
	 * @return the value of the init param
	 * 
	 * NOTE:return type can be nuber or array. DO NOT define as Object otherwise MMC fails
	 */
	public function getInitParamVal(id:String){
		return this[id].getVal();
	}

	
	/*
	 * Sets the value of an init param
	 * 
	 * @param id the id of the init param to retreive
	 * @param val the new of the init param
	 * @param i the index of the array to set if the parameter is an array. If the parameter
	 * is not an array this should be undefined 
	 * 
	 */
	public function setInitParamVal(id:String, val:Number, i:Number):Void{
		if(i!=undefined){
			getInitParamVal(id)[i] = val
		}else{
			this[id].setVal(String(val));
		}
		
	}
}