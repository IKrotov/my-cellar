package com.akrotov.cellarbackendservice.domain.cellar

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table

@Entity
@Table(name = "cellar_invites")
data class CellarInvite(

    @Column(name = "from", nullable = false)
    val from: Long,

    @Column(name = "to", nullable = false)
    val to: Long,

    @Column(name = "cellar_id", nullable = false)
    val cellarId: Long,

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long? = null,
){
    constructor() : this(0, 0, 0)
}
