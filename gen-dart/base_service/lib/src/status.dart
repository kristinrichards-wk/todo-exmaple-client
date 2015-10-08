/**
 * Autogenerated by Thrift Compiler (1.0.0-dev)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */
library base_service.src.status;

class Status {
  static const int STARTING = 1;
  static const int STOPPING = 2;
  static const int HEALTHY = 3;
  static const int DEPENDENCY_DOWN = 4;
  static const int ERROR = 5;

  static final Set<int> VALID_VALUES = new Set.from([
    STARTING
    , STOPPING
    , HEALTHY
    , DEPENDENCY_DOWN
    , ERROR
  ]);
  static final Map<int, String> VALUES_TO_NAMES = {
    STARTING: 'STARTING'
    , STOPPING: 'STOPPING'
    , HEALTHY: 'HEALTHY'
    , DEPENDENCY_DOWN: 'DEPENDENCY_DOWN'
    , ERROR: 'ERROR'
  };
}
