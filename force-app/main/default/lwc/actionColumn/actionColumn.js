import { LightningElement, api } from 'lwc';

export default class ActionColumn extends LightningElement {
    @api recordId;
    ProjectNoteClicked = false;
    OpenProjectNote()
    {
        this.dispatchEvent(new CustomEvent('ProjectNoteClick'));  
    }
    CloneJob()
    {
        this.dispatchEvent(new CustomEvent('CloneJob'));  
    }
    EditAccountRoles()
    {
        this.dispatchEvent(new CustomEvent('EditAccountRoles'));  
    }
}