import ascb.util.logging.Logger;
import lindissima.LindApp;
import lindissima.utils.LUtils;
import lindissima.model.InitParam;


/*
 * Activity used for tests
 * 
 * @author Max Pimm
 * @version 1.0
 * @created 14-07-2005
 */
 class lindissima.test.util.TestActivity extends lindissima.activity.LindActivity{
	 
	 //logger
	public static var logger:Logger = Logger.getLogger("lindissima.test.util.TestActivity");
	
	/*
	 * Constructor
	 */
	public function TestActivity() {
		
		//call super class constructor
		super();

		//log
		logger.debug("instantiating TestActivity");
		
		LindApp.getInitParamCol().getSelInitParams().setInitParam("nAnual", new InitParam("nAnual", "Nitrógeno anual", "El nitrógeno que se aplica cada año medido en gramos por m². Nota: 1gm/ m² es equivalente a 10kg/hectarea.", 2, "15:15:15:15:15", 0, 15 ));
		
		LUtils.clearOutputs();
		
		//define process
		var lakeNetProfit = lindissima.process.LakeNetProfit.getProcess();
		for (var i=0; i<5; i++){
			logger.debug(lakeNetProfit.getOutput(i).toString());
		}

	}
	
}