package com.akrotov.cellarbackendservice.application.dto

data class LoginResponse(
    val login: String,
    val accessToken: String,
    val refreshToken: String
)