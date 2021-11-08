#lang racket
(require 2htdp/universe)
(require "card-sexp.rkt")
(require "accessor.rkt")
(require "message-handler.rkt")

; Universum kümmert sich um alle Messages von der Welt.

;  /$$   /$$           /$$                                                                
; | $$  | $$          |__/                                                                
; | $$  | $$ /$$$$$$$  /$$ /$$    /$$ /$$$$$$   /$$$$$$   /$$$$$$$ /$$   /$$ /$$$$$$/$$$$ 
; | $$  | $$| $$__  $$| $$|  $$  /$$//$$__  $$ /$$__  $$ /$$_____/| $$  | $$| $$_  $$_  $$
; | $$  | $$| $$  \ $$| $$ \  $$/$$/| $$$$$$$$| $$  \__/|  $$$$$$ | $$  | $$| $$ \ $$ \ $$
; | $$  | $$| $$  | $$| $$  \  $$$/ | $$_____/| $$       \____  $$| $$  | $$| $$ | $$ | $$
; |  $$$$$$/| $$  | $$| $$   \  $/  |  $$$$$$$| $$       /$$$$$$$/|  $$$$$$/| $$ | $$ | $$
;  \______/ |__/  |__/|__/    \_/    \_______/|__/      |_______/  \______/ |__/ |__/ |__/

; Verteilt die Karten auf zwei Hände und den Rest aufs Deck
(define (serve-cards)
  (let ((cards (shuffle all-cards)))
    (list 
     (list (list-ref cards 0)  (list-ref cards 1)  (list-ref cards 2)  (list-ref cards 3)  (list-ref cards 4)  (list-ref cards 5))
     (list (list-ref cards 6)  (list-ref cards 7)  (list-ref cards 8)  (list-ref cards 9)  (list-ref cards 10) (list-ref cards 11))
     (list (list-ref cards 12) (list-ref cards 13) (list-ref cards 14) (list-ref cards 15) (list-ref cards 16) (list-ref cards 17)
           (list-ref cards 18) (list-ref cards 19) (list-ref cards 20) (list-ref cards 21) (list-ref cards 22) (list-ref cards 23)))))

; Startzustand
(define UNIVERSE0
  (let ([cards (serve-cards)])
    (list
     'p0                           ;  1. Zustand
     (first cards)                 ;  2. Hand P1
     (second cards)                ;  3. Hand P2
     '()                           ;  4. Stiche P1
     0                             ;  5. Stiche P1 Punkte
     '()                           ;  6. Stiche P2
     0                             ;  7. Stiche P2 Punkte
     '()                           ;  8. Mitte
     (third cards)                 ;  9. Deck
     '()                           ; 10. Letzter Stich
     'p0                           ; 11. Wer hat zugemacht?
     0                             ; 12. Gewinnpunkte P1
     0                             ; 13. Gewinnpunkte P2
     (first (first (third cards))) ; 14. Trumpfkarte
     '()                           ; 15. Spielernamen
     '())))                        ; 16. Alle Welten

; Maximale Anzahl an Spieler
(define NUM-PLAYERS 2)

; univ (Universe-Zustand), wrld (Welt-Zustand) --> Universum-Zustand, Welt-Zustand
; Fügt eine neue Welt hinzu 
(define (add-world univ wrld)
  (cond 
    ; Maximale Anzahl an Spielern erreicht  --> Weise diese Welt ab
    [(= (length (current-worlds univ)) NUM-PLAYERS)
     (make-bundle univ
                  (list (make-mail wrld (list 'rejected empty_hand empty_hand '() 0 '() 0 '() '() '() 'p0 0 0 "" '())))
                  (list wrld))]
         
    ; Maximale Anzahl an Spielern mit dieser Welt erreicht --> Füge die Welt zu den bekannten hinzu & Starte das Spiel
    [(= (length (current-worlds univ)) (- NUM-PLAYERS 1))
     (make-bundle (list (_state univ)
                        (first-hand univ) (second-hand univ)
                        (first-stich univ) (first-stich-points univ)
                        (second-stich univ) (second-stich-points univ)
                        (middle univ) (deck univ)
                        (recent-stich univ) (who-closed univ)
                        (gamepoints-p1 univ) (gamepoints-p2 univ)
                        (trump univ) (append (wrld-names univ) (list (iworld-name wrld)))
                        (append (current-worlds univ) (list wrld)))
                  (list (make-mail (world1 univ) (list 'play
                                                       (first-hand univ) (second-hand univ)
                                                       (first-stich univ) (first-stich-points univ)
                                                       (second-stich univ) (second-stich-points univ)
                                                       (middle univ) (deck univ)
                                                       (recent-stich univ) (who-closed univ)
                                                       (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                       (trump univ) (append (wrld-names univ) (list (iworld-name wrld)))))
                        (make-mail  wrld         (list 'wait
                                                       (first-hand univ) (second-hand univ)
                                                       (first-stich univ) (first-stich-points univ)
                                                       (second-stich univ) (second-stich-points univ)
                                                       (middle univ) (deck univ)
                                                       (recent-stich univ) (who-closed univ)
                                                       (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                       (trump univ) (append (wrld-names univ) (list (iworld-name wrld))))))
                  '())]
         
    ; Maximale Anzahl an Spielern noch nicht erreicht --> Füge die Welt zu den bekannten hinzu
    [else 
     (make-bundle (list (_state univ)
                        (first-hand univ) (second-hand univ)
                        (first-stich univ) (first-stich-points univ)
                        (second-stich univ) (second-stich-points univ)
                        (middle univ) (deck univ)
                        (recent-stich univ) (who-closed univ)
                        (gamepoints-p1 univ) (gamepoints-p2 univ)
                        (trump univ) (append (wrld-names univ) (list (iworld-name wrld)))
                        (append (current-worlds univ) (list wrld)))
                  (list (make-mail wrld (list 'wait
                                              empty_hand empty_hand
                                              (first-stich univ) (first-stich-points univ)
                                              (second-stich univ) (second-stich-points univ)
                                              (middle univ) (deck univ)
                                              (recent-stich univ) (who-closed univ)
                                              (gamepoints-p1 univ) (gamepoints-p2 univ)
                                              (trump univ) (append (wrld-names univ) (list (iworld-name wrld))))))
                  '())]))


; univ (Universum-Zustand), wrld (Welt-Zustand), m (List) --> Methodenaufruf abhängig von (first m)
; Nachrichtenaustausch zwischen den Welten 
(define (handle-messages univ wrld m)
  (cond
    ; Sortieren von Karten
    [(equal? (first m) 'sort) (handle-sort univ wrld)]
    
    ; Ansagen einer Hochzeit
    [(equal? (first m) 'announce) (handle-announce univ wrld m)]

    ; Ansagen einer Trumpf Hochzeit
    [(equal? (first m) 'announceTrump) (handle-announce-trump univ wrld m)]
    
    ; Legen von Karten
    [(equal? (first m) 'lay) (handle-lay univ wrld m)]

    ; Entscheiden, wer den Stich gewinnt
    [(equal? (first m) 'decideStich) (handle-decide-stich univ m)]
    
    ; Tauschen von Trumpfkarte
    [(equal? (first m) 'swap) (handle-swap univ wrld m)]

    ; Zumachen des Decks
    [(equal? (first m) 'close) (handle-close-deck univ wrld m)]
    
    ; Stoppen
    [(equal? (first m) 'stop) (handle-stop-game univ wrld m)]

    ; Neustart
    [(equal? (first m) 'restart) (handle-restart univ wrld m (serve-cards))]
     
    ; Sonstige Anfragen verändern das Universum nicht
    [else (make-bundle univ '() '())]))

; Erschafft ein Universum
(universe UNIVERSE0
         ;(port 8080)
          (on-new add-world)
          (on-msg handle-messages))
