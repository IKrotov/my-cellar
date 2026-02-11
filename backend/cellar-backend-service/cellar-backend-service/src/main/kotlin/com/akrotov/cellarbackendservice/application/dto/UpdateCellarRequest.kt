package com.akrotov.cellarbackendservice.application.dto

data class UpdateCellarRequest(
    var id: Long? = null,
    var userId: Long? = null,
    val name: String
)
