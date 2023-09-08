enum ModuleType{
  Message,
  Login,
  Profile,
  LiveRoom,
  Contacts,
  Discover,
}
abstract class IModuleRouter{

}
class RouterManager {

  static RouterManager? _instance;
  static RouterManager get instance {
    return _instance ??= RouterManager();
  }
  Map<ModuleType, IModuleRouter> _moduleMap = {};

  void addModuleRouter(ModuleType type, IModuleRouter module) {
    _moduleMap[type] = module;
  }
  void removeModuleRouter(ModuleType type){

    _moduleMap.remove(type);
  }

  IModuleRouter? getModuleRouter(ModuleType type){
    return _moduleMap[type];
  }

}
