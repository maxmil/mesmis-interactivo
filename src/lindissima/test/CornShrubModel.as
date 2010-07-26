import lindissima.LindApp;
import lindissima.model.InitParam;
import lindissima.model.InitParams;


/* Class created to test the corn model with shrubs for lindissima
 *
 * @author Max Pimm
 * @version 1.0
 * @created 06-07-2005
 */
 class lindissima.test.CornShrubModel {
	
	/*
	 * Constructor
	 * 
	 * @param ipType the type of init parameters to initialize
	 */
	public function CornShrubModel(ipType:String){
		
		//initialize the init parameters if they don't exist
		if (!LindApp.getInitParamCol().initParamsExsists(ipType)){
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
		ips.setInitParam("fnM_A", new InitParam("fnM_A", "Am", "Parámetro de f(N)m", 2, "1", 0, 2 ));
		ips.setInitParam("fnM_B", new InitParam("fnM_B", "Bm", "Parámetro de f(N)m", 2, "1", 0, 2 ));
		ips.setInitParam("fnM_TRA", new InitParam("fnM_TRA", "TRAm", "Parámetro de f(N)m", 2, "0.3", 0, 1 ));
		ips.setInitParam("fnM_TRC", new InitParam("fnM_TRC", "TRCm", "Parámetro de f(N)m", 3, "0.035", 0, 0.01 ));
		ips.setInitParam("fnM_C", new InitParam("fnM_C", "Cm", "Parámetro de f(N)m", 3, "0.018", 0, 0.1 ));
		ips.setInitParam("indCosecha", new InitParam("indCosecha", "Índice de Cosecha", "La relación entre la masa seca de maíz cosechado y el peso de grano resultante.", 2, "0.5", 0.3, 0.6 ));
		ips.setInitParam("biomasaIniM", new InitParam("biomasaIniM", "Biomasa Inicial de un maíz", "La relación entre la masa seca de maíz cosechado y el peso de grano resultante.", 2, "1", 0.2, 5 ));
		ips.setInitParam("efiCapM", new InitParam("efiCapM", "Eficacia de  captura de nitrógeno de maíz", "Eficacia de captura de nitrógeno por parte del maíz.", 2, "1", 0.1, 1 ));
		ips.setInitParam("maxConcNitM", new InitParam("maxConcNitM", "Máxima Concentración de nitrógeno en tejidos de maíz", "La máxima concentración de nitrógeno que puede aprovechar el maíz. Simplificación: Se supone que si hay nitrógeno disponible, el maíz siempre va a mantener la concentración máxima en sus tejidos.", 3, "0.016", 0, 0.02 ));
		ips.setInitParam("densM", new InitParam("densM", "Densidad de maíz", "La densidad de maíz medido en plantas/m²", 2, "4", 1, 10 ));
		ips.setInitParam("nAnual", new InitParam("nAnual", "Nitrógeno anual", "El nitrógeno que se aplica cada año medido en gramos por m². Nota: 1gm/ m² es equivalente a 10kg/hectarea.", 2, "0:0:0:0:0", 0, 15 ));
		ips.setInitParam("fnA_A", new InitParam("fnA_A", "Aa", "Parámetro de f(N)a", 2, "1", 0, 2 ));
		ips.setInitParam("fnA_B", new InitParam("fnA_B", "Ba", "Parámetro de f(N)a", 2, "1", 0, 2 ));
		ips.setInitParam("fnA_TRA", new InitParam("fnA_TRA", "TRAa", "Máxima tasa relativa de anabolismo del arbusto.", 2, "1", 0, 2 ));
		ips.setInitParam("fnA_TRC", new InitParam("fnA_TRC", "TRCa", "Máxima tasa relativa de catabolismo del arbusto.", 2, "0.2", 0.1, 0.3 ));
		ips.setInitParam("fnA_C", new InitParam("fnA_C", "Ca", "Parámetro de efecto de biomasa sobre el catabolismo del arbusto.", 4, "0.005", 0.001, 0.01 ));
		ips.setInitParam("fnA_fnMin", new InitParam("fnA_fnMin", "fNMinimo", "valor mínimo de la función f(N)a. Si el nitrógeno del suelo disponible para el arbusto genera un valor de f(N)a menor que fNMinimo entonces la diferencia se obtiene por fijación. (Simplificación: Esta fijación no tiene un costo energético para el arbusto). Rango de 0 a 1. Dónde 0 indica que no puede fijar aunque f(N) sea menor que 1 y un valor de 1 indica que se fijará tanto nitrógeno como sea necesario para que f(N) sea igual a 1.", 2, "0.5", 0, 1 ));
		ips.setInitParam("biomasaIniA", new InitParam("biomasaIniA", "Biomasa Inicial de un arbusto", "Biomasa inicial de un arbusto medido en gramos.", 2, "4", 1, 20 ));
		ips.setInitParam("efiCapA", new InitParam("efiCapA", "Eficacia de  captura de nitrógeno del arbusto", "Eficacia de captura de nitrógeno por parte del arbusto. Nota: 1 es equivalente a estar en proporción al peso de sus órganos de captura y menos de 1 significa que la captura es menos que proporcional de sus órganos de captura.", 2, "1", 0.1, 1 ));
		ips.setInitParam("maxConcNitA", new InitParam("maxConcNitA", "Máxima Concentración de nitrógeno en tejidos de arbusto", "La máxima concentración de nitrógeno que puede aprovechar el arbusto. Simplificación: Se supone que si hay nitrógeno disponible, el arbusto siempre va a mantener la concentración máxima en sus tejidos.", 3, "0.01", 0, 0.02 ));
		ips.setInitParam("indPersCob", new InitParam("indPersCob", "Índice de persistencia de la cobertura", "Parámetro de control de la persistencia de la cobertura con tiempo. Proporción de cobertura que persiste de una semana a la siguiente.", 2, "0.8", 0, 1 ));
		ips.setInitParam("acPotSurFertil", new InitParam("acPotSurFertil", "Acceso potencial a surco fértil", "La capacidad de las raíces del arbusto de llegar a la fuente de nitrógeno ubicada en el surco del maíz. Valor usado para calcular la competencia por nitrógeno entre el arbusto y maíz. Nota: 1 denota acceso potencial total y 0 sin acceso.", 2, "1", 0, 1 ));
		ips.setInitParam("indRecRaices", new InitParam("indRecRaices", "Índice de recuperación de raíces", "Parámetro de control que modula la velocidad con la que recuperan los raíces del arbusto después de una poda de raíces.", 2, "0.001", 0, 0.002 ));
		ips.setInitParam("densA", new InitParam("densA", "Densidad de arbustos", "La densidad de arbustos medido en arbustos/m².", 2, "1", 0, 2 ));
		ips.setInitParam("podasTallo", new InitParam("podasTallo", "Número de podas de tallo", "Las semanas que se realizan podas de tallo y follaje que se realiza en un ciclo cultivo.", 0, "41:93:145:197:249", 0, 1000 ));
		ips.setInitParam("podasRaiz", new InitParam("podasRaiz", "Podas de raíz", "La profundidad máxima de una poda de raíz que se realiza en un ciclo cultivo es arbitrariamente de un metro. El parámetro mide la proporción de está profundidad máxima. La poda de raíz sólo se ejecuta una vez al año.", 2, "0", 0, 1 ));
		ips.setInitParam("nInicial", new InitParam("nInicial", "Nitrógeno inicial", "La concentración de nitrógeno inicial en el suelo medido en gramos por m².", 2, "2", 0, 4 ));
		ips.setInitParam("propNLixSem", new InitParam("propNLixSem", "Proporción de nitrógeno lixiviado por semana", "La proporción del total de nitrógeno que se pierde mediante lixiviación cada semana.", 3, "0.01", 0, 0.05 ));
		ips.setInitParam("indProtCob", new InitParam("indProtCob", "Índice de protección de la cobertura", "Parámetro de control de la lixiviación de nitrógeno según la cobertura.", 2, "0.5", 0, 1 ));
		ips.setInitParam("algasIniBaja", new InitParam("algasIniBaja", "Concentración de algas inicial - baja", "La concentración de algas al principio de la temporada de lluvias en el caso de que es un año de baja concentración.", 2, "1", 0.5, 5 ));
		ips.setInitParam("algasIniAlta", new InitParam("algasIniAlta", "Concentración de algas inicial - alta", "La concentración de algas al principio de la temporada de lluvias en el caso de que es un año de alta concentración.", 2, "14", 12, 20 ));
		ips.setInitParam("probAlta", new InitParam("probAlta", "Probabilidad de año de alta concentración", "La probabilidad de que se empieza el año con una alta concentración de algas.", 2, "0.1", 0, 0.5 ));
		ips.setInitParam("fnva_c", new InitParam("fnva_c", "c", "Modula el efecto de la población sobre el proceso que limita su propio crecimiento.", 4, "0.0142", 0, 0.2 ));
		ips.setInitParam("fnva_r", new InitParam("fnva_r", "r", "Tasa intrínseca (potencial) de crecimiento de las algas.", 2, "0.5", 0, 1 ));
		ips.setInitParam("fnva_ha", new InitParam("fnva_ha", "hA", "Benevolencia competitiva de las algas sobre la vegetación acuática.", 1, "11", 6, 16 ));
		ips.setInitParam("fnva_P", new InitParam("fnva_P", "P", "Parámetro que aumenta la curvatura de la catástrofe.", 1, "12", 7, 17 ));
		ips.setInitParam("fnva_hv", new InitParam("fnva_hv", "hV", "Benevolencia competitiva de vegetación sobre algas.", 2, "0.75", 0, 1 ));
		ips.setInitParam("fnva_hn", new InitParam("fnva_hn", "hN", "Saturación de algas al nitrógeno (mas hN, menos algas).", 2, "1.66", 1, 2 ));
		ips.setInitParam("nCritAlta", new InitParam("nCritAlta", "NCritA", "Nivel de nitrógeno crítico para que el lago no se ve turbio si se empieza el año con una alta concentración de algas.", 2, "1.22", 1, 2 ));
		ips.setInitParam("nCritBaja", new InitParam("nCritBaja", "NCritB", "Nivel de nitrógeno crítico para que el lago no se ve turbio si se empieza el año con una baja concentración de algas.", 2, "2.27", 2, 3 ));
		ips.setInitParam("algasIni", new InitParam("algasIni", "Algas Inicial", "Los niveles iniciales de las algas cuando se comienza el cíclo de cultivo", 2, "0:0:0:0:0", 0, 20 ));
		ips.setInitParam("nLake", new InitParam("nLake", "NLago", "Nivel de nitrógeno en el lago.", 2, "1.22", 2, 3 ));
		ips.setInitParam("umbTurb", new InitParam("umbTurb", "UmbralTurbidez", "El umbral de la concentración de algas arriba de la cual se considera el lago turbio.", 2, "10", 5, 15 ));
		ips.setInitParam("cstM", new InitParam("cstM", "Precio de venta del maíz", "El precio en pesos que se puede vender un kilo de granos de maíz.", 2, "2", 1, 4 ));
		ips.setInitParam("ingAnRib", new InitParam("ingAnRib", "Ingreso anual de ribereño con lago claro", "El ingreso anual que espera el ribereño en el caso de que el lago está claro en la época del turismo.", 0, "32000", 25000, 50000 ));
		ips.setInitParam("cstUrea", new InitParam("cstUrea", "Precio Urea", "Costo de un costal (50kg) de fertilizante medido en pesos. Nota: 50kg de urea es equivalente a 23kg de nitrógeno.", 0, "120", 60, 160 ));
		ips.setInitParam("cstPodTallo", new InitParam("cstPodTallo", "Costo de poda de tallo", "Costo de los trabajadores adicionales requeridos para una poda de tallo, medido en pesos por poda por hectárea.", 0, "80", 60, 160 ));
		ips.setInitParam("cstPodRaiz", new InitParam("cstPodRaiz", "Costo de poda de raíz", "Costo de los trabajadores adicionales requeridos para una poda de raíz, medido en pesos por poda por hectárea. Nota: Si la poda de raíz es de x% el costo de la poda también será reflejado como x% del costo de una poda completa.", 0, "80", 60, 160 ));
		ips.setInitParam("sbsdPodTallo", new InitParam("sbsdPodTallo", "Subsidios para la poda de tallo", "Los subsidios que paga el ribereño para la poda de tallo, medido en pesos. El máximo valor que puede tomar es la del costo de la poda de tallo.", 0, "0", 0, 160 ));
		ips.setInitParam("sbsdPodRaiz", new InitParam("sbsdPodRaiz", "Subsidios para la poda de raíz", "Los subsidios que paga el ribereño para la poda de raíz, medido en pesos. El máximo valor que puede tomar es la del costo de la poda de raíz.", 0, "0", 0, 160 ));
		ips.setInitParam("benNetReqM", new InitParam("benNetReqM", "Beneficio neto promedio requerido maicero", "El promedio anual de dinero neto que requiere el maicero para poder quedarse en la región. Si su ingreso es inferior a está cantidad se supone que el sistema no es sustentable.", 0, "25000", 20000, 30000 ));
		ips.setInitParam("benNetReqR", new InitParam("benNetReqR", "Beneficio neto promedio requerido ribereño", "El promedio anual de dinero neto que requiere el ribereño para poder quedarse en la región. Si su ingreso es inferior a está cantidad se supone que el sistema no es sustentable.", 2, "25000", 20000, 30000 ));

		//define init params that depend on type
		switch (ipType) {
			case "noShrub":
				ips.setInitParam("densA", new InitParam("densA", "Densidad de arbustos", "La densidad de arbustos medido en arbustos/m².", 2, "0", 0, 2 ));
			break;
			case "fertilizer":
				ips.setInitParam("nAnual", new InitParam("nAnual", "Nitrógeno anual", "El nitrógeno que se aplica cada año medido en gramos por m². Nota: 1gm/ m² es equivalente a 10kg/hectarea.", 2, "15:15:15:15:15", 0, 15 ));
			break;
			case "rootPrune":
				ips.setInitParam("podasRaiz", new InitParam("podasRaiz", "Podas de raíz", "La profundidad máxima de una poda de raíz que se realiza en un ciclo cultivo es arbitrariamente de un metro. El parámetro mide la proporción de está profundidad máxima. La poda de raíz sólo se ejecuta una vez al año.", 2, "1", 0, 1 ));
			break;
			default:
			break;
		}
		
		//add and select init params
		LindApp.getInitParamCol().addInitParams(ips, ipType);
		LindApp.selInitParams(ipType);
	}
}