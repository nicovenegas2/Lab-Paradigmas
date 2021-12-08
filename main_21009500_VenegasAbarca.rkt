#lang racket

(require "TDA_fechas_21009500_VenegasAbarca.rkt")
(require "TDA_usuarios_21009500_VenegasAbarca.rkt")
(require "TDA_document_21009500_VenegasAbarca.rkt")
(require "encriptar_21009500_VenegasAbarca.rkt")
(require "TDA_paradigmaDocs_21009500_VenegasAbarca.rkt")
(require "TDA_access_21009500_VenegasAbarca.rkt")
(require "TDA_version_21009500_VenegasAbarca.rkt")

(provide (all-defined-out))



; Funcion que agrega un usuario a una lista Usuarios sin que este se repita
; Dom: listaUsers X usuario X Numero X lista
; Rec: lista
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

; Funcion que revisa si un usuario puede logearse en una lista se usuario
; Dom: listaUsers X String X String
; Rec: Boolean
(define (checkLogCola userList user pass) (
                                                if (null? userList) #f (
                                                                        if (userCanLog? (car userList) user pass) #t (checkLogCola (user-next userList) user pass)  )))


; Funcion que revisa si un usuario puede logearse en una lista se usuario
; Dom: listaUsers X String X String
; Rec: Boolean
(define (documentAddAccessList  documento accessList) (if (null? accessList) documento (documentAddAccessList (DocumentAddAccess documento (car accessList)) (cdr accessList))))

(define (register paradigmadocs date username password) (
                                                         Para-set paradigmadocs 2 (
                                                                                   agregarUsuarioNatural (ParaGetUsers paradigmadocs)
                                                                                                         (usuario username password date)
                                                                                                         0 user-empty )))

; Funcion que Logea a un usuario y devuelve una funcion con paradigmadocs con el usuario logeado
; Dom: String X String X Funcion
; Rec: Funcion
(define (login paradigmadocs user pass funcion)  (if (checkLogCola (ParaGetUsers paradigmadocs) user pass) (funcion (logIn paradigmadocs user)) (funcion paradigmadocs)  ))


; Funcion que crea un documento en paradigmadocs
; Dom: paradigmadocs X date X String X String
; Rec: paradigmadocs
(define (create paradigmadocs ) ( lambda (date nombre contenido)(
                                  if (logedEmpty? paradigmadocs) paradigmadocs (logOut (ParaAddDocument paradigmadocs (documento  (+ 1 (ParaLastId paradigmadocs))
                                                                                                      (ParaGetLoged paradigmadocs)
                                                                                                      date nombre ((ParaGetEncrypt paradigmadocs) contenido)))))))


; Funcion que agrega uno o mas accesos a un documento
; Dom: paradigmadocs X Int X Access X. Accesses
; Rec: paradigmadocs
(define (share paradigmadocs) (lambda (id acc . access) (if (logedEmpty? paradigmadocs) paradigmadocs (
                                                                                                  logOut (


                                                                                                          ParaEditDocument paradigmadocs id (documentAddAccessList (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0) ) (append (list acc) access) ) ) ))  ))


; Funcion que agrega contenido al final de un documento que se encuentre en paradigmadocs
; Dom: paradigmadocs X Int X date X String
; Rec: paradigmadocs
(define (add paradigmadocs) (lambda (id date text) (if (logedEmpty? paradigmadocs) paradigmadocs
                                                       (if (ParaCanEdit? (DocumentGetAccess (ParaGetDocumentById paradigmadocs id)) (DocumentGetAutor (ParaGetDocumentById paradigmadocs id)) (ParaGetLoged paradigmadocs)  )
                                                           (ParaAddVersionDocument (ParaAddTextDocument (logOut paradigmadocs) id text) id (version (ParaAutoIdVersion paradigmadocs id) date (DocumentGetContent (ParaGetDocumentById paradigmadocs id)) ) )
                                                           paradigmadocs )
                                                       )))




; Funcion restaura una version de un documento
; Dom: paradigmadocs X Int X Int
; Rec: paradigmadocs
(define (restoreVersion paradigmadocs ) (lambda (idDoc idVersion) (if (logedEmpty? paradigmadocs) paradigmadocs  (ParaAddVersionDocument (ParaSetContentDoc paradigmadocs idDoc (verGetContent (ParaGetVersionById paradigmadocs idVersion idDoc)) ) idDoc (version (ParaAutoIdVersion paradigmadocs idDoc) (date 0 0 0) (DocumentGetContent (ParaGetDocumentById paradigmadocs idDoc)) ) )    )))


; Funcion que borra todos los accesos en documentos de un usuario en especial
; Dom: paradigmadocs
; Rec: paradigmadocs
(define (revokeAllAccesses paradigmadocs)  (if (logedEmpty? paradigmadocs) paradigmadocs (
                                                                                          ParaSetDocuments (logOut paradigmadocs) (map (lambda (doc) (DocumentRevokeAccess doc (ParaGetLoged paradigmadocs))) (ParaGetDocuments paradigmadocs)) )) )

; Funcion que busca todos los documentos relacionados a un texto donde un usurio esta involucrado
; Dom: paradigmadocs X String
; Rec: paradigmadocs
(define (search paradigmadocs)  (lambda (text) (
                                                if (logedEmpty? paradigmadocs) null (filter  (lambda (doc) (string-contains? ((ParaGetDecrypt paradigmadocs)(DocumentGetContent doc)) text ))   (filter (lambda (doc) (DocumentIsInvolved? doc (ParaGetLoged paradigmadocs))) (ParaGetDocuments paradigmadocs))   ))))


; Funcion que muestra informacion de paradigmadocs entero y en algunos casos de usuarios en especificos
; Dom: paradigmadocs
; Rec: String
(define (paradigmadocs->string paradigmadocs ) (if (logedEmpty? paradigmadocs) (ParaInfo paradigmadocs) (ParaInfoUser paradigmadocs (ParaGetLoged paradigmadocs)))   )
;pruebas
#|
(define finalIfGrande 3)
(define us1 (usuario "nicovenegas" "1234" (date 03 05 2021)))
(define word (paradigmadocs "word" (date 24 10 2021) encryptFn encryptFn))
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
(define nico (usuario "nico" "1234" (date 03 05 2021)))
(define vic (usuario "vic" 1234444 (date 03 05 2021)))
(define listalista (list (usuario "nico" "1234" (date 03 05 2021))))
(define word1 )
(define listaUsers (list nico vic))
(define ac1 (access "nico" #\w))
(define ac2 (access "ale" #\w))
(define ac3 (access "vic" #\e))
(define ac4 (access "loki" #\c))
(define lista (list ac1 ac2 ac3 ac4))
(define word2 ((login word1 "nico" "1234" create) (date 02 03 2021) "doc1" "hola que tal"))
(define word3 (register word2 hoy "ale" "12345"))
(define word4 ((login word3 "nico" "1234" share) 1 (access "“user2”" #\r) ac2 ac1 ac3 ac4))
(define word5 ((login word4 "nico" "1234" add) 1 (date 12 23 2021) " sdfsdfddsfdf"))
(define word6 ((login word5 "nico" "1234" restoreVersion) 1 0))
(define accesso (DocumentGetAccess (ParaGetDocumentById word6 1))   )
|#


