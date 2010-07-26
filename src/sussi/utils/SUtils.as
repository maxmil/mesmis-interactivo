import ascb.util.logging.Logger;
import sussi.SussiApp;
import sussi.model.InitParam;

import sussi.process.*
/*
 * Static utility functions for Sussi
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.utils.SUtils {
	 
	//logger
	private static var logger:Logger = Logger.getLogger("sussi.utils.SUtils");
	
	/*
	 * Prevent instantiation
	 */
	private function SUtils(){
	}
	
	/*
	 * Clears outputs of all processes
	 */
	public static function clearOutputs():Void{
		Bh1.getProcess().clearOutput();
		Bh2.getProcess().clearOutput();
		Bc.getProcess().clearOutput();
		Dh1.getProcess().clearOutput();
		Dh2.getProcess().clearOutput();
		Dc.getProcess().clearOutput();
		Ph1.getProcess().clearOutput();
		Ph2.getProcess().clearOutput();
		Pc.getProcess().clearOutput();
	}
	
	/*
	 * Gets an init param object
	 * 
	 * @param id the id of the parameter to retreive
	 * @return the init param
	 */
	public static function getIPObj(id:String):InitParam{
		return SussiApp.getInitParamCol().getSelInitParams()[id];
	}
	
	/*
	 * Sets an init param object
	 * 
	 * @param id the id of the parameter to set
	 * @param the new init param object
	 */
	public static function setIPObj(id:String, ip:InitParam):Void{
		SussiApp.getInitParamCol().getSelInitParams()[id] = ip;
	}
	
	/*
	 * Gets the value of a numeric init param
	 * 
	 * @param id the id of the parameter to retreive
	 * @param i the index of the array to retreive if the parameter is an array. If the parameter
	 * is not an array this should be null or undefined 
	 * @return the value of the init param converted to a number
	 */
	public static function getIP(id:String, i:Number):Number{
		//define return variable
		var ret:Number;
		
		if (i==undefined || i==null){
			ret = Number(SussiApp.getInitParamCol().getSelInitParams().getInitParamVal(id));
		}else{
			ret = Number(SussiApp.getInitParamCol().getSelInitParams().getInitParamVal(id)[i]);
		}

		//logger.debug("getIP: id="+id+", i="+i+" ret="+ret.toString());
		return ret;
	}
	
	/*
	 * Sets the value of a numeric init param
	 * 
	 * @param id the id of the parameter to retreive
	 * @param val the new value of the parameter
	 * @param i the index of the array to set if the parameter is an array. If the parameter
	 * is not an array this should be null or undefined 
	 */
	public static function setIP(id:String, val:Number, i:Number):Void{
		SussiApp.getInitParamCol().getSelInitParams().setInitParamVal(id, val, i);
	}
	
	/*
	 * Gets the array value of an init param (init param must be defined as an array)
	 * 
	 * @param id the id of the parameter to retreive
	 * @return the array value of the init param
	 */
	public static function getIPArray(id:String):Array{
		return SussiApp.getInitParamCol().getSelInitParams().getInitParamVal(id);
	}
	

}