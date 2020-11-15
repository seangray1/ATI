/**
 * An LWC component for displaying status messages (info, warning, error) in a 
 * consistent manner.
 * 
 * @see lwc-recipes errorPanel (https://github.com/trailheadapps/lwc-recipes/tree/master/force-app/main/default/lwc/errorPanel)
 */

import { LightningElement, api } from 'lwc';
import * as Utils from 'c/utils';

export default class StatusPanel extends LightningElement {
  // Properties
  @api infos;     // Single or array of LDS info messages
  @api warnings;  // Single or array of LDS warnings
  @api errors;    // Single or array of LDS errors

  // Methods
  get infoMessages() {
    return Utils.reduceErrors(this.infos);
  }
  get warningMessages() {
    return Utils.reduceErrors(this.warnings);
  }
  get errorMessages() {
    return Utils.reduceErrors(this.errors);
  }
}