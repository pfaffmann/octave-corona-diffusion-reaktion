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
## @deftypefn {} {@var{retval} =} PositionVizentiusKrankenhausLandau (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20

function [x, y, radius] = PositionVizentiusKrankenhausLandau (B, h)
 M = rows(B);
 N = columns(B);
 x = floor(N/2); %x-Koordinate des Krankenhaus
 y = floor(7*M/32);%y-Koordinate des Krankenhaus
 flaecheKrankenhaus = 0.02; % km^2 = 20.000 m^2 Umrechnung 10^6
 radiusKrankenhaus = sqrt(flaecheKrankenhaus/pi);
 %radius = 0.3/h; %radius von 300 Metern
 radius=radiusKrankenhaus/h;
endfunction
