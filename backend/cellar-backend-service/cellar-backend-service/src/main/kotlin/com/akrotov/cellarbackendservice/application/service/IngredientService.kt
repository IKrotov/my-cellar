package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.CreateIngredientRequest
import com.akrotov.cellarbackendservice.application.dto.IngredientResponseDto
import com.akrotov.cellarbackendservice.application.dto.UpdateIngredientRequest
import com.akrotov.cellarbackendservice.application.exception.ForbiddenException
import com.akrotov.cellarbackendservice.application.exception.NotFoundException
import com.akrotov.cellarbackendservice.application.mapper.IngredientMapper
import com.akrotov.cellarbackendservice.domain.cellar.CellarRepository
import com.akrotov.cellarbackendservice.domain.ingredient.IngredientRepository
import org.springframework.stereotype.Service

@Service
class IngredientService(
    private val ingredientRepository: IngredientRepository,
    private val cellarRepository: CellarRepository,
    private val ingredientMapper: IngredientMapper
) {

    private fun userHasAccessToCellar(userId: Long, cellarId: Long): Boolean =
        cellarRepository.findAllByUserId(userId).any { it.id == cellarId }

    fun getIngredients(userId: Long, cellarId: Long): List<IngredientResponseDto> {
        if (!userHasAccessToCellar(userId, cellarId)) throw ForbiddenException()
        val ingredients = ingredientRepository.findByCellarId(cellarId)
        return ingredientMapper.toDtoList(ingredients)
    }

    fun addIngredient(request: CreateIngredientRequest, userId: Long): IngredientResponseDto {
        if (!userHasAccessToCellar(userId, request.cellarId!!)) throw ForbiddenException()
        val savedIngredient = ingredientRepository.save(ingredientMapper.toEntity(request))
        return ingredientMapper.toDto(savedIngredient)
    }

    fun updateIngredient(request: UpdateIngredientRequest, userId: Long): IngredientResponseDto {
        if (!userHasAccessToCellar(userId, request.cellarId!!)) throw ForbiddenException()
        val ingredientFromDb = ingredientRepository.findById(request.id!!)
        if (ingredientFromDb.isEmpty) {
            throw NotFoundException("Ingredient with ID ${request.id} not found")
        }
        val ingredient = ingredientFromDb.get()
        if (ingredient.cellarId != request.cellarId) throw ForbiddenException()
        val updatedIngredient = ingredientMapper.updateEntityFromRequest(request, ingredient)
        return ingredientMapper.toDto(ingredientRepository.save(updatedIngredient))
    }

    fun deleteIngredient(userId: Long, cellarId: Long, ingredientId: Long) {
        if (!userHasAccessToCellar(userId, cellarId)) throw ForbiddenException()
        val ingredientFromDb = ingredientRepository.findById(ingredientId)
        if (ingredientFromDb.isEmpty) return
        if (ingredientFromDb.get().cellarId != cellarId) throw ForbiddenException()
        ingredientRepository.delete(ingredientFromDb.get())
    }
}