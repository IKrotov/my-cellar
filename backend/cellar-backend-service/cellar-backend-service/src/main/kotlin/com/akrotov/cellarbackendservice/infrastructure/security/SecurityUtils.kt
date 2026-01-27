package com.akrotov.cellarbackendservice.infrastructure.security

import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails

object SecurityUtils {
    fun getCurrentUserId(): Long? {
        val authentication = SecurityContextHolder.getContext().authentication
        return if (authentication != null && authentication.principal is CustomUserPrincipal) {
            (authentication.principal as CustomUserPrincipal).userId
        } else {
            null
        }
    }

    fun getCurrentUsername(): String? {
        val authentication = SecurityContextHolder.getContext().authentication
        return authentication?.name
    }
}

data class CustomUserPrincipal(
    val userId: Long,
    private val username: String,
    private val password: String,
    private val authorities: Collection<String>
) : UserDetails {
    override fun getAuthorities() = authorities.map { SimpleGrantedAuthority(it) }
    override fun getPassword() = password
    override fun getUsername() = username
    override fun isAccountNonExpired() = true
    override fun isAccountNonLocked() = true
    override fun isCredentialsNonExpired() = true
    override fun isEnabled() = true
}
