package com.akrotov.cellarbackendservice.application.mapper

import com.akrotov.cellarbackendservice.application.dto.CellarResponseDto
import com.akrotov.cellarbackendservice.application.dto.CreateCellarRequest
import com.akrotov.cellarbackendservice.application.dto.UpdateCellarRequest
import com.akrotov.cellarbackendservice.domain.cellar.Cellar
import org.mapstruct.Mapper

@Mapper(componentModel = "spring")
interface CellarMapper {

    fun toEntity(dto: CreateCellarRequest): Cellar {
        return Cellar(
            ownerId = dto.ownerId ?: throw IllegalArgumentException("ownerId cannot be null"),
            name = dto.name,
            id = null
        )
    }

    fun toDto(cellar: Cellar): CellarResponseDto
    fun toDtoList(cellars: List<Cellar>): List<CellarResponseDto>

    fun updateEntityFromRequest(request: UpdateCellarRequest, cellar: Cellar): Cellar {
        return Cellar(
            ownerId = cellar.ownerId,
            name = request.name,
            id = cellar.id
        )
    }
}