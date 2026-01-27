package com.akrotov.cellarbackendservice.application.exception

class AuthenticationException (
    message: String = "Authentication failed",
    cause: Throwable? = null
) : RuntimeException(
    message,
    cause
)