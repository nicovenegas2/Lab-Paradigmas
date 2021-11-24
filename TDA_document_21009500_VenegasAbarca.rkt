#lang racket
; se definira el TDA de documento con la siguiente estructura de lista
; (id, autor, fechaCreacion, (versiones), nombre, contenido, (usuarios con permisos ))

(require "TDA_fechas_21009500_VenegasAbarca.rkt")
(require "TDA_usuarios_21009500_VenegasAbarca.rkt")
(require "TDA_access_21009500_VenegasAbarca.rkt")
(require "TDA_version_21009500_VenegasAbarca.rkt")

(provide (all-defined-out))

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

; extrae los accesos de un documento
; Dominio: Documento
; Recorrido: lista de accesos
(define (DocumentSetAccess documento listAccess) (Document-set documento 6 listAccess))



; Funcion que Recopila toda la informacion referente a un Documento en un string
; Dominio: Documento
; Recorrido: String

(define (DocumentInfo documento FDe) (
                                  string-append
                                         "Id: " (to-string (DocumentGetId documento)) "\n"
                                         "autor: " (DocumentGetAutor documento) "\n"
                                         "Fecha de creacion: " (DateString (DocumentGetDate documento)) "\n"
                                         "Nombre: " (DocumentGetNombre documento) "\n"
                                         "Contenido: " "\n" "\"" (FDe (DocumentGetContent documento)) "\"" "\n"
                                         "usuarios compartidos: \n"
                                         (string-join (map accInfo (DocumentGetAccess documento)))
                                         "-------------------------------------------\n"))


; funcion que añade texto al final de un documento
; Dominio: Documento X String
; Recorrido: Documento
(define (DocumentAddContent documento texto FEn FDe) (
                                        Document-set documento 5 (
                                                           FEn(string-append (FDe(DocumentGetContent documento)) texto))))


; funcion que revisa si un usuario esta en una lista de acceso, entrega la posicion en la que este y -1 si no se encuentra
; Dominio:  listaAccesos X usuario X Numero
; Recorrido: Numero
(define (isShared? listAccess user pos) (if (null? listAccess) -1 (
                                                                   if (equal? (accGetName (car listAccess)) user) pos  (isShared? (cdr listAccess) user (+ 1 pos)) )))
; funcion que añade un acceso sin tomar en cuenta ninguna restriccion
; Dominio: documento X acceso
; Recorrido: documento
(define (DocumentAddIAccess documento access) (DocumentSetAccess documento (append (DocumentGetAccess documento) (list access)) ) )

; funcion que edita un acceso sin tomar en cuenta ninguna restriccion
; Dominio: documento X String X caracter
; Recorrido: documento
(define (DocumentEditAccess documento user type) (DocumentSetAccess documento (list-set (DocumentGetAccess documento)  (isShared? (DocumentGetAccess documento) user 0) (accSetType (list-ref (DocumentGetAccess documento) (isShared? (DocumentGetAccess documento) user 0)) type)  )))

; funcion que añade un acceso tomando en cuenta restricciones
; Dominio: documento X acceso
; Recorrido: documento
(define (DocumentAddAccess documento access) (if (= -1 (isShared? (DocumentGetAccess documento) (accGetName access) 0)) (DocumentAddIAccess documento access) (DocumentEditAccess documento (accGetName access) (accGetType access)) ))



; funcion que añade una version a un documento
; Dominio: documento X version
; Recorrido: documento
(define (DocumentAddVersion documento version) (Document-set documento 3 (append (list version) (DocumentGetVersions documento)) ))

; funcion que verifica si un usuario es creador de un documento
; Dominio: documento X String
; Recorrido: documento
(define (isCreator? documento user) (if (equal? user (DocumentGetAutor documento)) #t #f))

; funcion que elimina la lista de accesos tomando en cuenta restricciones
; Dominio: documento X String
; Recorrido: documento
(define (DocumentRevokeAccess documento user) (if (isCreator? documento user) (DocumentSetAccess documento '() ) documento))


; funcion que verifica si un usuario esta ingresado en un documento, tanto como autor como usuario compartido
; Dominio: listaAccesos X String
; Recorrido: boolean
(define (isInvolved? accessList user) (if (null? accessList) #f (
                                                                 if (equal? user (accGetName (car accessList))) #t (isInvolved? (cdr accessList) user ))  ))


; funcion que verifica si un usuario esta ingresado en un documento, tanto como autor como usuario compartido a nivel de documento
; Dominio: documento X usuario
; Recorrido: documento
(define (DocumentIsInvolved? document user) (
                                             if (or (isInvolved? (DocumentGetAccess document) user) (equal? user (DocumentGetAutor document))) #t #f))


; funcion setea el contenido de un documento
; Dominio: documento X String
; Recorrido: documento
(define (DocumentSetContent document content) (Document-set document 5 content))


;pruebas
;(define hoy (date 03 05 2002))
;(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
;(define ac1 (access "nico" #\w))
;(define ac2 (access "ale" #\w))
;(define ac3 (access "vic" #\w))
;(define ac4 (access "loki" #\w))
;(define lista (list ac1 ac2 ac3 ac4))
;(define dc1 (DocumentAddIAccess DC1 ac1))
;(define dc2 (DocumentAddIAccess dc1 ac2))
;(define dc3 (DocumentAddIAccess dc2 ac3))