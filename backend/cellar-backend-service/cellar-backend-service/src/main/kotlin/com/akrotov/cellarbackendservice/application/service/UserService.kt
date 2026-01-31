package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.LoginRequest
import com.akrotov.cellarbackendservice.application.dto.LoginResponse
import com.akrotov.cellarbackendservice.application.dto.RefreshRequest
import com.akrotov.cellarbackendservice.application.dto.RefreshResponse
import com.akrotov.cellarbackendservice.application.dto.RegisterRequest
import com.akrotov.cellarbackendservice.application.dto.RegisterResponse
import com.akrotov.cellarbackendservice.application.dto.UserResponseDto
import com.akrotov.cellarbackendservice.application.exception.AuthenticationException
import com.akrotov.cellarbackendservice.application.exception.InvalidRefreshTokenException
import com.akrotov.cellarbackendservice.application.exception.RegistrationFailedException
import com.akrotov.cellarbackendservice.application.mapper.UserMapper
import com.akrotov.cellarbackendservice.domain.refreshtoken.RefreshToken
import com.akrotov.cellarbackendservice.domain.refreshtoken.RefreshTokenRepository
import com.akrotov.cellarbackendservice.domain.user.User
import com.akrotov.cellarbackendservice.domain.user.UserRepository
import com.akrotov.cellarbackendservice.infrastructure.security.JwtTokenProvider
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.security.MessageDigest
import java.security.SecureRandom
import java.time.Instant

@Service
class UserService(
    private val userDetailsService: UserDetailsService,
    private val userRepository: UserRepository,
    private val refreshTokenRepository: RefreshTokenRepository,
    private val userMapper: UserMapper,
    private val passwordEncoder: PasswordEncoder,
    private val jwtTokenProvider: JwtTokenProvider,
    @Value("\${jwt.refresh-expiration:604800000}") // 7 дней по умолчанию
    private val refreshExpirationMs: Long
) {

    fun getUsers(): List<UserResponseDto> {
        val users = userRepository.findAll()
        return userMapper.toDtoList(users)
    }

    fun login(request: LoginRequest): LoginResponse {
        val userDetails = userDetailsService.loadUserByUsername(request.login)
        if (!passwordEncoder.matches(request.password, userDetails.password)) {
            throw AuthenticationException()
        }
        val accessToken = jwtTokenProvider.generateAccessToken(userDetails)
        val refreshToken = createRefreshToken(userDetails.username)
        return LoginResponse(request.login, accessToken, refreshToken)
    }

    @Transactional
    fun register(request: RegisterRequest): RegisterResponse {
        val userFromDb = userRepository.findByLogin(request.login)
        if (userFromDb != null) {
            throw RegistrationFailedException("User ${request.login} is already registered")
        }
        val user = User(request.login, passwordEncoder.encode(request.password).toString())
        userRepository.save(user)
        val accessToken = jwtTokenProvider.generateAccessToken(user.id!!, user.login)
        val refreshToken = createRefreshToken(user.login)
        return RegisterResponse(user.login, accessToken, refreshToken)
    }

    @Transactional
    fun refreshTokens(request: RefreshRequest): RefreshResponse {
        val tokenHash = sha256(request.refreshToken)
        val stored = refreshTokenRepository.findByTokenHashAndRevokedFalse(tokenHash)
            ?: throw InvalidRefreshTokenException()
        if (stored.expiresAt.isBefore(Instant.now())) {
            throw InvalidRefreshTokenException()
        }
        val user = stored.user
        refreshTokenRepository.delete(stored)
        val newAccessToken = jwtTokenProvider.generateAccessToken(user.id!!, user.login)
        val newRefreshToken = createRefreshToken(user.login)
        return RefreshResponse(newAccessToken, newRefreshToken)
    }

    private fun createRefreshToken(login: String): String {
        val user = userRepository.findByLogin(login) ?: throw IllegalStateException("User not found: $login")
        val rawToken = generateRandomToken()
        val tokenHash = sha256(rawToken)
        val expiresAt = Instant.now().plusMillis(refreshExpirationMs)
        refreshTokenRepository.save(
            RefreshToken(user = user, tokenHash = tokenHash, expiresAt = expiresAt)
        )
        return rawToken
    }

    private fun generateRandomToken(): String {
        val bytes = ByteArray(32)
        SecureRandom().nextBytes(bytes)
        return bytes.joinToString("") { "%02x".format(it) }
    }

    private fun sha256(input: String): String {
        val digest = MessageDigest.getInstance("SHA-256")
        val hash = digest.digest(input.toByteArray(Charsets.UTF_8))
        return hash.joinToString("") { "%02x".format(it) }
    }
}
