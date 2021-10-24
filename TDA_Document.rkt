#lang racket
; se definira el TDA de documento con la siguiente estructura de lista
; (id, autor, fechaCreacion, historial, nombre, contenido, (usuarios), (permisos de usuarios))

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")



; Funcion de apoyo que transforma numeros a string
; Dom: Numero
; Rec: String
( define (to-string numero) (format "~v" numero))


; se redefine la funcion list-update para quedar acorde con el TDA
(define Document-set list-set)



; constuctor de un documento
; Dominio: NumeroXStringXStringXDAteXStringXString
; Recorrido: un documento
(define (documento id autor fechaC nombre contenido)(
                                                     list id autor fechaC '() nombre contenido '() '() ))

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

; extrae las versiones guardadas de un documento
; Dominio: Documento
; Recorrido: lista de documentos
(define (DocumentGetVersions documento) (list-ref documento 3))

; extrae el nombre de un documento
; Dominio: Documento
; Recorrido: String
(define (DocumentGetNombre documento) (list-ref documento 4))

; extrae el contenido de un documento
; Dominio: Documento
; Recorrido: String
(define (DocumentGetContent documento) (list-ref documento 5))

; extrae los usuarios de un documento
; Dominio: Documento
; Recorrido: lista de usuarios
(define (DocumentGetUsers documento) (list-ref documento 6))

; extrae los permisos de usuarios de un documento
; Dominio: Documento
; Recorrido: lista de permisos 
(define (DocumentGetPerms documento) (list-ref documento 7))


; Funcion que Recopila toda la informacion referente a un Documento en un string
; Dominio: Documento
; Recorrido: String

(define (DocumentInfo documento) (
                                  string-append "Id: " (to-string (DocumentGetId documento)) "\n"
                                         "autor: " (DocumentGetAutor documento) "\n"
                                         "Fecha de creacion: " (DateString (DocumentGetDate documento)) "\n"
                                         "Nombre: " (DocumentGetNombre documento) "\n"
                                         "Contenido: " "\n" "\"" (DocumentGetContent documento) "\"" "\n"
                                         "usuarios compartidos: " ))

(define (DocumentAddContent documento texto) (define documento (
                                        Document-set documento 5 (
                                                           string-append (DocumentGetContent documento) texto))))

;pruebas
(define hoy (Date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))