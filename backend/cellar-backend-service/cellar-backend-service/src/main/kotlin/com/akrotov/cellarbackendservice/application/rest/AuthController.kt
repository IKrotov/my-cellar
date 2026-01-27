package com.akrotov.cellarbackendservice.application.rest

import com.akrotov.cellarbackendservice.application.dto.LoginRequest
import com.akrotov.cellarbackendservice.application.dto.LoginResponse
import com.akrotov.cellarbackendservice.application.dto.RegisterRequest
import com.akrotov.cellarbackendservice.application.dto.RegisterResponse
import com.akrotov.cellarbackendservice.application.service.UserService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/auth")
class AuthController(
    private val userService: UserService,
) {

    @PostMapping("/login")
    fun login(@RequestBody user: LoginRequest): ResponseEntity<LoginResponse> {
        return ResponseEntity.ok(userService.login(user))
    }

    @PostMapping("/register")
    fun register(@RequestBody request: RegisterRequest): ResponseEntity<RegisterResponse> {
        return ResponseEntity.ok(userService.register(request))
    }
}