/*
 * Container for Intro text formats
 * 
 * @author Max pimm
 * @created 12-10-2005
 * @version 1.0
 */
 class intro.utils.IntroTxtFormats {
	 
	public var smallTxtFormat:TextFormat;
	public var defaultTxtFormat:TextFormat;
	public var defaultTitleTxtFormat:TextFormat;
	public var titleTxtFormat:TextFormat;
	public var btnTxtFormat:TextFormat;
	public var softTitleTxtFormat:TextFormat;
	public var highlightTxtFormat:TextFormat;
	

	function IntroTxtFormats(){
	
		//init small text format
		smallTxtFormat = new TextFormat ();
		smallTxtFormat.size = 10;
		smallTxtFormat.font = "Arial";
		smallTxtFormat.color = 0x996633;
		smallTxtFormat.bold = false;

		//init default text format
		defaultTxtFormat = new TextFormat();
		defaultTxtFormat.size = 13;
		defaultTxtFormat.font = "Arial";
		defaultTxtFormat.color = 0x996633;
		
		//init default title text format
		defaultTitleTxtFormat = new TextFormat();
		defaultTitleTxtFormat.size = 18;
		defaultTitleTxtFormat.font = "Arial";
		defaultTitleTxtFormat.color = 0x996633;

		//init title text format
		titleTxtFormat = new TextFormat();
		titleTxtFormat.size = 22;
		titleTxtFormat.font = "Arial";
		titleTxtFormat.color = 0x996633;
		
		//init button txt format
		btnTxtFormat = new TextFormat();
		btnTxtFormat.font = "Arial bold";
		btnTxtFormat.size = 18;
		btnTxtFormat.align = "center";
		
		//init soft title text format
		softTitleTxtFormat = new TextFormat();
		softTitleTxtFormat.size = 18;
		softTitleTxtFormat.font = "Arial bold";
		softTitleTxtFormat.bold = true;
		softTitleTxtFormat.color = 0xcccccc;
		softTitleTxtFormat.align = "right";
		
		//init highlight text format
		highlightTxtFormat = new TextFormat();
		highlightTxtFormat.size = 14;
		highlightTxtFormat.font = "Arial";
		highlightTxtFormat.color = 0x009191;
	}
}