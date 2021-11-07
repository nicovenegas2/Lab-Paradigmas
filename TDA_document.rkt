#lang racket
; se definira el TDA de documento con la siguiente estructura de lista
; (id, autor, fechaCreacion, historial, nombre, contenido, (usuarios con permisos ))

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")
(require "TDA_access.rkt")

(provide to-string)
(provide documento)
(provide DocumentGetId)
(provide DocumentGetAutor)
(provide DocumentGetDate)
(provide DocumentGetVersions)
(provide DocumentGetNombre)
(provide DocumentGetContent)
(provide DocumentGetAccess)
(provide DocumentInfo)
(provide DocumentAddContent)
(provide DocumentSetAccess)
(provide DocumentAddIAccess)
(provide DocumentAddAccess)

; Funcion de apoyo que transforma numeros a string
; Dom: Numero
; Rec: String
( define (to-string numero) (format "~v" numero))


; se redefine la funcion list-update para quedar acorde con el TDA
(define Document-set list-set)



; constuctor de un documento
; Dominio: Numero X String X String X DAte X String X String
; Recorrido: un documento
(define (documento id autor fechaC nombre contenido)(
                                                     list id autor fechaC '() nombre contenido '() '() ))

; extrae el id de un documento
; Dominio: Documento
; Recorrido: Numero
(define (DocumentGetId documento) (list-ref documento 0))

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
(define (DocumentGetAccess documento) (list-ref documento 6))


(define (DocumentSetAccess documento listAccess) (Document-set documento 6 listAccess))



; Funcion que Recopila toda la informacion referente a un Documento en un string
; Dominio: Documento
; Recorrido: String

(define (DocumentInfo documento) (
                                  string-append
                                         "Id: " (to-string (DocumentGetId documento)) "\n"
                                         "autor: " (DocumentGetAutor documento) "\n"
                                         "Fecha de creacion: " (DateString (DocumentGetDate documento)) "\n"
                                         "Nombre: " (DocumentGetNombre documento) "\n"
                                         "Contenido: " "\n" "\"" (DocumentGetContent documento) "\"" "\n"
                                         "usuarios compartidos: \n"
                                         "-------------------------------------------\n"))

(define (DocumentAddContent documento texto) (
                                        Document-set documento 5 (
                                                           string-append (DocumentGetContent documento) texto)))


(define (isShared? listAccess user pos) (if (null? listAccess) -1 (
                                                                   if (equal? (accGetName (car listAccess)) user) pos  (isShared? (cdr listAccess) user (+ 1 pos)) )))

(define (DocumentAddIAccess documento access) (DocumentSetAccess documento (append (DocumentGetAccess documento) (list access)) ) )

(define (DocumentEditAccess documento user type) (DocumentSetAccess documento (list-set (DocumentGetAccess documento)  (isShared? (DocumentGetAccess documento) user 0) (accSetType (list-ref (DocumentGetAccess documento) (isShared? (DocumentGetAccess documento) user 0)) type)  )))

(define (DocumentAddAccess documento access) (if (= -1 (isShared? (DocumentGetAccess documento) (accGetName access) 0)) (DocumentAddIAccess documento access) (DocumentEditAccess documento (accGetName access) (accGetType access)) ))


;pruebas
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
(define ac1 (access "nico" #\w))
(define ac2 (access "ale" #\w))
(define ac3 (access "vic" #\w))
(define ac4 (access "loki" #\w))
(define lista (list ac1 ac2 ac3 ac4))
(define dc1 (DocumentAddIAccess DC1 ac1))
(define dc2 (DocumentAddIAccess dc1 ac2))
(define dc3 (DocumentAddIAccess dc2 ac3))