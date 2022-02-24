function CB_FM_about(source, event)

    msg = {};
    msg{end+1} = 'Promethean Toolkit is a software tool for IC designers, by IC designers. It solves many of the most common problems encountered in physical testing (and design in CAD tools) by centralizing information describing the state of your system in a single source location. This centralization provides many advantages of synchronization, reproducibility, traceability, and usability. It is all handled through a graphical environment that boosts productivity and increases insight, enabling rapid test automation and multi-user collaboration.';
    msg{end+1} = '';
    msg{end+1} = '';
    msg{end+1} = 'Promethean Toolkit was conceived and developed by Benjamin Hershberg at imec in Leuven, Belgium from 2018-2020.';
    msg{end+1} = '';
    msg{end+1} = 'Key continuing support is provided by:';
    msg{end+1} = '    - The open-source community';
    msg{end+1} = '    - Benjamin Hershberg';
    msg{end+1} = '    - Imec';
    msg{end+1} = '';
    msg{end+1} = 'Get involved at: https://github.com/bhershberg/PrometheanToolkit';
    
    options.title = 'About Promethean Toolkit';
    
    textEditor(msg, options);

end