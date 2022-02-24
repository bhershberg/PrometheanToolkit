function CB_exampleCB1(source, event, dropBox, editBox, listBox)

    dropBox.String = [{editBox.String} ; dropBox.String];
    listBox.String = [{editBox.String} ; listBox.String];
    listBox.Value = 1;

end