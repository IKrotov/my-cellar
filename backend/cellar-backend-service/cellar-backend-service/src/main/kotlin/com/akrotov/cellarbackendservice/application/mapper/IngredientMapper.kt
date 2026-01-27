package com.akrotov.cellarbackendservice.application.mapper

import com.akrotov.cellarbackendservice.application.dto.CreateIngredientRequest
import com.akrotov.cellarbackendservice.application.dto.IngredientResponseDto
import com.akrotov.cellarbackendservice.application.dto.UpdateIngredientRequest
import com.akrotov.cellarbackendservice.domain.ingredient.Ingredient
import org.mapstruct.Mapper
import org.mapstruct.Mapping

@Mapper(componentModel = "spring")
interface IngredientMapper {
    fun toEntity(dto: CreateIngredientRequest): Ingredient {
        return Ingredient(
            userId = dto.userId ?: throw IllegalArgumentException("userId cannot be null"),
            name = dto.name,
            type = dto.type,
            status = dto.status,
            amount = dto.amount,
            id = null
        )
    }
    
    fun toDto(ingredient: Ingredient): IngredientResponseDto
    fun toDtoList(ingredients: List<Ingredient>): List<IngredientResponseDto>
    
    fun updateEntityFromRequest(request: UpdateIngredientRequest, ingredient: Ingredient): Ingredient {
        return Ingredient(
            userId = ingredient.userId,
            name = request.name,
            type = request.type,
            status = request.status,
            amount = request.amount,
            id = ingredient.id
        )
    }
}
