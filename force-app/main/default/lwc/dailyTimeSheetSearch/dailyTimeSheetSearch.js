/* eslint-disable no-alert */
/* eslint-disable no-console */
import { LightningElement, track } from 'lwc';
import { NavigationMixin} from 'lightning/navigation';
import findJobs from '@salesforce/apex/DailyTimesheetController.findJobs';
const DELAY = 1400;
export default class DailyTimeSheetSearch extends NavigationMixin(LightningElement) {
    @track searchKey = '';
    @track Jobs;
    @track error;
    
    ChangeSearchKey(event){
        this.searchKey = event.target.value;
    }


    SearchJobs() {  
        
        window.clearTimeout(this.delayTimeout);
        //this.searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation 
        this.delayTimeout = setTimeout(() => {     
        findJobs(
            { searchKey: this.searchKey }
        )
            .then(result => {
                this.Jobs = result;
            })
            .catch(error => {
                this.error = error;
            });
        }, DELAY);
    
    }
    


    navigateToDailyTimesheetListView(event) {
      //alert(event.target.value);
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://' + window.location.hostname + '/lightning/n/DailyTimesheetListView?ati__jobid=' + event.target.value,
                    replace: false
            }
        });
 
    }

    openTimeSheetPage(event)
    {
      alert(event.target.value);
      alert(event.currentTarget.Value);
        location.href='https://' + window.location.hostname + '/lightning/n/DailyTimesheetListView?ati__jobid=' + event.target.value;
        event.action= this.location;

    }
}