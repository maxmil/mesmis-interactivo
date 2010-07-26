class stepByStep.model.valueObject.Flow {
	private var id:Number;
	private var literal:String;
	private var description:String;
	private var subsysEntry:Number;
	private var subsysExit:Number;
	private var img:String;
	private var isSel:Boolean;
	//
	public function Flow() {
		this.isSel = false;
	}
	//
	public function getId():Number {
		return this.id;
	}
	//
	public function getLiteral():String {
		return this.literal;
	}
	//
	public function getDescription():String {
		return this.description;
	}
	//
	public function getSubsysEntry():Number {
		return this.subsysEntry;
	}
	//
	public function getSubsysExit():Number {
		return this.subsysExit;
	}
	//
	public function getImg():String {
		return this.img;
	}
	//
	public function getIsSel():Boolean {
		return this.isSel;
	}
	//
	public function setId(id:Number):Void {
		this.id = id;
	}
	//
	public function setLiteral(literal:String):Void {
		this.literal = literal;
	}
	//
	public function setDescription(description:String):Void {
		this.description = description;
	}
	//
	public function setSubsysEntry(subsysEntry:Number):Void {
		this.subsysEntry = subsysEntry;
	}
	//
	public function setSubsysExit(subsysExit:Number):Void {
		this.subsysExit = subsysExit;
	}
	//
	public function setImg(img:String):Void {
		this.img = img;
	}
	//
	public function setIsSel(isSel:Boolean):Void {
		this.isSel = isSel;
	}
}
