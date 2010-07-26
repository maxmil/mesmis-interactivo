/*
 * Class used to save user dependent variables at run time
 * 
 * @author Max Pimm
 * @created 09-09-2005
 * @version 1.0
 */
 class lindissima.UserSession {
	 
	private var answers:Object;
	
	/*
	 * Constructor
	 */
	function UserSession(){
		this.answers = new Object();
	}
	
	/*
	 * Gets the answers
	 */
	public function getAnswers():Object{
		return this.answers;
	}
}