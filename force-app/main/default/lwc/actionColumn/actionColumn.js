import { LightningElement } from 'lwc';

export default class ActionColumn extends LightningElement {
    ProjectNoteClicked = false;
    OpenProjectNote()
    {
        this.ProjectNoteClicked = true;
    }
}