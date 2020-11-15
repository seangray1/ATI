/**
 * Base is meant to be extended by other components.
 * It provides logging of lifecycle events and a logging utility, common
 * error handling, and spinner tracking.
 *
 * As you develop other components, refactor common designs to this class.
 * 
 * Status Handling: to handle informational, warning, and error messages 
 * consistent with other components:
 *   1. include a c-status-panel in your HTMP template and set info, warning, or error
 *   2. call this.setError('the error') when problems occur
 * 
 * Spinner: to include a spinner for long operations:
 *   1. include a lightning-spinner in your HTML template, displayed when isBusy=true
 *   2. set this.isBusy as needed
 */

/* eslint-disable no-console */
import { LightningElement, api } from 'lwc';
import * as Utils from 'c/utils';

export default class Base extends LightningElement {
  // Properties
  isInitialized = false;  // has the component been initialized?
  isBusy = false;         // used to display spinner

  info;                   // tracks current info messages, if any
  warning;                // tracks current warning messages, if any
  error;                  // tracks current error messages, if any

  // Methods
  /** clear errors and if this component contains a dialog box, toggle it */
  @api toggle() {
    this.setError(undefined);
    const dialog = this.template.querySelector("c-dialog");
    if (dialog) {
      dialog.toggle();
    }
  }

  /** validation of lightning input fields */
  _reportValidity(isComplete) {
    let allValid = true;
    this.template.querySelectorAll('lightning-input-field').forEach(f => {
      const v = f.reportValidity();
      allValid = allValid && (v || !isComplete);
    });
    return allValid;
  }

  /** log a message, including the caller's class name */
  log(message) {
    Utils.log(`(${this.constructor.name}) ${message}`);
  }

  /** assert, including the caller's class name */
  assert(expression, message = '') {
    Utils.assert(expression, `(${this.constructor.name}) ${message}`);
  }

  /** assertEquals, including the caller's class name */
  assertEquals(a, b, message = '') {
    Utils.assertEquals(a, b, `(${this.constructor.name}) ${message}`);
  }

  /** assertNotEquals, including the caller's class name */
  assertNotEquals(a, b, message = '') {
    Utils.assertNotEquals(a, b, `(${this.constructor.name}) ${message}`);
  }

  constructor() {
    super();
  }

  /// override this method to do one-time initialization
  initialize() {
    this.log('initialize()');
  }

  connectedCallback() {
    this.log('connectedCallback()');
  }

  disconnectedCallback() {
    this.log('disconnectedCallback()');
  }

  renderedCallback() {
    this.log('renderedCallback()');
    if (!this.isInitialized) {
      this.initialize();
      this.isInitialized = true;
    }
  }

  errorCallback(error, stack) {
    this.setErrorAndStack(error, stack);
  }

  setError(error, toastTitle) {
    this.setErrorAndStack(error, new Error().stack, toastTitle);
  }

  setErrorAndStack(error, stack, toastTitle) {
    if (error) {
      if (toastTitle) {
        Utils.toastError(Utils.reduceErrors(error).toString(), toastTitle);
      } else {
        this.error = error;
      }
      this.log(`setError(${JSON.stringify(error, null, 2)} | Stack: ${stack}`);
    } else {
      this.error = null;
    }

    this.isBusy = false;
  }
}