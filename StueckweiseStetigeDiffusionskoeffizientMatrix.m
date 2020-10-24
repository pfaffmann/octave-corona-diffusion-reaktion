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
## @deftypefn {} {@var{retval} =} StueckweiseStetigeDiffusionskoeffizientMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-21

function C = StueckweiseStetigeDiffusionskoeffizientMatrix (B, c_0 , c_1, B_0)
  %B_0 ist der Grenzwert, alle Matrizenwerte kleiner gleich B_0 werden mit c_0 faktorisiert, der Rest mit c_1
  C=B;
  C(B<=B_0)=c_0;
  C(C>B_0)=c_1;
  %C = NullenAmMatrixRand(C);
  
  global plotten;
  global speichern; 
  global fileDir; 
  
  if(plotten)
   figure(9993)
   global x;
   global y;
   surface (x,y,C);
   title (["Stueckweise stetige Diffusionskoeffizient Matrix c_0 = " num2str(c_0) "   c_1 = " num2str(c_1) "   Grenzwert = " num2str(B_0)]);
   axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
   ylabel("y")
   xlabel("x")
   colorbar
  endif
  if(speichern)
      filename=[fileDir "/Stueckweise_stetige_Diffusionskoeffizient_ Matrix_ c0_" num2str(c_0) "_c1_" num2str(c_1) "_Grenzwert_" num2str(B_0) ".jpg"];
      saveas(9993, filename)
      
    endif
endfunction
