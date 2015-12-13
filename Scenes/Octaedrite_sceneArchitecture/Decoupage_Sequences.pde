/*
info : 
 R : Message Max/Msp to Processing (entête);
 S : Message Processing to Max/Msp (entête);
 onOff : int between -1, 0, 1; (0 : begin; 1 : end; -1 : erase);
 float : normalized value only;
 
 Scene 1_1 : Page 3 à 8
 R Pattern : /scene00_00_P5
 i : int Top/End : Debut/Fin de la scène
 iiff : int index, int onOff, float speed, float opacity : Ajouter un tracé
 S Pattern :  /P5_scene00_00
 ii : int index, int onOff : Le tracé est arrivé à la fin de son animation
 
 Scene 2_1 : Page 10 à 11
 R Pattern : /scene01_00_P5
 i : int Top/End : Debut/Fin de la scène
 iif : int index, int onOff, float deviation : Ajouter une grattage
 ii : int "cut", int plan : changement de plan (int plan : 0 = zoom, 1 = dezoom)
 S Pattern : /P5_scene01_00
 if : int index, float distanceBetweenActualAndPrevious : Envoi des donnée du grattage
 
 Scene 2_2 : Page 12 à 14
 R Pattern : /scene01_01_P5
 i : int Top/End : Debut/Fin de la scène
 iifff : int index, int onOff, float beginLocation, float endLocation, float speed : Ajouter un tracé
 f : float meteoriteOpacity : Faire varier l'intensité de la météorite
 S Pattern : /P5_scene01_01
 iffff : int index, float angle, float radius, float intensity : Données des tracés
 
 Scene 3_1 : Page 16 
 R Pattern : /scene02_00_P5
 i : int Top/End : Debut/Fin de la scène
 iiff : int index, int onOff, float speed, float intensity : Ajouter un tracé interieur
 ii : int index, int onOff : supprimer un tracé de contour
 S Pattern : /P5_scene02_00
 if : int index, float distanceBetweenLineAndCenter : données du tracé interieur
 ii : int index, int onOff : fin de l'animation du tracé interieur
 
 Scene 3_2 : Page 17 à 19
 R Pattern : /scene02_01_P5
 i : int Top/End : Debut/Fin de la scène
 iif : int index, int onOff, float speed : ajouter une tete de lecture
 S Pattern : /P5_scene02_01
 ifi : int index, float position, int arrivedAtExtremity : données de la tête de lecture
 
 Scene 3_3 : Page 19 à 25
 R Pattern : /scene02_02_P5
 i : int Top/End : Debut/Fin de la scène
 sii: String "unlock" int indexElement, int onOff : décrocher une tête de lecture
 ii : int index, int onOff : apparition des éléments/tracés précédents
 S Pattern : /P5_scene02_02
 iff : int index, float angle, float intensity : rebon d'une tête de lecture
 
 Scene 3_4 : Page 26 à 27
 R Pattern : /scene02_03_P5
 i : int Top/End : Debut/Fin de la scène
 iif : int index, int onOff, float speed : ajouter une bande de scanner
 S Pattern : /P5_scene03_02
 if : int index, float collisionPosition : envoi des données du scanner
 */