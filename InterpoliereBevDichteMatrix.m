## Copyright (C) 2020 chris
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} InterpoliereBevDichteMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20

function [IntBevMatrix, M, N, h] = InterpoliereBevDichteMatrix (BevMatrix,RasterlaengeInMetern)

 m = rows(BevMatrix);
 n = columns(BevMatrix);
 
 h = RasterlaengeInMetern/1000; %Schrittweite in km.
 AnzahlPunkteProKilometer = floor(1/h);
 
 M = m * AnzahlPunkteProKilometer; %Anzahl der Punkte in y-Richtung (Spalte)
 N = n * AnzahlPunkteProKilometer; %Anzahl der Punkte in x-Richtung (Zeile)
 
 
 hilfsM = M-AnzahlPunkteProKilometer; %Anzahl der "inneren Punkte" in y-Richtung (Spalte)
 hilfsN = N-AnzahlPunkteProKilometer; %Anzahl der "inneren Punkte" in x-Richtung (Spalte)
 
 %Verschiebung der Punkte in Mitte der Quadrate
 x = 0.5:1:n-0.5; 
 y = 0.5:1:m-0.5;
 
 %Interpolation
 xi = linspace (min (x), max (x), hilfsN); %unterteilt den "Raum" vom Anfangswert min(x) bis Endwert max(x) in hilfsN gleich große Schritte
 yi = linspace (min (y), max (y), hilfsM)';% hier zusätzlich transponiert -> macht aus Zeilenvektor -> Spaltenvektor
 
 hilfsBevMatrix = interp2 (x,y,BevMatrix,xi,yi,"cubic"); %übergibt ursprungs x,y, z-Koordinate(BevMatrix) sowie neuen xi,yi zur Interpolation
                                                         %-> erhält interpolierte zi-Kooridnaten (hilfsBevMatrix)
                                                         %Interpolation kubisch -> verläuft als Linien
 %Extrapolation
 xxi = linspace (min (x)-0.5, max (x)+0.5, N); %betrachtet gesamtes Gebiet mit N gleich großen Unterteilungen
 yyi = linspace (min (y)-0.5, max (y)+0.5, M)'; 
 
 IntBevMatrix = griddata(xi,yi,hilfsBevMatrix,xxi,yyi,"nearest"); %extrapoliert die ganze Matrix
                                                                  %da Werte außerhalb Punkte nicht bekannt muss extrapolieren, da Punkte in Mitte der                                                                     Quadrate liegen
                                                                  %nearest-> nearest neighbour interpolation
 
 %Normieren, damit nicht mehr Einwohner entstehen
 
 %Gesamtpersonenanzahl der urprünglichen BevMatrix von Landau
 sollMenschen = sum(sum(BevMatrix))*1^2; % 1^2 da die Flaeche ein Kilometer^2 ist (absolute Personenanzahl=Bevdichte*Fläche -> siehe Formel)
                                         %"sum" summiert Spalten -> will Gesamtanzahl deswegen zweimal sum
 %Gesamtpersonenanzahl der interpolierten BevMatrix
 istMenschen = sum(sum(IntBevMatrix))*h^2; %Dichtefunktion - auf die Fläche bringen --> Bevölkerung
 quotient= sollMenschen/istMenschen;
 %erhählt urprüngliche Gesamtpersonenanzahl für interpolierte Matrix
 IntBevMatrix = quotient*IntBevMatrix;
  
%Plotten der interpolierten Matrix
global plotten;
global speichern;
global fileDir;

if plotten==true
   figure(9990) %jeder Plot den man macht wird in einer Figur gespeichter und mit figure() gibt Figur einen Namen
   surface (xxi,yyi,IntBevMatrix); %stellt di Oberfläche der interpolierten -Gesamtmatrix dar
   axis([min(min(x(:)),min(y(:))) max(max(x(:)),max(y(:))) min(min(x(:)),min(y(:))) max(max(x(:)),max(y(:)))])
   [x,y] = meshgrid (x,y); %erzeugt Gitter (2Matrizen), die die Position der einzelnen Koordinaten wiedergeben
   hold on;
   plot3 (x,y,BevMatrix,"ro"); %plotter ursprünglichen Werte der Bevmatrix, um zu überprüfen, ob Interpolation gut ist
                               %Plot hier in CoCalc auf Bild nicht sichtbar -> wären rote Kreise der Werte zu sehen
   title ("Bevoelkerungsdichte Landau");
  xlabel("x [km]")
  ylabel("y [km]")
   colorbar %zeigt an, welche Werte den Farben zugeordnet werden
   hold off;
   
if speichern==true
      filename=[fileDir "/Bevoelkerungsdichte.jpg"];
      saveas(9990, filename)
      %close (9990)
    endif
 endif
endfunction
