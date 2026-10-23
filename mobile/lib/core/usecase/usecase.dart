/// Kontrak dasar usecase pada domain layer.
///
/// Setiap usecase hanya punya satu tugas dan dipanggil seperti fungsi:
/// `final user = await loginUser(LoginParams(email: e, password: p));`
///
/// Kegagalan dilempar sebagai exception dan ditangkap di BLoC, yang lalu
/// mengubahnya menjadi state gagal (M9.1).
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

/// Dipakai usecase yang tidak butuh parameter, mis. `logout(const NoParams())`.
class NoParams {
  const NoParams();
}
