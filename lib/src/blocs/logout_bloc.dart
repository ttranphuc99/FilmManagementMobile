import 'package:film_management/src/blocs/authentication_bloc.dart';
import 'package:film_management/src/repositories/authenticate_repo.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

class LogoutBloc {
  final AuthRepository _authRepository = AuthRepository();

  final PublishSubject<bool> _isLoading = PublishSubject<bool>();
  final PublishSubject<bool> _processResult = PublishSubject<bool>();
  final PublishSubject<String> _processMessage = PublishSubject<String>();

  Observable<bool> get isLoading => _isLoading.stream;
  Observable<bool> get processResult => _processResult.stream;
  Observable<String> get processMessage => _processMessage.stream;

  void dispose() {
    _isLoading.close();
    _processResult.close();
    _processMessage.close();
  }

  void processLogout() async {
    _isLoading.sink.add(true);

    try {
      var authBloc = AuthenticationBloc();
      var account = await authBloc.getProfile();

      Response response = await _authRepository.logout(account.token);

      switch (response.statusCode) {
        case 200: 
          _processResult.sink.add(true);
          authBloc.closeSession();
          break;
        case 500:
          _processResult.sink.add(false);
          _processMessage.sink.add("Server process failed!");
          break;
      }

      _isLoading.sink.add(false);
    } catch (e) {
      _processResult.sink.add(false);
      _processResult.sink.add(false);
      _processMessage.sink.add("Processing failed!");
    }
  }
}