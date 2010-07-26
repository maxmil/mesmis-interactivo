import lindissima.model.InitParams;

/*
 * Manages a collection of initial parameters backed by an array
 * 
 * @author Max Pimm
 * @created 09-09-2005
 * @version 1.0
 */
 class lindissima.model.InitParamCollection {
	 
	//array of init params
	private var objs:Array;
	
	//array of ids
	private var ids:Array;
	
	//the index of selected initial parameters
	private var selInd:Number;
 
	/*
	 * Constructor
	 */
	function InitParamCollection(){
		this.objs = new Array();
		this.ids = new Array();
		this.selInd = -1;
	}
	
	/*
	 * Ands a set of init params to the colection
	 * 
	 * @param initParams the set of initial parameters
	 * @param id the id of this set
	 */
	public function addInitParams(initParams:InitParams, id:String):Void{
		ids[objs.length] = id;
		objs[objs.length] = initParams;
	}
	
	/*
	 * Selects one of the initial parameter set by its id
	 *
	 * @param id the id of the set to select
	 */
	public function selectInitParams(id:String){
		for (var i=0; i<ids.length; i++){
			if (ids[i] == id){
				selInd = i;
			}
		}
	}
	
	/*
	 * Gets the selected init parameters from the array of init parameters
	 *
	 * @return the selected init parameters
	 */
	public function getSelInitParams():InitParams{
		return (objs[selInd]);
	}
	
	/*
	 * Checks whether init parameters with a certain id exist
	 * 
	 * @param the id of the parameters to look for
	 * @return true if a set of parameters exists with this id, false otherwise
	 */
	public function initParamsExsists(id:String):Boolean{
		for (var i=0; i<ids.length; i++){
			if (ids[i] == id){
				return true;
			}
		}
		return false;
	}	
}