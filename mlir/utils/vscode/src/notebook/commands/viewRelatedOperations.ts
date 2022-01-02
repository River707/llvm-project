
import * as vscode from 'vscode'

import {Command} from '../../command'
import {MLIRNotebookKernel} from '../notebookkernel'

export class ViewRelatedOperationsCommand extends Command {
    private _kernel: MLIRNotebookKernel;

    constructor(kernel: MLIRNotebookKernel) {
        super('mlir.viewRelatedOperations');
        this._kernel = kernel;
    }

    execute() {
        const editor = vscode.window.activeTextEditor;
        if (editor.document.languageId != 'mlir') {
            return;
        }

        const currentURI = editor.document.uri;
        const currentURIStr = currentURI.toString();
        const position = editor.selection.active;

        vscode.window.visibleNotebookEditors.forEach(notebookEditor => {
          if (notebookEditor.document.metadata['file'] === currentURIStr) {
            this._kernel.highlightLinesInNotebook(notebookEditor.document,
                                                  position.line + 1);
          }
        });
    }
}
