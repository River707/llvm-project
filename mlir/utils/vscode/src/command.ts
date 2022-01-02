import * as vscode from 'vscode';

export abstract class Command extends vscode.Disposable {
    private _disposable: vscode.Disposable;

    constructor(command: string) {
        super(() => this.dispose());
        this._disposable = vscode.commands.registerCommand(command, this.execute, this);
    }

    dispose() {
        this._disposable && this._disposable.dispose();
    }

    abstract execute(...args: any[]): any;
}
