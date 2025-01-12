import 'package:jio_inet/jio_inet.dart';
import 'package:mockito/annotations.dart';

/// Using Mockito, create a mock class for Connectivity
// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([JioInet])
import './mock_inet.mocks.dart';

/// This is mock version of the JioInet.
/// get instance of MockJioInet before starting the test.
late final MockJioInet mockInet;

/// following test will be perform for mock connectivity
const List<INetResult> kResultNone = [INetResult.none];
const List<INetResult> kResultMobile = [INetResult.mobile];
const List<INetResult> kResultWifi = [INetResult.wifi];
