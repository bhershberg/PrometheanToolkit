% GUI tools for Promethean Toolkit
% Benjamin Hershberg, 2020
% 
% USAGE:
% 
% [start, stop, step] = parametricSweepDialog('Your Message', 'Units', start, stop, step);
% 
% 
% DESCRIPTION:
% 
% The Parametric Sweep Dialog allows the user to graphically set up a parametric sweep. This is often very useful when building custom measurement functions for lab testing where you want to let the user interactively set up the sweep parameters.
% 
% 
% WORKING EXAMPLE:
% 
% [start, stop, step] = parametricSweepDialog('A Handy Tool for Setting Up Sweeps','Volts',-5, 10, 1);
function [ start, stop, step, tf ] = parametricSweepDialog( message, units, start, stop, step)

    tf = 0;

    if(nargin <1), message = 'Sweep bounds:'; end
    if(nargin < 2), units = ''; end

    d = dialog('Position',[0 0 0 0],'Name','Parametric Sweep');
    p = relativePosition(d,[1 7],[1 2]);
    d.Position = p + [0 0 20 20];
    movegui(d,'center');
    
    placeText(d,1,1,message);
    
    col1 = [1 1.33];
    col2 = [1.33 1.66];
    col3 = [1.66 2];

    placeText(d,2,col1,'Start:');
    editStart = placeEdit(d,2,col2);
    placeText(d,2,col3,units);
    
    placeText(d,3,col1,'Stop:');
    editStop = placeEdit(d,3,col2);
    placeText(d,3,col3,units);
    
    placeText(d,4,col1,'Step:');
    editStep = placeEdit(d,4,col2);
    placeText(d,4,col3,'steps');
    
    if(nargin >= 5)
        editStart.String = num2str(start);
        editStop.String = num2str(stop);
        editStep.String = num2str(step);
    end
    
    btnOK = placeButton(d,6,1,'OK');
    btnOK.Callback = @CB_parametricSweepDialog_OKbutton;
    
    uiwait(d);
    
    function CB_parametricSweepDialog_OKbutton(source, event)
        start = str2num(editStart.String);
        stop = str2num(editStop.String);
        step = str2num(editStep.String);
        tf = 1;
        delete(d);
    end
    
end



