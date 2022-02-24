function convertToVeriloga(flatlist, moduleName, filename)
% Author: Benjamin Hershberg
% Date Created: May 2017
% Last Updated: November 2019
% Description: 

varnames = fieldnames(flatlist);
numfields = length(varnames);
varvalues = cell(numfields,1);
for i = 1:numfields
   eval(sprintf('varvalues{%d} = flatlist.%s;',i,varnames{i})); 
end

special_IN(1) = {'vdd'};
special_IN(2) = {'vss'};
special_IN(3) = {'SCKIN'};
special_IN(4) = {'SDATAIN'};
special_IN(5) = {'LOAD'};
special_OUT(1) = {'SCKOUT'};
special_OUT(2) = {'SDATAOUT'};

pathname = fileparts(filename);
if(~exist(pathname,'dir'))
    mkdir(pathname);
end
fd = fopen(filename, 'w');

fprintf(fd, '// Verilog-A code for the VerilogaModule named %s\n', moduleName);
fprintf(fd, '\n');
fprintf(fd, '`include "constants.vams"\n');
fprintf(fd, '`include "disciplines.vams"\n');
fprintf(fd, '\n');

% module declaration
fprintf(fd, 'module %s(', moduleName);
isFirst = true;
for i = 1:numfields,
    if isFirst, isFirst = false;
    else fprintf(fd, ', '); end
    fprintf(fd, '%s', varnames{i});
end
for i = 1:length(special_IN)
    fprintf(fd, ', %s', special_IN{i});
end
for i = 1:length(special_OUT)
    fprintf(fd, ', %s', special_OUT{i});
end
fprintf(fd, ');\n');
fprintf(fd, '\n');

% special inputs
fprintf(fd, '// Input signals\n');
for i = 1:length(special_IN),
      fprintf(fd, 'input %s;\n', special_IN{i});
end
for i = 1:length(special_IN),
      fprintf(fd, 'electrical %s;\n', special_IN{i});
end

fprintf(fd, '\n');
fprintf(fd, '// Output signals\n');

% special outputs
for i = 1:length(special_OUT),
      fprintf(fd, 'output %s;\n', special_OUT{i});
end
for i = 1:length(special_OUT),
      fprintf(fd, 'electrical %s;\n', special_OUT{i});
end
fprintf(fd, '\n');

% auto-generated outputs
for i = 1:numfields,
    if(length(varvalues{i}) < 5)
        warning('\nInvalid control variable ''%s'' encountered. Skipping.',varnames{i});
        varvalues(i) = [];
        varnames(i) = [];
        i = i-1;
        numfields = length(varnames);
        continue;
    end 
    if varvalues{i}{2} == 1,
      fprintf(fd, 'output %s;\n', varnames{i});
    else
      fprintf(fd, 'output [%d:0] %s;\n', varvalues{i}{2}-1, varnames{i});
    end
end
fprintf(fd, '\n');
for i = 1:numfields,
    if varvalues{i}{2} == 1,
      fprintf(fd, 'electrical %s;\n', varnames{i});
    else
      fprintf(fd, 'electrical [%d:0] %s;\n', varvalues{i}{2}-1, varnames{i});
    end
end
fprintf(fd, '\n');

fprintf(fd, '\n');
fprintf(fd, '// Parameters\n');

for i = 1:numfields,
    fprintf(fd, 'parameter param_%s = 0.0;\n', varnames{i});
end

fprintf(fd, '\n');
fprintf(fd, '// Variables\n');
fprintf(fd, 'real Vdd = 0.85;\n');
fprintf(fd, 'real Xnumber = 0;\n');
fprintf(fd, 'real remainder = 0;\n');
fprintf(fd, 'integer i = 0;\n');
% fprintf(fd, 'real Vdd = 0.85;\n');
for i = 1:numfields,
    if varvalues{i}{2} == 1,
      fprintf(fd, 'real var_%s;\n', varnames{i});
    else
      fprintf(fd, 'real var_%s[%d:0];\n', varnames{i},varvalues{i}{2}-1);
    end
end

fprintf(fd, '\n');
fprintf(fd, 'analog begin\n');
fprintf(fd, '\n');
fprintf(fd, '  @(initial_step) begin\n');
fprintf(fd, '\n');
fprintf(fd, '  Vdd = V(vdd);\n');
for i = 1:numfields
    
    if varvalues{i}{2} == 1,
%           fprintf(fd, 'var_%s = Vdd*%d;\n', varnames{i}, varvalues{i}{1});
          fprintf(fd, 'var_%s = Vdd*param_%s;\n', varnames{i}, varnames{i});
    else
%           fprintf(fd, '    Xnumber = param_%s;\n',varnames{i});
          fprintf(fd, '    Xnumber = param_%s;\n',varnames{i});
          bits = varvalues{i}{2};
          fprintf(fd, '    for ( i = 0; i <= %d; i = i+1) begin\n',bits-1);
          fprintf(fd, '      remainder = Xnumber %% 2;\n');
          fprintf(fd, '      Xnumber = (Xnumber - remainder) / 2;\n');
          fprintf(fd, '      var_%s[i] = Vdd*remainder;\n',varnames{i});
          fprintf(fd, '    end\n');
    end
%     for i=1:bits
%        remainder(i) = mod(number,2);
%        number = (number-remainder(i)) / 2;
%     end
end
fprintf(fd, '\n');
fprintf(fd, '  end // initial step\n');
fprintf(fd, '\n');
for i = 1:numfields
    
    if varvalues{i}{2} == 1,
          fprintf(fd, 'V(%s) <+ var_%s;\n', varnames{i},varnames{i});
    else
          for j = 0:varvalues{i}{2}-1
              fprintf(fd, 'V(%s[%d]) <+ var_%s[%d];\n', varnames{i},j,varnames{i},j);
          end
    end
end
fprintf(fd, '\n');
fprintf(fd, 'end // analog begin\n');
fprintf(fd, '\n');

fprintf(fd, 'endmodule  // %s\n', moduleName);

% fd2 = fopen('dec2bin.va');
% copyline = fgetl(fd2);
% while(ischar(copyline))
%     fprintf(fd,[copyline '\n']);
%     copyline = fgetl(fd2);
% end
% fclose(fd2);


fclose(fd);

end


% 
% % parameter assignments based on config data
% fprintf(fd,'analog begin');
% fprintf(fd, '\n');
% for i = 1:numfields,
%     
% 	if(varvalues{i}{1} < varvalues{i}{3})
%         warning(sprintf('%s = %d is less than minimum allowed value of %d, setting to %d instead',varnames{i},varvalues{i}{1},varvalues{i}{3},varvalues{i}{3}));
%         varvalues{i}{1} = varvalues{i}{3};
%     end
%     if(varvalues{i}{1} > varvalues{i}{4})
%         warning(sprintf('%s = %d is more than maximum allowed value of %d, setting to %d instead',varnames{i},varvalues{i}{1},varvalues{i}{4},varvalues{i}{4}));
%         varvalues{i}{1} = varvalues{i}{4};
%     end
%     
%     if varvalues{i}{2} == 1,
%         if(varvalues{i}{1} == 1)
%             fprintf(fd, 'V(%s) <+ V(vdd);\n', varnames{i});
%         else
%             fprintf(fd, 'V(%s) <+ V(vss);\n', varnames{i});
%         end
%     else
%       varbin = fliplr(dec2bin(varvalues{i}{1},varvalues{i}{2}));
%       for j=0:(varvalues{i}{2}-1)
%           if(str2num(varbin(j+1)) == 1)
%                 fprintf(fd, 'V(%s[%d]) <+ V(vdd);\n', varnames{i},j);
%           else
%                 fprintf(fd, 'V(%s[%d]) <+ V(vss);\n', varnames{i},j);
%           end
%       end
%     end
% end
% for i = 1:length(special_OUT)
%    fprintf(fd,'V(%s) <+ V(vss);\n',special_OUT{i});
% end



