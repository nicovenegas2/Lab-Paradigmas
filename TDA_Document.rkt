#lang racket
; se definira el TDA de documento con la siguiente estructura de lista
; (id, autor, fechaCreacion, historial, nombre, contenido, (usuarios), (permisos de usuarios))

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")





; constuctor de un documento
; Dominio: NumeroXStringXStringXDAteXStringXString
; Recorrido: un documento
(define (documento id autor fechaC nombre contenido)(
                                                     list id autor fechaC nombre contenido '() '() ))

; extrae el id de un documento
; Dominio: Documento
; Recorrido: Numero
(define (DocumentGetId documento) (car documento))

; extrae autor de un documento
; Dominio: Documento
; Recorrido: String
(define (DocumentGetAutor documento) (list-ref documento 1))

; extrae la fecha de un documento
; Dominio: Documento
; Recorrido: Date
(define (DocumentGetDate documento) (list-ref documento 2))

; extrae el nombre de un documento
; Dominio: Documento
; Recorrido: String
(define (DocumentGetNombre documento) (list-ref documento 3))

; extrae el contenido de un documento
; Dominio: Documento
; Recorrido: String
(define (DocumentGetContent documento) (list-ref documento 4))

; extrae los usuarios de un documento
; Dominio: Documento
; Recorrido: lista de usuarios
(define (DocumentGetUsers documento) (list-ref documento 5))

; extrae los permisos de usuarios de un documento
; Dominio: Documento
; Recorrido: lista de permisos 
(define (DocumentGetPerms documento) (list-ref documento 6))



;pruebas
(define hoy (Date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))