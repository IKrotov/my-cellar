package com.akrotov.cellarbackendservice.infrastructure.security

import com.akrotov.cellarbackendservice.domain.user.UserRepository
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class CustomUserDetailsService(
    private val userRepository: UserRepository
) : UserDetailsService {

    override fun loadUserByUsername(username: String): CustomUserPrincipal {
        val user = userRepository.findByLogin(username)
            ?: throw UsernameNotFoundException("User not found with login: $username")

        return CustomUserPrincipal(
            userId = user.id ?: throw IllegalStateException("User ID cannot be null"),
            username = user.login,
            password = user.password,
            authorities = listOf("ROLE_USER")
        )
    }
}
