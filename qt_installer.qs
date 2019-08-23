function Controller()
{
  installer.wizardPageInsertionRequested.connect(function(widget, page)
  {
    installer.removeWizardPage(installer.components()[0], "WorkspaceWidget");
  })

  installer.autoRejectMessageBoxes();
  installer.installationFinished.connect(function()
  {
    gui.clickButton(buttons.NextButton);
  })
}

Controller.prototype.WelcomePageCallback = function()
{
  gui.clickButton(buttons.NextButton, 5000);
}

Controller.prototype.CredentialsPageCallback = function()
{
  gui.currentPageWidget().loginWidget.EmailLineEdit.setText("");
  gui.currentPageWidget().loginWidget.PasswordLineEdit.setText("");
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function()
{
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
  gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/Qt");
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function()
{
  var cBoxes = ["Archive", "LTS", "Latest releases", "Preview"];
  for (var i in cBoxes)
  {
    var box = gui.currentPageWidget().findChild(cBoxes[i]);
    if (box)
    {
      box.checked = true;
    }
  }

  var refButton = gui.currentPageWidget().findChild("FetchCategoryButton");
  if (refButton)
  {
    refButton.click();
  }

  var widget = gui.currentPageWidget();
  widget.deselectAll();
    
  var version = "qt5.5124";
  if (installer.value("VERSION") != "")
  {
    version = installer.value("VERSION");
  }


  gui.currentPageWidget().selectComponent("qt."+version+".android_armv7");
  gui.currentPageWidget().selectComponent("qt."+version+".android_arm64_v8a");

  gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function()
{
  gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function()
{
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
  gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function()
{
  var checkBox = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
  if (checkBox && checkBox.launchQtCreatorCheckBox)
  {
    checkBox.launchQtCreatorCheckBox.checked = false;
  }
  gui.clickButton(buttons.FinishButton);
}
