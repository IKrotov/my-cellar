package com.akrotov.cellarbackendservice.domain.ingredient

import org.springframework.data.jpa.repository.JpaRepository

interface IngredientRepository : JpaRepository<Ingredient, Long> {

    fun findIngredientsByUserId(userId: Long): List<Ingredient>
}