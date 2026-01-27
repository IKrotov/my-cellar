package com.akrotov.cellarbackendservice.application.rest

import com.akrotov.cellarbackendservice.application.dto.UserResponseDto
import com.akrotov.cellarbackendservice.application.service.UserService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/users")
class UserController(
    private val userService: UserService,
) {

    @GetMapping
    fun listUsers(): ResponseEntity<List<UserResponseDto>> {
        return ResponseEntity.ok(userService.getUsers())
    }
}