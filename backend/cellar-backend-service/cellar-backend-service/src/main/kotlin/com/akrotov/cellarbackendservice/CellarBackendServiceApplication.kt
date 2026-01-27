package com.akrotov.cellarbackendservice

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class CellarBackendServiceApplication

fun main(args: Array<String>) {
    runApplication<CellarBackendServiceApplication>(*args)
}
