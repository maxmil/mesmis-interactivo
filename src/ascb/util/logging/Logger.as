import ascb.util.logging.LogManager;
import ascb.util.logging.Level;

class ascb.util.logging.Logger {

  private var _sName:String;
  private var _lmInstance:LogManager;

  private function Logger(sName:String) {
    _sName = sName;
    _lmInstance = LogManager.getLogManager();
  }

  public static function getLogger(sName:String):Logger {
    var lmInstance:LogManager = LogManager.getLogManager();
    var lInstance:Logger = lmInstance.getLogger(sName);
    if(lInstance != undefined) {
      return lInstance;
    }else {
      lInstance = new Logger(sName);
      lmInstance.addLogger(lInstance);
      return lInstance;
    }
  }

  public function getName():String {
    return _sName;
  }

  public function info(sMessage:Object):Void {
	if (!_lmInstance){
		_lmInstance = LogManager.getLogManager();
	}
    _lmInstance.log({level: Level.INFO, message: sMessage.toString(), name: _sName});
  }

  public function severe(sMessage:Object):Void {
	if (!_lmInstance){
		_lmInstance = LogManager.getLogManager();
	}
    _lmInstance.log({level: Level.SEVERE, message: sMessage.toString(), name: _sName});
  }

  public function warning(sMessage:Object):Void {
	if (!_lmInstance){
		_lmInstance = LogManager.getLogManager();
	}
    _lmInstance.log({level: Level.WARNING, message: sMessage.toString(), name: _sName});
  }

  public function debug(sMessage:Object):Void {
	if (!_lmInstance){
		_lmInstance = LogManager.getLogManager();
	}
    _lmInstance.log({level: Level.DEBUG, message: sMessage.toString(), name: _sName});
  }

  public function log(nLevel:Number, sMessage:Object):Void {
	if (!_lmInstance){
		_lmInstance = LogManager.getLogManager();
	}
    _lmInstance.log({level: nLevel, message: sMessage.toString(), name: _sName});
  }

}