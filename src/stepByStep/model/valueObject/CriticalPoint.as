class stepByStep.model.valueObject.CriticalPoint {
	private var id:Number;
	private var literal:String;
	private var shortTitle:String;
	private var description:String;
	private var img:String;
	private var type:String;
	//
	public function CriticalPoint() {
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
	public function getShortTitle() {
		return this.shortTitle;
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
	public function getType() {
		return this.type;
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
	public function setShortTitle(shortTitle:String) {
		this.shortTitle = shortTitle;
	}
	//
	public function setDescription(description:String) {
		this.description = description;
	}
	//
	public function setImg(img:String) {
		this.img = img;
	}
	//
	public function setType(type:String) {
		this.type = type;
	}
}
