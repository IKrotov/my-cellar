package com.akrotov.cellarbackendservice.domain.ingredient

import org.springframework.data.jpa.repository.JpaRepository

interface IngredientRepository : JpaRepository<Ingredient, Long> {

    fun findByCellarId(cellarId: Long): List<Ingredient>
}