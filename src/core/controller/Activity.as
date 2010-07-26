/*
 * A value object for representing activities
 * Class used by core.controller.Nav to manage navegation
 * Each activity references an activity class that should extend
 * MovieClip with a given id and an initialization object.
 * From this definition core.controller.Nav can manage the creation and removal
 * of instances of each activity as movie clips.
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 18-07-2005
 */
class core.controller.Activity {
	
	private var constructor:Function;
	private var id:String;
	private var initObj:Object;
	private var _type:String;

	/*
	 * Constructor
	 */
	public function Activity(constructor:Function, id:String, initObj:Object, _type:String) {
		this.constructor = constructor;
		this.id = id;
		this.initObj = initObj;
		this._type = _type;
	}
	
	/*
	 * Gets the constructor
	 * 
	 * @return the constructor function
	 */
	public function getConstructor():Function {
		return this.constructor;
	}
	
	/*
	 * Gets the id
	 * 
	 * @return the id of the activity
	 */
	public function getId():String {
		return this.id;
	}

	/*
	 * Gets the initial object
	 * 
	 * @return the initial object
	 */
	public function getInitObj():Object {
		return this.initObj;
	}
	
	/*
	 * Gets the _type
	 * 
	 * @return the _type
	 */
	public function get_type():String {
		return this._type;
	}

	/*
	 * Sets the constructor
	 * 
	 * @param constructor the constructor
	 */
	public function setConstructor(constructor:Function):Void {
		this.constructor = constructor;
	}

	/*
	 * Sets the id
	 * 
	 * @param id the id
	 */
	public function setId(id:String):Void {
		this.id = id;
	}

	/*
	 * Sets the initial object
	 * 
	 * @param initObj the initial object
	 */
	public function setInitObj(initObj:Object):Void {
		this.initObj = initObj;
	}

	/*
	 * Sets the _type
	 * 
	 * @param initObj the _type
	 */
	public function set_type(_type:String):Void {
		this._type = _type;
	}
}
