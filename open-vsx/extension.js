const vscode = require("vscode");
const { removeInvisibleCharacters, scanInvisibleCharacters, stripMarkdownPasteResidue } = require("../npm/src/index.js");

function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand("atwr.scan", async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;
      const findings = scanInvisibleCharacters(editor.document.getText());
      const message = findings.length
        ? `Found ${findings.length} invisible character(s), first at ${findings[0].codePoint} index ${findings[0].index}`
        : "No invisible characters found";
      vscode.window.showInformationMessage(message);
    }),
    vscode.commands.registerCommand("atwr.clean", async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;
      const text = editor.document.getText();
      const cleaned = removeInvisibleCharacters(text);
      if (cleaned === text) {
        vscode.window.showInformationMessage("No invisible characters to remove");
        return;
      }
      await editor.edit((builder) => {
        const last = editor.document.lineAt(editor.document.lineCount - 1).range.end;
        builder.replace(new vscode.Range(new vscode.Position(0, 0), last), cleaned);
      });
    }),
    vscode.commands.registerCommand("atwr.tidy", async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;
      const text = editor.document.getText();
      const cleaned = stripMarkdownPasteResidue(text);
      await editor.edit((builder) => {
        const last = editor.document.lineAt(editor.document.lineCount - 1).range.end;
        builder.replace(new vscode.Range(new vscode.Position(0, 0), last), cleaned);
      });
    })
  );
}

function deactivate() {}

module.exports = { activate, deactivate };
