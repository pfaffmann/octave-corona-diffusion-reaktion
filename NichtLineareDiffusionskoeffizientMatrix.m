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
## @deftypefn {} {@var{retval} =} NichtLineareDiffusionskoeffizientMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-21

function C = NichtLineareDiffusionskoeffizientMatrix (B, c_0, k)
   maxB = max(B(:));
   minB = min(B(:));
   B = NormiereMatrixAufWert(B,1);
   C = atan(k.*B-k/2) + atan(k/2) +c_0;
   C = C/1000;
  
global plotten;
global speichern;
global fileDir;

if(plotten)
   figure(9992)
   global x;
   global y;
   surface (x,y,C, "EdgeColor", "none");
   title (["Nicht Lineare Diffusionskoeffizient Matrix c_0 = " num2str(c_0) "   k = " num2str(k)]);
     %axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
     axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
   ylabel("y")
   xlabel("x")
   colorbar   
   if (speichern)
      filename=[fileDir "/NichtLineareDiffusionskoeffizient Matrix.jpg"];
      saveas(9992, filename)
      %close (9991)
    endif
endif
  
endfunction
