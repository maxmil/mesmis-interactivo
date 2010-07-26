class TblIndicatorWeights {
	var contClip:MovieClip;
	var colWidths = new Array(200, 90, 90, 90, 90, 90, 90, 90, 90);
	var colTitles = new Array("Nombre", "Campesinos", "Técnicos", "Gobierno", "Campesinos", "Técnicos", "Gobierno", "Sistema Tradicional", "Sistema Comercial");
	var lineHeight = 35;
	var preTitleHeight = 20;
	var titleHeight = 35;
	var titleTxtFormat:TextFormat;
	var cellTxtFormat:TextFormat;
	var rows:Array;
	private var indicators;
	public var weigherOpen:Boolean = false;
	//
	public function TblIndicatorWeights(id:String, depth:Number, parentClip:MovieClip, indicators:Array) {
		//set indicators and initialize rows
		this.indicators = indicators;
		this.rows = new Array(indicators.length);
		//
		initTextFormats();
		//create conainer clip
		contClip = parentClip.createEmptyMovieClip(id, depth);
		//create header
		createHeader();
		//create rows
		createRows();
	}
	//
	private function initTextFormats() {
		//title text format
		titleTxtFormat = new TextFormat();
		titleTxtFormat.size = 11;
		titleTxtFormat.font = "Arial";
		titleTxtFormat.bold = true;
		titleTxtFormat.align = "center";
		titleTxtFormat.color = 0xFFFFFF;
		//cell text format
		cellTxtFormat = new TextFormat();
		cellTxtFormat.size = 11;
		cellTxtFormat.font = "Arial";
		cellTxtFormat.bold = false;
		cellTxtFormat.align = "center";
		cellTxtFormat.color = 0x996633;
	}
	//
	private function createHeader() {
		var currX:Number;
		var currY:Number;
		var header = this.contClip.createEmptyMovieClip("header", 1);
		with (header) {
			lineStyle(1, 0xffffff, 100);
			//create first row of header
			currX = 0;
			//create first cell with no text
			beginFill(0x003300, 90);
			moveTo(currX, 0);
			lineTo(currX+this.colWidths[0], 0);
			lineTo(currX+this.colWidths[0], this.preTitleHeight);
			lineTo(currX, this.preTitleHeight);
			lineTo(currX, 0);
			endFill();
			currX += this.colWidths[0];
			//create first cell, traditional system
			beginFill(0x003300, 90);
			moveTo(currX, 0);
			lineTo(currX+this.colWidths[1]+this.colWidths[2]+this.colWidths[3], 0);
			lineTo(currX+this.colWidths[1]+this.colWidths[2]+this.colWidths[3], this.preTitleHeight);
			lineTo(currX, this.preTitleHeight);
			lineTo(currX, 0);
			endFill();
			createTextField("title_sys_trad", 2, currX, 0, this.colWidths[1]+this.colWidths[2]+this.colWidths[3], this.preTitleHeight);
			header["title_sys_trad"].text = "Sistema Tradicional";
			header["title_sys_trad"].embedFonts = true;
			header["title_sys_trad"].setTextFormat(this.titleTxtFormat);
			header["title_sys_trad"].wordWrap = true;
			currX += this.colWidths[1]+this.colWidths[2]+this.colWidths[3];
			//create second cell, commercial system
			beginFill(0x003300, 90);
			moveTo(currX, 0);
			lineTo(currX+this.colWidths[4]+this.colWidths[5]+this.colWidths[6], 0);
			lineTo(currX+this.colWidths[4]+this.colWidths[5]+this.colWidths[6], this.preTitleHeight);
			lineTo(currX, this.preTitleHeight);
			lineTo(currX, 0);
			endFill();
			createTextField("title_sys_com", 3, currX, 0, this.colWidths[4]+this.colWidths[5]+this.colWidths[6], this.preTitleHeight);
			header["title_sys_com"].text = "Sistema Comercial";
			header["title_sys_com"].embedFonts = true;
			header["title_sys_com"].setTextFormat(this.titleTxtFormat);
			header["title_sys_com"].wordWrap = true;
			currX += this.colWidths[4]+this.colWidths[5]+this.colWidths[6];
			//create third cell, average
			beginFill(0x003300, 90);
			moveTo(currX, 0);
			lineTo(currX+this.colWidths[7]+this.colWidths[8], 0);
			lineTo(currX+this.colWidths[7]+this.colWidths[8], this.preTitleHeight);
			lineTo(currX, this.preTitleHeight);
			lineTo(currX, 0);
			endFill();
			createTextField("title_average", 4, currX, 0, this.colWidths[7]+this.colWidths[8], this.preTitleHeight);
			header["title_average"].text = "Promedio";
			header["title_average"].embedFonts = true;
			header["title_average"].setTextFormat(this.titleTxtFormat);
			header["title_average"].wordWrap = true;
			//create header cells
			currX = 0;
			for (var i = 0; i<this.colTitles.length; i++) {
				//create background
				beginFill(0x006600, 90);
				moveTo(currX, this.preTitleHeight);
				lineTo(currX+this.colWidths[i], this.preTitleHeight);
				lineTo(currX+this.colWidths[i], this.preTitleHeight+this.titleHeight);
				lineTo(currX, this.preTitleHeight+this.titleHeight);
				lineTo(currX, this.preTitleHeight);
				endFill();
				//create title text
				var txtField = "title"+String(i);
				createTextField("title"+String(i), 5+i, currX, this.preTitleHeight, this.colWidths[i], this.titleHeight);
				header[txtField].text = this.colTitles[i];
				header[txtField].embedFonts = true;
				header[txtField].setTextFormat(this.titleTxtFormat);
				header[txtField].wordWrap = true;
				//increment current x position
				currX += this.colWidths[i];
			}
		}
	}
	//
	private function createRows() {
		var rowClip;
		var bgClip;
		var bgOverClip;
		var currX:Number;
		var currY:Number;
		currY = this.preTitleHeight+this.titleHeight;
		for (var i = 0; i<indicators.length; i++) {
			//create new row
			rowClip = this.contClip.createEmptyMovieClip("row"+String(i), 2+i);
			rowClip._y = currY;
			rowClip.indicator = indicators[i];
			rowClip.tblIndicators = this;
			currX = 0;
			//create background clips
			bgClip = rowClip.createEmptyMovieClip("bg", 1);
			bgOverClip = rowClip.createEmptyMovieClip("bgOver", 2);
			bgOverClip._alpha = 0;
			//create row cells
			with (rowClip) {
				//create cells
				for (var j = 0; j<this.colTitles.length; j++) {
					//create background
					with (bgClip) {
						lineStyle(1, 0xffffff, 100);
						beginFill(0xC0A47D, 50);
						moveTo(currX, 0);
						lineTo(currX+this.colWidths[j], 0);
						lineTo(currX+this.colWidths[j], this.lineHeight);
						lineTo(currX, this.lineHeight);
						lineTo(currX, 0);
						endFill();
					}
					//create roll over background
					with (bgOverClip) {
						lineStyle(1, 0xffffff, 100);
						beginFill(0xFFCC00, 50);
						moveTo(currX, 0);
						lineTo(currX+this.colWidths[j], 0);
						lineTo(currX+this.colWidths[j], this.lineHeight);
						lineTo(currX, this.lineHeight);
						lineTo(currX, 0);
						endFill();
					}
					/*
															//create roll over funcionality
															rowClip.onRollOver = function() {
																if (this.tblIndicators.weigherOpen == false) {
																	this.bgOver._alpha = 100;
																}
															};
															rowClip.onRollOut = function() {
																if (this.tblIndicators.weigherOpen == false) {
																	this.bgOver._alpha = 0;
																}
															};*/
					//create title text
					var txtField = "cellTxt"+String(j);
					createTextField(txtField, 3+j, currX, 0, this.colWidths[j], this.lineHeight);
					switch (j) {
					case 0 :
						rowClip[txtField].text = indicators[i].getLiteral();
						break;
					case 1 :
						rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[0], 2);
						break;
					case 2 :
						rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[1], 2);
						break;
					case 3 :
						rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[2], 2);
						break;
					case 4 :
						rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[0], 2);
						break;
					case 5 :
						rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[1], 2);
						break;
					case 6 :
						rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[2], 2);
						break;
					case 7 :
						rowClip[txtField].text = roundNumber((indicators[i].getTradSystemCalc()*indicators[i].getWeights()[0]+indicators[i].getTradSystemCalc()*indicators[i].getWeights()[1]+indicators[i].getTradSystemCalc()*indicators[i].getWeights()[2])/3, 2);
						break;
					case 8 :
						rowClip[txtField].text = roundNumber((indicators[i].getComSystemCalc()*indicators[i].getWeights()[0]+indicators[i].getComSystemCalc()*indicators[i].getWeights()[1]+indicators[i].getComSystemCalc()*indicators[i].getWeights()[2])/3, 2);
						break;
					}
					trowClip[txtField].embedFonts = true;
					rowClip[txtField].setTextFormat(this.cellTxtFormat);
					rowClip[txtField].wordWrap = true;
					//increment current x position
					currX += this.colWidths[j];
				}
				//add row to global array
				this.rows[i] = rowClip;
				//increment current y position
				currY += this.lineHeight;
			}
		}
	}
	private function refreshTable() {
		for (var i = 0; i<this.indicators.length; i++) {
			//get row
			var rowClip:MovieClip = this.rows[i];
			//loop through columns refreshing values
			for (var j = 0; j<this.colTitles.length; j++) {
				var txtField = "cellTxt"+String(j);
				switch (j) {
				case 0 :
					rowClip[txtField].text = indicators[i].getLiteral();
					break;
				case 1 :
					rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[0], 2);
					break;
				case 2 :
					rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[1], 2);
					break;
				case 3 :
					rowClip[txtField].text = roundNumber(indicators[i].getTradSystemCalc()*indicators[i].getWeights()[2], 2);
					break;
				case 4 :
					rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[0], 2);
					break;
				case 5 :
					rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[1], 2);
					break;
				case 6 :
					rowClip[txtField].text = roundNumber(indicators[i].getComSystemCalc()*indicators[i].getWeights()[2], 2);
					break;
				case 7 :
					rowClip[txtField].text = roundNumber((indicators[i].getTradSystemCalc()*indicators[i].getWeights()[0]+indicators[i].getTradSystemCalc()*indicators[i].getWeights()[1]+indicators[i].getTradSystemCalc()*indicators[i].getWeights()[2])/3, 2);
					break;
				case 8 :
					rowClip[txtField].text = roundNumber((indicators[i].getComSystemCalc()*indicators[i].getWeights()[0]+indicators[i].getComSystemCalc()*indicators[i].getWeights()[1]+indicators[i].getComSystemCalc()*indicators[i].getWeights()[2])/3, 2);
					break;
				}
				rowClip[txtField].setTextFormat(this.cellTxtFormat);
				rowClip[txtField].wordWrap = true;
			}
		}
	}
	//
	private function roundNumber(n:Number, scale:Number) {
		var mult = Math.pow(10, scale);
		return ((Math.round(mult*n))/mult);
	}
}
