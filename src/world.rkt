#lang racket

(require 2htdp/universe)
(require "card.rkt")
(require "accessor.rkt")
(require "render.rkt")
(require "predicate.rkt")

; Die Welt fängt Inputs vom Spieler ab und verarbeitet diese und bearbeitet Messages vom Universum.

;  /$$      /$$           /$$   /$$    
; | $$  /$ | $$          | $$  | $$    
; | $$ /$$$| $$  /$$$$$$ | $$ /$$$$$$  
; | $$/$$ $$ $$ /$$__  $$| $$|_  $$_/  
; | $$$$_  $$$$| $$$$$$$$| $$  | $$    
; | $$$/ \  $$$| $$_____/| $$  | $$ /$$
; | $$/   \  $$|  $$$$$$$| $$  |  $$$$/
; |__/     \__/ \_______/|__/   \___/  

; Startzustand
(define WORLD0 (list 'wait              ;  1. Zustand
                     empty_hand         ;  2. Hand P1
                     empty_hand         ;  3. Hand P2
                     '()                ;  4. Stiche P1
                     0                  ;  5. Stiche P1 Punkte
                     '()                ;  6. Stiche P2
                     0                  ;  7. Stiche P2 Punkte
                     '()                ;  8. Mitte
                     '()                ;  9. Deck
                     '()                ; 10. Letzter Stich
                     'p0                ; 11. Wer hat zugemacht?
                     0                  ; 12. Gewinnpunkte P1
                     0                  ; 13. Gewinnpunkte P2
                     ""                 ; 14. Trumpfkarte
                     '()))              ; 15. Spielernamen

; wrld (Welt-Zustand), m (Message) --> neuer Welt-Zustand
; Falls korrekter Weltzustand erhalten und update; sonst bleibe im alten Zustand
(define (receive wrld m)
  (cond
    ; Nachricht im richtigen Format?
    [(and (list? m) (= (length m) 15))
     (if (equal? (_state m) 'waitStich)
         (make-package (decode-message wrld m)
                       (list 'decideStich (middle m) (_state wrld)))
         
         (decode-message wrld m))]
    [else wrld]))

; wrld (Welt-Zustand), m (Message) --> decodierte Message
; Empfängt Message vom Universum und decodiert die S-expressions
(define (decode-message wrld m)
  (list
   ; Zustandsüberprüfung
   (cond
     [(equal? (_state m) 'sort) (_state wrld)]
     [(equal? (_state m) 'swap) (_state wrld)]
     [else (_state m)])
   
   ; die restliche Message
   (decode-strings (first-hand m))
   (decode-strings (second-hand m))
   (decode-strings (first-stich m))
   (first-stich-points m)
   (decode-strings (second-stich m))
   (second-stich-points m)
   (decode-strings (middle m))
   (decode-strings (deck m))
   (decode-strings (recent-stich m))
   (who-closed m)
   (gamepoints-p1 m)
   (gamepoints-p2 m)
   (trump m)
   (wrld-names m)))

; wrld (Welt-Zustand) --> Message ans Universum
; Sortiert die Karten auf der Hand
(define (sort-cards wrld)
  (make-package wrld
                (list 'sort
                      (_state wrld))))

; wrld (Welt-Zustand), KEY (String) --> neuer Welt-Zustand
; Legt eine Karte
(define (lay-card wrld KEY)
  (if (< (length (middle wrld)) 2)
      (make-package wrld                            
                    (list 'lay
                          (- (string->number KEY) 1)
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Trumpfkarte austauschen
(define (swap-trump wrld)
  (if (<= (length (middle wrld)) 1)
      (make-package wrld
                    (list 'swap
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Spiel beenden
(define (stop-game wrld)
  (if (= (length (middle wrld)) 0)
      (make-package wrld
                    (list 'stop
                          (_state wrld)))
      wrld))
  
; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Spiel beenden
(define (close-deck wrld)
  (if (= (length (middle wrld)) 0)
      (make-package wrld
                    (list 'close
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Hochzeit ansagen
(define (announce wrld)
  (if (= (length (middle wrld)) 0)
      (make-package wrld
                    (list 'announce
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Trumpf Hochzeit ansagen
(define (announce-trump wrld)
  (if (= (length (middle wrld)) 0)
      (make-package wrld
                    (list 'announceTrump
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand) --> neuer Welt-Zustand
; Neues Spiel starten
(define (restart-game wrld)
  (if (end-state? (_state wrld))
      (make-package wrld
                    (list 'restart
                          (_state wrld)))
      wrld))

; wrld (Welt-Zustand), KEY (String) --> Methodenaufruf abhängig von KEY
; Key Event Handler
(define (change wrld KEY)
  (cond
    [(key=? KEY "s")  (if (= (length (wrld-names wrld)) 2) (sort-cards wrld) wrld)]
    [(key=? KEY "t")  (if (can-play? (_state wrld)) (swap-trump wrld) wrld)]
    [(key=? KEY "z")  (if (can-play? (_state wrld)) (close-deck wrld) wrld)]
    [(key=? KEY "\r") (if (can-play? (_state wrld)) (stop-game wrld) wrld)]
    [(key=? KEY "h")  (if (can-play? (_state wrld)) (announce wrld) wrld)]
    [(key=? KEY "j")  (if (can-play? (_state wrld)) (announce-trump wrld) wrld)]
    [(or (key=? KEY "1")
         (key=? KEY "2")
         (key=? KEY "3")
         (key=? KEY "4")
         (key=? KEY "5")
         (key=? KEY "6")) (if (can-play? (_state wrld)) (lay-card wrld KEY) wrld)]
    [else wrld]))

; Mouse Event Handler
(define (handle-mouse NAME)
  (lambda (wrld x_pos y_pos mouse_event)
    (cond
      [(equal? mouse_event "button-down") (restart-game wrld)]
      [else wrld])))

(define (create-wrld NAME)
  (big-bang WORLD0
    (on-receive receive)
    (to-draw (draw NAME) 600 750)
    (on-key change)
    (on-mouse (handle-mouse NAME))
    (name NAME)
    (state #f)
   ;(register "rzpc102.informatik.uni-hamburg.de")
   ;(port 8080)
    (register LOCALHOST)))

; Zum lokalen Spielen oder Testen
 (launch-many-worlds 
  (create-wrld "Mudi")
  (create-wrld "Nickel"))
