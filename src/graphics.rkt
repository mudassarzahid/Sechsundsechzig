#lang racket
(require 2htdp/image)

; Card_images ist dafür da, Kartenbilder, die Bilder der Charaktere und Sonstiges (für den Renderer) bereitzustellen.

;  /$$   /$$                       /$$                         /$$       /$$ /$$       /$$                    
; | $$  /$$/                      | $$                        | $$      |__/| $$      | $$                    
; | $$ /$$/   /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$  /$$$$$$$ | $$$$$$$  /$$| $$  /$$$$$$$  /$$$$$$   /$$$$$$ 
; | $$$$$/   |____  $$ /$$__  $$|_  $$_/   /$$__  $$| $$__  $$| $$__  $$| $$| $$ /$$__  $$ /$$__  $$ /$$__  $$
; | $$  $$    /$$$$$$$| $$  \__/  | $$    | $$$$$$$$| $$  \ $$| $$  \ $$| $$| $$| $$  | $$| $$$$$$$$| $$  \__/
; | $$\  $$  /$$__  $$| $$        | $$ /$$| $$_____/| $$  | $$| $$  | $$| $$| $$| $$  | $$| $$_____/| $$      
; | $$ \  $$|  $$$$$$$| $$        |  $$$$/|  $$$$$$$| $$  | $$| $$$$$$$/| $$| $$|  $$$$$$$|  $$$$$$$| $$      
; |__/  \__/ \_______/|__/         \___/   \_______/|__/  |__/|_______/ |__/|__/ \_______/ \_______/|__/

; Bilder von den vier Farben (Kartentypen): Kreuz, Pik, Herz, Karo
(define KREUZ (bitmap "cardimgs/Kreuz.png"))
(define PIK   (bitmap "cardimgs/Pik.png"))
(define HERZ  (bitmap "cardimgs/Herz.png"))
(define KARO  (bitmap "cardimgs/Karo.png"))

; Bilder von König, Dame, Bube
; kommt noch!

; Bild des Kartenrückens
(define BACK (bitmap "cardimgs/back.png"))

; Bild einer leeren Karte (Platzhalter)
(define EMPTY (rectangle 48 72 'solid "transparent"))

; Alle Karten
(define KREUZ-A  (bitmap "cardimgs/Kreuz-A.png"))
(define KREUZ-10 (bitmap "cardimgs/Kreuz-10.png"))
(define KREUZ-K  (bitmap "cardimgs/Kreuz-K.png"))
(define KREUZ-D  (bitmap "cardimgs/Kreuz-D.png"))
(define KREUZ-B  (bitmap "cardimgs/Kreuz-B.png"))
(define KREUZ-9  (bitmap "cardimgs/Kreuz-9.png"))

(define PIK-A  (bitmap "cardimgs/Pik-A.png"))
(define PIK-10 (bitmap "cardimgs/Pik-10.png"))
(define PIK-K  (bitmap "cardimgs/Pik-K.png"))
(define PIK-D  (bitmap "cardimgs/Pik-D.png"))
(define PIK-B  (bitmap "cardimgs/Pik-B.png"))
(define PIK-9  (bitmap "cardimgs/Pik-9.png"))

(define HERZ-A  (bitmap "cardimgs/Herz-A.png"))
(define HERZ-10 (bitmap "cardimgs/Herz-10.png"))
(define HERZ-K  (bitmap "cardimgs/Herz-K.png"))
(define HERZ-D  (bitmap "cardimgs/Herz-D.png"))
(define HERZ-B  (bitmap "cardimgs/Herz-B.png"))
(define HERZ-9  (bitmap "cardimgs/Herz-9.png"))

(define KARO-A  (bitmap "cardimgs/Karo-A.png"))
(define KARO-10 (bitmap "cardimgs/Karo-10.png"))
(define KARO-K  (bitmap "cardimgs/Karo-K.png"))
(define KARO-D  (bitmap "cardimgs/Karo-D.png"))
(define KARO-B  (bitmap "cardimgs/Karo-B.png"))
(define KARO-9  (bitmap "cardimgs/Karo-9.png"))

; trump (String) --> Image
; Gibt das Bild der Trumpffarbe aus
(define (trump-image trump)
  (cond
    [(equal? trump "Kreuz") KREUZ]
    [(equal? trump "Pik")   PIK]
    [(equal? trump "Herz")  HERZ]
    [(equal? trump "Karo")  KARO]
    [else EMPTY]))



;   /$$$$$$  /$$                                    /$$         /$$                                  
;  /$$__  $$| $$                                   | $$        | $$                                  
; | $$  \__/| $$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$ | $$   /$$ /$$$$$$    /$$$$$$   /$$$$$$   /$$$$$$ 
; | $$      | $$__  $$ |____  $$ /$$__  $$|____  $$| $$  /$$/|_  $$_/   /$$__  $$ /$$__  $$ /$$__  $$
; | $$      | $$  \ $$  /$$$$$$$| $$  \__/ /$$$$$$$| $$$$$$/   | $$    | $$$$$$$$| $$  \__/| $$$$$$$$
; | $$    $$| $$  | $$ /$$__  $$| $$      /$$__  $$| $$_  $$   | $$ /$$| $$_____/| $$      | $$_____/
; |  $$$$$$/| $$  | $$|  $$$$$$$| $$     |  $$$$$$$| $$ \  $$  |  $$$$/|  $$$$$$$| $$      |  $$$$$$$
;  \______/ |__/  |__/ \_______/|__/      \_______/|__/  \__/   \___/   \_______/|__/       \_______/

; Bilder von den zwei gegeneinanderspielenden Charakteren mit Reaktionen
(define CHAR1      (bitmap "cardimgs/Char1.png"))
(define CHAR1-WON  (bitmap "cardimgs/Char1Happy.png"))
(define CHAR1-LOST (bitmap "cardimgs/Char1Sad.png"))
(define CHAR2      (bitmap "cardimgs/Char2.png"))
(define CHAR2-WON  (bitmap "cardimgs/Char2Happy.png"))
(define CHAR2-LOST (bitmap "cardimgs/Char2Sad.png"))



;  /$$$$$$$$                    /$$    
; |__  $$__/                   | $$    
;    | $$  /$$$$$$  /$$   /$$ /$$$$$$  
;    | $$ /$$__  $$|  $$ /$$/|_  $$_/  
;    | $$| $$$$$$$$ \  $$$$/   | $$    
;    | $$| $$_____/  >$$  $$   | $$ /$$
;    | $$|  $$$$$$$ /$$/\  $$  |  $$$$/
;    |__/ \_______/|__/  \__/   \___/  
                                     
; m (String) --> Image
; Formatieren der Zug-erklärenden Nachrichten
(define (main-text m)
  (text/font m 24 "darkblue" "Lucida Sans" 'swiss 'normal 'bold #f))

; m (String) --> Image
; Formatieren anderer Nachrichten
(define (custom-text m size color weight)
  (text/font m size color "Lucida Sans" 'swiss 'normal weight #f))

; Text für eine neues Spiel
(define new-game-text (main-text "Für ein neues Spiel bitte klicken."))

; num (number) --> String
; Erklärungsmessages am Ende eines Spiels
(define (get-won-end-message state name)
  (let ([opponent (string-replace (~v name) "\"" "")])
    (let ([messages
           (cond
             [(or
               (equal? state 'cWon3t)
               (equal? state 'Won3t))  (list "Du gewinnst!"
                                             "Du bekommst 3 Gewinnpunkte")]
             [(or
               (equal? state 'Won2t)
               (equal? state 'cWon2t)) (list "Du gewinnst!"
                                             "Du bekommst 2 Gewinnpunkte")]
             [(or
               (equal? state 'Won1t)
               (equal? state 'Won1t))  (list "Du gewinnst!"
                                             "Du bekommst 1 Gewinnpunkte")]
             [(equal? state 'Won3f)    (list (string-append "Du gewinnst, weil " opponent " Gegner gestoppt hat, bevor er 66 Punkte erreicht hat!")
                                             "Du bekommst 3 Gewinnpunkte")]
             [(equal? state 'cWon3f)   (list (string-append "Du gewinnst, weil " opponent " zugemacht und nicht 66 Punkt erreicht hat!")
                                             "Du bekommst 3 Gewinnpunkte.")]
             [(equal? state 'wonLast)  (list "Du gewinnst, weil du den letzten Stich bekommen hast!"
                                             "Du bekommst 1 Gewinnpunkt.")])])
      (above
       (custom-text (first messages) 16 'darkgreen 'normal)
       (vertical-padding 10)
       (custom-text (second messages) 22 'darkgreen 'bold)))))


(define (get-lost-end-message state name)
  (let ([opponent (string-replace (~v name) "\"" "")])
    (let ([messages
           (cond
             [(or
               (equal? state 'cLost3t)
               (equal? state 'Lost3t))  (list "Du verlierst"
                                              opponent " bekommt 3 Gewinnpunkte")]
             [(or
               (equal? state 'Lost2t)
               (equal? state 'cLost2t)) (list "Du verlierst"
                                              opponent " bekommt 2 Gewinnpunkte")]
             [(or
               (equal? state 'Lost1t)
               (equal? state 'Lost1t))  (list "Du verlierst"
                                              (string-append opponent " bekommt 1 Gewinnpunkte"))]
             [(equal? state 'Lost3f)    (list "Du verlierst, weil du gestoppt hast, bevor du 66 Punkte erreicht hast!"
                                              (string-append opponent " bekommt 3 Gewinnpunkte"))]
             [(equal? state 'cLost3f)   (list "Du verlierst, weil du zugemacht hast, bevor du 66 Punkte erreicht hast."
                                              (string-append opponent " bekommt 3 Gewinnpunkte."))]
             [(equal? state 'lostLast)  (list "Du verlierst, weil du den letzten Stich abgegeben hast!"
                                              (string-append opponent " bekommt 1 Gewinnpunkt."))])])
      (above
      (custom-text (first messages) 16 'red 'normal)
       (vertical-padding 10)
       (custom-text (second messages) 22 'red 'bold)))))

; state (Symbol) --> Image
; Rendern vom State des Spielers
(define (render-text state name)
  (let ([opponent (custom-text (string-replace (~v name) "\"" "") 24 'red 'bold)])
    (cond
      [(equal? state 'play)               (above (main-text "Du bist am Zug!")
                                                 (main-text ""))]
      [(equal? state 'won)                (above (main-text "Du hast den Stich gewonnen!")
                                                 (main-text ""))]
      [(equal? state 'announce)           (above (main-text "Du hast ein Pärchen angesagt!")
                                                 (main-text ""))]
      [(equal? state 'announceTrump)      (above (main-text "Du hast das Trumpf-Pärchen angesagt!")
                                                 (main-text ""))]
      [(equal? state 'forcePlay)          (above (main-text "Du bist am Zug!")
                                                 (main-text "Es herrscht Farbzwang."))]
      [(equal? state 'forceWon)           (above (main-text "Du hast den Stich gewonnen!")
                                                 (main-text "Es herrscht Farbzwang."))]
      [(equal? state 'forceAnnounce)      (above (main-text "Du hast ein Pärchen angesagt!")
                                                 (main-text "Es herrscht Farbzwang."))]
      [(equal? state 'forceAnnounceTrump) (above (main-text "Du hast das Trumpf-Pärchen angesagt!")
                                                 (main-text "Es herrscht Farbzwang."))]

      [(equal? state 'waitStich)          (above (main-text "")
                                                 (main-text ""))]
      [(equal? state 'wait)               (above (beside (main-text "Warte auf ") opponent (main-text "..."))
                                                 (main-text ""))]
      [(equal? state 'lost)               (above (main-text "Du hast den Stich verloren!")
                                                 (main-text ""))]
      [(equal? state 'listen)             (above (beside opponent (main-text " hat ein Pärchen angesagt."))
                                                 (main-text ""))]
      [(equal? state 'listenTrump)        (above (beside opponent (main-text " hat das Trumpf-Pärchen angesagt."))
                                                 (main-text ""))]
      [(equal? state 'forceWait)          (above (beside (main-text "Warte auf ") opponent (main-text "..."))
                                                 (main-text "Es herrscht Farbzwang."))]
      [(equal? state 'forceLost)          (above (main-text "Du hast den Stich verloren!")
                                                 (main-text "Es herrscht Farbzwang."))]
      [(equal? state 'forceListen)        (above (beside opponent (main-text " hat ein Pärchen angesagt."))
                                                 (main-text "Es herrscht Stichzwang"))]
      [(equal? state 'forceListenTrump)   (above (beside opponent (main-text "name hat das Trumpf-Pärchen angesagt."))
                                                 (main-text "Es herrscht Stichzwang"))])))



;   /$$$$$$                                  /$$     /$$                              
;  /$$__  $$                                | $$    |__/                              
; | $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$$ /$$$$$$   /$$  /$$$$$$   /$$$$$$   /$$$$$$$
; |  $$$$$$  /$$__  $$| $$__  $$ /$$_____/|_  $$_/  | $$ /$$__  $$ /$$__  $$ /$$_____/
;  \____  $$| $$  \ $$| $$  \ $$|  $$$$$$   | $$    | $$| $$  \ $$| $$$$$$$$|  $$$$$$ 
;  /$$  \ $$| $$  | $$| $$  | $$ \____  $$  | $$ /$$| $$| $$  | $$| $$_____/ \____  $$
; |  $$$$$$/|  $$$$$$/| $$  | $$ /$$$$$$$/  |  $$$$/| $$|  $$$$$$$|  $$$$$$$ /$$$$$$$/
;  \______/  \______/ |__/  |__/|_______/    \___/  |__/ \____  $$ \_______/|_______/ 
;                                                        /$$  \ $$                    
;                                                       |  $$$$$$/                    
;                                                        \______/

; Hintergrundbild der Tastenbedienung
(define BACKGROUND (rectangle 480 80 'solid "lightgrey"))

; Abstand zwischen jeweils zwei Karten auf der Hand
(define WHITESPACE (rectangle 10 0 'solid "transparent"))

; Trennlinie zwischen Sprite und Karten
(define DIVIDER
  (rectangle 600 2 'solid 'grey))

; Abstände vor / zwischen / nach den einzelnen Elementen
(define margin-left-text   (rectangle 100  0 'solid "transparent"))
(define margin-left-deck   (rectangle 194  0 'solid "transparent"))
(define margin-left-middle (rectangle 208  0 'solid "transparent"))
(define margin-left-hand   (rectangle  30  0 'solid "transparent"))
(define margin-left-stich  (rectangle 175  0 'solid "transparent"))

; n (number) --> Horizontaler Abstand mit Breite n (image)
; Elemente horizontal verschieben
(define (horizontal-padding n)
  (rectangle  n  0 'solid "transparent"))

; n (number) --> Vertikaler Abstand mit Breite n (image)
; Elemente vertikal verschieben
(define (vertical-padding n)
  (rectangle  0  n 'solid "transparent"))

; n (number) --> Horizontaler Abstand mit Breite 29*n (image)
; Zentrieren der Handkarten; je weniger Karten, desto weiter nach rechts müssen alle Karten verschoben werden
(define (padding-hand n)
  (rectangle (* n 29) 0 'solid "transparent"))

; Bild der Tastenbedienung
(define controls
  (let ([vert-padding (vertical-padding 10)]
        [hor-padding (horizontal-padding 10)])
    (underlay BACKGROUND
              (above
               (beside (custom-text "1-6    " 16 'black 'bold) (custom-text "Karten legen" 16 'black 'normal))
               vert-padding
               (beside
                (beside
                 (above/align "left"
                              (custom-text "S" 14 'black 'bold)
                              (custom-text "T" 14 'black 'bold))
                 hor-padding
                 (above/align "left"
                              (custom-text "Sortieren"       14 'black 'normal)
                              (custom-text "Trumpf tauschen" 14 'black 'normal)))
                hor-padding
                (beside
                 (above/align "left"
                              (custom-text "H" 14 'black 'bold)
                              (custom-text "J" 14 'black 'bold))
                 hor-padding
                 (above/align "left"
                              (custom-text "Hochzeit ansagen"        14 'black 'normal)
                              (custom-text "Trumpf-Hochzeit ansagen" 14 'black 'normal)))
                hor-padding
                (beside
                 (above/align "left"
                              (custom-text "Z"     14 'black 'bold)
                              (custom-text "Enter" 14 'black 'bold))
                 hor-padding
                 (above/align "left"
                              (custom-text "Zumachen" 14 'black 'normal)
                              (custom-text "Stoppen"  14 'black 'normal))))))))

; Alles exportieren
(provide (all-defined-out))