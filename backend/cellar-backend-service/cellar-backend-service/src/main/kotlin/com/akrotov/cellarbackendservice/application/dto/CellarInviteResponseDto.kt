package com.akrotov.cellarbackendservice.application.dto

data class CellarInviteResponseDto(
    val id: Long,
    val cellarName: String,
    val inviter: String,
)
