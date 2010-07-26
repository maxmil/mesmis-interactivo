import core.util.Utils;
class stepByStep.model.valueObject.Indicator {
	private var id:Number;
	private var type:String;
	private var literal:String;
	private var description:String;
	private var atrib:String;
	private var units:String;
	private var objective:String;
	private var tradSystem:Number;
	private var comSystem:Number;
	private var areaEval:String;
	private var measureMethod:String;
	private var measureDesc:String;
	private var _min:Number;
	private var _max:Number;
	private var maxLimit:Number;
	private var tradSystemCalc:Number;
	private var comSystemCalc:Number;
	private var weights:Array;
	private var isSel:Boolean;
	private var isOptimize:Boolean;
	private var optimizeDesc:String;
	private var tradeOffQuotient:Number;
	private var img:String;
	private var graphic:String;
	//
	public function Indicator() {
	}
	//
	public function getId() {
		return this.id;
	}
	//
	public function getType() {
		return this.type;
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
	public function getArtrib() {
		return this.atrib;
	}
	//
	public function getUnits() {
		return this.units;
	}
	//
	public function getObjective() {
		return this.objective;
	}
	//
	public function getTradSystem() {
		return this.tradSystem;
	}
	//
	public function getComSystem() {
		return this.comSystem;
	}
	//
	public function getAreaEval() {
		return this.areaEval;
	}
	//
	public function getMeasureMethod() {
		return this.measureMethod;
	}
	//
	public function getMeasureDesc() {
		return this.measureDesc;
	}
	//
	public function getMin() {
		return this._min;
	}
	//
	public function getMax() {
		return this._max;
	}
	//
	public function getMaxLimit() {
		return this.maxLimit;
	}
	//
	public function getTradSystemCalc() {
		return this.tradSystemCalc;
	}
	//	
	public function getComSystemCalc() {
		return this.comSystemCalc;
	}
	//	
	public function getWeights() {
		return this.weights;
	}
	//
	public function getIsSel() {
		return this.isSel;
	}
	//
	public function getIsOptimize() {
		return this.isOptimize;
	}
	//
	public function getOptimizeDesc() {
		return this.optimizeDesc;
	}
	//
	public function getTradeOffQuotient() {
		return this.tradeOffQuotient;
	}
	//
	public function getImg() {
		return this.img;
	}
	//
	public function getGraphic() {
		return this.graphic;
	}
	//
	//
	public function setId(id:Number) {
		this.id = id;
	}
	//
	public function setType(type:String) {
		this.type = type;
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
	public function setAtrib(atrib:String) {
		this.atrib = atrib;
	}
	//
	public function setUnits(units:String) {
		this.units = units;
	}
	//
	public function setObjective(objective:String) {
		this.objective = objective;
	}
	//
	public function setTradSystem(tradSystem:Number) {
		this.tradSystem = Utils.roundNumber(tradSystem, 2);
	}
	//
	public function setAreaEval(areaEval:String) {
		this.areaEval = areaEval;
	}
	//
	public function setMeasureMethod(measureMethod:String) {
		this.measureMethod = measureMethod;
	}
	//
	public function setMeasureDesc(measureDesc:String) {
		this.measureDesc = measureDesc;
	}
	//
	public function setComSystem(comSystem:Number) {
		this.comSystem = Utils.roundNumber(comSystem, 2);
	}
	//
	public function setMin(_min:Number) {
		this._min = Utils.roundNumber(_min, 2);
	}
	//
	public function setMax(_max:Number) {
		this._max = Utils.roundNumber(_max, 2);
	}
	//
	public function setMaxLimit(maxLimit:Number) {
		this.maxLimit = maxLimit;
	}
	//
	public function setTradSystemCalc(tradSystemCalc:Number) {
		this.tradSystemCalc = Utils.roundNumber(tradSystemCalc, 2);
	}
	//	
	public function setComSystemCalc(comSystemCalc:Number) {
		this.comSystemCalc = Utils.roundNumber(comSystemCalc, 2);
	}
	//
	public function setWeights(weights:Array) {
		this.weights = weights;
	}
	//
	public function setIsSel(isSel:Boolean) {
		this.isSel = isSel;
	}
	//
	public function setIsOptimize(isOptimize:Boolean) {
		this.isOptimize = isOptimize;
	}
	//
	public function setOptimizeDesc(optimizeDesc:String) {
		this.optimizeDesc = optimizeDesc;
	}
	//	
	public function setTradeOffQuotient(tradeOffQuotient:Number) {
		this.tradeOffQuotient = tradeOffQuotient;
	}
	//
	public function setImg(img:String) {
		this.img = img;
	}
	//
	public function setGraphic(graphic:String) {
		this.graphic = graphic;
	}
}
