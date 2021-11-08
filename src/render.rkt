#lang racket
(require 2htdp/image)
(require "card.rkt")
(require "graphics.rkt")
(require "accessor.rkt")
(require "predicate.rkt")

; Render ist dafür da, den Spielstand zu visualisieren.

;  /$$$$$$$                            /$$                                        
; | $$__  $$                          | $$                                        
; | $$  \ $$  /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$ 
; | $$$$$$$/ /$$__  $$| $$__  $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$
; | $$__  $$| $$$$$$$$| $$  \ $$| $$  | $$| $$$$$$$$| $$  \__/| $$$$$$$$| $$  \__/
; | $$  \ $$| $$_____/| $$  | $$| $$  | $$| $$_____/| $$      | $$_____/| $$      
; | $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$| $$      |  $$$$$$$| $$      
; |__/  |__/ \_______/|__/  |__/ \_______/ \_______/|__/       \_______/|__/      

; name (String) --> render-game (Methode)
; Render Methode
(define (draw name)
  (lambda (wrld)
    (cond
      [(= (length (wrld-names wrld)) 2)
       (cond
         ; Player 1
         [(equal? name (first (wrld-names wrld)))  (render-game wrld (first (wrld-names wrld)) (second (wrld-names wrld))
                                                                CHAR1-LOST CHAR1-WON CHAR1
                                                                (first-hand wrld)  (second-hand wrld)
                                                                (first-stich wrld) (second-stich wrld)
                                                                (first-stich-points wrld) (second-stich-points wrld)
                                                                (number->string (gamepoints-p1 wrld))
                                                                (number->string (gamepoints-p2 wrld)))]
         ; Player 2
         [(equal? name (second (wrld-names wrld))) (render-game wrld (second (wrld-names wrld)) (first (wrld-names wrld))
                                                                CHAR2-LOST CHAR2-WON CHAR2
                                                                (second-hand wrld)  (first-hand wrld)
                                                                (second-stich wrld) (first-stich wrld)
                                                                (second-stich-points wrld) (first-stich-points wrld)
                                                                (number->string (gamepoints-p2 wrld))
                                                                (number->string (gamepoints-p1 wrld)))])]
      ; Am Anfang
      [else EMPTY])))

; wrld (Welt-Zustand), name (String), stich (List<card>), points (int) --> render-end (Methode) | render-regular (Methode)
; Rendern des Endgame-Screens
(define (render-game wrld name-1 name-2 char-lost char-won char hand-1 hand-2 stich-1 stich-2 stich-points-1 stich-points-2 game-points-1 game-points-2)
  (cond
    ; Player gewinnt
    [(won?  (_state wrld))  (render-end wrld name-2 (get-won-end-message  (_state wrld) name-2) stich-1 stich-2 stich-points-1 stich-points-2 game-points-1 game-points-2)]

    ; Player verliert
    [(lost?  (_state wrld)) (render-end wrld name-2 (get-lost-end-message (_state wrld) name-2) stich-1 stich-2 stich-points-1 stich-points-2 game-points-1 game-points-2)]

    ; Normales Spiel
    [else (render-regular wrld name-1 name-2 char-lost char-won char hand-2 hand-1 stich-1 stich-2)]))

; wrld (Welt-Zustand), name (String) --> Image
; Sonst wird normal gespielt
(define (render-regular wrld name-1 name-2 char-lost char-won char hand-2 hand-1 stich-1 stich-2)
  (above/align "left"
               (vertical-padding 10)
               (let ([text-img (render-text (_state wrld) name-2)]) (center text-img (image-width text-img)))
               (vertical-padding 10)
               (beside (horizontal-padding 256) (cond
                                                  [(or (equal? (_state wrld) 'won)  (equal? (_state wrld) 'forceWon))  char-won]
                                                  [(or (equal? (_state wrld) 'lost) (equal? (_state wrld) 'forceLost)) char-lost]
                                                  [else char]))
               (vertical-padding 30)
               DIVIDER
               (vertical-padding 30)
               (beside (horizontal-padding 60) (render-stich stich-2) (horizontal-padding 10) (render-hand hand-2 card-back))
               (vertical-padding 10)
               (let ([img (render-deck (deck wrld) (trump wrld))]) (center img (- (image-width img) 41)))
               (vertical-padding 20)
               (beside (horizontal-padding 289) (render-middle (middle wrld)) (horizontal-padding 90) (render-recent-stich (recent-stich wrld)))
               (vertical-padding 20)
               (beside (horizontal-padding 60) (render-stich stich-1) (horizontal-padding 10) (render-hand hand-1 card-image))
               (vertical-padding 30)
               (beside (horizontal-padding 60) controls)))


; message (String), stich (List<card>), points (int) --> Image
; Hilfsmethode zum Rendern des Endgame-Screens
(define (render-end wrld name message stich-1 stich-2 stich-points-1 stich-points-2 game-points-1 game-points-2)
  (above/align "left"
               (vertical-padding 10)
               (let ([img (beside (custom-text game-points-1 24 'black 'bold) (custom-text " : " 24 'black 'bold) (custom-text game-points-2 24 'black 'bold))]) (center img (image-width img)))
               (vertical-padding 30)
               (center message (image-width message))
               (vertical-padding 20)
               (beside (horizontal-padding 20) (custom-text (string-append "Deine Stiche " "(" (number->string stich-points-1) " Stichpunkte)") 22 'black 'normal))
               (vertical-padding 10)
               (let ([img (render-last-stich stich-1)]) (center img (image-width img)))
               (vertical-padding 40)
               (beside (horizontal-padding 20) (custom-text (string-append (string-replace (~v name) "\"" "") "s Stiche " "(" (number->string stich-points-2) " Stichpunkte)") 22 'black 'normal))
               (vertical-padding 10)
               (let ([img (render-last-stich stich-2)]) (center img (image-width img)))
               (vertical-padding 50)
               (center new-game-text (image-width new-game-text))))

; cards (List<card>) --> Image (Erste Karte unter die zweite gelegt)
; Zwei gelegte Karten rendern (z.B. Spielmitte oder alle gewonnenen Stiche nach Ende eines Spiels) 
(define (overlay-cards cards)
  (underlay/offset (card-image (first cards)) 30 30 (card-image (second cards))))

; hand (List<card>) --> Image (Kartenbilder mit Abstand nebeneinander gelegt)
; Rendern der Hand
(define (render-hand hand image-type)
  (cond
    [(> (length hand) 1) (let ([img (apply beside (map (lambda (x) (beside (image-type x) WHITESPACE)) hand))]) (center img (+ (image-width img) 168)))]
    [(= (length hand) 1) (let ([img (image-type (first hand))]) (center img (+ (image-width img) 168)))]
    [else EMPTY]))

; lst (List<card>) --> List<List<card,card>>
; Aufteilen von Elementen einer Liste in 2-Tuples
(define (split-to-tuples lst)
  (if (not (empty? lst))
      (cons (take lst 2) (split-to-tuples (drop lst 2)))
      '()))

; img (Image), width (Number) --> Image (centered)
; Zentrieren von Bildern mithilfe der Screen-Breite und Bild-Breite
(define (center img width)
  (let ([num (quotient (- 600 width) 2)])
    (if (> num 0)
        (beside (horizontal-padding (quotient (- 600 width) 2)) img)
        (beside (horizontal-padding 10) img))))

; stich (List<card>) --> Image
; Rendern des Stiches auf dem End-Screen
(define (render-last-stich stich)
  (cond
    [( = (length stich) 0)  EMPTY]
    [( = (length stich) 2)  (first (map overlay-cards (split-to-tuples stich)))]
    [(<= (length stich) 10) (apply beside (map overlay-cards (split-to-tuples stich)))]
    [else                  
     (let ([stiche
            (let ([row-1 (apply beside (map overlay-cards (split-to-tuples
                                                           (list (first stich) (second stich) (third stich) (fourth stich)
                                                                 (fifth stich) (sixth stich) (seventh stich) (eighth stich)))))]
                  [row-2 (apply beside (map overlay-cards (split-to-tuples (member (ninth stich) stich))))])
              (above row-1 (vertical-padding 10) row-2))])
       stiche)]))

; middle (List<card>) --> Image
; Rendern der Mitte
(define (render-middle middle)
  (cond
    [(= (length middle) 2) (overlay-cards middle)]
    [(= (length middle) 1) (overlay-cards (list (first middle) card0))]
    [(= (length middle) 0) (overlay-cards (list card0 card0))]))

; stich (List<card>) --> Image
; Rendern des zuletzt gewonnenen Stichs
(define (render-recent-stich stich)
  (cond
    [(= (length stich) 2) (overlay-cards stich)]
    [else (above (text "(letzter" 14 'black) (text "Stich)" 14 'black))]))

; deck (List<card>) --> Image
; Rendern des Decks
(define (render-deck deck trump)
  (cond
    ; Bei >=2 Karten liegt die Trumpfkarte um 90° rotiert unter dem Deck
    [(>= (length deck) 2)
     (underlay/offset
      (rotate 90 (card-image (car deck)))
      45 0
      (overlay (text (~v (- (length deck) 1)) 14 'white) (card-back (first (cdr deck)))))]
    
    [else (beside (horizontal-padding 29) (trump-image trump))]))

; stich (List<card>) --> Image
; Rendern des Stiches (List von cards)
(define (render-stich stich)
  (cond
    [(= (length stich) 0) EMPTY]
    [else (card-back card1)]))

; Alle exportieren
(provide (all-defined-out))