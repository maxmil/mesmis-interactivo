/*
 * Constants for lindissima
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 27-06-2005
 */
 class lindissima.Const {
	 
	//proccess time intervals
	public static var PROC_INT_WEEK:Number = 1;
	public static var PROC_INT_YEAR:Number = 2;
	
	//process time limit in years
	public static var PROC_YEARS_LIMIT:Number = 5;
	
	//the index week when the corn is planted each year.
	//the x'th week of the year has index x-1
	public static var WEEK_BEGIN_CORN_CYCLE = 17;
	
	//the week when the corn is harvested each year
	//the x'th week of the year has index x-1
	public static var WEEK_END_CORN_CYCLE = 42;
	
	//the number of hectares that the corn farmer controls
	public static var HECTARES_CORN = 10;
	
	//weight of un sack of urea in kilograms
	public static var WEIGHT_UREA = 50
	
	//relation between weight of Urea and nitrogen that it contains
	public static var NIT_PER_UREA = 0.46;
	
	//low weed concentration
	public static var WEED_CONCENTRATION_LOW = 0;

	//high weed concentration
	public static var WEED_CONCENTRATION_HIGH = 1;

	//custom weed concentration
	public static var WEED_CONCENTRATION_CUSTOM = 2;
	
	//nitrogen in soil limits
	public static var LIMIT_ENTOXIFICATION = 20;
	public static var LIMIT_ERROSION = 0.2;
	
	//colors
	public static var DEFAULT_BORDER_COLOR = 0x996633;
	public static var ALT_BORDER_COLOR = 0x006600;
	public static var CLEAR_LAKE_COLOR = 0x09a6cc;
	public static var MIRKY_LAKE_COLOR = 0xcccc00;
	
	//don't allow instantiation
	private function Const(){
	}
}