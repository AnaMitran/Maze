# Maze
Escaping a maze using Verilog

Provocarea ridicata de problema “maze” este gasirea iesirii, aflata pe conturul labirintului. Stiu sigur ca pornesc de pe o pozitie libera si ca in jurul meu se afla 3 pereti, deci voi avea o singura iesire dintre acestia. Pentru a ma orienta mai departe folosesc algoritmul Wall Follower, ce presupune sa ma asigur ca am in permanenta perete in dreapta mea (sau stanga). Aceasta metoda garanteaza ca indiferent de aparatia infundaturilor si reluarea unor pasi, voi reusi sa gasesc intr-un final iesirea din labirint.

Implementarea nu poate fi de tip brute force prin parcurgerea intregii matrici corespunzatoare labirintului si nu pot retine mai mult decat indicii pozitiei curente. Scenariul este similar cu deplasarea unei persoane cu incapaciatate de vedere. Trebuie sa ating peretele din dreapta pentru a sti sigur ca este acolo si ma voi lovi cu capul de peretele pe care eu l-am presupus culoar liber. Ceea ce imi aminteste de Minesweeper unde trebuia sa imi creez o stategie pentru a descoperi celulele din jurul meu fara a declansa o bomba. Si in cazul acestui joc, parcugeam din aproape in aproape, pentru a putea atinge scopul.

![image](https://user-images.githubusercontent.com/89164540/156737960-e4333ddc-2f0b-488b-b258-8c09dfa9d11c.png)

Initial in labirint, scenariul arata asemanator cu:

Primul task al meu este sa gasesc iesirea dintre cei 3 pereti.
Cum fac asta? Ma ghidez dupa busola, adica dupa punctele cardinale (N, V, S, E) si retin de fiecare data directia in care m-am deplasat.

Stiind coordonatele punctului de start, voi putea sa imi determin noua pozitie in care m-am mutat, dupa directia X, intrucat incrementez sau decrementez linia sau coloana astfel:
Pot porni inspre orice directie, insa pentru o buna practica pentru parcurgerea ulterioara a labirintului aleg urmatoarea directie in sens trigonometric.

![image](https://user-images.githubusercontent.com/89164540/156738965-519bd825-10ef-4821-89d4-f1eef2d61f6f.png)

De ce in sens trigonometric? Pentru ca astfel, dupa ce ies dintre cei 3 pereti, prioritizez verificarea valorii din dreapta, adica a existentei peretelui in dreapta. Daca am perete in dreapta, voi verifica in fata mea. In cazul in care in fata am un perete, verific daca pot iesi prin stanga si de-abia daca si atunci descopar ca am un perete si nu un culoar, ma intorc pe unde am venit, pentru ca este o fundatura.
Pentru a verifica ce exista in dreapta, aleg directia anterioara directiei de deplasare „in fata”.
Sagetile negre indica directia de deplasare. De fiecare data cand descopar un perete, ma intorc la pozitia atenrioara, adica pe directia inversa de deplasare. Sagetile galbene indica sensul trigonometric de alegere a urmatoarei directii (S – E – N – W).
Pentru a ma intoarce ma folosesc de regulile de schimbare a coordonatelor, prezentate mai sus si nu schimb efectiv directia, decat in sens trigonometric sau aleg directia anterioara pentru a verifica peretele in dreapta.
In cazul in care in dreapta mea nu am peretele inseamna ca am trecut pe langa un colt din labirint. Totusi acest caz este similar cu situatia iesirii dintre primii 3 pereti.

Logica de implementare:
Automatul finit determinist este de tip Moore (iesirea pe stare - aflu mereu informatia utila sau pot face modificari asupra labirintului doar la pasul urmator = urmatorul front crescator de ceas). Circuitul este de tip secvential sincron, cu parte combinationala de prelucrare/setare a datelor.
Modulul are urmatoarea structura:
In fiecare stare, pot modifica fie maze_we pentru scriere in labirint, fie maze_oe pentru citire din labirint.
set : starea de pornire, salvez coordonatele punctului de start, setez o directie initiala de deplasare si permit marcarea drumului in labirint prin maze_we = 1
update : modific coordonatele pozitiei indicate de directia anterior aleasa si permit citirea valorii inregistrare in aceasta pozitie prin maze_oe = 1
check : pot verifica valoarea pozitiei in care ma aflu (in maze_in), daca am descoperit :
- un perete (maze_in = 1), revin la pozitia anterioara si voi trece la directia urmatoare in sens trigonometric
- un culoar (maze_in = 0), permit marcarea drumului, verific daca nu cumva am ajuns la iesire, aflandu-ma pe conturul labirintului si voi schimba directia in cea anterioara pentru a verifica daca am perete in dreapta
Se trece de la starea update la check si invers atata timp cat nu am gasit iesirea din labirint (done = 1) .
Am observat ca doar aceste stari sunt suficiente atat pentru a gasi iesirea dintre cei trei pereti, cat si pentru a ma orienta prin labirint, intrucat folosesc aceeasi logica de actualizare si verificare a datelor.
