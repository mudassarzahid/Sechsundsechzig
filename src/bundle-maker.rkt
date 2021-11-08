#lang racket
(require "accessor.rkt")
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

; univ (Universum Zustand), first_hand (List<cards>), middle (List<cards>), p1_state (Symbol), p2_state (Symbol)
; Bundles fürs Kartenlegen (P1)
(define (make-lay-bundle-p1 univ first_hand middle states)
  (make-bundle (list 'p1
                     first_hand (second-hand univ)
                     (first-stich univ) (first-stich-points univ)
                     (second-stich univ) (second-stich-points univ)
                     middle (deck univ)
                     (recent-stich univ) (who-closed univ)
                     (gamepoints-p1 univ) (gamepoints-p2 univ)
                     (trump univ) (wrld-names univ)
                     (current-worlds univ))
               (list (make-mail (world1 univ) (list (first states)
                                                    first_hand (second-hand univ)
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    middle (deck univ)
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ)))
                     
                     (make-mail (world2 univ) (list (second states)
                                                    first_hand (second-hand univ)
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    middle (deck univ)
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ))))
               '()))

; univ (Universum Zustand), first_hand (List<cards>), middle (List<cards>), p1_state (Symbol), p2_state (Symbol)
; Bundles fürs Kartenlegen (P2)
(define (make-lay-bundle-p2 univ second_hand middle states)
  (make-bundle (list 'p2
                     (first-hand univ) second_hand
                     (first-stich univ) (first-stich-points univ)
                     (second-stich univ) (second-stich-points univ)
                     middle (deck univ)
                     (recent-stich univ) (who-closed univ)
                     (gamepoints-p1 univ) (gamepoints-p2 univ)
                     (trump univ) (wrld-names univ)
                     (current-worlds univ)) 
               (list (make-mail (world1 univ) (list (first states)
                                                    (first-hand univ) second_hand
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    middle (deck univ)
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ)))
                     
                     (make-mail (world2 univ) (list (second states)
                                                    (first-hand univ) second_hand
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    middle (deck univ)
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ))))
               '()))



;  /$$   /$$                     /$$                           /$$   /$$
; | $$  | $$                    | $$                          |__/  | $$
; | $$  | $$  /$$$$$$   /$$$$$$$| $$$$$$$  /$$$$$$$$  /$$$$$$  /$$ /$$$$$$
; | $$$$$$$$ /$$__  $$ /$$_____/| $$__  $$|____ /$$/ /$$__  $$| $$|_  $$_/
; | $$__  $$| $$  \ $$| $$      | $$  \ $$   /$$$$/ | $$$$$$$$| $$  | $$
; | $$  | $$| $$  | $$| $$      | $$  | $$  /$$__/  | $$_____/| $$  | $$ /$$
; | $$  | $$|  $$$$$$/|  $$$$$$$| $$  | $$ /$$$$$$$$|  $$$$$$$| $$  |  $$$$/
; |__/  |__/ \______/  \_______/|__/  |__/|________/ \_______/|__/   \___/

; univ (Universum Zustand), m (List<s-expression>), hand (List<card>), states (List<Symbol,Symbol>), points (List<Number,Number>) --> bundle
; Bundle für Hochzeit
(define (make-hochzeit-bundle univ m hand states points predicate)
  (cond
    [(or (equal? (second m) 'play)      (equal? (second m) 'won)
         (equal? (second m) 'forcePlay) (equal? (second m) 'forceWon))
     (if (predicate (trump univ) hand)
         (make-bundle (list (_state univ)
                            (first-hand univ) (second-hand univ)
                            (first-stich univ) (+ (first points) (first-stich-points univ))
                            (second-stich univ) (+ (second points) (second-stich-points univ))
                            (middle univ) (deck univ)
                            (recent-stich univ) (who-closed univ)
                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                            (trump univ) (wrld-names univ)
                            (current-worlds univ))
                      (list (make-mail (world1 univ) (list (first states)
                                                           (first-hand univ) (second-hand univ)
                                                           (first-stich univ) (+ (first points) (first-stich-points univ))
                                                           (second-stich univ) (+ (second points) (second-stich-points univ))
                                                           (middle univ) (deck univ)
                                                           (recent-stich univ) (who-closed univ)
                                                           (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                           (trump univ) (wrld-names univ)))
                            
                            (make-mail (world2 univ) (list (second states)
                                                           (first-hand univ) (second-hand univ)
                                                           (first-stich univ) (+ (first points) (first-stich-points univ))
                                                           (second-stich univ) (+ (second points) (second-stich-points univ))
                                                           (middle univ) (deck univ)
                                                           (recent-stich univ) (who-closed univ)
                                                           (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                           (trump univ) (wrld-names univ))))
                      '())
         (handle-no-change univ))]
    [else (handle-no-change univ)]))

; univ (Universe Zustand), m (List<s-expressions>), hand (List<card>), states (List<Symbol,Symbol>), points (List<Number,Number>) --> bundle
; Bundle für Trumpf-Hochzeit
(define (make-trump-hochzeit-bundle univ m hand states points predicate)
  (cond
    [(or (equal? (second m) 'play)      (equal? (second m) 'won)
         (equal? (second m) 'forcePlay) (equal? (second m) 'forceWon))
     (if (predicate (trump univ) hand)
         (make-bundle (list (_state univ)
                            (first-hand univ) (second-hand univ)
                            (first-stich univ) (+ (first points) (first-stich-points univ))
                            (second-stich univ) (+ (second points) (second-stich-points univ))
                            (middle univ) (deck univ)
                            (recent-stich univ) (who-closed univ)
                            (gamepoints-p1 univ) (gamepoints-p2 univ)
                            (trump univ) (wrld-names univ)
                            (current-worlds univ))
                      (list (make-mail (world1 univ) (list (first states)
                                                           (first-hand univ) (second-hand univ)
                                                           (first-stich univ) (+ (first points) (first-stich-points univ))
                                                           (second-stich univ) (+ (second points) (second-stich-points univ))
                                                           (middle univ) (deck univ)
                                                           (recent-stich univ) (who-closed univ)
                                                           (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                           (trump univ) (wrld-names univ)))
                            
                            (make-mail (world2 univ) (list (second states)
                                                           (first-hand univ) (second-hand univ)
                                                           (first-stich univ) (+ (first points) (first-stich-points univ))
                                                           (second-stich univ) (+ (second points) (second-stich-points univ))
                                                           (middle univ) (deck univ)
                                                           (recent-stich univ) (who-closed univ)
                                                           (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                           (trump univ) (wrld-names univ))))
                      '())
         (handle-no-change univ))]
    [else (handle-no-change univ)]))



;  /$$$$$$$$                                             /$$                          
; |_____ $$                                             | $$                          
;      /$$/  /$$   /$$ /$$$$$$/$$$$   /$$$$$$   /$$$$$$$| $$$$$$$   /$$$$$$  /$$$$$$$ 
;     /$$/  | $$  | $$| $$_  $$_  $$ |____  $$ /$$_____/| $$__  $$ /$$__  $$| $$__  $$
;    /$$/   | $$  | $$| $$ \ $$ \ $$  /$$$$$$$| $$      | $$  \ $$| $$$$$$$$| $$  \ $$
;   /$$/    | $$  | $$| $$ | $$ | $$ /$$__  $$| $$      | $$  | $$| $$_____/| $$  | $$
;  /$$$$$$$$|  $$$$$$/| $$ | $$ | $$|  $$$$$$$|  $$$$$$$| $$  | $$|  $$$$$$$| $$  | $$
; |________/ \______/ |__/ |__/ |__/ \_______/ \_______/|__/  |__/ \_______/|__/  |__/

; univ (Universum Zustand), m (List<s-expressions>), states (List<Symbol,Symbol>), i-closed (Symbol) --> bundle
; Bundle für Zumachen
(define (make-close-bundle univ m states i-closed)
  (if (or (equal? (second m) 'play) (equal? (second m) 'won))
      (make-bundle (list 'p1
                         (first-hand univ) (second-hand univ)
                         (first-stich univ) (first-stich-points univ)
                         (second-stich univ) (second-stich-points univ)
                         (middle univ) '()
                         (recent-stich univ) i-closed
                         (gamepoints-p1 univ) (gamepoints-p2 univ)
                         (trump univ) (wrld-names univ)
                         (current-worlds univ))
                   (list (make-mail (world1 univ) (list (first states)
                                                        (first-hand univ) (second-hand univ)
                                                        (first-stich univ) (first-stich-points univ)
                                                        (second-stich univ) (second-stich-points univ)
                                                        (middle univ) '()
                                                        (recent-stich univ) i-closed
                                                        (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                        (trump univ) (wrld-names univ)))
                         
                         (make-mail (world2 univ) (list (second states)
                                                        (first-hand univ) (second-hand univ)
                                                        (first-stich univ) (first-stich-points univ)
                                                        (second-stich univ) (second-stich-points univ)
                                                        (middle univ) '()
                                                        (recent-stich univ) i-closed
                                                        (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                        (trump univ) (wrld-names univ))))
                   '())
      (handle-no-change univ)))



;  /$$$$$$$$                                      /$$                          
; |__  $$__/                                     | $$                          
;    | $$  /$$$$$$  /$$   /$$  /$$$$$$$  /$$$$$$$| $$$$$$$   /$$$$$$  /$$$$$$$ 
;    | $$ |____  $$| $$  | $$ /$$_____/ /$$_____/| $$__  $$ /$$__  $$| $$__  $$
;    | $$  /$$$$$$$| $$  | $$|  $$$$$$ | $$      | $$  \ $$| $$$$$$$$| $$  \ $$
;    | $$ /$$__  $$| $$  | $$ \____  $$| $$      | $$  | $$| $$_____/| $$  | $$
;    | $$|  $$$$$$$|  $$$$$$/ /$$$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$| $$  | $$
;    |__/ \_______/ \______/ |_______/  \_______/|__/  |__/ \_______/|__/  |__/

; univ (Universe Zustand), m (List<s-expressions>), updated_first_hand (List<cards>), updated_deck (List<cards>) --> bundle
; Bundle für Tauschen (P1)
(define (make-swap-bundle-p1 univ m updated_first_hand updated_deck)
  (make-bundle (list (_state univ)
                     updated_first_hand (second-hand univ)
                     (first-stich univ) (first-stich-points univ)
                     (second-stich univ) (second-stich-points univ)
                     (middle univ) updated_deck
                     (recent-stich univ) (who-closed univ)
                     (gamepoints-p1 univ) (gamepoints-p2 univ)
                     (trump univ) (wrld-names univ)
                     (current-worlds univ))
               (list (make-mail (world1 univ) (list 'swap
                                                    updated_first_hand (second-hand univ)
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    (middle univ) updated_deck
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ)))
                     
                     (make-mail (world2 univ) (list 'swap
                                                    updated_first_hand (second-hand univ)
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    (middle univ) updated_deck
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ))))
               '()))

; univ (Universe Zustand), m (List<s-expressions>), updated_first_hand (List<cards>), updated_deck (List<cards>) --> bundle
; Bundle für Tauschen (P2)
(define (make-swap-bundle-p2 univ m updated_second_hand updated_deck)
  (make-bundle (list (_state univ)
                     (first-hand univ) updated_second_hand
                     (first-stich univ) (first-stich-points univ)
                     (second-stich univ) (second-stich-points univ)
                     (middle univ) updated_deck
                     (recent-stich univ) (who-closed univ)
                     (gamepoints-p1 univ) (gamepoints-p2 univ)
                     (trump univ) (wrld-names univ)
                     (current-worlds univ))
               (list (make-mail (world1 univ) (list 'swap
                                                    (first-hand univ) updated_second_hand
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    (middle univ) updated_deck
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ)))
                     
                     (make-mail (world2 univ) (list 'swap
                                                    (first-hand univ) updated_second_hand
                                                    (first-stich univ) (first-stich-points univ)
                                                    (second-stich univ) (second-stich-points univ)
                                                    (middle univ) updated_deck
                                                    (recent-stich univ) (who-closed univ)
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    (trump univ) (wrld-names univ))))
               '()))



;   /$$$$$$                        /$$     /$$                                        
;  /$$__  $$                      | $$    |__/                                        
; | $$  \__/  /$$$$$$   /$$$$$$  /$$$$$$   /$$  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$ 
; |  $$$$$$  /$$__  $$ /$$__  $$|_  $$_/  | $$ /$$__  $$ /$$__  $$ /$$__  $$| $$__  $$
;  \____  $$| $$  \ $$| $$  \__/  | $$    | $$| $$$$$$$$| $$  \__/| $$$$$$$$| $$  \ $$
;  /$$  \ $$| $$  | $$| $$        | $$ /$$| $$| $$_____/| $$      | $$_____/| $$  | $$
; |  $$$$$$/|  $$$$$$/| $$        |  $$$$/| $$|  $$$$$$$| $$      |  $$$$$$$| $$  | $$
;  \______/  \______/ |__/         \___/  |__/ \_______/|__/       \_______/|__/  |__/

; univ (Universum Zustand), wrld (Welt Zustand) --> bundle
; Bundle für Sortieren (P1)
(define (make-sort-bundle-p1 univ wrld)
  (let ([sorted-hand (sort (first-hand univ) (lambda (x y) (< (fourth x) (fourth y))))])
    (make-bundle (list (_state univ)
                       sorted-hand (second-hand univ)
                       (first-stich univ) (first-stich-points univ)
                       (second-stich univ) (second-stich-points univ)
                       (middle univ) (deck univ)
                       (recent-stich univ) (who-closed univ)
                       (gamepoints-p1 univ) (gamepoints-p2 univ)
                       (trump univ) (wrld-names univ)
                       (current-worlds univ))
                 (list (make-mail (world1 univ) (list 'sort
                                                      sorted-hand (second-hand univ)
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                      (trump univ) (wrld-names univ)))
                       (make-mail (world2 univ) (list 'sort
                                                      sorted-hand (second-hand univ)
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                      (trump univ) (wrld-names univ))))
                 '())))

; univ (Universum Zustand) wrld (Welt Zustand) --> bundle
; Bundle für Sortieren (P2)
(define (make-sort-bundle-p2 univ wrld)
  (let ([sorted-hand (sort (second-hand univ) (lambda (x y) (< (fourth x) (fourth y))))])
    (make-bundle (list (_state univ)
                       (first-hand univ) sorted-hand
                       (first-stich univ) (first-stich-points univ)
                       (second-stich univ) (second-stich-points univ)
                       (middle univ) (deck univ)
                       (recent-stich univ) (who-closed univ)
                       (gamepoints-p1 univ) (gamepoints-p2 univ)
                       (trump univ) (wrld-names univ)
                       (current-worlds univ))
                 (list (make-mail (world1 univ) (list 'sort
                                                      (first-hand univ) sorted-hand
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                      (trump univ) (wrld-names univ)))
                       (make-mail (world2 univ) (list 'sort
                                                      (first-hand univ) sorted-hand
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                      (trump univ) (wrld-names univ))))
                 '())))



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

; univ (Universe Zustand), states (List<Symbol,Symbol>) --> bundle
; Bundle für Stoppen
(define (make-stop-bundle univ states)
  (let ([p1_gamepoints
         (cond
           [(member (first states) (list 'Won3t 'cWon3t 'cWon3f 'Won3f)) (+ (gamepoints-p1 univ) 3)]
           [(member (first states) (list 'Won2t 'cWon2t)) (+ (gamepoints-p1 univ) 2)]
           [(member (first states) (list 'Won1t 'cWon1t 'wonLast)) (+ (gamepoints-p1 univ) 1)]
           [(member (second states) (list 'Lost3t 'cLost3t 'cLost3f 'Lost3f)) (+ (gamepoints-p1 univ) 3)]
           [(member (second states) (list 'Lost2t 'cLost2t)) (+ (gamepoints-p1 univ) 2)]
           [(member (second states) (list 'Lost1t 'cLost1t 'lostLast)) (+ (gamepoints-p1 univ) 1)]
           [else (+ (gamepoints-p1 univ) 0)])]
        [p2_gamepoints
         (cond
           [(member (second states) (list 'Won3t 'cWon3t 'cWon3f 'Won3f)) (+ (gamepoints-p2 univ) 3)]
           [(member (second states) (list 'Won2t 'cWon2t)) (+ (gamepoints-p2 univ) 2)]
           [(member (second states) (list 'Won1t 'cWon1t 'wonLast)) (+ (gamepoints-p2 univ) 1)]
           [(member (first states) (list 'Lost3t 'cLost3t 'cLost3f 'Lost3f)) (+ (gamepoints-p2 univ) 3)]
           [(member (first states) (list 'Lost2t 'cLost2t)) (+ (gamepoints-p2 univ) 2)]
           [(member (first states) (list 'Lost1t 'cLost1t 'lostLast)) (+ (gamepoints-p2 univ) 1)]
           [else (+ (gamepoints-p2 univ) 0)])])
        
    (make-bundle (list (_state univ)
                       (first-hand univ) (second-hand univ)
                       (first-stich univ) (first-stich-points univ)
                       (second-stich univ) (second-stich-points univ)
                       (middle univ) (deck univ)
                       (recent-stich univ) (who-closed univ)
                       p1_gamepoints p2_gamepoints
                       (trump univ) (wrld-names univ)
                       (current-worlds univ))
                 (list (make-mail (world1 univ) (list (first states)
                                                      (first-hand univ) (second-hand univ)
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      p1_gamepoints p2_gamepoints
                                                      (trump univ) (wrld-names univ)))
                           
                       (make-mail (world2 univ) (list (second states)
                                                      (first-hand univ) (second-hand univ)
                                                      (first-stich univ) (first-stich-points univ)
                                                      (second-stich univ) (second-stich-points univ)
                                                      (middle univ) (deck univ)
                                                      (recent-stich univ) (who-closed univ)
                                                      p1_gamepoints p2_gamepoints
                                                      (trump univ) (wrld-names univ))))
                 '())))

(define (make-restart-bundle univ new-first-hand new-second-hand new-deck new-trump states)
  (make-bundle (list 'p0
                     new-first-hand new-second-hand
                     '() 0
                     '() 0
                     '() new-deck
                     '() 'p0
                     (gamepoints-p1 univ) (gamepoints-p2 univ)
                     new-trump (wrld-names univ)
                     (current-worlds univ))
               (list (make-mail (world1 univ) (list (first states)
                                                    new-first-hand new-second-hand
                                                    '() 0
                                                    '() 0
                                                    '() new-deck
                                                    '() 'p0
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    new-trump (wrld-names univ)))
                     (make-mail (world2 univ) (list (second states)
                                                    new-first-hand new-second-hand
                                                    '() 0
                                                    '() 0
                                                    '() new-deck
                                                    '() 'p0
                                                    (gamepoints-p1 univ) (gamepoints-p2 univ)
                                                    new-trump (wrld-names univ))))
               '()))

; univ (Universum Zustand) --> 
; Bundle für keine Veränderung
(define (handle-no-change univ)
  (make-bundle univ '() '()))

(provide (all-defined-out))