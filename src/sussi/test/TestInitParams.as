import sussi.SussiApp;
import sussi.model.InitParam;
import sussi.model.InitParams;


/* Class created to test the corn model with shrubs for Sussi
 *
 * @author Max Pimm
 * @version 1.0
 * @created 14-09-2005
 */
 class sussi.test.TestInitParams {
	
	/*
	 * Constructor
	 * 
	 * @param ipType the type of init parameters to initialize
	 */
	public function TestInitParams(ipType:String){
		
		//initialize the init parameters if they don't exist
		if (!SussiApp.getInitParamCol().initParamsExsists(ipType)){
			initInitialParameters(ipType);
		}
	}
	
	/*
	 * Initializes the init params for this model
	 * 
	 * @param ipType the type of init parameters to initialize
	 */
	private function initInitialParameters(ipType:String):Void{
		
		//create init params
		var ips:InitParams = new InitParams();
		
		//define common init params
		ips.setInitParam("h1_ini", new InitParam("h1_ini", "H1Inicial", "El número de individuos en la populación de herbívoro 1’s cuando se inicia el modelo", 0, "180", 180, 180 ));
		ips.setInitParam("comp_h1h2", new InitParam("comp_h1h2", "alpha12", "La competencia que implica el herbívoro 2 para  y el herbívoro 1", 1, "0.2", 0.2, 0.2 ));
		ips.setInitParam("bh1_b", new InitParam("bh1_b", "b1", "Parámetro del proceso de nacimiento del herbívoro 1", 3, "0.097", 0.097, 0.097 ));
		ips.setInitParam("bh1_c", new InitParam("bh1_c", "c1", "Parámetro del proceso de nacimiento del herbívoro 1", 3, "0.92", 0.92, 0.92 ));
		ips.setInitParam("bh1_rAlee", new InitParam("bh1_rAlee", "r1Alee", "La intensidad del efecto aleé", 4, "0.0415", 0.0415, 0.0415 ));
		ips.setInitParam("dh1_e", new InitParam("dh1_e", "e1", "Parámetro del proceso de muerte del herbívoro 1", 1, "0.03", 0.03, 0.03 ));
		ips.setInitParam("dh1_f", new InitParam("dh1_f", "f1", "Parámetro del proceso de muerte del herbívoro 1", 1, "0", 0, 0 ));
		ips.setInitParam("dh1_carn", new InitParam("dh1_carn", "alpha13", "Parámetro del proceso de muerte del herbívoro 1 que representa muertes debidos al carnívoro", 3, "0.002", 0.002, 0.002 ));
		ips.setInitParam("dh1_epid", new InitParam("dh1_epid", "H1epidemia", "Parámetro del proceso de muerte del herbívoro 1 que representa el umbral de epidemia (número de individuos)", 0, "240", 240, 240 ));
		ips.setInitParam("h2_ini", new InitParam("h2_ini", "H2Inicial", "El número de individuos en la populación de herbívoro 2’s cuando se inicia el modelo", 0, "180", 0, 0 ));
		ips.setInitParam("comp_h2h1", new InitParam("comp_h2h1", "alpha21", "La competencia que implica el herbívoro 1 para  y el herbívoro 2", 1, "0.3", 0.3, 0.3 ));
		ips.setInitParam("bh2_b", new InitParam("bh2_b", "b2", "Parámetro del proceso de nacimiento del herbívoro 2", 3, "0.06", 0.06, 0.06 ));
		ips.setInitParam("bh2_c", new InitParam("bh2_c", "c2", "Parámetro del proceso de nacimiento del herbívoro 2", 3, "0.92", 0.92, 0.92 ));
		ips.setInitParam("bh2_rAlee", new InitParam("bh2_rAlee", "r2Alee", "La intensidad del efecto aleé", 4, "0.0415", 0.0415, 0.0415 ));
		ips.setInitParam("dh2_e", new InitParam("dh2_e", "e2", "Parámetro del proceso de muerte del herbívoro 2", 1, "0.035", 0.035, 0.035 ));
		ips.setInitParam("dh2_f", new InitParam("dh2_f", "f2", "Parámetro del proceso de muerte del herbívoro 2", 1, "0", 0, 0 ));
		ips.setInitParam("dh2_carn", new InitParam("dh2_carn", "alpha23", "Parámetro del proceso de muerte del herbívoro 2 que representa muertes debidos al carnívoro", 4, "0.0008", 0.0008, 0.0008 ));
		ips.setInitParam("dh2_epid", new InitParam("dh2_epid", "H2epidemia", "Parámetro del proceso de muerte del herbívoro 2 que representa el umbral de epidemia (número de individuos)", 0, "240", 240, 240 ));
		ips.setInitParam("c_ini", new InitParam("c_ini", "CInicial", "El número de individuos en la populación de carnívoros cuando se inicia el modelo", 0, "20", 0, 0 ));
		ips.setInitParam("alpha_ch1", new InitParam("alpha_ch1", "alpha31", "El valor alimenticio que representa el herbívoro 1 para el carnívoro", 3, "0.002", 0.002, 0.002 ));
		ips.setInitParam("alpha_ch2", new InitParam("alpha_ch2", "alpha32", "El valor alimenticio que representa el herbívoro 2 para el carnívoro", 3, "0.002", 0.002, 0.002 ));
		ips.setInitParam("bc_rAlee", new InitParam("bc_rAlee", "r3Alee", "La intensidad del efecto aleé", 4, "0.9", 0.9, 0.9 ));
		ips.setInitParam("dc_e", new InitParam("dc_e", "e3", "Parámetro del proceso de muerte del carnívoro", 1, "0.4", 0.4, 0.4 ));
		ips.setInitParam("dc_f", new InitParam("dc_f", "f3", "Parámetro del proceso de muerte del carnívore", 1, "0", 0, 0 ));
		ips.setInitParam("dc_epid", new InitParam("dc_epid", "D1epidemia", "Parámetro del proceso de muerte del carnívoro que representa el umbral de epidemia (número de individuos)", 0, "60", 60, 60 ));
		ips.setInitParam("rp_size", new InitParam("rp_size", "RP_Magnitude", "La magnitud de las perturbaciones. Número de individuos", 0, "-20", -20, -20 ));
		ips.setInitParam("rp_prob", new InitParam("rp_prob", "RP_Probabilidad", "La probabilidad de una perturbación", 0, "0", 0, 1 ));
		ips.setInitParam("fl_week", new InitParam("fl_week", "SemFlor", "El número de la semana en cada año cuando ocurre floración", 0, "24", 0, 52 ));
		ips.setInitParam("fl_lim_pol", new InitParam("fl_lim_pol", "UmbralPol", "Umbral del número de herbívoros 1 por debajo de lo cual no se polinizan las flores durante floración y (como consecuencia) no se produce suficiente fruta.", 0, "150", 150, 150 ));

		//define init params that depend on type
		switch (ipType) {
			case "H1Only":
				ips.setInitParam("h2_ini", new InitParam("h2_ini", "H2Inicial", "El número de individuos en la populación de herbívoro 2’s cuando se inicia el modelo", 0, "0", 0, 0 ));
				ips.setInitParam("c_ini", new InitParam("c_ini", "CInicial", "El número de individuos en la populación de carnívoros cuando se inicia el modelo", 0, "0", 0, 0 ));
			break;
			case "H1C":
				ips.setInitParam("h2_ini", new InitParam("h2_ini", "H2Inicial", "El número de individuos en la populación de herbívoro 2’s cuando se inicia el modelo", 0, "0", 0, 0 ));
			break;
			default:
			break;
		}
		
		//add and select init params
		SussiApp.getInitParamCol().addInitParams(ips, ipType);
		SussiApp.selInitParams(ipType);
	}
}