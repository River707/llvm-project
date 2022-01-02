import * as vscode from 'vscode';
import * as vscodelc from 'vscode-languageclient';

type PipelineExecutionParams = Partial<{
  textUri : string | undefined,
  textString : string | undefined,
  pipeline : string;
}>;
type PipelineExecutionResult =
    Partial<{output : string, inputToOutputMapping : [];}>;

type OutputMetadataShape =
    Partial<{startTime : number, inputToOutputMapping : [];}>;

function extractMLIRStringFromCellOutput(cell: vscode.NotebookCell) {
  return cell.outputs[0]
      .items
      .map(item => {
        const outputStr = new TextDecoder().decode(item.data);
        return outputStr.replace(
            new RegExp('(```mlir\n)|(\n```)|(`\n)|(\n`)', 'g'), "");
      })
      .join("");
}

export class MLIRNotebookKernel {
  private _executionOrder = 0;
  private _client: vscodelc.LanguageClient;
  readonly controller: vscode.NotebookController;

  constructor(client: vscodelc.LanguageClient) {
    this._client = client;

    this.controller = vscode.notebooks.createNotebookController(
        'mlir-notebook-controller', 'mlir-notebook', 'mlir-notebook');
    this.controller.executeHandler = this._executeCells.bind(this);
    this.controller.supportsExecutionOrder = true;
    this.controller.supportedLanguages = [ 'shellscript' ];
  }

  highlightLinesInNotebook(notebook: vscode.NotebookDocument, line: number) {
    if (notebook.cellCount !== 0) {
      this._highlightLinesInCell(notebook.cellAt(0), [ line ]);
    }
  }

  private async _highlightLinesInCell(cell: vscode.NotebookCell,
                                      sourceLines: number[]) {
    if (cell.outputs.length !== 1) {
      return;
    }
    const mlirStr: string = extractMLIRStringFromCellOutput(cell);
    const outputMetadata: OutputMetadataShape = cell.outputs[0].metadata;
    if (outputMetadata === undefined) {
      return;
    }

    let outputLines: number[] = [];
    sourceLines.forEach(sourceLine => {
      const mapping = outputMetadata.inputToOutputMapping.find(
          element => element[0] === sourceLine);
      if (mapping !== undefined) {
        outputLines = outputLines.concat(mapping[1] as number[]);
      }
    });
    if (outputLines.length === 0) {
      return;
    }
    outputLines = [...new Set(outputLines) ];
    outputLines.sort((a, b) => a - b);

    const mlirStrLines = mlirStr.split('\n');
    let currentLine = 0;
    const newOutput: string[] = [];
    const pushPrevSectionFn = line => {
      if (currentLine === line) {
        ++currentLine;
        return;
      }

      newOutput.push('```mlir\n' +
                     mlirStrLines.slice(currentLine, line).join('\n') +
                     '\n```');
      currentLine = line + 1;
    };

    outputLines.forEach(line => {
      if (line === 0) {
        return;
      }

      pushPrevSectionFn(line - 1);
      newOutput.push('`\n' + mlirStrLines[line - 1] + '\n`');
    });
    pushPrevSectionFn(mlirStrLines.length);

    const execution = this.controller.createNotebookCellExecution(cell);
    execution.executionOrder = cell.executionSummary.executionOrder + 1;
    execution.start(cell.executionSummary.timing.startTime);

    const newArray: vscode.NotebookCellOutputItem[] =
        [ vscode.NotebookCellOutputItem.text(newOutput.join('\n'),
                                             'text/plain') ];
    // = newOutput.map(output => {});
    const executionOutput =
        new vscode.NotebookCellOutput(newArray, cell.outputs[0].metadata);
    executionOutput.items = newArray;
    await execution.replaceOutput(executionOutput);

    execution.end(true, cell.executionSummary.timing.endTime);

    // Move on to the next cell in the document.
    if (cell.notebook.cellCount > cell.index + 1) {
      this._highlightLinesInCell(cell.notebook.cellAt(cell.index + 1),
                                 outputLines);
    }
  }

  private async _executeCells(cells: vscode.NotebookCell[]): Promise<void> {
    const all = new Set<vscode.NotebookCell>();
    for (const cell of cells) {
      this._collectDependentCells(cell, all);
    }

    const tasks = Array.from(all).map(
        cell => this.controller.createNotebookCellExecution(cell)!);
    for (const task of tasks) {
      await this._doExecuteCell(task);
    }
  }

  private async _doExecuteCell(execution: vscode.NotebookCellExecution):
      Promise<void> {
    execution.executionOrder = ++this._executionOrder;
    execution.start(Date.now());

    const metadata: OutputMetadataShape = {inputToOutputMapping : []};

    let pipelineParams: PipelineExecutionParams = {
      pipeline : execution.cell.document.getText()
    };
    if (execution.cell.index === 0) {
      pipelineParams.textUri = execution.cell.notebook.metadata['file'];
      if (pipelineParams.textUri === null) {
        await execution.replaceOutput([ new vscode.NotebookCellOutput(
            [ vscode.NotebookCellOutputItem.error(new Error(
                'The input file of this notebook could not be found.')) ],
            metadata) ]);
        execution.end(false, Date.now());
        return;
      }
    } else {
      const prevCell = execution.cell.notebook.cellAt(execution.cell.index - 1);
      pipelineParams.textString =
          extractMLIRStringFromCellOutput(prevCell).replace(
              new RegExp(' ', 'g'), ' ');
    }

    const result: PipelineExecutionResult|undefined =
        await this._client.sendRequest('mlir/executePipeline', pipelineParams);
    const output = result.output.replace(new RegExp(' ', 'g'), ' ');
    metadata.inputToOutputMapping = result.inputToOutputMapping;

    // TODO: Add proper logging facilities.
    // let channel = vscode.window.createOutputChannel('MLIR');

    await execution.replaceOutput([ new vscode.NotebookCellOutput(
        [ vscode.NotebookCellOutputItem.text(
            '```mlir\n' + output.trimRight() + '\n```', 'text/plain') ],
        metadata) ]);
    execution.end(true, Date.now());
  }

  private _collectDependentCells(cell: vscode.NotebookCell,
                                 bucket: Set<vscode.NotebookCell>): void {
    if (cell.index > 0) {
      const prevCell = cell.notebook.cellAt(cell.index - 1);
      if (prevCell.outputs.length === 0) {
        this._collectDependentCells(prevCell, bucket);
      }
    }
    bucket.add(cell);
  }
}
