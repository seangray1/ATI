import { LightningElement, wire, track } from 'lwc';
import searchJobs from '@salesforce/apex/MergeJobs.searchJobs';
const DELAY = 100;

export default class MergeJobs extends LightningElement {
    @track JobToKeep = {Date_of_Loss__c:'', Name : '', Claim__c: '', Street:'',City:'',Zip:'', State:'',XASP_Transaction_ID__c:''};
    @track JobToDelete = {Date_of_Loss__c:'', Name : '', Claim__c: '', Street:'',City:'',Zip:'', State:'',XASP_Transaction_ID__c:''};
    @track JobsToKeep =[];
    @track JobsToDelete=[];
    @track JobToKeepSelected = false;
    @track searchKey = '';
    error;
    ClearJobToKeep(){

    }
    // @wire(searchJobs, { searchKey: '$$searchKey' })
    // searchJobs(result) {
    //     if (result.data) {
    //         this.JobsToKeep = result.data;
    //         this.error = undefined;
    //     } else if (result.error) {
    //         this.error = result.error;
    //         this.JobsToKeep = undefined;
    //     }
    // }
    JobToKeepChange(event){
        window.clearTimeout(this.delayTimeout);
        let searchKey = event.target.value;
        if (searchKey.length === 0) {
            this.JobsToKeep = null;
        }
        if (searchKey.length >= 2) {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            //this.delayTimeout = setTimeout(() => {
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                searchJobs({ searchKey: searchKey })
                .then(result => {
                this.JobsToKeep = result;
                })

                .catch((error) => {
                this.error = error;
                });
            }, DELAY);
        }
    }
    populateJobToKeep(event)
    {
        this.JobsToKeep = '';
        this.JobToKeep = event.target.value;
    }
}