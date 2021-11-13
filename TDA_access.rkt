#lang racket
; Se define la estructura de una acceso con el siguiente formato de lista
; (NombreUsuario, TipoAcceso)


(provide access)
(provide accGetName)
(provide accGetType)
(provide accSetType)

; constructor de un access
; Dominio: String X caracter 
; Recorrido: access
(define (access nombre caracter) (list nombre caracter))

; funcion que extrae el usuario de un access
; Dominio: access
; Recorrido: String
(define (accGetName access) (car access))

; funcion que extrae el tipo de acceso
; Dominio: access
; Recorrido: caracter 
(define (accGetType access) (list-ref access 1))

; funcion que edita el tipo de acceso a un access
; Dominio: access X caracter 
; Recorrido: access
(define (accSetType access type) (list-set access 1 type))

