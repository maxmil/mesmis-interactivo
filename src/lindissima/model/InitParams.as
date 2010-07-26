import ascb.util.logging.Logger;
import lindissima.model.InitParam;
/*
 * Inicial parameters for lindissima
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 27-06-2005
 */
 class lindissima.model.InitParams {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.InitParams");
	
	//functions
	private var onComplete:Function;
	 
	//xml object used to load parameters
	private var _xml:XML;
	 
	//variables linked to the corn genus type
	private var fnM_A:InitParam;
	private var fnM_B:InitParam;
	private var fnM_TRA:InitParam;
	private var fnM_TRC:InitParam;
	private var fnM_C:InitParam;
	private var indCosecha:InitParam;
	private var biomasaIniM:InitParam;
	private var efiCapM:InitParam;
	private var maxConcNitM:InitParam;
	
	//variables linked to the management of corn
	private var densM:InitParam;
	private var nAnual:InitParam;

	//variables linked to the shrub genus type
	private var fnA_A:InitParam;
	private var fnA_B:InitParam;
	private var fnA_TRA:InitParam;
	private var fnA_TRC:InitParam;
	private var fnA_C:InitParam;
	private var fnA_fnMin:InitParam;
	private var biomasaIniA:InitParam;
	private var efiCapA:InitParam;
	private var maxConcNitA:InitParam;
	private var indPersCob:InitParam;
	private var acPotSurFertil:InitParam;
	private var indRecRaices:InitParam;
	
	//variables linked to the management of shrubs
	private var densA:InitParam;
	private var podasTallo:InitParam;
	private var podasRaiz:InitParam;
	
	//variables linked to the condition of the soil
	private var nInicial:InitParam;
	private var propNLixSem:InitParam;
	private var indProtCob:InitParam;
	private var limN100Sat:InitParam;
	private var limN0Sat:InitParam;
	
	//variables linked to the condition of the lake
	private var algasIniBaja:InitParam;
	private var algasIniAlta:InitParam;
	private var algasIniCustom:InitParam;
	private var probAlta:InitParam;
	private var fnva_c:InitParam;
	private var fnva_r:InitParam;
	private var fnva_ha:InitParam;
	private var fnva_P:InitParam;
	private var fnva_hv:InitParam;
	private var fnva_hn:InitParam;
	private var nCritAlta:InitParam;
	private var nCritBaja:InitParam;
	private var algasIni:InitParam;
	private var nLake:InitParam;
	private var nLakgoClaro:InitParam;
	private var nLakgoTurbio:InitParam;
	private var nLakgoBiestable:InitParam;
	private var umbTurb:InitParam;
	
	//variables linked to economy
	private var cstM:InitParam;
	private var ingAnRib:InitParam;
	private var cstUrea:InitParam;
	private var cstPodTallo:InitParam;
	private var cstPodRaiz:InitParam;
	private var sbsdPodTallo:InitParam;
	private var sbsdPodRaiz:InitParam;
	private var benNetReqM:InitParam;
	private var benNetReqR:InitParam;
	private var benNetOptM:InitParam;
	private var benNetOptR:InitParam;
	
	//variables linked to application properties
	private var csmSoluciones:InitParam;
	
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
		//logger.debug(id+ "  " + val + "  " +i)
		//logger.debug(id+ "  " + val + "  " +i)
		if(i!=undefined){
			getInitParamVal(id)[i] = val
		}else{
			this[id].setVal(String(val));
		}
		
	}
}