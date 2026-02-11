package com.akrotov.cellarbackendservice.application.dto

data class CreateCellarRequest(
    var ownerId : Long?,
    val name: String
)
