#lang racket
; se define el TDA de paradigmaDocs con la siguiente implementacion de lista
; (nombrePlataforma, FechaCreacion, (usuarios), (documentos), funcion encriptar, funcion desencriptar, usuarioLogeado?)

(require "TDA_fechas.rkt")
(require "TDA_usuarios.rkt")
(require "TDA_document.rkt")
(require "encriptar.rkt")



(provide paradigmadocs)
(provide ParaGetNombre)
(provide ParaGetDate)
(provide ParaGetUsers)
(provide ParaGetDocuments)
(provide ParaGetEncrypt)
(provide ParaGetDecrypt)
(provide ParaAddUser)
(provide ParaInfo)
(provide loged?)
(provide logIn)
(provide logOut)
(provide ParaSetUsers)
(provide ParaLastId)
(provide ParaAddDocument)
(provide ParaGetLoged)


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

(define (loged? paradigmadocs) (null? (list-ref paradigmadocs 6)))

(define (ParaGetLoged paradigmadocs) (list-ref paradigmadocs 6))

(define (logIn paradigmadocs usuario) (list-set paradigmadocs 6 usuario))

(define (logOut paradigmadocs) (list-set paradigmadocs 6 user-empty))


(define (ParaAddUser paradigmadocs usuario) (
                                     user-set paradigmadocs 2 (
                                                               append (ParaGetUsers paradigmadocs) usuario)))


(define (ParaInfo paradigmadocs) (
                                  string-append "Nombre de la plataforma: " (ParaGetNombre paradigmadocs) "\n"
                                                "Fecha de creacion: " (DateString (ParaGetDate paradigmadocs)) "\n"
                                                "documentos creados: " "\n"
                                                (string-join (map DocumentInfo (ParaGetDocuments paradigmadocs)))  ))

(define (ParaSetUsers paradigmadocs users) (
                                            user-set paradigmadocs 2 (users)))

;sale numero
(define (ParaLastId paradigmadocs) (
                                    if (null? (ParaGetDocuments paradigmadocs)) 0
                                       (DocumentGetId (last (ParaGetDocuments paradigmadocs)))
                                       ))

(define (ParaAddDocument paradigmadocs document) (list-set paradigmadocs 3 (append (ParaGetDocuments paradigmadocs)
                                                                                   (list document))))

;pruebas
(define us1 (usuario "nicovenegas" "1234"))
(define word (paradigmadocs "word" (date 24 10 2021) encryptFn encryptFn))
(define hoy (date 03 05 2002))
(define DC1 (documento 01 "nicolas" hoy "Documento 1" "hola que tal"))
