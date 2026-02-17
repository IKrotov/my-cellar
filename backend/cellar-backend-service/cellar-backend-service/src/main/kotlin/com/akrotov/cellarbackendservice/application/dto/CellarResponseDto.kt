package com.akrotov.cellarbackendservice.application.dto

import java.time.Instant

data class CellarResponseDto(
    val id: Long?,
    val name: String,
    val createdAt: Instant,
    val updatedAt: Instant,
)
