function CB_FM_about(source, event)

    msg = {};
    msg{end+1} = 'Promethean Toolkit is made for IC designers, by IC designers. It solves many of the most common problems encountered in design and testing of analog-mixed signal integrated circuits by centralizing the information the fully describes the state of your system. This centralization provides many advantages with regard to synchronization, reproducibility, traceability, and usability. It is all handled through a graphical environment and accompanying API that boosts productivity and increases insight, enabling rapid test automation and multi-user collaboration.';
    msg{end+1} = '';
    msg{end+1} = 'This project was originally conceived and developed by Benjamin Hershberg at imec in Leuven, Belgium from 2018-2020. Continuing support is provided by open-source contributors on GitHub, Benjamin Hershberg, and Imec.';
    msg{end+1} = '';
    msg{end+1} = 'Get involved at: https://github.com/bhershberg/PrometheanToolkit';
    
    options.title = 'About Promethean Toolkit';
    
    textEditor(msg, options);

end