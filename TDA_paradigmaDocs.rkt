#lang racket
; se define el TDA de paradigmaDocs con la siguiente implementacion de lista
; (nombrePlataforma, FechaCreacion, (usuarios), (documentos), funcion encriptar, funcion desencriptar, usuarioLogeado?)

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")
(require "TDA_document.rkt")
(require "encriptar.rkt")
(require "TDA_access.rkt")
(require "TDA_version.rkt")



(provide paradigmadocs)
(provide ParaGetNombre)
(provide ParaGetDate)
(provide ParaGetUsers)
(provide ParaGetDocuments)
(provide ParaGetEncrypt)
(provide ParaGetDecrypt)
(provide ParaAddUser)
(provide ParaInfo)
(provide logedEmpty?)
(provide logIn)
(provide logOut)
(provide ParaSetUsers)
(provide ParaLastId)
(provide ParaAddDocument)
(provide ParaGetLoged)
(provide ParaEditDocument)
(provide ParaSearchId)
(provide Para-set)
(provide ParaCanEdit?)
(provide ParaAddTextDocument)
(provide ParaAddVersionDocument)
(provide ParaAutoIdVersion)
(provide ParaGetDocumentById)
(provide ParaGetVersionById)
(provide ParaSetDocuments)


(define Para-set list-set)

; Constructor de un paradigmadocs(plataforma)
; Dom: String X Date X EncryptFunction X DecryptFunction
; Rec: paradigmadocs
(define (paradigmadocs nombre date encriptar desencriptar) (list nombre date '() '() encriptar desencriptar user-empty))

; Funcion que extrae el nombre de un paradigmadocs
; Dom: paradigmadocs
; Rec: String
(define (ParaGetNombre paradigmadocs) (list-ref paradigmadocs 0))

; Funcion que extrae la fecha de creacion de un paradigmadocs
; Dom: paradigmadocs
; Rec: date
(define (ParaGetDate paradigmadocs) (list-ref paradigmadocs 1))

; Funcion que extrae los usuarios registrados de un paradigmadocs
; Dom: paradigmadocs
; Rec: Lista de usuarios
(define (ParaGetUsers paradigmadocs) (list-ref paradigmadocs 2))

; Funcion que extrae los documentos de un paradigmadocs
; Dom: paradigmadocs
; Rec: lista de documentos
(define (ParaGetDocuments paradigmadocs) (list-ref paradigmadocs 3))

; Funcion que extrae la funcion de encriptacion de un paradigmadocs
; Dom: paradigmadocs
; Rec: Funcion
(define (ParaGetEncrypt paradigmadocs) (list-ref paradigmadocs 4))

; Funcion que extrae la funcion de desencriptacion de un paradigmadocs
; Dom: paradigmadocs 
; Rec: Funcion
(define (ParaGetDecrypt paradigmadocs) (list-ref paradigmadocs 5))

; funcion revisa si la posicion de usuario activo esta vacia
; Dominio: paradigmadocs
; Recorrido: paradigmadocs
(define (logedEmpty? paradigmadocs) (null? (list-ref paradigmadocs 6)))

; funcion que retorna el usuario logeado de un paradigmadocs
; Dominio: paradigmadocs
; Recorrido: usuario
(define (ParaGetLoged paradigmadocs) (list-ref paradigmadocs 6))

; funcion que logea a un usuario
; Dominio: paradigmadocs X usuario
; Recorrido: paradigmadocs
(define (logIn paradigmadocs usuario) (list-set paradigmadocs 6 usuario))

; funcion que deslogea a un usuario
; Dominio: paradigmadocs
; Recorrido: paradigmadocs
(define (logOut paradigmadocs) (list-set paradigmadocs 6 user-empty))

; funcion que agrega un usuario al paradigmadocs
; Dominio: paradigmadocs X usuario
; Recorrido: paradigmadocs
(define (ParaAddUser paradigmadocs usuario) (
                                     user-set paradigmadocs 2 (
                                                               append (ParaGetUsers paradigmadocs) (list usuario))))

; funcion que extrae informacion de una plataforma
; Dominio: paradigmadocs
; Recorrido: String
(define (ParaInfo paradigmadocs) (
                                  string-append "Nombre de la plataforma: " (ParaGetNombre paradigmadocs) "\n"
                                                "Fecha de creacion: " (DateString (ParaGetDate paradigmadocs)) "\n"
                                                "documentos creados: " "\n"
                                                 "-------------------------------------------\n"
                                                (string-join (map (lambda (docs) (DocumentInfo docs (ParaGetDecrypt paradigmadocs))) (ParaGetDocuments paradigmadocs)))  ))

; funcion setea la lista de usuarios
; Dominio: paradigmadocs X listaUsuarios
; Recorrido: paradigmadocs
(define (ParaSetUsers paradigmadocs users) (
                                            Para-set paradigmadocs 2 users))


(define (ParaSetDocuments paradigmadocs documents) (
                                            Para-set paradigmadocs 3 documents))

; funcion que extrae el ultimo id de los documentos de un paradigmadocs
; Dominio: paradigmadocs
; Recorrido: Numero
(define (ParaLastId paradigmadocs) (
                                    if (null? (ParaGetDocuments paradigmadocs)) 0
                                       (DocumentGetId (last (ParaGetDocuments paradigmadocs)))
                                       ))

; funcion que agrega un documento a paradigmadocs
; Dominio: paradigmadocs X documento
; Recorrido: paradigmadocs
(define (ParaAddDocument paradigmadocs document) (list-set paradigmadocs 3 (append (ParaGetDocuments paradigmadocs)
                                                                                   (list document))))

; funcion que busca un documento mediante su id, entrega la posicion del mismo y -1 si no lo encuentra
; Dominio: listaDocumentod X Numero X numero
; Recorrido: Numero
(define (ParaSearchId listDocs id pos) (if (null? listDocs) -1 (
                                                                 if (= id (DocumentGetId (car listDocs))) pos (ParaSearchId (cdr listDocs) id (+ 1 pos)) )))

; funcion que setea un documento mediante su posicion
; Dominio: paradigmadocs X Numero X Documento
; Recorrido: paradigmadocs
(define (ParaEditDocument paradigmadocs id newDoc) (Para-set paradigmadocs 3 (list-set (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0) newDoc)))



(define (canEdit? accessList creator usuario)  (if (equal? creator usuario) #t (
                                                                                if (null? accessList)
                                                                                   (2)
                                                                                   (if (equal? (accGetType (car accessList)) #\w) #t (canEdit? (cdr accessList) creator usuario))   )))

(define (ParaCanEdit? accessList creator usuario) (ormap (lambda (access) (
                                                                           if (equal? usuario creator) #t (
                                                                                                           if (equal? usuario (accGetName access)) (
                                                                                                                                                    if (equal? #\w (accGetType access)) #t #f) #f)) )  accessList))

(define (ParaAddTextDocument paradigmadocs id text) (ParaEditDocument paradigmadocs id (
                                                                                          DocumentAddContent (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0)) text (ParaGetEncrypt paradigmadocs) (ParaGetDecrypt paradigmadocs) ))) 



(define (ParaAddVersionDocument paradigmadocs id version) (ParaEditDocument paradigmadocs id  (DocumentAddVersion (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0)) version)  ))


(define (ParaAutoIdVersion paradigmadocs id) (length (DocumentGetVersions (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0))) ))


(define (ParaGetDocumentById paradigmadocs id) (list-ref (ParaGetDocuments paradigmadocs) (ParaSearchId (ParaGetDocuments paradigmadocs) id 0)))

(define (ParaSearchVersion listVersions idVersion) (if (null? listVersions) #f  (if (= (verGetNumber (car listVersions)) idVersion) (car listVersions) (ParaSearchVersion (cdr listVersions) idVersion))  ))


(define (ParaGetVersionById paradigmadocs idVersion idDocument) (ParaSearchVersion (DocumentGetVersions (ParaGetDocumentById paradigmadocs idDocument)) idVersion ))




;pruebas
(define us1 (usuario "nicovenegas" "1234"))
(define word (paradigmadocs "word" (date 24 10 2021) encryptFn encryptFn))
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" (encryptFn "hola que tal")))
(define ac1 (access "nico" #\w))
(define ac2 (access "ale" #\w))
(define ac3 (access "vic" #\w))
(define ac4 (access "loki" #\w))
(define lista (list ac1 ac2 ac3 ac4))
(define dc1 (DocumentAddIAccess DC1 ac1))
(define dc2 (DocumentAddIAccess dc1 ac2))
(define dc3 (DocumentAddIAccess dc2 ac3))
(define ale (usuario "ale" "1234"))
(define word1 (ParaAddDocument word dc3))
(define word2 (ParaAddDocument word1 dc1))
(define word3 (ParaAddDocument word2 dc2))
(define excel (ParaAddTextDocument word1 1 " como estas?"))
(define v1 (version 0 (date 02 20 2020) excel))
(define excel1 (ParaAddVersionDocument word1 1 v1))
