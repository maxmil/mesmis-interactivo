import ascb.util.logging.Logger;
import core.util.Utils;
import core.comp.ResultTable;
import sussi.Const;
import sussi.utils.SUtils;
import sussi.process.*;

/*
 * Activity used for tests
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.test.util.TestActivity extends sussi.activity.SussiActivity{
	 
	 //logger
	public static var logger:Logger = Logger.getLogger("sussi.test.util.TestActivity");
	
	/*
	 * Constructor
	 */
	public function TestActivity() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating TestActivity");
		
		//define proceses
		var bc:Process = Bc.getProcess();
		var bh1:Process = Bh1.getProcess();
		var bh2:Process = Bh2.getProcess();
		var dc:Process = Dc.getProcess();
		var dh1:Process = Dh1.getProcess();
		var dh2:Process = Dh2.getProcess();
		var pc:Process = Pc.getProcess();
		var ph1:Process = Ph1.getProcess();
		var ph2:Process = Ph2.getProcess();

		SUtils.clearOutputs();
		
		//Scroll pane containing result table
		var mc:MovieClip = this.createEmptyMovieClip("mc", this.getNextHighestDepth());
		var sp = mc.createClassObject(mx.containers.ScrollPane, "sp", 1, {contentPath:"emptyMovieClip"});
		sp.setSize(950,600);
		var restable = Utils.newObject(ResultTable, sp.content, "restable_1", sp.content.getNextHighestDepth(),{nRows:Const.PROC_YEARS_LIMIT*52, bgColorHeader:0x006600, bgColorREven:0x9FCB96, bgColorROdd:0xCEECC8, startInd:0});
		restable.addCol("t", "semanas", bh1, bh1.getTableValueWeek, 50);
		restable.addCol("bh1", "Nac. h1", bh1, bh1.getTableValueWeek, 100);
		restable.addCol("dh1", "Muerte h1", dh1, dh1.getTableValueWeek, 100);
		restable.addCol("ph1", "Pob. h1", ph1, ph1.getTableValueWeek, 100);
		restable.addCol("bh2", "Nac. h2", bh2, bh2.getTableValueWeek, 100);
		restable.addCol("dh2", "Muerte h2", dh2, dh2.getTableValueWeek, 100);
		restable.addCol("ph2", "Pob. h2", ph2, ph2.getTableValueWeek, 100);
		restable.addCol("bc", "Nac. c", bc, bc.getTableValueWeek, 100);
		restable.addCol("dc", "Muerte c", dc, dc.getTableValueWeek, 100);
		restable.addCol("pc", "Pob. c", pc, pc.getTableValueWeek, 100);
		
		 //var gt:Object = new sussi.test.util.GenerateTestValues();
	}
	
}