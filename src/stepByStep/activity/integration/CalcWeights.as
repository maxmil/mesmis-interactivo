import core.util.Utils;
import core.comp.TextPane;
import core.comp.Amoeba;
import stepByStep.comp.MesmisButton;
//
class stepByStep.activity.integration.CalcWeights extends stepByStep.activity.StepByStepActivity {
	private var indicators:Array;
	//the indicators
	private var yBase:Number = 500;
	// the y-coord of the y axis of the graphic
	private var xBase:Number = 170;
	// the x-coord of the x axis of the graphic
	private var h:Number = 400;
	// the height of the graphic
	private var w:Number = 400;
	// the width of the graphic
	private var scale:Number = 100;
	// the scale of the graphic
	private var tableXBase = 600;
	// the x-coord of the table containing the current values
	private var weights:Array = new Array(3);
	// the weights, the three elements represent "campesinos", "tecnicos" y "gobierno" and each one contains an array of values
	private var txtFormat:TextFormat;
	// the text format for the table containing the current values
	private var selWeight:Number;
	// the array of weights that the user is editing (0 = campesinos, 1 = tecnicos, 2 = gobierno)
	//
	public function CalcWeights() {
		
		
		//get selected indicators
		this.indicators = MUtils.selectIndicators(StepByStepApp.getApp().indicators);
		
		this.selWeight = 0;
		createIntroText();
		createGraphic();
		createTable();
		createButtons();
		drawControls();
		getWeights();
		redrawWeights();
	}
	//
	private function createIntroText() {
		var introText = this.createEmptyMovieClip("introText", 13);
		introText._x = 650;
		introText._y = 20;
		//create text format
		var introTextFormat:TextFormat = new TextFormat();
		introTextFormat.size = 11;
		introTextFormat.font = "Arial";
		introTextFormat.color = 0x996633;
		//create text field
		introText.createTextField("txt", 2, 0, 0, 200, 300);
		introText.txt.text = "Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. Aquí va la introducción. ";
		introText.txt.embedFonts = true;
		introText.txt.setTextFormat(introTextFormat);
		introText.txt.wordWrap = true;
	}
	//
	private function createButtons() {
		//create internal buttons
		var buttons:MovieClip = this.createEmptyMovieClip("buttons", 12);
		buttons.calWeight = this;
		buttons._x = 200;
		buttons._y = 30;
		var btn_campesinos = Utils.newObject(MesmisButton, buttons, "btn_campesinos", 10, {_alpha:20, literal:"Campesinos"});
		buttons.btn_campesinos.onRelease = function() {
			this._parent.calWeight.selWeight = 0;
			this._parent.calWeight.redrawWeights();
			this._alpha = 20;
			this._parent.btn_tecnicos._alpha = 100;
			this._parent.btn_gobierno._alpha = 100;
		};
		var btn_tecnicos = Utils.newObject(MesmisButton, buttons, "btn_tecnicos", 11, {_x:buttons._width+20, literal:"Técnicos"});
		buttons.btn_tecnicos.onRelease = function() {
			this._parent.calWeight.selWeight = 1;
			this._parent.calWeight.redrawWeights();
			this._alpha = 20;
			this._parent.btn_campesinos._alpha = 100;
			this._parent.btn_gobierno._alpha = 100;
		};
		var btn_gobierno = Utils.newObject(MesmisButton, buttons, "btn_gobierno", 12, {_x:buttons._width+20, literal:"Gobierno"});
		buttons.btn_gobierno.onRelease = function() {
			this._parent.calWeight.selWeight = 2;
			this._parent.calWeight.redrawWeights();
			this._alpha = 20;
			this._parent.btn_tecnicos._alpha = 100;
			this._parent.btn_campesinos._alpha = 100;
		};
		//
		//create navigation buttons
		var btns_nav = this.createEmptyMovieClip("btns_nav", 14);
		btns_nav._x = 670;
		btns_nav._y = 560;
		//create button ver amoebas
		var btn_ver_amoebas = Utils.newObject(MesmisButton, btns_nav, "btn_ver_amoebas", btns_nav.getNextHighestDepth(), {literal:"Ver Amoebas"});
		btn_ver_amoebas.onRelease = function() {
			this._parent._parent.showAmoebas();
		};
		//create button atras
		var btn_atras = Utils.newObject(MesmisButton, btns_nav, "btn_atras", btns_nav.getNextHighestDepth(), {_x:btns_nav._width+10, literal:"Atras"});
		btn_atras.onRelease = function() {
			_root.nav.getPrevious();
		};
		//create button siguente
		var btn_siguiente = Utils.newObject(MesmisButton, btns_nav, "btn_siguiente", btns_nav.getNextHighestDepth(), {_x:btns_nav._width+10, literal:"Siguiente"});
		btn_siguiente.onRelease = function() {
			this._parent._parent.saveWeights();
			_root.nav.getNext();
		};
	}
	//
	private function createGraphic() {
		//define text format
		txtFormat = new TextFormat();
		txtFormat.font = "Arial";
		txtFormat.color = 0x996633;
		txtFormat.align = "right";
		txtFormat.size = 9;
		//create graphic clip and backgUtils.round
		var graphic:MovieClip = this.createEmptyMovieClip("graphic", 10);
		var bg:MovieClip = graphic.createEmptyMovieClip("bg", 10);
		//draw y axis and x axis
		bg.lineStyle(1, 0x996633, 100);
		bg.moveTo(xBase, yBase+5);
		bg.lineTo(xBase, yBase-this.h-10);
		bg.moveTo(xBase-5, yBase);
		bg.lineTo(xBase+this.w, yBase);
		//draw horizontal guides for indicators
		for (var i = 1; i<=this.indicators.length; i++) {
			bg.moveTo(this.xBase-5, this.yBase-this.h/this.indicators.length*i);
			bg.lineTo(this.tableXBase, this.yBase-this.h/this.indicators.length*i);
		}
		//draw indicator titles
		var txtFieldId:String;
		for (var i = 0; i<this.indicators.length; i++) {
			txtFieldId = "xAxisLit_"+String(i);
			bg.createTextField(txtFieldId, 10+i, 0, this.yBase-this.h+this.h/this.indicators.length*i-8, this.xBase-10, 20);
			bg[txtFieldId].text = this.indicators[i].getLiteral();
			bg[txFieldId].embedFonts = true;
			bg[txtFieldId].setTextFormat(txtFormat);
		}
		//draw x markers
		for (var i = 1; i<=5; i++) {
			//linea version: bg.moveTo(this.xBase+this.w/5*i, this.yBase);
			var xCoord = this.xBase+this.w*(1-Math.pow((i/5-1), 2));
			bg.moveTo(xCoord, this.yBase);
			bg.lineTo(xCoord, this.yBase+5);
		}
		//draw x titles
		txtFormat.align = "center";
		for (var i = 0; i<=5; i++) {
			var xCoord = this.xBase+this.w*(1-Math.pow((i/5-1), 2));
			txtFieldId = "yAxisLit_"+String(i);
			//linea version: bg.createTextField(txtFieldId, this.indicators.length+10+i, this.xBase+this.w/5*i-10, this.yBase+5, 20, 20);
			bg.createTextField(txtFieldId, this.indicators.length+10+i, xCoord-10, this.yBase+5, 20, 20);
			bg[txtFieldId].text = i/5*this.scale;
			bg[txtFieldId].embedFonts = true;
			bg[txtFieldId].setTextFormat(txtFormat);
		}
	}
	//
	private function drawControls() {
		//add controls
		var control;
		var controls = this["graphic"].bg.createEmptyMovieClip("controls", this.indicators.length+21);
		var controlH = 20;
		//create mask clip
		controls.createEmptyMovieClip("mask", 10);
		controls.mask.beginFill(0x000000, 100);
		controls.mask.moveTo(0, 0);
		controls.mask.lineTo(this.w+1, 0);
		controls.mask.lineTo(this.w+1, this.h);
		controls.mask.lineTo(0, this.h);
		controls.mask.lineTo(0, 0);
		controls.mask.endFill();
		controls.setMask(controls.mask);
		//move controls and save reference to calcWeight object
		controls._x = this.xBase;
		controls._y = this.yBase-this.h-controlH/2;
		controls.calWeight = this;
		for (var i = 0; i<this.indicators.length; i++) {
			//create control movie clip
			control = "control_"+String(i);
			controls.createEmptyMovieClip(control, 11+i);
			//draw horizontal bar that extends to the x coord defined by the weitht of the indicator
			var color = Math.floor(16777215*Math.random());
			controls[control].lineStyle(1, color, 100);
			var matrix = {matrixType:"box", x:0, y:0, w:this.w, h:controlH, r:Math.PI/2};
			controls[control].beginGradientFill("linear", [color, color], [0, 100], [0, 0xFF], matrix);
			controls[control].moveTo(0, 0);
			controls[control].lineTo(this.w, 0);
			controls[control].lineTo(this.w, controlH);
			controls[control].lineTo(0, controlH);
			controls[control].lineTo(0, 0);
			controls[control].endFill();
			//linea version: controls[control]._x = this.w*indicators[i].getWeights()[0]/this.scale-this.w;
			//controls[control]._x = (1-Math.pow(indicators[i].getWeights()[0]/this.scale-1, 2))*this.w-this.w;
			controls[control]._y = this.h/this.indicators.length*i;
			controls[control].ind = i;
			//add drag funcionality
			controls[control].onPress = function() {
				this.startDrag(false, -this._parent.calWeight.w, this._y, 0, this._y);
			};
			controls[control].onRelease = function() {
				this.stopDrag();
				this._parent.calWeight.updateWeights(this.ind, (this._x-this.oldX)/this._parent.calWeight.w);
			};
			controls[control].onRollOut = function() {
				this.stopDrag();
				this._parent.calWeight.updateWeights(this.ind, (this._x-this.oldX)/this._parent.calWeight.w);
			};
		}
	}
	//
	private function updateWeights(controlIndex:Number, inc:Number) {
		var w:Array = this.weights[this.selWeight];
		// linea version: var initInc = (this.graphic.bg.controls["control_"+String(controlIndex)]._x+this.w)*this.scale/this.w-w[controlIndex];
		var xCoord = this["graphic"].bg.controls["control_"+String(controlIndex)]._x+this.w;
		var relXValue = 1-Math.sqrt(1-xCoord/this.w);
		var initInc = relXValue*this.scale-w[controlIndex];
		var control;
		var incDone:Number = 0;
		var nMarkers:Number = w.length-1;
		var limit:Number = (initInc>0) ? 0 : this.scale;
		//get number of weights that can be moved
		for (var i = 0; i<w.length; i++) {
			if (i != controlIndex && w[i] == limit) {
				nMarkers--;
			}
		}
		//get relative increment for remaining markers
		var incRel:Number = (initInc/nMarkers);
		//keep adding to remaining weights until total increment is equal to initial increment
		var cnt = 0;
		var distFromLimit:Number;
		while (nMarkers>0 && Math.abs(incRel)>0.01) {
			for (var i = 0; i<w.length; i++) {
				if (i != controlIndex) {
					distFromLimit = w[i]-limit;
					if (distFromLimit != 0 && Math.abs(distFromLimit)<=Math.abs(incRel)) {
						incDone += distFromLimit;
						w[i] = limit;
						nMarkers--;
					} else if (w[i] != limit) {
						incDone += incRel;
						w[i] -= incRel;
					}
				}
			}
			//recalculate relative increment
			incRel = (initInc-incDone)/nMarkers;
			cnt++;
		}
		//set control weight with value of incDone
		w[controlIndex] += incDone;
		//redrawMarkers and update text boxes
		redrawWeights();
	}
	//
	private function createTable() {
		var boxWidth:Number = 40;
		var boxHeight:Number = 20;
		//create container clip
		var tbl = this.createEmptyMovieClip("tbl", 11);
		tbl._x = this.tableXBase;
		tbl._y = this.yBase-this.h-boxHeight/2;
		//draw boxes
		var txtFieldId:String;
		for (var i = 0; i<this.indicators.length; i++) {
			//create box
			tbl.lineStyle(1, 0x996633, 100);
			tbl.moveTo(0, this.h/this.indicators.length*i);
			tbl.lineTo(boxWidth, this.h/this.indicators.length*i);
			tbl.lineTo(boxWidth, this.h/this.indicators.length*i+boxHeight);
			tbl.lineTo(0, this.h/this.indicators.length*i+boxHeight);
			tbl.lineTo(0, this.h/this.indicators.length*i);
			//create text field
			txtFieldId = "weightBox_"+String(i);
			tbl.createTextField(txtFieldId, 10+i, 0, this.h/this.indicators.length*i, boxWidth, boxHeight);
			tbl[txtFieldId].embedFonts = true;
			tbl[txtFieldId].selectable = false;
		}
	}
	//
	public function showAmoebas() {
		//create new text pane0
		var tp = Utils.newObject(TextPane, this, "amoebas", 15, {_x:200, _y:100, w:500, h:420, title:"Amoebas de Pesos"});
		var cont = tp.getContent();
		//define indicator titles
		var titles:Array = new Array(this.indicators.length);
		for (var i = 0; i<this.indicators.length; i++) {
			titles[i] = this.indicators[i].getLiteral();
		}
		//create amoeba
		var am = Utils.newObject(Amoeba, cont, "amoeba", cont.getNextHighestDepth(), {titles:titles, _x:0, _y:0});
		//add campesinos
		am.addAmoeba("campesinos", "Campesinos", 0x0000ff, this.weights[0]);
		//add técnicos
		am.addAmoeba("tecnicos", "Técnicos", 0xff0000, this.weights[1]);
		//add gobierno
		am.addAmoeba("gobierno", "Gobierno", 0x00ff00, this.weights[2]);
		//add close button
		var btn_close = Utils.newObject(MesmisButton, cont, "btn_close", 11, {_x:410, _y:350, literal:"Cerrar"});
		btn_close.tp = tp;
		btn_close.onRelease = function() {
			this.tp.remove();
		};
		//init text pane
		tp.init(true);
	}
	//
	private function redrawWeights() {
		var w:Array = this.weights[this.selWeight];
		for (var i = 0; i<w.length; i++) {
			//linea version: this.graphic.bg.controls["control_"+String(i)]._x = w[i]/this.scale*this.w-this.w;
			this["graphic"].bg.controls["control_"+String(i)]._x = (1-Math.pow(w[i]/this.scale-1, 2))*this.w-this.w;
			this["tbl"]["weightBox_"+String(i)].text = Utils.roundNumber(w[i], 2);
			this["tbl"]["weightBox_"+String(i)].setTextFormat(this.txtFormat);
		}
	}
	//
	private function getWeights() {
		var l = this.indicators.length;
		for (var j = 0; j<3; j++) {
			var w:Array = new Array(l);
			for (var i = 0; i<l; i++) {
				w[i] = this.indicators[i].getWeights()[j];
			}
			this.weights[j] = w;
		}
	}
	//
	private function saveWeights() {
		var l:Number = this.indicators.length;
		var w:Array;
		for (var i = 0; i<l; i++) {
			w = new Array(3);
			for (var j = 0; j<3; j++) {
				w[j] = this.weights[j][i];
			}
			this.indicators[i].setWeights(w);
		}
	}
}
