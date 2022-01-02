
import * as vscode from 'vscode'
import { Command } from '../../command';

export class RunPipelineCommand extends Command {
    constructor() {
        super('mlir.runPipeline');
    }

    async execute() {
        const editor = vscode.window.activeTextEditor;
        if (editor.document.languageId != 'mlir')
            return;
        const currentURI = editor.document.uri.toString();

        const pipeline = await vscode.window.showInputBox({
            prompt: 'Pass Pipeline to Run',
            placeHolder: 'func(canonicalize)'
        });
        if (pipeline.length === 0)
            return;

        const fileName = 'untitled-1.mlir_notebook';
        const newUri = vscode.Uri.file(fileName).with({ scheme: 'untitled', path: fileName });
        await vscode.commands.executeCommand('vscode.openWith', newUri, 'mlir-notebook-provider');

        await vscode.window.activeNotebookEditor!.edit(editBuilder => {
            editBuilder.replaceCells(0, 0, [
                new vscode.NotebookCellData(vscode.NotebookCellKind.Code, pipeline, 'shell')
            ])
            editBuilder.replaceMetadata({
                cellHasExecutionOrder: true,
                custom: {
                    'file': currentURI
                }
            });
        });
        await vscode.commands.executeCommand('notebook.execute', newUri);
    }
}
