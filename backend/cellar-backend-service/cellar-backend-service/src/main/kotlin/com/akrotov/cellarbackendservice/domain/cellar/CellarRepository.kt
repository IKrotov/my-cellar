package com.akrotov.cellarbackendservice.domain.cellar

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param

interface CellarRepository : JpaRepository<Cellar, Long> {

    @Query(value = """
        SELECT DISTINCT c.* FROM cellars c
        LEFT JOIN cellar_user cu ON c.id = cu.cellar_id
        WHERE c.owner_id = :userId 
           OR cu.user_id = :userId
    """, nativeQuery = true)
    fun findAllByUserId(@Param("userId") userId: Long): List<Cellar>
}