package com.akrotov.cellarbackendservice.domain.refreshtoken

import org.springframework.data.jpa.repository.JpaRepository

interface RefreshTokenRepository : JpaRepository<RefreshToken, Long> {

    fun findByTokenHashAndRevokedFalse(tokenHash: String): RefreshToken?

    fun deleteByUser_Id(userId: Long)
}
