package com.akrotov.cellarbackendservice.domain.ingredient

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EnumType
import jakarta.persistence.Enumerated
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table

@Table(name = "ingredients")
@Entity
data class Ingredient(

    @Column(name = "user_id", nullable = false)
    val userId: Long,

    @Column(name = "name", nullable = false)
    val name: String,

    @Column(name = "type", nullable = false)
    @Enumerated(EnumType.STRING)
    val type: IngredientType,

    @Column(name = "status", nullable = false)
    @Enumerated(EnumType.STRING)
    val status: IngredientStockStatus? = IngredientStockStatus.NONE,

    @Column(name = "amount", nullable = true)
    val amount: Int? = null,

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
) {
    constructor() : this(0, "", IngredientType.UNKNOWN)
}