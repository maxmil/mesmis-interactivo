import ascb.util.logging.Handler;

class ascb.util.logging.TraceHandler extends Handler {
	
  private var _fmtInstance:Object;
  private var _nLevel:Number;

  public function TraceHandler(fmtInstance:Object, nLevel:Number) {
    _fmtInstance = fmtInstance;
    _nLevel = nLevel;
  }

  public function log(oLogRecord:Object):Void {
    if(oLogRecord.level <= _nLevel) {
      trace(_fmtInstance.format(oLogRecord));
    }
  }

}