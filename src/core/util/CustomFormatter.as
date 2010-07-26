//import ascb.util.logging.Level;
//
class core.util.CustomFormatter {
	public function format(oLogRecord:Object):String {
		//return Level.LABELS[oLogRecord.level]+":"+String(new Date())+" ("+oLogRecord.name+") : "+oLogRecord.message;
		return oLogRecord.message;
	}
}
