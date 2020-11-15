import { api } from 'lwc';
import Base from 'c/base';

const ESC_KEY_CODE = 27;
const ESC_KEY_STRING = 'Escape';
const TAB_KEY_CODE = 9;
const TAB_KEY_STRING = 'Tab';

export default class Dialog extends Base {
  // Properties
  @api title;
  @api size = 'medium';
  @api tagline;
  @api cancelLabel = 'Close';
  @api saveLabel = 'Save';
  @api saveHandler;
  @api save2Label = 'Mark as Complete';
  @api save2Handler;

  isOpen = false;

  @api // just for testing
  get cssClass() {
    const baseClasses = ['slds-modal slds-backdrop'];
    baseClasses.push([this.isOpen ? 'slds-visible slds-fade-in-open' : 'slds-hidden']);
    if (this.size) {
      baseClasses.push(`slds-modal_${this.size}`);
    }
    return baseClasses.join(' ');
  }

  @api // just for testing
  get isAriaHidden() {
    return !this.isOpen;
  }

  // Methods
  @api toggle() {
    super.log('toggle');
    this.isOpen = !this.isOpen;
    if (this.isOpen) {
      setTimeout(() => this._getCloseButton().focus());
    }
  }

  handleCancel(event) {
    event.stopPropagation();
    this.toggle();
  }

  handleSave(event) {
    event.stopPropagation();
    this.saveHandler();
  }

  innerClickHandler(event) {
    event.stopPropagation();
  }

  innerKeyUpHandler(event) {
    if ((ESC_KEY_CODE === event.keyCode) || (ESC_KEY_STRING === event.code)) {
      this.toggle();
    } else if ((TAB_KEY_CODE === event.keyCode) || (TAB_KEY_STRING === event.code)) {
      const el = this.template.activeElement;
      let focusableElement;
      if (event.shiftKey && el && el.classList.contains('firstLink')) {
        // fallback to the close button
        focusableElement = this._getCloseButton();
      } else if (el && el.classList.contains('lastLink')) {
        focusableElement = this._getCloseButton();
      }
  
      if (focusableElement) {
        focusableElement.focus();
      }
    }
  }

  _getCloseButton() {
    let closeButton = this.template.querySelector('button[title="Close"]');
    if (!closeButton) {
      // if no header is present, choose the first button
      closeButton = this.template.querySelector('button');
    }
    return closeButton;
  }
}