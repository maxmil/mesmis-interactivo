import ascb.util.logging.Logger;
import core.util.Utils;
import lindissima.Const;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import lindissima.comp.cornShrubModel.ExploreCornShrubModel;
import core.comp.ResultTable;
import lindissima.process.NFiltered;
import lindissima.process.FarmerNetProfit;
import lindissima.process.LakeNetProfit;
import lindissima.process.NInSoil;

/*
 * Auxiliar component for exploring the corn model. Shows two graphics. 
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 12-97-2005
 */
class lindissima.comp.cornShrubModel.ExploreCornShrubModelAnualDetail extends core.util.GenericMovieClip {
	
	//logger
	private static var logger:Logger = Logger.getLogger("lindissima.comp.cornModel.ExploreCornModelAnualDetail");
	
	//processes
	private var nis:NInSoil;
	private var fnp:FarmerNetProfit;
	private var lnp:LakeNetProfit;
	private var nf:NFiltered;
	
	/*
	 * Constructor
	 */
	public function ExploreCornShrubModelAnualDetail() {
		
		logger.debug("instantiating ExploreCornModelAnualDetail");
		
		//initialize processes
		nis = NInSoil(NInSoil.getProcess());
		fnp = FarmerNetProfit(FarmerNetProfit.getProcess());
		lnp = LakeNetProfit(LakeNetProfit.getProcess());
		nf = NFiltered(NFiltered.getProcess());
		
		//init detail table
		var detailTbl = Utils.newObject(ResultTable, this, "detailTbl", 1,{_x:5, _y:5, nRows:ExploreCornShrubModel.nYears, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8, noInit:true});
		detailTbl.addCol("lic", LindApp.getMsg("tbl.col.lakeInitialCond"), this, this.getTableValue, 100);
		detailTbl.addCol("y", LindApp.getMsg("tbl.col.years"), this, this.getTableValue, 50);
		detailTbl.addCol("nan", LindApp.getMsg("tbl.col.nAnual"), this, this.getTableValue, 50);
		detailTbl.addCol("nis", LindApp.getMsg("tbl.col.nInSoil"), this, this.getTableValue, 80);
		detailTbl.addCol("nf", LindApp.getMsg("tbl.col.nFiltered"), this, this.getTableValue, 80);
		detailTbl.addCol("pcf", LindApp.getMsg("tbl.col.profitCornFarmer"), this, this.getTableValue, 100);
		detailTbl.addCol("plw", LindApp.getMsg("tbl.col.profitLakeWorker"), this, this.getTableValue, 100);
	}
	
	/*
	 * Populates the detail table
	 * 
	 * @param y the row index corresponds to the year (first year == 0)
	 * @param id the column id
	 * @return a string value to be printed in the cell
	 */
	public function getTableValue(y:Number, id:String):String{
		var ret:Number;
		
		switch (id){
			case "lic":
				return (LUtils.getIP("algasIni", y) == Const.WEED_CONCENTRATION_HIGH) ? LindApp.getMsg("lakeModel.high") : LindApp.getMsg("lakeModel.low");
			break;
			case "y":
				return String(y+1);
			break;
			case "nan":
				//get anual nitrogen applied from the init params
				ret = LUtils.getIP("nAnual", y);
			break;
			case "nis":
				//get final value of nitrogen in soil
				ret = this.nis.getOutput(y*52);
			break;
			case "nf":
				//get value of nitrogen filtered from the soil
				ret = this.nf.getAcumAnual(y);
			break;
			case "pcf":
				//get average value of corn farmers net profit
				ret = Utils.roundNumber(fnp.getOutput(y), 2);
			break;
			case "plw":
				//get average value of lake workers net profit
				ret = Utils.roundNumber(lnp.getOutput(y)/Const.HECTARES_CORN, 2);
			break;
			default:
				return "";
			break
		}
		
		return String(Utils.roundNumber(ret, 2));
	}
	

	/*
	 * Updates the detail table
	 */
	public function update():Void{
		this["detailTbl"].update();
	}

}
