import { LightningElement, api } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class ActionColumn extends LightningElement {
    @api recordId;
    ProjectNoteClicked = false;
    
    OpenProjectNote()
    {
        if(FORM_FACTOR === 'Large')
        {
        this.dispatchEvent(new CustomEvent('ProjectNoteClick')); 
        }
        if(FORM_FACTOR !== 'Large')
        {
        this.dispatchEvent(new CustomEvent('MobileProjectNote')); 
        }  
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