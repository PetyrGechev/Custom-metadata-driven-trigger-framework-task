import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export function dispatchToastMessage(toastMessage,variant){
    const toastEvent = new ShowToastEvent({
        title: variant,
        message: toastMessage,
        variant: variant
    });
    dispatchEvent(toastEvent);
}