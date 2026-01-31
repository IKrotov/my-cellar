package com.akrotov.cellarbackendservice.application.exception

class InvalidRefreshTokenException(
    message: String = "Invalid or expired refresh token",
    cause: Throwable? = null
) : RuntimeException(message, cause)
