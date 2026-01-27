package com.akrotov.cellarbackendservice.application.mapper

import com.akrotov.cellarbackendservice.application.dto.UserResponseDto
import com.akrotov.cellarbackendservice.domain.user.User
import org.mapstruct.Mapper
import org.mapstruct.Mapping

@Mapper(componentModel = "spring")
interface UserMapper {
    fun toDto(user: User): UserResponseDto
    fun toDtoList(users: List<User>): List<UserResponseDto>
}
