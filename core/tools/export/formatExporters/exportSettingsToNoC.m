function outputs = exportSettingsToNoC(nocSpec, options, dummy)

    global settings;

%   legacy format was:
%   exportSettingsToNoC(settings, nocSpec, options)
%   so, let's support that:
    if(isfield(nocSpec, 'readme') && isfield(nocSpec, 'options'))
        nocSpec = options;
        options = dummy;
    end

    parser = structFieldDefaults();
    parser.add('debug',false); % quiet, because we always program
    parser.add('exportNoC',true);
    parser.add('saveToFile',false);
    options = parser.applyDefaults(options);

    if(options.debug)
       fprintf('Export of %s to NoC vector: ',nocSpec.name);
    end

    if(options.exportNoC)

%         try
            flatlist = struct;
            for i = 1:size(nocSpec.parts,2)
                part = eval(getAbsoluteControlVariablePath(nocSpec.parts{i}{1}));
                flatlist = flattenStruct(part, flatlist, nocSpec.parts{i}{2});
            end

            Noc_Vector = [];
            for i = nocSpec.assemblyOrder
                fname = fullfile(nocSpec.mappingsPath, nocSpec.mappings{i}{1});
                fname_csv = [fname(1:end-3) 'csv'];
                if(~doesFileExist(fname) && doesFileExist(fname_csv))
                    if(options.debug)
                        fprintf('NoC mapping .mat file was missing, but .csv file was found. Converting csv to mat. ');
                    end
                    try
                        NocMapping = table2cell(readtable(fname_csv));
                        for xyz = 1:size(NocMapping,1)
                            if(~isnumeric(NocMapping{xyz,3}))
                                NocMapping{xyz,3} = str2num(NocMapping{xyz,3});
                                if(isempty(NocMapping{xyz,3}))
                                    NocMapping{xyz,3} = NaN;
                                end
                            end
                        end
                        save(fname, 'NocMapping');
                        if(options.debug), fprintf('Success.\n'); end
                    catch
                        if(options.debug), fprintf('Failure.\n'); end
                    end
                end
                mapping = load(fullfile(nocSpec.mappingsPath, nocSpec.mappings{i}{1}));
                fieldname = fieldnames(mapping);
                Noc_Vector = [Noc_Vector convertToNocBits(mapping.(fieldname{:}), flatlist, nocSpec.mappings{i}{2}, nocSpec.mappings{i}{3})];
            end

            outputs.Noc_Vector = Noc_Vector;
            
            if(~exist(nocSpec.exportPath,'dir'))
                mkdir(nocSpec.exportPath); 
            end
            if(options.saveToFile)
                save(fullfile(nocSpec.exportPath, [nocSpec.name '.mat']),nocSpec.name);
                fh_Noc = fopen(fullfile(nocSpec.exportPath, [nocSpec.name '.txt']),'w');
    %             fwrite(fh_Noc, strrep(num2str(Noc_Vector),' ',''));
                fwrite(fh_Noc, num2str(Noc_Vector));
                fclose(fh_Noc);
            end
            
            if(options.debug), fprintf('done.'); end

%         catch
%             fprintf('ERROR, NoC export failed.');
%         end

    elseif(options.debug)
        fprintf('not requested, skipping.');
    end
    
    if(options.debug), fprintf('\n'); end

end