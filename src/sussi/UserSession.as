import sussi.model.Relations;

/*
 * Class used to save user dependent variables at run time
 * 
 * @author Max Pimm
 * @created 14-09-2005
 * @version 1.0
 */
 class sussi.UserSession {
	 
	private var relations:Relations;
	
	/*
	 * Constructor
	 */
	function UserSession(){
	}
	
	/*
	 * Gets the relations
	 */
	public function getRelations():Relations{
		if (relations){
			return relations;
		}else{
			relations = new Relations();
			return relations;
		}
	}
}