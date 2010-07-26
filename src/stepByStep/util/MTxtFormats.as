/*
 * Container for mesmis text formats
 * 
 * @author Max pimm
 * @created 09-09-2005
 * @version 1.0
 */
 class stepByStep.util.MTxtFormats {
	
	public var smallTxtFormat:TextFormat;
	public var altSmallTxtFormat:TextFormat;
	public var defaultTxtFormat:TextFormat;
	public var defaultMsgTxtFormat:TextFormat;
	public var defaultTitleTxtFormat:TextFormat;
	public var altTxtFormat:TextFormat;
	public var bigTitleTxtFormat:TextFormat;
	public var bigTxtFormat:TextFormat;
	public var warningTxtFormat:TextFormat;
	public var softTitleTxtFormat:TextFormat;

	function MTxtFormats(){
		
		//init small text format
		smallTxtFormat = new TextFormat ();
		smallTxtFormat.size = 10;
		smallTxtFormat.font = "Arial";
		smallTxtFormat.color = 0x996633;
		smallTxtFormat.bold = false;
		
		//init alt small text format
		altSmallTxtFormat = new TextFormat ();
		altSmallTxtFormat.size = 10;
		altSmallTxtFormat.font = "Arial";
		altSmallTxtFormat.color = 0x006600;
		altSmallTxtFormat.bold = false;
		altSmallTxtFormat.align = "center";
		
		//init default text format
		defaultTxtFormat = new TextFormat ();
		defaultTxtFormat.size = 14;
		defaultTxtFormat.font = "Arial";
		defaultTxtFormat.color = 0x996633;
		
		//init default msg text format
		defaultMsgTxtFormat = new TextFormat ()
		defaultMsgTxtFormat.size = 14;
		defaultMsgTxtFormat.font = "Arial";
		defaultMsgTxtFormat.color = 0x996633;
		
		//init alt text format
		altTxtFormat = new TextFormat();
		altTxtFormat.size = 14;
		altTxtFormat.font = "Arial";
		altTxtFormat.color = 0x006600;
		
		//init title text format
		defaultTitleTxtFormat = new TextFormat ()
		defaultTitleTxtFormat.size = 18;
		defaultTitleTxtFormat.font = "Arial";
		defaultTitleTxtFormat.color = 0x996633;
		
		//init big title txt format
		bigTitleTxtFormat = new TextFormat ()
		bigTitleTxtFormat.size = 22;
		bigTitleTxtFormat.font = "Arial Bold";
		bigTitleTxtFormat.color = 0x006600;
		bigTitleTxtFormat.bold = true;
		
		//init big text format
		bigTxtFormat = new TextFormat ()
		bigTxtFormat.size = 16;
		bigTxtFormat.font = "Arial";
		bigTxtFormat.color = 0x996633;
		
		//init warning text format
		warningTxtFormat = new TextFormat ()
		warningTxtFormat.size = 12;
		warningTxtFormat.font = "Arial";
		warningTxtFormat.bold = true;
		warningTxtFormat.color = 0xff6600;
		warningTxtFormat.align = "center";
		
		//init soft title text format
		softTitleTxtFormat = new TextFormat();
		softTitleTxtFormat.size = 18;
		softTitleTxtFormat.font = "Arial bold";
		softTitleTxtFormat.bold = true;
		softTitleTxtFormat.color = 0x666666;
		softTitleTxtFormat.align = "right";
	}
}