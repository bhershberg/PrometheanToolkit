function exportSettingsToOrderedPinLabel(pinLabelSpec, options, dummy)

    global settings;

%   legacy format was:
%   exportSettingsToOrderedPinLabel(settings, pinLabelSpec, options)
%   so, let's support that:
    if(isfield(pinLabelSpec, 'readme') && isfield(pinLabelSpec, 'options'))
        pinLabelSpec = options;
        options = dummy;
    end


    if(options.debug)
       fprintf('Export of %s to ordered pin labels: ',pinLabelSpec.name);
    end

    if(options.exportPinLabels)

        try

            pinLabelSpec.exportPath = fullfile(pinLabelSpec.exportPath);
            if(~exist(pinLabelSpec.exportPath,'dir'))
                mkdir(pinLabelSpec.exportPath); 
            end
            fh = fopen(fullfile(pinLabelSpec.exportPath, [pinLabelSpec.name '.txt']),'w');
            
            for i = 1:length(pinLabelSpec.mappings)
                mappingInStruct = load(fullfile(pinLabelSpec.mappingsPath, pinLabelSpec.mappings{i}{1}));
                fieldname = fieldnames(mappingInStruct);
                mappingCells = mappingInStruct.(fieldname{:});
                pinLabelString = convertToOrderedPinLabel(mappingCells, pinLabelSpec.mappings{i}{2}, pinLabelSpec.mappings{i}{3});
                fwrite(fh, sprintf('*** Ordered pin label for mapping file "%s":\n',pinLabelSpec.mappings{i}{1}));
                fwrite(fh, sprintf('%s\n*** %d bits in total.\n',pinLabelString,size(mappingCells,1)));
                
                % break into subsections if too big:
                if(length(pinLabelString) > 5000)
                    middleRow = round(size(mappingCells,1)/2);
                    mappingCells_sub1 = mappingCells(1:middleRow,:,:);
                    mappingCells_sub2 = mappingCells(middleRow+1:end,:,:);
                    pinLabelString_sub1 = convertToOrderedPinLabel(mappingCells_sub1, pinLabelSpec.mappings{i}{2}, pinLabelSpec.mappings{i}{3});
                    pinLabelString_sub2 = convertToOrderedPinLabel(mappingCells_sub2, pinLabelSpec.mappings{i}{2}, pinLabelSpec.mappings{i}{3});
                    
                    fwrite(fh,sprintf('This is a very long label string!!...\nYou may have problems inserting this in Cadence. Here are two smaller subsets that you can use instead:\n'));
                    fwrite(fh, sprintf('First subset:\n'));
                    fwrite(fh, sprintf('%s\n*** %d bits in total.\n',pinLabelString_sub1,size(mappingCells_sub1,1)));
                    fwrite(fh, sprintf('Second subset:\n'));
                    fwrite(fh, sprintf('%s\n*** %d bits in total.\n',pinLabelString_sub2,size(mappingCells_sub2,1)));
                end
                fwrite(fh, sprintf('\n\n\n'));
            end

            fclose(fh);
            
            if(options.debug), fprintf('done.'); end

        catch
            fprintf('ERROR, ordered pin label export failed.');
        end

    elseif(options.debug)
        fprintf('not requested, skipping.');
    end
    
    if(options.debug), fprintf('\n'); end

end