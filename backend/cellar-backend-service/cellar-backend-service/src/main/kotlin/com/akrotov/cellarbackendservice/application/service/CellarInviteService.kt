package com.akrotov.cellarbackendservice.application.service

import com.akrotov.cellarbackendservice.application.dto.CellarInviteResponseDto
import com.akrotov.cellarbackendservice.domain.cellar.Cellar
import com.akrotov.cellarbackendservice.domain.cellar.CellarInviteRepository
import com.akrotov.cellarbackendservice.domain.cellar.CellarRepository
import com.akrotov.cellarbackendservice.domain.user.User
import com.akrotov.cellarbackendservice.domain.user.UserRepository
import com.akrotov.cellarbackendservice.infrastructure.security.CustomUserPrincipal
import org.springframework.stereotype.Service
import java.util.stream.Collectors

@Service
class CellarInviteService(
    private val cellarInviteRepository: CellarInviteRepository,
    private val cellarRepository: CellarRepository,
    private val userRepository: UserRepository
) {

    fun getAllInvites(userPrincipal: CustomUserPrincipal) : List<CellarInviteResponseDto> {
        val invites = cellarInviteRepository.findAllByTo(userPrincipal.userId)
        val userIds = invites.map { invite -> invite.from }
        val cellarsIds = invites.map { invite -> invite.cellarId }

        val userIdToUser : Map<Long, User> = userRepository.findAllById(userIds).associateBy { user -> user.id!! }
        val cellarIdToCellar : Map<Long, Cellar> = cellarRepository.findAllById(cellarsIds).associateBy { cellar -> cellar.id!! }

        return invites.map { i -> CellarInviteResponseDto(i.id!!,
            cellarIdToCellar[i.cellarId]!!.name,
            userIdToUser[i.from]!!.login) }
            .toList()
    }
}