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

    this.nodes = XMPPSession.prototype.nodes;
    // Clear the existing elements from previous registrations.
    for (let elem in this.nodes)
      delete this.nodes[elem];

    this.registerStanza = window.arguments[0].wrappedJSObject;
    this.dataStanza = this.registerStanza.getElement(["x"]);

    let instructions = this.dataStanza.getElement(["instructions"]);
    if (instructions) {
      let instructionRow = this.createRow();
      let instructionLabel = this.createElement("label", null, instructions.innerText);
      instructionRow.appendChild(instructionLabel);
      this.rows.appendChild(instructionRow);
    }

    let title = this.dataStanza.getElement(["title"]);
    if (title)
      document.title = title.innerText;
    else
      document.title = _("brandShortName");

    for each (let ele in this.dataStanza.getElements(["field"])) {
      let fieldType = ele.attributes["type"];
      switch (fieldType) {

        case "text-single":
        case "text-private":

          let textRow = this.createRow();
          let textLabel = this.createElement("label", null, ele.attributes["label"]);

          let textBox = this.createElement("textbox", ele.attributes["var"],
                                           ele.getElement(["value"]) ? ele.getElement(["value"]).innerText : "");
          if (fieldType == "text-private")
            textBox.setAttribute("type", "password");
          if (ele.getElement(["required"]))
            textBox.setAttribute("oninput", "onInput(this)");

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

      let ocrLabel = this.createElement("label", null, ocr.attributes["label"]);
      let ocrInput = this.createElement("textbox", ocr.attributes["var"], null);

      ocrRow.appendChild(ocrLabel);
      ocrRow.appendChild(ocrInput);
      this.rows.appendChild(ocrRow);

      let ocrBox = document.createElement("hbox");
      ocrBox.setAttribute("align", "center");
      ocrBox.appendChild(ocrImage);

      let ocrImageRow = this.createRow();
      ocrImageRow.appendChild(ocrBox);
      this.rows.appendChild(ocrImageRow);
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
