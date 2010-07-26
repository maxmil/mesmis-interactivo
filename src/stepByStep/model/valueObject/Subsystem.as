class stepByStep.model.valueObject.Subsystem {
	private var id:Number;
	private var literal:String;
	private var description:String;
	private var img:String;
	//
	public function Subsystem() {
	}
	//
	public function getId() {
		return this.id;
	}
	//
	public function getLiteral() {
		return this.literal;
	}
	//
	public function getDescription() {
		return this.description;
	}
	//
	public function getImg() {
		return this.img;
	}
	//
	public function setId(id:Number) {
		this.id = id;
	}
	//
	public function setLiteral(literal:String) {
		this.literal = literal;
	}
	//
	public function setDescription(description:String) {
		this.description = description;
	}
	//
	public function setImg(img:String) {
		this.img = img;
	}
}
