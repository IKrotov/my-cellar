package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.LoginRequest
import com.akrotov.cellarbackendservice.application.dto.LoginResponse
import com.akrotov.cellarbackendservice.application.dto.RegisterRequest
import com.akrotov.cellarbackendservice.application.dto.RegisterResponse
import com.akrotov.cellarbackendservice.application.dto.UserResponseDto
import com.akrotov.cellarbackendservice.application.exception.AuthenticationException
import com.akrotov.cellarbackendservice.application.exception.RegistrationFailedException
import com.akrotov.cellarbackendservice.application.mapper.UserMapper
import com.akrotov.cellarbackendservice.domain.user.User
import com.akrotov.cellarbackendservice.domain.user.UserRepository
import com.akrotov.cellarbackendservice.infrastructure.security.JwtTokenProvider
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class UserService(
    private val userDetailsService: UserDetailsService,
    private val userRepository: UserRepository,
    private val userMapper: UserMapper,
    private val passwordEncoder: PasswordEncoder,
    private val jwtTokenProvider: JwtTokenProvider
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

        val token = jwtTokenProvider.generateToken(userDetails)

        return LoginResponse(request.login, token)
    }

    @Transactional
    fun register(request: RegisterRequest): RegisterResponse {
        val userFromDb = userRepository.findByLogin(request.login)
        if (userFromDb != null) {
            throw RegistrationFailedException("User ${request.login} is already registered")
        }

        val user = User(request.login, passwordEncoder.encode(request.password).toString())
        userRepository.save(user)

        val token = jwtTokenProvider.generateToken(user.id!!, user.login)

        return RegisterResponse(user.login, token)

    }
}