#lang racket

; Se define el tda de una version con la siguiente implementacion de lista
; (numero, fecha cambio , contenido)

(provide version)
(provide verGetNumber)
(provide verGetNumber)
(provide verGetContent)


; constructor de una version
; Dom: Numero X date X content
; Rec: version
(define (version num date content) (list num date content))

; funcion que extrae el numero de una version
; Dom: version
; Rec: Numero
(define (verGetNumber version) (list-ref version 0))

; funcion que extrae la fecha de una version
; Dom: version
; Rec: date
(define (verGetDate version) (list-ref version 1))

; funcion que extrae el numero de una version
; Dom: version
; Rec: content
(define (verGetContent version) (list-ref version 2))