#lang racket
; Se define la estructura de una acceso con el siguiente formato de lista
; (NombreUsuario, TipoAcceso)




(define (access nombre caracter) (list nombre caracter))


(define (accGetName access) (car access))

(define (accGetType access) (list-ref access 1))

(define (accSetType acces type) (list-set access 1 type))

