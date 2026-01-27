package com.akrotov.cellarbackendservice.domain.user

import org.springframework.data.jpa.repository.JpaRepository


interface UserRepository : JpaRepository<User, Long> {

    fun findByLogin(login: String): User?
}