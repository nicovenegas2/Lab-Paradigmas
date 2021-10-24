#lang racket
; Se definira el tda usuario con los siguientes elementos
; (nombre, contraseña)
; se tomara en consideracion que los usuarios siempren se almacenaran en listas para funciones de busqueda


(provide usuario)
(provide getUser)
(provide getPass)
(provide user?)
(provide userName?)
(provide userLog?)

; Constructor de un usuario
; Dom: StringXString
; Rec: usuario
(define (usuario user cont) (
                             list user cont))

; obtencion del nombre de un usuario
; Dom: usuario
; Rec: String
(define (getUser usuario) (car usuario))

; obtencion de la contraseña de un usuario
; Dom: usuario
; Rec: String
(define (getPass usuario) (cdr usuario))

; comprobacion de si es un usuario o no
; Dom: SupuestoUser
; Rec: Boolean
(define (user? usuario) (
                         if (= (length usuario )2)
                            (andmap string? usuario) #f))

; verificar si el nombre de usuario es igual un string
; Dom: usuarioXString
; Rec: Boolean
(define (userName? usuario texto)(= texto (getUser usuario)))

; Comprobar si un user y un password entregado concide con el usuario
; Dom: usuarioXStringXString
; Rec: Boolean
(define (userLog? usuario user pass) (and
                                     (= user (getUser usuario) )
                                     (= pass (getPass usuario))))



