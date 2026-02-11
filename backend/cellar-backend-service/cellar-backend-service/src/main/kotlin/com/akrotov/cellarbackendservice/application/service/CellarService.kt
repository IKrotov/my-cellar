package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.CellarResponseDto
import com.akrotov.cellarbackendservice.application.dto.CreateCellarRequest
import com.akrotov.cellarbackendservice.application.dto.UpdateCellarRequest
import com.akrotov.cellarbackendservice.application.exception.ForbiddenException
import com.akrotov.cellarbackendservice.application.exception.NotFoundException
import com.akrotov.cellarbackendservice.application.mapper.CellarMapper
import com.akrotov.cellarbackendservice.domain.cellar.CellarRepository
import org.springframework.stereotype.Service

@Service
class CellarService(
    private val cellarRepository: CellarRepository,
    private val cellarMapper: CellarMapper
) {

    fun getCellars(userId: Long): List<CellarResponseDto> {
        val cellars = cellarRepository.findAllByUserId(userId)
        return cellarMapper.toDtoList(cellars)
    }

    fun addCellar(request: CreateCellarRequest): CellarResponseDto {
        val cellar = cellarMapper.toEntity(request)
        val savedCellar = cellarRepository.save(cellar)
        return cellarMapper.toDto(savedCellar)
    }

    fun updateCellar(request: UpdateCellarRequest): CellarResponseDto {
        val cellarFromDb = cellarRepository.findById(request.id!!)
        if (cellarFromDb.isEmpty) {
            throw NotFoundException("Cellar with ID ${request.id} not found")
        }
        val cellar = cellarFromDb.get()
        if (cellar.ownerId != request.userId) {
            throw ForbiddenException()
        }
        val updatedCellar = cellarMapper.updateEntityFromRequest(request, cellar)
        return cellarMapper.toDto(cellarRepository.save(updatedCellar))
    }

    fun deleteCellar(userId: Long, cellarId: Long) {
        val cellarFromDb = cellarRepository.findById(cellarId)
        if (cellarFromDb.isEmpty) {
            return
        }
        if (cellarFromDb.get().ownerId != userId) {
            throw ForbiddenException()
        }
        cellarRepository.delete(cellarFromDb.get())
    }
}