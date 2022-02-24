function custom__equipmentInterface_onDelete(source, event, interfacePanel)

    % Any time an equipment interface is deleted, this function will be
    % called. It is sometimes helpful to do some house-cleaning after an
    % interface is deleted in order to remove dependencies. For example, if
    % you had some globalOptions that you use to point to certain equipment
    % interfaces, you may want to check that those pointers are still
    % valid. A specific example of this is if you had a globalOption setup to
    % specify which interface is the "core" supply that you usually measure
    % the current consumption from when automating measurements, you should
    % check to see if that interface wasn't deleted by the user (and the
    % preference value must be reset to null).

end