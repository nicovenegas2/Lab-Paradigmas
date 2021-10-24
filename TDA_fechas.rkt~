#lang racket
; se define de siguiente forma una representacion de fechas
; (dia, mes año) --> (String, String, String)


; constuctor de una fecha
; Dominio: NumeroXNumeroXNumero
; Recorrido: una fecha
(define (Date dia mes agno)(list (format "~v" dia) (format "~v" mes) (format "~v" agno)))


; extrae el dia de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (getDia Date) (car Date))

; extrae el mes de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (getMes Date) (list-ref Date 1))

; extrae el año de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (getAgno Date) (list-ref Date 2))


; extrae la fecha completa de un Date como un String
; Dominio: Date
; Recorrido: String
(define (DateString Date) (
                          string-append (getDia Date) " " (getMes Date) " "(getAgno Date)))