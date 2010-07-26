/*
 * Container for Sussi text formats
 * 
 * @author Max pimm
 * @created 14-09-2005
 * @version 1.0
 */
 class sussi.utils.STxtFormats {
	 
	public var smallTxtFormat:TextFormat;
	public var altSmallTxtFormat:TextFormat;;
	public var linkTxtFormat:TextFormat;
	public var defaultTxtFormat:TextFormat;
	public var labelTxtFormat:TextFormat;
	public var altTxtFormat:TextFormat;
	public var defaultMsgTxtFormat:TextFormat;
	public var defaultTitleTxtFormat:TextFormat;
	public var bigTitleTxtFormat:TextFormat;
	public var bigTxtFormat:TextFormat;
	public var bigAltTxtFormat:TextFormat;
	public var warningTxtFormat:TextFormat;
	public var stepTitleTxtFormat:TextFormat;
	public var graphBgTxtFormat:TextFormat;
	public var storyTxtFormat:TextFormat;
	public var softTitleTxtFormat:TextFormat;

	function STxtFormats(){
		
		//init small text format
		smallTxtFormat = new TextFormat ();
		smallTxtFormat.size = 10;
		smallTxtFormat.font = "Arial";
		smallTxtFormat.color = 0x996633;
		smallTxtFormat.bold = false;
		//init alternative small text format
		altSmallTxtFormat = new TextFormat()
		altSmallTxtFormat.size = 10;
		altSmallTxtFormat.font = "Arial";
		altSmallTxtFormat.color = 0x006600;
		altSmallTxtFormat.bold = false;
		//init link text format
		linkTxtFormat = new TextFormat();
		linkTxtFormat.size = 11;
		linkTxtFormat.font = "Arial";
		linkTxtFormat.color = 0x006600;
		linkTxtFormat.bold = false;
		linkTxtFormat.underline = true;
		//init default text format
		defaultTxtFormat = new TextFormat();
		defaultTxtFormat.size = 14;
		defaultTxtFormat.font = "Arial";
		defaultTxtFormat.color = 0x996633;
		//init label text format
		labelTxtFormat = new TextFormat();
		labelTxtFormat.size = 14;
		labelTxtFormat.align = "right";
		labelTxtFormat.font = "Arial";
		labelTxtFormat.color = 0x996633;
		//init alt text format
		altTxtFormat = new TextFormat();
		altTxtFormat.size = 14;
		altTxtFormat.font = "Arial";
		altTxtFormat.color = 0x006600;
		//init story text format
		storyTxtFormat = new TextFormat();
		storyTxtFormat.size = 14;
		storyTxtFormat.font = "Arial";
		storyTxtFormat.color = 0x996633;
		//init default msg text format
		defaultMsgTxtFormat = new TextFormat();
		defaultMsgTxtFormat.size = 14;
		defaultMsgTxtFormat.font = "Arial";
		defaultMsgTxtFormat.color = 0x996633;
		defaultMsgTxtFormat.bold = false;
		//init title text format
		defaultTitleTxtFormat = new TextFormat();
		defaultTitleTxtFormat.size = 18;
		defaultTitleTxtFormat.font = "Arial";
		defaultTitleTxtFormat.color = 0x996633;
		//init big title txt format
		bigTitleTxtFormat = new TextFormat();
		bigTitleTxtFormat.size = 20;
		bigTitleTxtFormat.font = "Arial";
		bigTitleTxtFormat.color = 0x006600;
		bigTitleTxtFormat.bold = true;
		//init big text format
		bigTxtFormat = new TextFormat();
		bigTxtFormat.size = 18;
		bigTxtFormat.font = "Arial";
		bigTxtFormat.color = 0x996633;
		//init big alternative text format
		bigAltTxtFormat = new TextFormat();
		bigAltTxtFormat.size = 18;
		bigAltTxtFormat.font = "Arial";
		bigAltTxtFormat.color = 0x006600;
		//init warning text format
		warningTxtFormat = new TextFormat();
		warningTxtFormat.size = 12;
		warningTxtFormat.font = "Arial";
		warningTxtFormat.bold = true;
		warningTxtFormat.color = 0xff6600;
		warningTxtFormat.align = "center";
		//init step title text format
		stepTitleTxtFormat = new TextFormat();
		stepTitleTxtFormat.size = 14;
		stepTitleTxtFormat.font = "Arial";
		stepTitleTxtFormat.bold = true;
		stepTitleTxtFormat.color = 0xDFFF85;
		//init graph bg text format
		graphBgTxtFormat = new TextFormat();
		graphBgTxtFormat.size = 12;
		graphBgTxtFormat.font = "Arial";
		graphBgTxtFormat.align = "center";
		//init soft title text format
		softTitleTxtFormat = new TextFormat();
		softTitleTxtFormat.size = 18;
		softTitleTxtFormat.font = "Arial bold";
		softTitleTxtFormat.bold = true;
		softTitleTxtFormat.color = 0x666666;
		softTitleTxtFormat.align = "right";
	}
}