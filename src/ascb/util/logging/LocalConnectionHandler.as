class ascb.util.logging.LocalConnectionHandler {

  private var _lcWindow:LocalConnection;
  private var _fmtInstance:Object;
  private var _nLevel:Number;

  public function LocalConnectionHandler(fmtInstance:Object, nLevel:Number){
    _fmtInstance = fmtInstance;
    _nLevel = nLevel;
    _lcWindow = new LocalConnection();
  }

  public function log(oLogRecord:Object):Void {
	if(oLogRecord.level <= _nLevel) {
      _lcWindow.send("_logger", "onMessage", _fmtInstance.format(oLogRecord));
    }
    
  }

}