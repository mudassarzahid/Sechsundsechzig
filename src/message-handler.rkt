#lang racket
(require "accessor.rkt")
(require "predicate.rkt")
(require "bundle-maker.rkt")
(require 2htdp/universe)

;  /$$                                              
; | $$                                              
; | $$        /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$ 
; | $$       /$$__  $$ /$$__  $$ /$$__  $$| $$__  $$
; | $$      | $$$$$$$$| $$  \ $$| $$$$$$$$| $$  \ $$
; | $$      | $$_____/| $$  | $$| $$_____/| $$  | $$
; | $$$$$$$$|  $$$$$$$|  $$$$$$$|  $$$$$$$| $$  | $$
; |________/ \_______/ \____  $$ \_______/|__/  |__/
;                      /$$  \ $$                    
;                     |  $$$$$$/                    
;                      \______/                    

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Messge 'lay entgegen
(define (handle-lay univ wrld m)
  (cond
    ; Player 1
    [(and (equal? (iworld-name wrld) (first (wrld-names univ))) (>= (- (length (first-hand univ)) 1) (second m)))
     (let ([selected_card (list-ref (first-hand univ) (second m))])
       (let ([updated_hand (remove selected_card (first-hand univ))]
             [updated_middle (append (middle univ) (list selected_card))])
         (cond 
           [(or (equal? (third m) 'play) (equal? (third m) 'won))
            (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'wait 'play)))]
    
           [(equal? (third m) 'announce)
            (if (and (paar? (first-hand univ) selected_card) (not (equal? (first selected_card) (trump univ))))
                (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'wait 'play)))
                (handle-no-change univ))]

           [(equal? (third m) 'announceTrump)
            (if (and (paar? (first-hand univ) selected_card) (equal? (first selected_card) (trump univ)))
                (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'wait 'play)))
                (handle-no-change univ))]

           [(equal? (third m) 'forceAnnounce)
            (if (and (paar? (first-hand univ) selected_card) (not (equal? (first selected_card) (trump univ))))
                (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forceWait 'forcePlay)))
                (handle-no-change univ))]

           [(equal? (third m) 'forceAnnounceTrump)
            (if (and (paar? (first-hand univ) selected_card) (equal? (first selected_card) (trump univ)))
                (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forceWait 'forcePlay)))
                (handle-no-change univ))]
    
           [(or (equal? (third m) 'forcePlay) (equal? (third m) 'forceWon))
            (if (or
                 (= (length (middle univ)) 0)
                 (and (same-color? (middle univ) (first-hand univ)) (equal? (first selected_card) (first (first (middle univ)))))
                 (not (same-color? (middle univ) (first-hand univ))))
                (make-lay-bundle-p1 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forceWait 'forcePlay)))      
                (handle-no-change univ))]

           [else (handle-no-change univ)])))]

    ; Player 2
    [(and (equal? (iworld-name wrld) (second (wrld-names univ))) (>= (- (length (second-hand univ)) 1) (second m)))
     (let ([selected_card (list-ref (second-hand univ) (second m))])
       (let ([updated_hand (remove selected_card (second-hand univ))]
             [updated_middle (append (middle univ) (list selected_card))])
         (cond
           [(or (equal? (third m) 'play) (equal? (third m) 'won))
            (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'play 'wait)))]

           [(equal? (third m) 'announce)
            (if (and (paar? (second-hand univ) selected_card) (not (equal? (first selected_card) (trump univ))))
                (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'play 'wait)))
                (handle-no-change univ))]
           
           [(equal? (third m) 'announceTrump)
            (if (and (paar? (second-hand univ) selected_card) (equal? (first selected_card) (trump univ)))
                (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'play 'wait)))
                (handle-no-change univ))]
           
           [(equal? (third m) 'forceAnnounce)
            (if (and (paar? (second-hand univ) selected_card) (not (equal? (first selected_card) (trump univ))))
                (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forcePlay 'forceWait)))
                (handle-no-change univ))]
           
           [(equal? (third m) 'forceAnnounceTrump)
            (if (and (paar? (second-hand univ) selected_card) (equal? (first selected_card) (trump univ)))
                (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forcePlay 'forceWait)))
                (handle-no-change univ))]
    
           [(or (equal? (third m) 'forcePlay) (equal? (third m) 'forceWon))
            (if (or
                 (= (length (middle univ)) 0)
                 (and (same-color? (middle univ) (second-hand univ)) (equal? (first selected_card) (first (first (middle univ)))))
                 (not (same-color? (middle univ) (second-hand univ))))
                (make-lay-bundle-p2 univ updated_hand updated_middle (if (= (length updated_middle) 2) (list 'waitStich 'waitStich) (list 'forcePlay 'forceWait)))
                (handle-no-change univ))]

           [else (handle-no-change univ)])))]

    [else (handle-no-change univ)]))



;  /$$   /$$                     /$$                           /$$   /$$
; | $$  | $$                    | $$                          |__/  | $$
; | $$  | $$  /$$$$$$   /$$$$$$$| $$$$$$$  /$$$$$$$$  /$$$$$$  /$$ /$$$$$$
; | $$$$$$$$ /$$__  $$ /$$_____/| $$__  $$|____ /$$/ /$$__  $$| $$|_  $$_/
; | $$__  $$| $$  \ $$| $$      | $$  \ $$   /$$$$/ | $$$$$$$$| $$  | $$
; | $$  | $$| $$  | $$| $$      | $$  | $$  /$$__/  | $$_____/| $$  | $$ /$$
; | $$  | $$|  $$$$$$/|  $$$$$$$| $$  | $$ /$$$$$$$$|  $$$$$$$| $$  |  $$$$/
; |__/  |__/ \______/  \_______/|__/  |__/|________/ \_______/|__/   \___/

; state (Symbol) --> Symbol
; Setzt den Zustand der Welt, die eine Hochzeit angesagt hat, zu dem Zustand 'announce oder 'forceAnnounce
(define (new-announce-state state)
  (cond [(or (equal? state 'play)      (equal? state 'won))      'announce]
        [(or (equal? state 'forcePlay) (equal? state 'forceWon)) 'forceAnnounce]))

; state (Symbol) --> Symbol
; Setzt den Zustand der Welt in den 'listen- oder 'forceListen-Zustand, falls der Gegner eine Hochzeit angesagt hat
(define (new-listen-state state)
  (cond [(or (equal? state 'play)      (equal? state 'won))      'listen]
        [(or (equal? state 'forcePlay) (equal? state 'forceWon)) 'forceListen]))

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'announce entgegen
(define (handle-announce univ wrld m)
  (let ([states (list (new-announce-state (second m)) (new-listen-state (second m)))]
        [points (list 20 0)])
    (cond
      [(equal? (iworld-name wrld) (first (wrld-names univ)))  (make-hochzeit-bundle univ m (first-hand  univ)          states           points  regular-hochzeit?)]
      [(equal? (iworld-name wrld) (second (wrld-names univ))) (make-hochzeit-bundle univ m (second-hand univ) (reverse states) (reverse points) regular-hochzeit?)])))

; state (Symbol) --> Symbol
; Setzt den Zustand der Welt, die eine Trumpf-Hochzeit angesagt hat, zu dem Zustand 'announceTrump oder 'forceAnnounceTrump
(define (new-announce-trump-state state)
  (cond [(or (equal? state 'play)      (equal? state 'won))      'announceTrump]
        [(or (equal? state 'forcePlay) (equal? state 'forceWon)) 'forceAnnounceTrump]))

; state (Symbol) --> Symbol
; ; Setzt den Zustand der Welt in den 'listenTrump- oder 'forceListenTrump-Zustand, falls der Gegner die Trumpf-Hochzeit angesagt hat
(define (new-listen-trump-state state)
  (cond [(or (equal? state 'play)      (equal? state 'won))      'listenTrump]
        [(or (equal? state 'forcePlay) (equal? state 'forceWon)) 'forceListenTrump]))

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'announceTrump entgegen
(define (handle-announce-trump univ wrld m)
  (let ([states (list (new-announce-trump-state (second m)) (new-listen-trump-state (second m)))]
        [points (list 30 0)])
    (cond
      [(equal? (iworld-name wrld) (first (wrld-names univ)))  (make-trump-hochzeit-bundle univ m (first-hand  univ)          states           points  trump-hochzeit?)]
      [(equal? (iworld-name wrld) (second (wrld-names univ))) (make-trump-hochzeit-bundle univ m (second-hand univ) (reverse states) (reverse points) trump-hochzeit?)])))



;  /$$$$$$$$                                             /$$                          
; |_____ $$                                             | $$                          
;      /$$/  /$$   /$$ /$$$$$$/$$$$   /$$$$$$   /$$$$$$$| $$$$$$$   /$$$$$$  /$$$$$$$ 
;     /$$/  | $$  | $$| $$_  $$_  $$ |____  $$ /$$_____/| $$__  $$ /$$__  $$| $$__  $$
;    /$$/   | $$  | $$| $$ \ $$ \ $$  /$$$$$$$| $$      | $$  \ $$| $$$$$$$$| $$  \ $$
;   /$$/    | $$  | $$| $$ | $$ | $$ /$$__  $$| $$      | $$  | $$| $$_____/| $$  | $$
;  /$$$$$$$$|  $$$$$$/| $$ | $$ | $$|  $$$$$$$|  $$$$$$$| $$  | $$|  $$$$$$$| $$  | $$
; |________/ \______/ |__/ |__/ |__/ \_______/ \_______/|__/  |__/ \_______/|__/  |__/

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'close entgegen
(define (handle-close-deck univ wrld m)
  (let ([states (list 'forcePlay 'forceWait)])
    (cond
      [(equal? (iworld-name wrld) (first (wrld-names univ)))  (make-close-bundle univ m states 'p1)]
      [(equal? (iworld-name wrld) (second (wrld-names univ))) (make-close-bundle univ m (reverse states) 'p2)])))



;  /$$$$$$$$                                      /$$                          
; |__  $$__/                                     | $$                          
;    | $$  /$$$$$$  /$$   /$$  /$$$$$$$  /$$$$$$$| $$$$$$$   /$$$$$$  /$$$$$$$ 
;    | $$ |____  $$| $$  | $$ /$$_____/ /$$_____/| $$__  $$ /$$__  $$| $$__  $$
;    | $$  /$$$$$$$| $$  | $$|  $$$$$$ | $$      | $$  \ $$| $$$$$$$$| $$  \ $$
;    | $$ /$$__  $$| $$  | $$ \____  $$| $$      | $$  | $$| $$_____/| $$  | $$
;    | $$|  $$$$$$$|  $$$$$$/ /$$$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$| $$  | $$
;    |__/ \_______/ \______/ |_______/  \_______/|__/  |__/ \_______/|__/  |__/

; univ (Universum Zustand), m (List<s-expression>), hand (List<card>), bundle-maker (function) --> Methodenaufruf
; Überprüft ob man tauschen darf
(define (swap-cards univ m hand bundle-maker)
  (let ([predicate (get-swap-predicate univ)])
    (if (and (or (equal? 'play (second m)) (equal? 'won (second m)))
             (> (length (deck univ)) 2 (length (middle univ))))
        (let ([trump_nine (filter predicate hand)])
          (if (empty? trump_nine) (handle-no-change univ)
              (let ([updated_hand (map (lambda (x) (if (predicate x) (car (deck univ)) x)) hand)]
                    [updated_deck (append trump_nine (cdr (deck univ)))])
                (bundle-maker univ m updated_hand updated_deck))))
        (handle-no-change univ))))

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'swap entgegen
(define (handle-swap univ wrld m)
  (cond
    [(equal? (iworld-name wrld) (first (wrld-names univ)))  (swap-cards univ m (first-hand univ)  make-swap-bundle-p1)]
    [(equal? (iworld-name wrld) (second (wrld-names univ))) (swap-cards univ m (second-hand univ) make-swap-bundle-p2)]))

; --> predicate
; Gibt das predicate abhängig von der Trumpf Farbe zurück
(define (get-swap-predicate univ)
  (cond [(equal? "Kreuz" (trump univ)) kreuz-neun?]
        [(equal? "Pik" (trump univ))   pik-neun?]
        [(equal? "Herz" (trump univ))  herz-neun?]
        [(equal? "Karo" (trump univ))  karo-neun?]))



;   /$$$$$$                        /$$     /$$                                        
;  /$$__  $$                      | $$    |__/                                        
; | $$  \__/  /$$$$$$   /$$$$$$  /$$$$$$   /$$  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$ 
; |  $$$$$$  /$$__  $$ /$$__  $$|_  $$_/  | $$ /$$__  $$ /$$__  $$ /$$__  $$| $$__  $$
;  \____  $$| $$  \ $$| $$  \__/  | $$    | $$| $$$$$$$$| $$  \__/| $$$$$$$$| $$  \ $$
;  /$$  \ $$| $$  | $$| $$        | $$ /$$| $$| $$_____/| $$      | $$_____/| $$  | $$
; |  $$$$$$/|  $$$$$$/| $$        |  $$$$/| $$|  $$$$$$$| $$      |  $$$$$$$| $$  | $$
;  \______/  \______/ |__/         \___/  |__/ \_______/|__/       \_______/|__/  |__/

; univ (Universum Zustand), wrld (Welt Zustand) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'sort entgegen
(define (handle-sort univ wrld)
  (cond
    [(equal? (iworld-name wrld) (first (wrld-names univ)))  (make-sort-bundle-p1 univ wrld)]
    [(equal? (iworld-name wrld) (second (wrld-names univ))) (make-sort-bundle-p2 univ wrld)]))



;   /$$$$$$   /$$     /$$           /$$                  /$$       /$$$$$$                        /$$               /$$ /$$                    
;  /$$__  $$ | $$    |__/          | $$                 /$$/      /$$__  $$                      | $$              |__/| $$                    
; | $$  \__//$$$$$$   /$$  /$$$$$$$| $$$$$$$           /$$/      | $$  \ $$ /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$  /$$| $$  /$$$$$$  /$$$$$$$ 
; |  $$$$$$|_  $$_/  | $$ /$$_____/| $$__  $$         /$$/       | $$$$$$$$| $$  | $$ /$$_____/|_  $$_/   /$$__  $$| $$| $$ /$$__  $$| $$__  $$
;  \____  $$ | $$    | $$| $$      | $$  \ $$        /$$/        | $$__  $$| $$  | $$|  $$$$$$   | $$    | $$$$$$$$| $$| $$| $$$$$$$$| $$  \ $$
;  /$$  \ $$ | $$ /$$| $$| $$      | $$  | $$       /$$/         | $$  | $$| $$  | $$ \____  $$  | $$ /$$| $$_____/| $$| $$| $$_____/| $$  | $$
; |  $$$$$$/ |  $$$$/| $$|  $$$$$$$| $$  | $$      /$$/          | $$  | $$|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$| $$|  $$$$$$$| $$  | $$
;  \______/   \___/  |__/ \_______/|__/  |__/     |__/           |__/  |__/ \______/ |_______/    \___/   \_______/|__/|__/ \_______/|__/  |__/

; univ (Universum-Zustand) --> Function (Gewinn-Handler)
; Liegen zwei Karten in der Mitte? Dann überprüfe, wer den Stich gewinnt
(define (handle-decide-stich univ m)
  (if (= (length (middle univ)) 2)
      (cond
        ; gleiche Farbe
        [(equal? (first (first (second m))) (first (second (second m))))
         
         ; Erste Karte größer als zweite
         (if (> (third (first (second m))) (third (second (second m))))
             (handle-first-win-stich univ m)
             (handle-second-win-stich univ m))]
        
        ; ungleiche Farbe
        [else
         (cond
           ; Erste Karte ein Trumpf
           [(equal? (first (first (second m))) (trump univ)) (handle-first-win-stich univ m)]
           
           ; Zweite Karte ein Trumpf
           [(equal? (first (second (second m))) (trump univ))
            (handle-second-win-stich univ m)]
           
           ; Sonst gewinnt der erste
           [else (handle-first-win-stich univ m)])]) (handle-no-change univ)))

; m (List<s-expression>), deck (List<card>) --> Symbol
; Erstelle einen neuen Gewinnzustand (Farbzwang oder reguläres Spiel?)
(define (new-won-state m deck)
  (if (or (= (length deck) 0) (equal? (third m) 'forcePlay) (equal? (third m) 'forceWait)) 'forceWon 'won))

; m (List<s-expression>), deck (List<card>) --> Symbol
; Erstelle einen neuen Verlierzustand (Farbzwang oder reguläres Spiel?)
(define (new-lost-state m deck)
  (if (or (= (length deck) 0) (equal? (third m) 'forcePlay) (equal? (third m) 'forceWait)) 'forceLost 'lost))

; univ (Universum Zustand), m (List<s-expression>), updated-first-hand bis updated-first-stich (List<card>),
; updated-first-stich-points (number), updated-deck (List<card>), last-played (Symbol) --> bundle
; Bundle für Gewinn Stich (P1)
(define (make-p1-won-stich-bundle univ m updated-first-hand updated-second-hand updated-first-stich updated-first-stich-points updated-deck last-played)
  (cond
    [(= (length updated-deck) (length updated-first-hand) (length updated-second-hand) 0)
     (cond
       ; Keiner hat zugemacht
       [(equal? (who-closed univ) 'p0)
        (make-bundle (list 'p1
                           updated-first-hand updated-second-hand
                           updated-first-stich updated-first-stich-points
                           (second-stich univ) (second-stich-points univ)
                           '() updated-deck
                           (second m) (who-closed univ)
                           (+ 1 (gamepoints-p1 univ)) (gamepoints-p2 univ)
                           (trump univ) (wrld-names univ)
                           (current-worlds univ))
                     (list (make-mail (world1 univ) (list 'wonLast
                                                          updated-first-hand updated-second-hand
                                                          updated-first-stich updated-first-stich-points
                                                          (second-stich univ) (second-stich-points univ)
                                                          '() updated-deck
                                                          (second m) (who-closed univ)
                                                          (+ 1 (gamepoints-p1 univ)) (gamepoints-p2 univ)
                                                          (trump univ) (wrld-names univ)))
                           
                           (make-mail (world2 univ) (list 'lostLast
                                                          updated-first-hand updated-second-hand
                                                          updated-first-stich updated-first-stich-points
                                                          (second-stich univ) (second-stich-points univ)
                                                          '() updated-deck
                                                          (second m) (who-closed univ)
                                                          (+ 1 (gamepoints-p1 univ)) (gamepoints-p2 univ)
                                                          (trump univ) (wrld-names univ))))
                     '())]

       ; P1 hat zugemacht
       [(equal? (who-closed univ) 'p1)
        (cond
          [(>= updated-first-stich-points 66)
           (cond
             [(= (length (second-stich univ) 0)) (make-stop-bundle univ (list 'cWon3t 'cLost3t))]
             [(<= (second-stich-points univ) 32) (make-stop-bundle univ (list 'cWon2t 'cLost2t))]   
             [else                               (make-stop-bundle univ (list 'cWon1t 'cLost1t))])]
          [(< updated-first-stich-points 66)     (make-stop-bundle univ (list 'cLost3f 'cWon3f))])]

       ; P2 hat zugemacht
       [(equal? (who-closed univ) 'p2)
        (cond
          [(>= (second-stich-points univ) 66)
           (cond
             [(<= updated-first-stich-points 32) (make-stop-bundle univ (list 'cLost2t 'cWon2t))]   
             [else                               (make-stop-bundle univ (list 'cLost1t 'cWon1t))])]
          [(< (second-stich-points univ) 66)     (make-stop-bundle univ (list 'cWon3f 'cLost3f))])])]

    ; Nicht der allerletzte Stich
    [else (make-bundle (list last-played
                             updated-first-hand updated-second-hand
                             updated-first-stich updated-first-stich-points
                             (second-stich univ) (second-stich-points univ)
                             '() updated-deck
                             (second m) (who-closed univ)
                             (gamepoints-p1 univ) (gamepoints-p2 univ)
                             (trump univ) (wrld-names univ)
                             (current-worlds univ))
                       (list (make-mail (world1 univ) (list (new-won-state m updated-deck)
                                                            updated-first-hand updated-second-hand
                                                            updated-first-stich updated-first-stich-points
                                                            (second-stich univ) (second-stich-points univ)
                                                            '() updated-deck
                                                            (second m) (who-closed univ)
                                                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                            (trump univ) (wrld-names univ)))
                             
                             (make-mail (world2 univ) (list (new-lost-state m updated-deck)
                                                            updated-first-hand updated-second-hand
                                                            updated-first-stich updated-first-stich-points
                                                            (second-stich univ) (second-stich-points univ)
                                                            '() updated-deck
                                                            (second m) (who-closed univ)
                                                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                            (trump univ) (wrld-names univ))))
                       '())]))

; univ (Universum Zustand), m (List<s-expression>), updated-first-hand - updated-second-stich (List<card>),
; updated-second-stich-points (number), updated-deck (List<card>), last-played (Symbol) --> bundle
; Bundle für Gewinn Stich (P2)
(define (make-p2-won-stich-bundle univ m updated-first-hand updated-second-hand updated-second-stich updated-second-stich-points updated-deck last-played)
  (cond
    [(= (length updated-deck) (length updated-first-hand) (length updated-second-hand) 0)
     (cond
       ; Keiner hat zugemacht
       [(equal? (who-closed univ) 'p0)
        (make-bundle (list 'p1
                           updated-first-hand updated-second-hand
                           (first-stich univ) (first-stich-points univ)
                           updated-second-stich updated-second-stich-points
                           '() updated-deck
                           (second m) (who-closed univ)
                           (gamepoints-p1 univ) (+ 1 (gamepoints-p2 univ))
                           (trump univ) (wrld-names univ)
                           (current-worlds univ))
                     (list (make-mail (world1 univ) (list 'lostLast
                                                          updated-first-hand updated-second-hand
                                                          (first-stich univ) (first-stich-points univ)
                                                          updated-second-stich updated-second-stich-points
                                                          '() updated-deck
                                                          (second m) (who-closed univ)
                                                          (gamepoints-p1 univ) (+ 1 (gamepoints-p2 univ))
                                                          (trump univ) (wrld-names univ)))
                                
                           (make-mail (world2 univ) (list 'wonLast
                                                          updated-first-hand updated-second-hand
                                                          (first-stich univ) (first-stich-points univ)
                                                          updated-second-stich updated-second-stich-points
                                                          '() updated-deck
                                                          (second m) (who-closed univ)
                                                          (gamepoints-p1 univ) (+ 1 (gamepoints-p2 univ))
                                                          (trump univ) (wrld-names univ))))
                     '())]

       ; P1 hat zugemacht
       [(equal? (who-closed univ) 'p1)
        (cond
          [(>= (first-stich-points univ) 66)
           (cond
             [(<= updated-second-stich-points 32) (make-stop-bundle univ (list 'cWon2t 'cLost2t))]   
             [else                                (make-stop-bundle univ (list 'cWon1t 'cLost1t))])]
          [(< (first-stich-points univ) 66)       (make-stop-bundle univ (list 'cLost3f 'cWon3f))])]

       ; P2 hat zugemacht
       [(equal? (who-closed univ) 'p2)
        (cond
          [(>= updated-second-stich-points 66)
           (cond
             [(= (length (first-stich univ) 0)) (make-stop-bundle univ (list 'cLost3t 'cWon3t))]
             [(<= (first-stich-points univ) 32) (make-stop-bundle univ (list 'cLost2t 'cWon2t))]   
             [else                              (make-stop-bundle univ (list 'cLost1t 'cWon1t))])]
          [(< updated-second-stich-points 66)   (make-stop-bundle univ (list 'cWon3f 'cLost3f))])])]

    ; Nicht der allerletzte Stich
    [else (make-bundle (list last-played
                             updated-first-hand updated-second-hand
                             (first-stich univ) (first-stich-points univ)
                             updated-second-stich updated-second-stich-points
                             '() updated-deck
                             (second m) (who-closed univ)
                             (gamepoints-p1 univ) (gamepoints-p2 univ)
                             (trump univ) (wrld-names univ)
                             (current-worlds univ))        
                       (list (make-mail (world1 univ) (list (new-lost-state m updated-deck)
                                                            updated-first-hand updated-second-hand
                                                            (first-stich univ) (first-stich-points univ)
                                                            updated-second-stich updated-second-stich-points
                                                            '() updated-deck
                                                            (second m) (who-closed univ)
                                                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                            (trump univ) (wrld-names univ)))
                                  
                             (make-mail (world2 univ) (list (new-won-state m updated-deck)
                                                            updated-first-hand updated-second-hand
                                                            (first-stich univ) (first-stich-points univ)
                                                            updated-second-stich updated-second-stich-points
                                                            '() updated-deck
                                                            (second m) (who-closed univ)
                                                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                            (trump univ) (wrld-names univ))))   
                       '())]))

; univ (Universum Zustand), m (List<s-expression>) --> Methodenaufruf
; Erste Karte gewinnt den Stich
(define (handle-first-win-stich univ m)
  (cond
    ; Player2 hat als erstes gelegt und gewinnt damit den Stich.
    [(equal? (_state univ) 'p1)
     (let ([updated_second_stich        (append (second-stich univ) (second m))]
           [updated_second_stich_points (+ (second-stich-points univ) (apply + (map (lambda (x) (third x)) (second m))))]
           [updated_first_hand   (cond [(= (length (deck univ)) 0) (first-hand univ)]
                                       [(= (length (deck univ)) 2) (append (first-hand univ)  (list (list-ref (deck univ) 0)))]
                                       [(> (length (deck univ)) 2) (append (first-hand univ)  (list (list-ref (deck univ) 2)))])]
           [updated_second_hand  (cond [(= (length (deck univ)) 0) (second-hand univ)]
                                       [(= (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 1)))]
                                       [(> (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 1)))])]
           [updated_deck         (cond [(= (length (deck univ)) 0) (deck univ)]
                                       [(= (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 0) (list-ref (deck univ) 1)) (deck univ))]
                                       [(> (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 1) (list-ref (deck univ) 2)) (deck univ))])])

       (make-p2-won-stich-bundle univ m updated_first_hand updated_second_hand updated_second_stich updated_second_stich_points updated_deck 'p1))]

    ; Player1 hat als erstes gelegt und gewinnt damit den Stich.
    [(equal? (_state univ) 'p2)
     (let ([updated_first_stich        (append (first-stich univ) (second m))]
           [updated_first_stich_points (+ (first-stich-points univ) (apply + (map (lambda (x) (third x)) (second m))))]
           [updated_first_hand   (cond [(= (length (deck univ)) 0) (first-hand univ)]
                                       [(= (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 0)))]
                                       [(> (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 1)))])]
           [updated_second_hand  (cond [(= (length (deck univ)) 0) (second-hand univ)]
                                       [(= (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 1)))]
                                       [(> (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 2)))])]
           [updated_deck         (cond [(= (length (deck univ)) 0) (deck univ)]
                                       [(= (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 0) (list-ref (deck univ) 1)) (deck univ))]
                                       [(> (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 1) (list-ref (deck univ) 2)) (deck univ))])])

       (make-p1-won-stich-bundle univ m updated_first_hand updated_second_hand updated_first_stich updated_first_stich_points updated_deck 'p2))]))

; univ (Universum Zustand), m (List<s-expression>) --> Methodenaufruf
; Zweite Karte gewinnt den Stich
(define (handle-second-win-stich univ m)
  (cond
    ; Player1 hat als letztes gelegt und gewinnt damit den Stich.
    [(equal? (_state univ) 'p1)
     (let ([updated_first_stich        (append (first-stich univ) (second m))]
           [updated_first_stich_points (+ (first-stich-points univ) (apply + (map (lambda (x) (third x)) (second m))))]
           [updated_first_hand   (cond [(= (length (deck univ)) 0) (first-hand univ)]
                                       [(= (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 1)))]
                                       [(> (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 1)))])]
           [updated_second_hand  (cond [(= (length (deck univ)) 0) (second-hand univ)]
                                       [(= (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 0)))]
                                       [(> (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 2)))])]
           [updated_deck         (cond [(= (length (deck univ)) 0) (deck univ)]
                                       [(= (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 0) (list-ref (deck univ) 1)) (deck univ))]
                                       [(> (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 1) (list-ref (deck univ) 2)) (deck univ))])])
       
       (make-p1-won-stich-bundle univ m updated_first_hand updated_second_hand updated_first_stich updated_first_stich_points updated_deck 'p1))]

    ; Player2 hat als letztes gelegt und gewinnt damit den Stich.
    [(equal? (_state univ) 'p2)
     (let ([updated_second_stich        (append (second-stich univ) (second m))]
           [updated_second_stich_points (+ (second-stich-points univ) (apply + (map (lambda (x) (third x)) (second m))))]
           [updated_first_hand   (cond [(= (length (deck univ)) 0) (first-hand univ)]
                                       [(= (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 0)))]
                                       [(> (length (deck univ)) 2) (append (first-hand univ) (list (list-ref (deck univ) 2)))])]
           [updated_second_hand  (cond [(= (length (deck univ)) 0) (second-hand univ)]
                                       [(= (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 1)))]
                                       [(> (length (deck univ)) 2) (append (second-hand univ) (list (list-ref (deck univ) 1)))])]
           [updated_deck         (cond [(= (length (deck univ)) 0) (deck univ)]
                                       [(= (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 0) (list-ref (deck univ) 1)) (deck univ))]
                                       [(> (length (deck univ)) 2) (remove* (list (list-ref (deck univ) 1) (list-ref (deck univ) 2)) (deck univ))])])

       (make-p2-won-stich-bundle univ m updated_first_hand updated_second_hand updated_second_stich updated_second_stich_points updated_deck 'p2))]))



;   /$$$$$$   /$$                                                      
;  /$$__  $$ | $$                                                      
; | $$  \__//$$$$$$    /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$ 
; |  $$$$$$|_  $$_/   /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$| $$__  $$
;  \____  $$ | $$    | $$  \ $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$  \ $$
;  /$$  \ $$ | $$ /$$| $$  | $$| $$  | $$| $$  | $$| $$_____/| $$  | $$
; |  $$$$$$/ |  $$$$/|  $$$$$$/| $$$$$$$/| $$$$$$$/|  $$$$$$$| $$  | $$
;  \______/   \___/   \______/ | $$____/ | $$____/  \_______/|__/  |__/
;                              | $$      | $$                          
;                              | $$      | $$                          
;                              |__/      |__/

; univ (Universum Zustand), m (List<s-expression>), stiche (List<List<card>,List<card>>),
; stich-points (List<Number,Number>), states-3 bis else-states (List<Symbol>) --> Methodenaufruf
; Überprüft wieviele Punkte der Gegner hat, wenn man Stopp sagt, um zu entscheiden wieviele Gewinnpunkte zu verteilen sind
(define (check-points univ m stiche stich-points states-3 states-2 states-1 else-states)
  (if (>= (first stich-points) 66)
      (cond
        [( = (length (second stiche)) 0) (make-stop-bundle univ (list (first states-3) (second states-3)))]
        [(<= (second stich-points) 32)   (make-stop-bundle univ (list (first states-2) (second states-2)))]   
        [else                            (make-stop-bundle univ (list (first states-1) (second states-1)))])

      (make-stop-bundle univ (list (first else-states) (second else-states)))))

; univ (Universum Zustand), wrld (Welt Zustand), m (List<s-expression>) --> Methodenaufruf je nach Spieler
; Nimmt die Message 'stop entgegen
(define (handle-stop-game univ wrld m)
  (let ([stiche (list (first-stich univ) (second-stich univ))]
        [stich-points (list (first-stich-points univ) (second-stich-points univ))]
        [states-3 (list 'Won3t 'Lost3t)]
        [states-2 (list 'Won2t 'Lost2t)]
        [states-1 (list 'Won1t 'Lost1t)]
        [else-states (list 'Lost3f 'Won3f)])
    (cond
      [(equal? (iworld-name wrld) (first (wrld-names univ)))  (check-points univ m stiche stich-points
                                                                            states-3 states-2 states-1 else-states)]
      [(equal? (iworld-name wrld) (second (wrld-names univ))) (check-points univ m (reverse stiche) (reverse stich-points)
                                                                            (reverse states-3) (reverse states-2) (reverse states-1) (reverse else-states))])))



;  /$$   /$$                                 /$$                           /$$    
; | $$$ | $$                                | $$                          | $$    
; | $$$$| $$  /$$$$$$  /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$  /$$$$$$  
; | $$ $$ $$ /$$__  $$| $$  | $$ /$$_____/|_  $$_/   |____  $$ /$$__  $$|_  $$_/  
; | $$  $$$$| $$$$$$$$| $$  | $$|  $$$$$$   | $$      /$$$$$$$| $$  \__/  | $$    
; | $$\  $$$| $$_____/| $$  | $$ \____  $$  | $$ /$$ /$$__  $$| $$        | $$ /$$
; | $$ \  $$|  $$$$$$$|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$        |  $$$$/
; |__/  \__/ \_______/ \______/ |_______/    \___/   \_______/|__/         \___/

; univ (Universum Zustand) --> neuer Universums- und Weltzustand
; Startet ein neues Spiel mit neu gemischten Karten
(define (handle-restart univ wrld m cards)
  (let ([new_first_hand (first cards)]
        [new_second_hand (second cards)]
        [new_deck (third cards)]
        [new_trump (first (first (third cards)))]
        [p1_state (cond
                    [(and (equal? (iworld-name wrld) (first (wrld-names univ)))  (won? (second m)))  'play]
                    [(and (equal? (iworld-name wrld) (second (wrld-names univ))) (lost? (second m))) 'play]
                    [else 'wait])]
        [p2_state (cond
                    [(and (equal? (iworld-name wrld) (first (wrld-names univ)))  (lost? (second m))) 'play]
                    [(and (equal? (iworld-name wrld) (second (wrld-names univ))) (won? (second m)))  'play]
                    [else 'wait])])
    (make-restart-bundle univ new_first_hand new_second_hand new_deck new_trump (list p1_state p2_state))))

; Alles exportieren
(provide (all-defined-out))