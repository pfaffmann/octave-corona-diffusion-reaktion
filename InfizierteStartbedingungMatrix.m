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
## @deftypefn {} {@var{retval} =} InfizierteStartbedingungMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20



function I = InfizierteStartbedingungMatrix (B,h, StartWerte)
  
  M = rows(B);
  N = columns(B);
  I = zeros(M,N);
  TMP = zeros(M,N);
  %Startpositionen soll eine Matrix sein mit den Eintraegen 
  %[x_1-Koordinate, y_1-Koordinate, radius_1, AnzahlInfizierte_1;
  % x_2-Koordinate, y_2-Koordinate, radius_2, AnzahlInfizierte_2;
  %      ...               ...         ...
  % x_n-Koordinate, y_n-Koordinate, radius_n, AnzahlInfizierte_n;]
  
  AnzahlStartPositionen = rows(StartWerte);
  
  for k=1:AnzahlStartPositionen
    
    x_Koordinate = StartWerte(k,1);
    y_Koordinate = StartWerte(k,2);
    radius = StartWerte(k,3);
    AnzahlInfizierte = StartWerte(k,4);
    
    for i=1:N
      for j=1:M
        if(sqrt((i.-x_Koordinate)^2+(j.-y_Koordinate)^2) <= radius)
          I(j,i) = I(j,i) + AnzahlInfizierte/(pi*radius^2);
        endif
      endfor 
    endfor
  endfor
 % Normierung der Matrix, da fuer kleine Radien die Flaeche nicht Kreisfoermig ist (daher Fehler bei Flaechenberechnung)
 sollInfizierte = round(sum(I(:)));  % Da es keine nicht natuerliche Anzahl an Personen geben kann.
 istInfizierte = sum(I(:));
 quotient= sollInfizierte/istInfizierte;
 I = quotient*I/h^2;

%Plotten der Funktion
global plotten;
global speichern;
global fileDir;
 
  if plotten
   Datum = AnzahlTageInDatum(0,1,3,2020); %Startdatum 1.März.2020
   figure(9995)
   global x;
   global y; 
   surface (x,y,I*h^2,"EdgeColor", "none"); %stellt die absolute Anzahl der Infizierten dar durch I*h^2
   title (["Startbedingungen an Tag 0: Anzahl Infizierte: " num2str(sollInfizierte)]);
   axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
   xlabel("x [km]", "position",[max(max(x),max(y))/2,-0.1,0])
   ylabel("y [km]", "position",[-0.1,max(max(x),max(y))/2,0])
   text(max(max(x),max(y))-0.5,-0.4, ["Datum: " Datum])
   colormap("ocean")
   colorbar
     if speichern
      filename=[fileDir "/Startbedingung_an_Tag_ 0_Anzahl_Infizierte" num2str(sollInfizierte) ".jpg"];
      saveas(9995, filename)
      %close (9995)
    endif
  endif
 
endfunction


