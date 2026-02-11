package com.akrotov.cellarbackendservice.application.rest

import com.akrotov.cellarbackendservice.application.dto.CellarInviteResponseDto
import com.akrotov.cellarbackendservice.application.dto.CellarResponseDto
import com.akrotov.cellarbackendservice.application.dto.CreateCellarRequest
import com.akrotov.cellarbackendservice.application.dto.UpdateCellarRequest
import com.akrotov.cellarbackendservice.application.service.CellarInviteService
import com.akrotov.cellarbackendservice.application.service.CellarService
import com.akrotov.cellarbackendservice.infrastructure.security.CustomUserPrincipal
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/cellars")
class CellarController(
    private val cellarService: CellarService,
    private val cellarInviteService: CellarInviteService
) {

    @GetMapping
    fun listCellars(@AuthenticationPrincipal userPrincipal: CustomUserPrincipal): ResponseEntity<List<CellarResponseDto>> {
        return ResponseEntity.ok(cellarService.getCellars(userPrincipal.userId))
    }

    @PostMapping
    fun createCellar(
        @RequestBody request: CreateCellarRequest,
        @AuthenticationPrincipal userPrincipal: CustomUserPrincipal
    ): ResponseEntity<CellarResponseDto> {
        request.ownerId = userPrincipal.userId
        return ResponseEntity.ok(cellarService.addCellar(request))
    }

    @PutMapping("/{cellarId}")
    fun updateCellar(
        @PathVariable cellarId: Long,
        @RequestBody request: UpdateCellarRequest,
        @AuthenticationPrincipal userPrincipal: CustomUserPrincipal
    ): ResponseEntity<CellarResponseDto> {
        request.id = cellarId
        request.userId = userPrincipal.userId
        return ResponseEntity.ok(cellarService.updateCellar(request))
    }

    @DeleteMapping("/{cellarId}")
    fun deleteCellar(
        @PathVariable cellarId: Long,
        @AuthenticationPrincipal userPrincipal: CustomUserPrincipal
    ) {
        cellarService.deleteCellar(userPrincipal.userId, cellarId)
    }

    @GetMapping("/invites")
    fun listInvites(@AuthenticationPrincipal userPrincipal: CustomUserPrincipal): ResponseEntity<List<CellarInviteResponseDto>> {
        return ResponseEntity.ok(cellarInviteService.getAllInvites(userPrincipal))
    }
}