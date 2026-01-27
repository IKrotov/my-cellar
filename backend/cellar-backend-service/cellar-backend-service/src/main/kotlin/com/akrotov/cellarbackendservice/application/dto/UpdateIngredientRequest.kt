package com.akrotov.cellarbackendservice.application.dto

import com.akrotov.cellarbackendservice.domain.ingredient.IngredientStockStatus
import com.akrotov.cellarbackendservice.domain.ingredient.IngredientType

data class UpdateIngredientRequest(
    var id: Long? = null,
    var userId : Long? = null,
    val name: String,
    val type: IngredientType,
    val status: IngredientStockStatus,
    val amount: Int?
)