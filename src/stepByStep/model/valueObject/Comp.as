class stepByStep.model.valueObject.Comp {
	private var id:Number;
	private var literal:String;
	private var description:String;
	private var subsystem:Number;
	private var img:String;
	private var isSel:Boolean;
	//
	public function Comp() {
		this.isSel = false;
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
	public function getSubsystem() {
		return this.subsystem;
	}
	//
	public function getImg() {
		return this.img;
	}
	//
	public function getIsSel() {
		return this.isSel;
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
	public function setSubsystem(subsystem:Number) {
		this.subsystem = subsystem;
	}
	//
	public function setImg(img:String) {
		this.img = img;
	}
	//
	public function setIsSel(isSel:Boolean) {
		this.isSel = isSel;
	}
}
