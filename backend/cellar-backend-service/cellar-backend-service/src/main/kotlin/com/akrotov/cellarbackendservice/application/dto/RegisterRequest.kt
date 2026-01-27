package com.akrotov.cellarbackendservice.application.dto

data class RegisterRequest (
    val login: String,
    val password: String
) {
}