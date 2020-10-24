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
## @deftypefn {} {@var{retval} =} OrtsabhaengigeSystemmatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20

function A_h = OrtsabhaengigeSystemmatrix (M, N, h, C)
%Indizes von Octave, also: I_0 = I_1 und I_M+1 = I_M

% ***Dimension der Systemmatrix festlegen***
A_h = zeros(M*N, M*N);
% ------------------------------------------------------------

% *** hI_0 und hI_M erstellen***
I_1 = diag(C(1,:)); %Dimension ist NxN
I_M = diag(C(M,:));
% ------------------------------------------------------------

% *** hI_0 und hI_M in erste und letzte Blockzeile einfügen***
Blockzeile=1;
Blockspalte=1;
A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=-h*I_1;
Blockspalte=2;
A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=h*I_1;
Blockzeile=M;
Blockspalte=M-1;
A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=h*I_M;
Blockspalte=M;
A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=-h*I_M;
% ------------------------------------------------------------

for j=2:M-1 %Anzahl der Blockzeilen
  
  % ***I_l,j und I_r,j erstellen***
  I_links=zeros(N,N);
  c_oben = diag(0.5*(C(j-1,2:N-1)+C(j,2:N-1)));
  I_links(2:N-1,2:N-1) = c_oben;
  
  I_rechts=zeros(N,N);
  c_unten = diag(0.5*(C(j+1,2:N-1)+C(j,2:N-1)));
  I_rechts(2:N-1,2:N-1)= c_unten;
  
  % ------------------------------------------------------------
  
  % ***I_l,j und I_r,j in Systemmatrix einsetzen***
  Blockzeile = j;
  Blockspalte = j-1;
  A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=I_links;
  Blockspalte = j+1;
  A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=I_rechts;
  % ------------------------------------------------------------
  
  % ***B erstellen***
  B = zeros(N,N);
  %erste und letzte Zeile
  B(1,1) = -h*C(j,1);
  B(1,2) = h*C(j,1);
  B(N,N) = -h*C(j,N);
  B(N,N-1) = h*C(j,N);
  %------------------------
  %Nebendiagonalen
  c_links  = diag(0.5*(C(j,2:N-1)+C(j,1:N-2)));
  c_rechts = diag(0.5*(C(j,2:N-1)+C(j,3:N)));
  TMP1 = zeros(N,N);
  TMP1(2:N-1,1:N-2)=c_links;
  B=B+TMP1;
  TMP1 = zeros(N,N);
  TMP1(2:N-1,3:N)=c_rechts;
  B=B+TMP1;
  %------------------------
  %Hauptdiagonale
  c = -1*(c_oben+c_unten+c_links+c_rechts);
  TMP1 = zeros(N,N);
  TMP1(2:N-1,2:N-1)=c;
  B=B+TMP1; 
  % ------------------------------------------------------------
  
  % ***B in Systemmatrix einsetzen***
  Blockspalte = j;
  A_h((Blockzeile-1)*N+1:(Blockzeile*N),(Blockspalte-1)*N+1:(Blockspalte*N))=B;
  % ------------------------------------------------------------
endfor

A_h=-1/(h^2)*A_h;

global plotten;
global speichern;
global fileDir;

  if(plotten)
  figure(9994)
  spy(A_h)
  if(speichern)
      filename=[fileDir "/Systemmatrix_Ah.jpg"];
      saveas(9994, filename)
      close (9994)
    endif
 endif
 
endfunction
