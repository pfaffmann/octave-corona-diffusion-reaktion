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
## @deftypefn {} {@var{retval} =} F_I (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20



function F = F_I (Erkrankungsrate, B, Wechselrate, ui, us) %hierbei ist Erkrankungsrate=slowdown(t*delta_t) * BasisErkrankungsrate
  F = (Erkrankungsrate./B);
  F(F==Inf) = 0; %Falls B an Punkten 0 ist, dann setze hier F auf 0
  F = F.*ui.*us-Wechselrate*ui;
endfunction

