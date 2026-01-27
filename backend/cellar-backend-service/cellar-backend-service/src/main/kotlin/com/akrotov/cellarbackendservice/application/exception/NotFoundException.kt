package com.akrotov.cellarbackendservice.application.exception

class NotFoundException (
     message: String,
     cause: Throwable? = null
) : RuntimeException(message, cause)