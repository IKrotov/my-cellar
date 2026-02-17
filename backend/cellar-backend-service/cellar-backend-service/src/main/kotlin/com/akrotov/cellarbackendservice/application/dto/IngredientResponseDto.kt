package com.akrotov.cellarbackendservice.application.dto

import com.akrotov.cellarbackendservice.domain.ingredient.IngredientStockStatus
import com.akrotov.cellarbackendservice.domain.ingredient.IngredientType
import java.time.Instant

data class IngredientResponseDto(
    val id: Long?,
    val name: String,
    val type: IngredientType,
    val status: IngredientStockStatus?,
    val amount: Int?,
    val createdAt: Instant,
    val updatedAt: Instant,
)
