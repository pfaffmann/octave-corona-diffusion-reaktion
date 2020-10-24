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
## @deftypefn {} {@var{retval} =} LineareDiffusionskoeffizientMatrix (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20

function C = LineareDiffusionskoeffizientMatrix (B, c_0, a)
  C = c_0 .+ a.*B;
  %C(B<=0)=0; %Verbreitung 0 falls keine BevDichte an dieser Stelle
global plotten;
global speichern;
global fileDir;
if(plotten)
   figure(9991)
   global x;
   global y;
   surface (x,y,C, "EdgeColor", "none");
   title (["Lineare Diffusionskoeffizient Matrix c_0 = " num2str(c_0) "   a = " num2str(a)]);
   axis([min(min(x),min(y)) max(max(x),max(y)) min(min(x),min(y)) max(max(x),max(y))])
   xlabel("x [km]", "position",[max(max(x),max(y))/2,-0.1,0])
   ylabel("y [km]", "position",[-0.1,max(max(x),max(y))/2,0])
   colorbar
   if (speichern)
      filename=[fileDir "/Diffusionskoeffizient Matrix.jpg"];
      saveas(9991, filename)
      %close (9991)
    endif
endif
  
endfunction
