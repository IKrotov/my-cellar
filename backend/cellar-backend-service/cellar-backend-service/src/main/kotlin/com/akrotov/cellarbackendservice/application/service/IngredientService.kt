package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.CreateIngredientRequest
import com.akrotov.cellarbackendservice.application.dto.IngredientResponseDto
import com.akrotov.cellarbackendservice.application.dto.UpdateIngredientRequest
import com.akrotov.cellarbackendservice.application.exception.ForbiddenException
import com.akrotov.cellarbackendservice.application.exception.NotFoundException
import com.akrotov.cellarbackendservice.application.mapper.IngredientMapper
import com.akrotov.cellarbackendservice.domain.ingredient.IngredientRepository
import org.springframework.stereotype.Service

@Service
class IngredientService(
    private val ingredientRepository: IngredientRepository,
    private val ingredientMapper: IngredientMapper
) {

    fun getIngredients(userId: Long): List<IngredientResponseDto> {
        val ingredients = ingredientRepository.findIngredientsByUserId(userId)
        return ingredientMapper.toDtoList(ingredients)
    }

    fun addIngredient(request: CreateIngredientRequest): IngredientResponseDto {
        val savedIngredient = ingredientRepository.save(ingredientMapper.toEntity(request))
        return ingredientMapper.toDto(savedIngredient)
    }

    fun updateIngredient(request: UpdateIngredientRequest): IngredientResponseDto {
        val ingredientFromDb = ingredientRepository.findById(request.id!!)
        if (ingredientFromDb.isEmpty) {
            throw NotFoundException("Ingredient with ID ${request.id} not found")
        }
        if (ingredientFromDb.get().userId != request.userId) {
            throw ForbiddenException()
        }

        val updatedIngredient = ingredientMapper.updateEntityFromRequest(request, ingredientFromDb.get())

        return ingredientMapper.toDto(ingredientRepository.save(updatedIngredient))
    }

    fun deleteIngredient(userId: Long, ingredientId: Long) {
        val ingredientFromDb = ingredientRepository.findById(ingredientId)
        if (ingredientFromDb.isEmpty) {
            return
        }
        if (ingredientFromDb.get().userId != userId) {
            throw ForbiddenException()
        }
        ingredientRepository.delete(ingredientFromDb.get())
    }
}