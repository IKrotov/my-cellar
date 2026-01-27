package com.akrotov.cellarbackendservice.application.exception

class RegistrationFailedException(
    message: String = "Registration failed",
    cause: Throwable? = null
) : RuntimeException(message, cause)
