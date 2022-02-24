function CB_exampleCB2(source, event)

    if(source.Value == 1)
        source.String = 'Checkbox (state: checked!)';
    else
        source.String = 'Checkbox (state: not checked)';
    end

end