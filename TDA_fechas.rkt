#lang racket
; se define de siguiente forma una representacion de fechas
; (dia, mes año) --> (String, String, String)

(provide Date)
(provide DateGetDia)
(provide DategetMes)
(provide DateGetAgno)
(provide DateString)

; constuctor de una fecha
; Dominio: NumeroXNumeroXNumero
; Recorrido: una fecha
(define (Date dia mes agno)(list (format "~v" dia) (format "~v" mes) (format "~v" agno)))


; extrae el dia de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (DateGetDia Date) (car Date))

; extrae el mes de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (DategetMes Date) (list-ref Date 1))

; extrae el año de una Fecha(Date)
; Dominio: Date
; Recorrido: String
(define (DateGetAgno Date) (list-ref Date 2))


; extrae la fecha completa de un Date como un String
; Dominio: Date
; Recorrido: String
(define (DateString Date) (
                          string-append (DateGetDia Date) " " (DategetMes Date) " "(DateGetAgno Date)))