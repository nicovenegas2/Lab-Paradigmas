#lang racket

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")
(require "TDA_document.rkt")
(require "encriptar.rkt")
(require "TDA_paradigmaDocs.rkt")
(require "TDA_access.rkt")
(require "TDA_version.rkt")



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

(define (checkLogCola userList user pass) (
                                                if (null? userList) #f (
                                                                        if (userCanLog? (car userList) user pass) #t (checkLogCola (user-next userList) user pass)  )))

(define (documentAddAccessList  documento accessList) (if (null? accessList) documento (documentAddAccessList (DocumentAddAccess documento (car accessList)) (cdr accessList))))

(define (register paradigmadocs date username password) (
                                                         Para-set paradigmadocs 2 (
                                                                                   agregarUsuarioNatural (ParaGetUsers paradigmadocs)
                                                                                                         (usuario username password)
                                                                                                         0 user-empty )))


(define (login paradigmadocs user pass funcion)  (if (checkLogCola (ParaGetUsers paradigmadocs) user pass) (funcion (logIn paradigmadocs user)) (funcion paradigmadocs)  ))


(define (create paradigmadocs ) ( lambda (date nombre contenido)(
                                  if (logedEmpty? paradigmadocs) paradigmadocs (logOut (ParaAddDocument paradigmadocs (documento  (+ 1 (ParaLastId paradigmadocs))
                                                                                                      (ParaGetLoged paradigmadocs)
                                                                                                      date nombre ((ParaGetEncrypt paradigmadocs) contenido)))))))



(define (share paradigmadocs) (lambda (id acc . access) (if (logedEmpty? paradigmadocs) paradigmadocs (
                                                                                                  logOut (


                                                                                                          ParaEditDocument paradigmadocs id (documentAddAccessList (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0) ) (append (list acc) access) ) ) ))  ))



(define (add paradigmadocs) (lambda (id date text) (if (logedEmpty? paradigmadocs) paradigmadocs (ParaAddVersionDocument (ParaAddTextDocument (logOut paradigmadocs) id text) id (version (ParaAutoIdVersion paradigmadocs id) date (DocumentGetContent (ParaGetDocumentById paradigmadocs id)) ) ) )))


(define (restoreVersion paradigmadocs ) (lambda (idDoc idVersion) (if (logedEmpty? paradigmadocs) paradigmadocs  (ParaAddVersionDocument (ParaEditDocument (logOut paradigmadocs) idDoc (verGetContent (ParaGetVersionById paradigmadocs idVersion idDoc))) idDoc (version (ParaAutoIdVersion paradigmadocs idDoc) (date 0 0 0) (ParaGetDocumentById paradigmadocs idDoc) ) ) ) ))


(define (revokeAllAccesses paradigmadocs)  (if (logedEmpty? paradigmadocs) paradigmadocs (
                                                                                          ParaSetDocuments (logOut paradigmadocs) (map (lambda (doc) (DocumentRevokeAccess doc (ParaGetLoged paradigmadocs))) (ParaGetDocuments paradigmadocs)) )) )


(define (search paradigmadocs)  (lambda (text) (
                                                if (logedEmpty? paradigmadocs) null (filter  (lambda (doc) (string-contains? ((ParaGetDecrypt paradigmadocs)(DocumentGetContent doc)) text ))   (filter (lambda (doc) (DocumentIsInvolved? doc (ParaGetLoged paradigmadocs))) (ParaGetDocuments paradigmadocs))   ))))

;pruebas
(define finalIfGrande 3)
(define us1 (usuario "nicovenegas" "1234"))
(define word (paradigmadocs "word" (date 24 10 2021) encryptFn encryptFn))
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
(define nico (usuario "nico" "1234"))
(define vic (usuario "vic" 1234444))
(define listalista (list (usuario "nico" "1234" )))
(define word1 (register word hoy "nico" "1234"))
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



