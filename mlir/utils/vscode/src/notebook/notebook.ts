import * as fs from 'fs';
import * as vscode from 'vscode';

import {MLIRContext} from '../mlirContext';

import {RunPipelineCommand} from './commands/runPipeline';
import {ViewRelatedOperationsCommand} from './commands/viewRelatedOperations';
import {MLIRNotebookKernel} from './notebookkernel';

interface RawNotebook {
  sourceFile: string;
  pipelines: string[];
}

export class MLIRNotebookSerializer implements vscode.NotebookSerializer {
  static mimeMLIR = 'text/x-mlir';

  async deserializeNotebook(content: Uint8Array,
                            _token: vscode.CancellationToken):
      Promise<vscode.NotebookData> {
    const notebookContent = JSON.parse(new TextDecoder().decode(content));
    return {
      metadata : {
        'file' : fs.existsSync(notebookContent.sourceFile)
                     ? vscode.Uri.file(notebookContent.sourceFile).toString()
                     : null
      },
      cells : notebookContent.pipelines.map((pipeline: string) => {
        return new vscode.NotebookCellData(vscode.NotebookCellKind.Code,
                                           pipeline, "shellscript");
      })
    };
  }

  async serializeNotebook(data: vscode.NotebookData,
                          _token: vscode.CancellationToken):
      Promise<Uint8Array> {
    const fileURI = vscode.Uri.parse(data.metadata['file'] as string).fsPath;
    const rawNotebook: RawNotebook = {
      sourceFile : fileURI,
      pipelines : data.cells.map(cell => cell.value)
    };
    return new TextEncoder().encode(JSON.stringify(rawNotebook, undefined, 2));
  }
}

/**
 *  Activate the support for MLIR notebooks.
 */
export function activate(mlirContext: MLIRContext) {
  const notebookSerializer = new MLIRNotebookSerializer();
  mlirContext.subscriptions.push(vscode.workspace.registerNotebookSerializer(
      'mlir-notebook', notebookSerializer));

  const kernel = new MLIRNotebookKernel(mlirContext.client);
  mlirContext.subscriptions.push(kernel.controller);
  mlirContext.subscriptions.push(new RunPipelineCommand());
  mlirContext.subscriptions.push(new ViewRelatedOperationsCommand(kernel));
}
