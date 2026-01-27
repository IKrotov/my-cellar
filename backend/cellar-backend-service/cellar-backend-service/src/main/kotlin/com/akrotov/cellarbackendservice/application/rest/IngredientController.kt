package com.akrotov.cellarbackendservice.application.rest

import com.akrotov.cellarbackendservice.application.dto.CreateIngredientRequest
import com.akrotov.cellarbackendservice.application.dto.IngredientResponseDto
import com.akrotov.cellarbackendservice.application.dto.UpdateIngredientRequest
import com.akrotov.cellarbackendservice.application.service.IngredientService
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
@RequestMapping("/api/v1/ingredients")
class IngredientController(
    private val ingredientService: IngredientService
) {

    @GetMapping
    fun listIngredients(@AuthenticationPrincipal userPrincipal: CustomUserPrincipal) : ResponseEntity<List<IngredientResponseDto>> {
        return ResponseEntity.ok(ingredientService.getIngredients(userPrincipal.userId))
    }

    @PostMapping
    fun createIngredient(@RequestBody request: CreateIngredientRequest,
                         @AuthenticationPrincipal userPrincipal: CustomUserPrincipal): ResponseEntity<IngredientResponseDto> {
        request.userId = userPrincipal.userId
        return ResponseEntity.ok(ingredientService.addIngredient(request))
    }

    @PutMapping("/{ingredientId}")
    fun updateIngredient(@PathVariable ingredientId: Long, @RequestBody request: UpdateIngredientRequest,
                         @AuthenticationPrincipal userPrincipal: CustomUserPrincipal) : ResponseEntity<IngredientResponseDto> {
        request.id = ingredientId
        request.userId = userPrincipal.userId
        return ResponseEntity.ok(ingredientService.updateIngredient(request))
    }

    @DeleteMapping("/{ingredientId}")
    fun deleteIngredient(@PathVariable ingredientId: Long, @AuthenticationPrincipal userPrincipal: CustomUserPrincipal){
        ingredientService.deleteIngredient(userPrincipal.userId, ingredientId)
    }
}