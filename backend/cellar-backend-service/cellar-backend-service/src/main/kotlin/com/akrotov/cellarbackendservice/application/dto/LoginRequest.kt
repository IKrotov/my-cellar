package com.akrotov.cellarbackendservice.application.dto

data class LoginRequest(
    val login: String,
    val password: String
) {
}