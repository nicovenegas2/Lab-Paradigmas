#lang racket
(require "main_21009500_VenegasAbarca.rkt")
(require "TDA_fechas_21009500_VenegasAbarca.rkt")
(require "TDA_usuarios_21009500_VenegasAbarca.rkt")
(require "TDA_document_21009500_VenegasAbarca.rkt")
(require "encriptar_21009500_VenegasAbarca.rkt")
(require "TDA_paradigmaDocs_21009500_VenegasAbarca.rkt")
(require "TDA_access_21009500_VenegasAbarca.rkt")
(require "TDA_version_21009500_VenegasAbarca.rkt")

; se definen 3 paradigmadocs y se guardan con sus respectivos nombres

(define word (paradigmadocs "Word" (date 24 10 2021) encryptFn encryptFn))
(define excel (paradigmadocs "Excel" (date 03 06 2021) encryptFn encryptFn))
(define gDocs (paradigmadocs "GDoc" (date 10 12 2020) encryptFn encryptFn))

; se registran distintas cantidad de usuarios para los 3 paradigmadocs

(define word1 (register (register word (date 05 07 2021) "nico" "1234") (date 05 07 2021) "raul" "4321"))
(define excel1 (register (register excel (date 05 07 2021) "nico" "1234") (date 05 07 2021) "Loki" "4321"))
(define gDocs1 (register (register (register gDocs (date 05 07 2021) "nico" "1234") (date 05 07 2021) "Loki" "4321") (date 24 09 2021) "cody" "5678"))

; se crean documentos en los paradigmadocs mediante el login y el create, en gDocs se hace un intento de prueba con usuario erroneo
(define word2 ((login word1 "nico" "1234" create) (date 02 03 2021) "Informe Nico" "introduccion...")  )
(define excel2 ((login excel1 "Loki" "4321" create) (date 02 03 2021) "Lista Loki" "1- MasterCat /n")  )
(define gDocs2 ((login gDocs1 "cody" "5678" create) (date 02 03 2021) "Revision Cody" "contenido Revision")  )
(define gDocsError ((login gDocs1 "cody" "1234" create) (date 02 03 2021) "Revision Cody" "contenido Revision")  )

; los dueños de documentos en los paradigmadocs les dan accesos a todos los demas usuarios registrados
(define word3 ((login word2 "nico" "1234" share) 1 (access "raul" #\r)))
(define excel3 ((login excel2 "Loki" "4321" share) 1 (access "nico" #\w)))
(define gDocs3 ((login gDocs2 "cody" "5678" share) 1 (access "Loki" #\r) (access "nico" #\c)))
(define gDocsError1 ((login gDocs2 "cody" "5678" share) 1 (access "Loki" #\r) (access "nico" #\c)))

; los dueños de documentos o usuarios con permiso de escritura añaden contenido al final de los documentos registrados
(define word4 ((login word3 "nico" "1234" add) 1 (date 12 23 2021) " /n Desarrollo..."))
(define excel4 ((login excel3 "nico" "1234" add) 1 (date 12 23 2021) "2-Atun"))
(define gDocs4 ((login gDocs3 "cody" "5678" add) 1 (date 12 23 2021) " /nConclusion Revision: "))
(define gDocsError2 ((login gDocs3 "Loki" "4321" add) 1 (date 12 23 2021) " /nConclusion Revision: "))

; de los documentos creados y con texto añadido se vuelve a la version anterior
(define word5 ((login word4 "nico" "1234" restoreVersion) 1 0))
(define excel5 ((login excel4 "Loki" "4321" restoreVersion) 1 0))
(define gDocs5 ((login gDocs4 "cody" "5678" restoreVersion) 1 0))

; se revocan todos los accesos a los documentos
(define word6 (login word5 "nico" "1234" revokeAllAccesses))
(define excel6 (login excel5 "Loki" "4321" revokeAllAccesses))
(define gDocs6 (login gDocs5 "cody" "5678" revokeAllAccesses))
