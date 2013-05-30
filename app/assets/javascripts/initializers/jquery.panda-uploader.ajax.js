PandaUploader.UploadOnSubmitAjax = function(successCallback) {
  this.onsuccess = successCallback;
  PandaUploader.UploadOnSubmit.apply(this, arguments);
};

PandaUploader.UploadOnSubmitAjax.prototype = new PandaUploader.UploadOnSubmit();
PandaUploader.UploadOnSubmitAjax.prototype.constructor = PandaUploader.UploadOnSubmitAjax;
