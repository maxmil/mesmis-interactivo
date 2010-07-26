import core.util.Proxy;

import ascb.util.logging.Logger;

/*
 * Message container
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 11-07-2005
 */
 class core.lang.Messages {

	//logger
	public static var logger:Logger = Logger.getLogger("core.lang.Messages");
	
	//internal xml object
	private var _xmlPath:String;
	private var _xml:XML;
	
	//functions
	private var onComplete:Function;
 
	/*
	 * Constructor
	 */
	public function Messages(onComplete:Function){

		this.onComplete = onComplete;

		//initialize xml
		_xml = new XML ();
		_xml.ignoreWhite = true;
		_xml.onLoad = Proxy.create(this, init);
	}
	
	/*
	 * Initializes the loading of messages
	 */
	public function load(xmlPath:String){
		_xmlPath = xmlPath;
		_xml.load(xmlPath);
	}
	
	/*
	 * Triggered when xml file has loaded. Parses xml file into messages
	 */
	private function init(success:Boolean){
		
		if(!success){
			logger.debug("Messages: XML Load Error ("+_xmlPath+") - Not able to load xml from file: " + _xmlPath)
			return;
		}

		var node:XMLNode;
		
		for (var i = 0; i < _xml.childNodes.length; i ++){
			
			//get node
			node = _xml.childNodes [i];
			//save nama and value
			this[node.attributes.key] = node.firstChild.nodeValue;
			//logger.debug(node.attributes.key + "="+node.firstChild.nodeValue)
		}
		
		onComplete();
		
	}
}