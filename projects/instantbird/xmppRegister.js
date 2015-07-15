const { interfaces: Ci, utils: Cu, classes: Cc } = Components;

Cu.import("resource:///modules/imXPCOMUtils.jsm");
Cu.import("resource:///modules/xmpp-session.jsm");

XPCOMUtils.defineLazyGetter(this, "_", function()
  l10nHelper("chrome://branding/locale/brand.properties")
);

let registerAccount = {
  createElement: function(aType, aID, aValue) {
    let element = document.createElement(aType);
    if (aID)
      element.setAttribute("id", aID);
    if (aValue)
      element.setAttribute("value", aValue);
    return element;
  },

  createRow: function() {
    let row = document.createElement("row");
    row.setAttribute("align", "baseline");
    return row;
  },

  onLoad: function() {
    document.documentElement.getButton("accept").disabled = true;

    this.rows = document.getElementById("register-rows");
    this.groupbox = document.getElementById("register-groupbox");

    this.nodes = XMPPSession.prototype.nodes;
    this.registerStanza = window.arguments[0].wrappedJSObject;
    this.dataStanza = this.registerStanza.getElement(["x"]);

    let instructions = this.dataStanza.getElement(["instructions"]);
    if (instructions) {
      let instructionLabel = this.createElement("caption");
      instructionLabel.setAttribute("label", instructions.innerText);
      this.groupbox.appendChild(instructionLabel);
    }

    let title = this.dataStanza.getElement(["title"]);
    if (title)
      document.title = title.innerText;
    else
      document.title = _("brandShortName");

    for each (let ele in this.dataStanza.getElements(["field"])) {
      let attrib = ele.attributes;
      let fieldType = attrib["type"];
      switch (fieldType) {

        case "text-single":
        case "text-private":
          let textRow = this.createRow();
          let textLabel = this.createElement("label", null,
                                             ele.getElement(["required"]) ?
                                             attrib["label"] + " *" : attrib["label"]);

          let textBox = this.createElement("textbox", attrib["var"],
                                           ele.getElement(["value"]) ?
                                           ele.getElement(["value"]).innerText : "");

          if (attrib["var"] == "username")
            textBox.setAttribute("value", this.nodes["username"]);
          if (attrib["var"] == "url")
            textBox.setAttribute("readonly", "true");

          if (fieldType == "text-private") {
            textBox.setAttribute("type", "password");
            textBox.setAttribute("oninput", "onInput(this);");
          }

          textRow.appendChild(textLabel);
          textRow.appendChild(textBox);
          this.rows.appendChild(textRow);
          break;

        case "fixed":
          let fixedRow = this.createRow();
          let fixedLabel = this.createElement("label", null, ele.getElement(["value"]).innerText);
          fixedRow.appendChild(fixedLabel);
          this.rows.appendChild(fixedRow);
          break;
      }
    }

    // Some forms have an OCR field. In that case, show the OCR image
    // and provide input for the same.
    let ocr = this.dataStanza.getElements(["field"]).find(e => e.attributes["var"] == "ocr");
    if (ocr) {
      let ocrRow = this.createRow();

      let ocrImage = this.createElement("image");
      ocrImage.setAttribute("src", "data:image/png;base64," + this.registerStanza.getElement(["data"]).innerText);

      // OCR will always be a required entry.
      let ocrLabel = this.createElement("label", null, ocr.attributes["label"] + " *");
      let ocrInput = this.createElement("textbox", ocr.attributes["var"], null);

      ocrRow.appendChild(ocrLabel);
      this.rows.appendChild(ocrRow);

      let ocrBox = document.createElement("hbox");
      ocrBox.setAttribute("flex", "1");
      let spacer = document.createElement("spacer");
      spacer.setAttribute("flex", "1");

      ocrBox.appendChild(ocrImage);
      ocrBox.appendChild(spacer);
      ocrBox.appendChild(ocrInput);
      this.groupbox.appendChild(ocrBox);
    }
    // Set focus on the password field.
    if (document.getElementById("password")) {
      document.getElementById("password").focus();
    }
  },

  onSave: function() {
    for each (let elements in this.dataStanza.getElements(["field"])) {
      if (elements.attributes["var"] != undefined) {
        let variable = elements.attributes["var"];
        if (document.getElementById(variable))
          this.nodes[variable] = document.getElementById(variable).value;
        else
          this.nodes[variable] = elements.getElement(["value"]).innerText;
      }
    }
    delete this.nodes["cancel"];
  },
  
  onCancel: function() {
    // The form was cancelled so we quit the registration.
    this.nodes["cancel"] = true;
  },
};

function onInput(e) {
  document.documentElement.getButton("accept").disabled = !e.value;
}
