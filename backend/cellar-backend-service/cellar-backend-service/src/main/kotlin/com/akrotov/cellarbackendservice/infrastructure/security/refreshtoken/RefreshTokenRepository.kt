package com.akrotov.cellarbackendservice.infrastructure.security.refreshtoken

import org.springframework.data.jpa.repository.JpaRepository

interface RefreshTokenRepository : JpaRepository<RefreshToken, Long> {

    fun findByTokenHashAndRevokedFalse(tokenHash: String): RefreshToken?

    fun deleteByUser_Id(userId: Long)
}
