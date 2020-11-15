/**
 * A headless component for reusable utilities.
 * Includes event names, logging, toasts, and error handling.
 */

/* eslint-disable no-use-before-define */
/* eslint-disable no-console */
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DEBUGGING from '@salesforce/label/c.Debugging';

//#region Diagnostics
let debugging = (DEBUGGING && (
  ('y' === DEBUGGING.toLowerCase().charAt(0)) || 
  ('t' === DEBUGGING.toLowerCase().charAt(0)))) ? true : false;
const setDebugging = (trueOrFalse) => {
  debugging = trueOrFalse;
}

/**
 * log a message
 * @param {Object} message
 */
// const log = (message) => {
//   const wholeMessage = `~ATI: ${message}`;
//   if (debugging) {
//     console.log(wholeMessage);
//   }
//   return wholeMessage;
// }
const log = (message) => {
  const wholeMessage = `~ATI: ${message}`;
  // if (debugging) {
    console.log(wholeMessage);
  // }
  return wholeMessage;
}


/**
 * Assert that an expression is true
 * @param {Object} expression
 * @param {Object} message
 * @throws {Error} error, if expression is false
 */
const assert = (expression, message = '') => {
  let result = null;
  if (!expression) {
    result = log(`ASSERT!${(message ? (' ' + message) : '')}`);
    if (debugging) {
      throw new Error(`ASSERT: ${message}`);
    }
  }
  return result;
}

/**
 * Assert that two values (a,b) are equal
 * @param {Object} a
 * @param {Object} b
 * @param {Object} message
 */
const assertEquals = (a, b, message = '') => {
  return assert(a === b, message);
}

/**
 * Assert that two values (a,b) are not equal
 * @param {Object} a
 * @param {Object} b
 * @param {Object} message
 */
const assertNotEquals = (a, b, message = '') => {
  return assert(a !== b, message);
}
//#endregion

//#region Toasts
const toast = (message, title='', variant='success') => {
  if (message instanceof Error) {
    message = reduceErrors(message).join('\r\n');
  }
  dispatchEvent(new ShowToastEvent({
    title: title,
    message: message,
    variant: variant,
    mode: 'dismissable'
  }));
}

/**
 * Invoke a success toast
 * @param {String,Error} message
 * @param {String} title
 */
const toastSuccess = (message, title) => {
  toast(message, title, 'success');
}

/**
 * Invoke an information toast
 * @param {String,Error} message
 * @param {String} title
 */
const toastInfo = (message, title) => {
  toast(message, title, 'info');
}

/**
 * Invoke a warning toast
 * @param {String,Error} message
 * @param {String} title
 */
const toastWarning = (message, title) => {
  toast(message, title, 'warning');
}

/**
 * Invoke an error toast
 * @param {String,Error} message
 * @param {String} title
 */
const toastError = (message, title) => {
  toast(message, title, 'error');
}
//#endregion

//#region Error handling
// @see lwc-recipes errorPanel (https://github.com/trailheadapps/lwc-recipes/tree/master/force-app/main/default/lwc/errorPanel)
/**
 * Reduces one or more LDS errors into a string[] of error messages.
 * @param {FetchResponse|FetchResponse[]} errors
 * @return {String[]} Error messages
 */
const reduceErrors = (errors) => {
  if (!Array.isArray(errors)) {
    errors = [errors];
  }

  return (
    errors.filter(error => !!error)             // Remove null/undefined items
      .map(error => {                         // Extract an error message
        if (Array.isArray(error.body)) {    // UI API read errors
          return error.body.map(e => e.message);
        } else if (error.body && typeof error.body.message === 'string') {
          return error.body.message;      // UI API DML, Apex and network errors
        } else if (typeof error.message === 'string') {
          return error.message;           // JS errors
        } else if (typeof error.statusText === 'string') {
          return error.statusText;        // Unknown error shape so try HTTP status text
        } else if (typeof error == 'string') {
          return error;
        }
        return null;
      })
      .reduce((prev, curr) => prev.concat(curr), [])  // Flatten
      .filter(message => !!message)           // Remove empty strings
  );
}
//#endregion

const mapToArray = (m, k="key", v="value") => {
  let result = [];
  if (m) {
    assertEquals("object", typeof m, "invalid map");
    for (let key in m) {
      let o = {};
      o[k] = key;
      o[v] = m.hasOwnProperty(key) ? m[key] : '';
      result.push(o);
    }
  }
  return result;
}

//#region PAB
const PAB = {
  SAVE_TOAST: "PAB changes were successfully saved",
  COMPLETE_TOAST: "PAB changes were successfully saved and marked 'complete'",
  ERR_VALIDATION: "Validation failed. See errors below",
  STATUS_COMPLETE: "Complete",
  STATUS_INCOMPLETE: "Incomplete"
};
//#endregion


export {
  debugging,
  setDebugging,
  log,
  assert, assertEquals, assertNotEquals,
  reduceErrors,

  toastSuccess, toastInfo, toastWarning, toastError,

  mapToArray,

  PAB
};