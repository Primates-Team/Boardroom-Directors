abstract class Failure {

}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthenticationFailure extends Failure {}

class TokenExpiredFailure extends Failure {}