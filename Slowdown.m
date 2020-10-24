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
## @deftypefn {} {@var{retval} =} Slowdown (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: chris <chris@PFAFFMANN-PC>
## Created: 2020-10-20

function val = Slowdown(t)
  T_offset = 0;
  switch (t)
    case num2cell([1:14]+T_offset)   % 2. März - 15. März
      val = 1;
    case num2cell([15:28]+T_offset)  %16. März - 29. März
      val = 0.25;
    case num2cell([29:33]+T_offset)  %30. März - 3. April
      val = 0.15;
    case num2cell([34:42]+T_offset)  % 4. April - 12. April
      val = 0.08;
    case num2cell([43:69]+T_offset)  %13. April - 9. Mai
      val = 0.05;
    case num2cell([70:150]+T_offset) %10. Mai - 29. Juli
      val = 0.03;
    case num2cell([151:195]+T_offset)%30. Juli - 12. September
      val = 0.03;
    otherwise                        %ab dem 13. September
    val = 0.25;
  endswitch

if(t<T_offset)
val = 0;
endif

endfunction

