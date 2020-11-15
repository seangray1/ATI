import LightningDatatable from 'lightning/datatable';
import imageTableControl from './imageTableControl.html';

export default class SharinPixExtDatatableComp extends LightningDatatable {
    static customTypes = {
        image: {
            template: imageTableControl
        }
    };
}