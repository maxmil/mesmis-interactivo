import core.util.Utils;
import stepByStep.comp.BarGraph;
import stepByStep.comp.MesmisButton;
//
class stepByStep.activity.integration.CalcIndic extends stepByStep.activity.StepByStepActivity {
	private var indicators:Array;
	private var txtFormat:TextFormat;
	private var origSys:Array;
	private var modSys:Array;
	private var avrge:Array;
	//
	public function CalcIndic() {
		
		//get selected indicators
		this.indicators = MUtils.selectIndicators(StepByStepApp.getApp().indicators);
		
		calculateIndicies();
		createButtons();
		drawGraphic();
	}
	//
	private function drawGraphic() {
		var graphic = this.createEmptyMovieClip("graphic", this.getNextHighestDepth());
		//draw campesinos
		var campGraph = Utils.newObject(BarGraph, graphic, "campGraph", graphic.getNextHighestDepth(), {_x:10, _y:500, w:120, h:400, yScale:10, xLabel:"Campesinos", yRange:100});
		campGraph.addBar("Sistema Original", Utils.roundNumber(this.origSys[0], 2), Math.floor(16777215*Math.random()));
		campGraph.addBar("Sistema Modificado", Utils.roundNumber(this.modSys[0], 2), Math.floor(16777215*Math.random()));
		campGraph.init();
		//draw técnicos
		var tecnicGraph = Utils.newObject(BarGraph, graphic, "tecnicGraph", graphic.getNextHighestDepth(), {_x:240, _y:500, w:120, h:400, yScale:10, xLabel:"Técnicos", yRange:100});
		tecnicGraph.addBar("Sistema Original", Utils.roundNumber(this.origSys[1], 2), Math.floor(16777215*Math.random()));
		tecnicGraph.addBar("Sistema Modificado", Utils.roundNumber(this.modSys[1], 2), Math.floor(16777215*Math.random()));
		tecnicGraph.init();
		//draw campesinos
		var gobernGraph = Utils.newObject(BarGraph, graphic, "gobernGraph", graphic.getNextHighestDepth(), {_x:480, _y:500, w:120, h:400, yScale:10, xLabel:"Gobierno", yRange:100});
		gobernGraph.addBar("Sistema Original", Utils.roundNumber(this.origSys[2], 2), Math.floor(16777215*Math.random()));
		gobernGraph.addBar("Sistema Modificado", Utils.roundNumber(this.modSys[2], 2), Math.floor(16777215*Math.random()));
		gobernGraph.init();
		//draw unweighted
		var unweightedGraph = Utils.newObject(BarGraph, graphic, "unweightedGraph", graphic.getNextHighestDepth(), {_x:720, _y:500, w:120, h:400, yScale:10, xLabel:"Sin Pesos", yRange:100});
		unweightedGraph.addBar("Sistema Original", Utils.roundNumber(this.origSys[3], 2), Math.floor(16777215*Math.random()));
		unweightedGraph.addBar("Sistema Modificado", Utils.roundNumber(this.modSys[3], 2), Math.floor(16777215*Math.random()));
		unweightedGraph.init();
	}
	//
	private function calculateIndicies() {
		var origSat:Number;
		var modSat:Number;
		var evenWeight:Number = 100/this.indicators.length
		this.origSys = new Array(0, 0, 0, 0);
		this.modSys = new Array(0, 0, 0, 0);
		for (var i = 0; i<this.indicators.length; i++) {
			origSat = this.indicators[i].getTradSystemCalc();
			modSat = Math.min(Math.max(this.indicators[i].getTradSystemCalc() + _root.tradeOffLevel*this.indicators[i].getTradeOffQuotient(),0),100)
			for (var j = 0; j<3; j++) {
				this.origSys[j] += this.indicators[i].getWeights()[j]*origSat/100;
				this.modSys[j] += this.indicators[i].getWeights()[j]*modSat/100;
			}
			this.origSys[3] += evenWeight*origSat/100;
			this.modSys[3] += evenWeight*modSat/100;
		}
	}
	//
	private function createButtons() {
		//draw buttons
		var btns_nav = this.createEmptyMovieClip("btns_nav", this.getNextHighestDepth());
		btns_nav._y = 690;
		btns_nav._x = 770;
		var btn_atras = Utils.newObject(MesmisButton, btns_nav, "btn_atras", btns_nav.getNextHighestDepth(), {literal:"Atras"});
		btn_atras.onRelease = function() {
			_root.nav.getPrevious();
		};
		var btn_siguiente = Utils.newObject(MesmisButton, btns_nav, "btn_siguiente", btns_nav.getNextHighestDepth(), {_x:70, literal:"Siguiente"});
		btn_siguiente.onRelease = function() {
			_root.nav.getNext();
		};
	}
}
