package com.akrotov.cellarbackendservice.domain.cellar

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table

@Entity
@Table(name = "cellars")
data class Cellar(

    @Column(name = "owner_id", nullable = false)
    val ownerId: Long,

    @Column(name = "name", nullable = false)
    val name: String,

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
){
    constructor() : this(0, "")
}
