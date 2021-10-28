#lang racket

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")
(require "TDA_document.rkt")
(require "encriptar.rkt")
(require "TDA_paradigmaDocs.rkt")



(define (agregarUsuarioNatural lista usuario cond result)(
                      if (null? lista)
                         (if (= cond 0)
                            (agregarUsuarioNatural lista usuario 1 (cons usuario result))
                            result
                          )
                         (if (userName? usuario (getUser (car lista)))
                             (cons (car lista)(agregarUsuarioNatural (cdr lista) usuario 1 result))
                             (cons (car lista)(agregarUsuarioNatural (cdr lista) usuario cond result))
                          )
                         )
                      
  )

(define (register paradigmadocs date username password) (
                                                         user-set paradigmadocs 2 (
                                                                                   agregarUsuarioNatural (ParaGetUsers paradigmadocs)
                                                                                                         (usuario username password)
                                                                                                         0 user-empty )))

(define (create paradigmadocs nombre contenido) (
                                                 if (loged? paradigmadocs) paradigmadocs (ParaAddDocument paradigmadocs (documento (+ 1 (ParaLastId paradigmadocs))
                                                                                                      (getUser (ParaGetLoged paradigmadocs))
                                                                                                      (date 00 00 00) contenido))))





;pruebas
(define us1 (usuario "nicovenegas" "1234"))
(define word (paradigmadocs "word" (date 24 10 2021) encryptFn encryptFn))
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
(define nico (usuario "nico" 1234))
(define vic (usuario "vic" 1234444))
(define listalista (list (usuario "nico" 1234)))
(define word1 (register word hoy "nico" 1234))