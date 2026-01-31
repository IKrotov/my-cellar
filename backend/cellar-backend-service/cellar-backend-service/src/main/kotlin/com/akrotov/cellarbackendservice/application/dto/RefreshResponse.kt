package com.akrotov.cellarbackendservice.application.dto

data class RefreshResponse(
    val accessToken: String,
    val refreshToken: String
)
