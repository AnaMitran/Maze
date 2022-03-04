# Maze
Escaping a maze using Verilog

Provocarea ridicata de problema “maze” este gasirea iesirii, aflata pe conturul labirintului. Stiu sigur ca pornesc de pe o pozitie libera si ca in jurul meu se afla 3 pereti, deci voi avea o singura iesire dintre acestia. Pentru a ma orienta mai departe folosesc algoritmul Wall Follower, ce presupune sa ma asigur ca am in permanenta perete in dreapta mea (sau stanga). Aceasta metoda garanteaza ca indiferent de aparatia infundaturilor si reluarea unor pasi, voi reusi sa gasesc intr-un final iesirea din labirint.

Implementarea nu poate fi de tip brute force prin parcurgerea intregii matrici corespunzatoare labirintului si nu pot retine mai mult decat indicii pozitiei curente. Scenariul este similar cu deplasarea unei persoane cu incapaciatate de vedere. Trebuie sa ating peretele din dreapta pentru a sti sigur ca este acolo si ma voi lovi cu capul de peretele pe care eu l-am presupus culoar liber. Ceea ce imi aminteste de Minesweeper unde trebuia sa imi creez o stategie pentru a descoperi celulele din jurul meu fara a declansa o bomba. Si in cazul acestui joc, parcugeam din aproape in aproape, pentru a putea atinge scopul.
![image](https://user-images.githubusercontent.com/89164540/156737960-e4333ddc-2f0b-488b-b258-8c09dfa9d11c.png)
