package com.akrotov.cellarbackendservice.domain.cellar

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface CellarInviteRepository : JpaRepository<CellarInvite, Long> {

    fun findAllByTo(to: Long): List<CellarInvite>
}