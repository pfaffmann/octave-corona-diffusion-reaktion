% Corona-Modell
clear all;
close all;
% *** INPUT ***

%Welche Methode der Verbreitung soll gewählt werden
% 1: linear
% 2: nicht-linear
% 3: stw. stetig
methode = 3;

%Raumvariablen
Rasterlaenge = 50; % Die interpolierte Matrix soll eine Rasterlaenge von "Rasterlaenge" in Metern haben. Entspricht h * 1000 Metern (h ist in km also 0,05 km)

% Zeitvariablen
maxTage = 365*2; %AnzahlTage als Obergrenze
delta_t = 0.05; 


%Plotten ja oder nein?
global plotten=true;
global speichern=false;
global fileDir = 'Images'; %OrdnerName zum Speichern der Bilder.

% Infektionsvariablen
BasisErkrankungsrate = 0.33; %"Rate der Infektionsverbreitung" bei einer Kontaktrate: Wahrscheinlichkeit des Kontakts eines Infizierten mit einem                                     Anfaelligen. 
Wechselrate = (1/14); % von Infizierten zu Genesenen

% Diffussionskoeffizient
c_0 = 0.25/1000; % beschreibt Ausbreitungsgeschwindigkeit -> je größer, desto schneller verbreitet sich die Infektion im Raum durch Kontaktübertragung
                 %Basisdiffusionskoeffzient (gering waehlen, da bei BevDichte = 0 dieser Wert genommen wird)

% *** Bevoelkerungsmatrix ***
B = BevDichteMatrix();
[B_Interpoliert, M, N, h] = InterpoliereBevDichteMatrix(B, Rasterlaenge);

global x = linspace(0,N*h,N);
global y = linspace(0,M*h,M);

% *** Ortsabhaengige Diffusionskoeffizientenmatrix ***
if (methode == 2)
  k = 5;
  C_Methode = NichtLineareDiffusionskoeffizientMatrix(B_Interpoliert,c_0, k);        
elseif (methode == 3)
  c_1 = 5 * c_0;
  c_2 = 50 * c_0;
  B_0 = mean(B_Interpoliert(:));
  C_Methode = StueckweiseStetigeDiffusionskoeffizientMatrix(B_Interpoliert,c_1, c_2, B_0);
else
  BasisKoeffizientFaktor = 5;
  a = ((BasisKoeffizientFaktor-1)*c_0)*(1/max(B_Interpoliert(:))); %-1, dass 50fache hat und nicht 51fache, da C=c_0+a*B -> hier kommt ein c_0 dazu
  % Der Diffusionskoeffizient ist an der Stelle mit der hoechsten BevDichte, "BasisKoeffizientFaktor" mal so hoch wie der Basisdiffusionskoeffizient
  C_Methode = LineareDiffusionskoeffizientMatrix(B_Interpoliert,c_0, a);    
endif
% *** Systemmatrix fuer ortsabhaengigen Diffusionskoeffizienten ***
A_h=OrtsabhaengigeSystemmatrix(M,N,h, C_Methode);

% *** Matrix mit den Startbedingungen der Infektion ***
[x_KH,y_KH,r_KH] = PositionVizentiusKrankenhausLandau(B_Interpoliert, h);
InfizierteStartAnzahl = 1;
InfizierteStartMatrix = InfizierteStartbedingungMatrix(B_Interpoliert, h, [x_KH, y_KH, r_KH, InfizierteStartAnzahl]);
clear *_KH; %Alle Variablen die mit _KH enden werden geloescht, da nicht mehr benoetigt.



% *** Tag 0 ***
B = reshape(B_Interpoliert',N*M,1); %B ueberschreiben mit Vektor der interpolierten Werte; %reshape, dass Vektoren B und u_i_alt subtrahieren kann
u_alt = 1*reshape(InfizierteStartMatrix',N*M,1);
u_i_alt = 1*reshape(InfizierteStartMatrix',N*M,1);
u_s_alt = B.-u_i_alt; %Subtraktion möglich, da aufgrund reshape von der gleichen Dimension sind

t=0;
begin_I = sum(u_i_alt(:))*h^2; %Anzahl Infizierte am Tag 0 (Startwert)

while(sum(u_i_alt(:))*h^2 >= 0 && t*delta_t <= maxTage )
  t = t+1;
  Erkrankungsrate = Slowdown(t*delta_t) * BasisErkrankungsrate; %Änderung der BasisErkrankungsrate aufgrund der slowdown-Funktion
  
  u = u_alt + delta_t * (-A_h * u_alt + F(Erkrankungsrate, B, u_alt));
    
  u_i = u_i_alt + delta_t * (-A_h * u_i_alt + F_I(Erkrankungsrate, B, Wechselrate, u_i_alt, u_s_alt));
  u_s = u_s_alt + delta_t * (-A_h * u_s_alt + F_S(Erkrankungsrate, B, Wechselrate, u_i_alt, u_s_alt));
  
  u_i_alt = u_i; 
  u_s_alt = u_s;
  u_alt = u;
  
  Erkrankungsrate_Speicher(1,t) = Erkrankungsrate; %speichert aktuelle Erkrankungsrate für jeden Tag (da aufgrund von slowdwon variable)
  u_Speicher(:,t) = u;
  u_i_Speicher(:,t) = u_i;% die Lösungen der aktuell Infizierten werden zu jedem Zeitpunkt t gespeichert, sodass anschließend plottbar - da Lösung Vektoren sind hängt man Lösungsvektoren aneinander
  u_s_Speicher(:,t) = u_s;%  die Lösungen der susceptibles werden zu jedem Zeitpunkt t gespeichert, sodass anschließend plottbar
endwhile
Tage = floor(t*delta_t);

% *** Plotten der Loesungen ***
if plotten==true
fig_index=floor([1:Tage]./delta_t); %Bilder bekommen Nummern anhand von 

j=0;
 for i=fig_index
  %Aktuell Infizierte
  MatrixAktuelleInfizierte = reshape(u_i_Speicher(:,i),N,M)'; % macht aus Lösungsvektoren eine Matrix mit N(Zeilen)x M(Spalten); transponiert noch, da reshape spaltenweise funktioniert und wir zeilenweise haben wollen
  aktuell_Infizierte = sum(MatrixAktuelleInfizierte(:)) * h^2; % summiert alle Einträge der Matrix auf; *h^2 um absolute Anzahl der Infizierten zu erhalten 
  aktuell_Infizierte_Speicher(:, i*delta_t) = aktuell_Infizierte; %speichert Gesamtinfizierten der einzelnen Tage in einer Matrix

  j=j+1;
%  figure(j);
  Datum = AnzahlTageInDatum(delta_t*i,1,3,2020) %Startdatum 1.März.2020

%  surfc(x,y,MatrixAktuelleInfizierte*h^2,"EdgeColor", "none")% *h^2 um absolute Anzahl der Infizierten zu erhalten
%  view(0,90)
%  grid off
%  colormap ("ocean")
%  caxis([0,max(u_i_Speicher(:))*h^2])
%  axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
%  colorbar
%  title (["Aktuell Infizierte"]);
%  text(0,-0.4,["Aktuell Infizierte: " num2str(aktuell_Infizierte)])
%  text(0,-0.6,["Erkrankungsrate: " num2str(Erkrankungsrate_Speicher(1,i))])
%  text(max(max(x),max(y))-0.5,-0.4, ["Datum: " Datum])
%  xlabel("x [km]", "position",[max(max(x),max(y))/2,-0.1,0])
%  ylabel("y [km]", "position",[-0.1,max(max(x),max(y))/2,0])
  
  
  %Kummulierte Infizierte
  MatrixKummulierteInfizierte=reshape(u_Speicher(:,i),N,M)';
  kummulierte_Infizierte = sum(MatrixKummulierteInfizierte(:)) * h^2;
  kummulierte_Infizierte_Speicher(:, i*delta_t) = kummulierte_Infizierte;
 
  k = 10000+j;
%  figure(k)
%  surfc(x,y,MatrixKummulierteInfizierte*h^2,"EdgeColor", "none");
%  view (0,90)
%  grid off
%  colormap("ocean")
%  caxis([0,max(u_Speicher(:))*h^2])
%  axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
%  colorbar
%  title (["Kummulierte Infizierte"]);
%  text(0,-0.4,["Kummulierte Infizierte: " num2str(kummulierte_Infizierte)])
%  text(0,-0.6,["Erkrankungsrate: " num2str(Erkrankungsrate_Speicher(1,i))])
%  text(max(max(x),max(y))-0.5,-0.4, ["Datum: " Datum])
%  xlabel("x [km]", "position",[max(max(x),max(y))/2,-0.1,0])
%  ylabel("y [km]", "position",[-0.1,max(max(x),max(y))/2,0])
  
  if speichern==true
    filename=[fileDir "/Aktuell_Infizierte/Aktuell_Infizierte_Tag_" num2str(j) "_von_" num2str(Tage) "_Raster_" num2str(M) "x" num2str(N) "_" num2str(Rasterlaenge) "m" ".jpg"];
    saveas(j, filename)
    filename=[fileDir "/Kummulierte_Infizierte/Kummulierte_Infizierte_Tag_" num2str(j) "_von_" num2str(Tage) "_Raster_" num2str(M) "x" num2str(N) "_" num2str(Rasterlaenge) "m" ".jpg"];
    saveas(k, filename)
    close all
  endif
endfor
endif

a=aktuell_Infizierte_Speicher';
b=kummulierte_Infizierte_Speicher';

save 'stw-stetig/Aktuelle_Infizierte_Speicher.txt' a;
save 'stw-stetig/Kummulierte_Infizierte_Speicher.txt' b;
close all;