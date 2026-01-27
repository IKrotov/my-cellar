package com.akrotov.cellarbackendservice.application.exception

class ForbiddenException(
    message: String = "Forbidden",
    cause: Throwable? = null
) : RuntimeException(message, cause)