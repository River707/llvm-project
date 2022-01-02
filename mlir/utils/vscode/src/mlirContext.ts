import * as vscode from 'vscode';
import * as vscodelc from 'vscode-languageclient';

import * as config from './config';
import * as configWatcher from './configWatcher';

/**
 *  This class manages all of the MLIR extension state,
 *  including the language client.
 */
export class MLIRContext implements vscode.Disposable {
  subscriptions: vscode.Disposable[] = [];
  client!: vscodelc.LanguageClient;
  pdlClient!: vscodelc.LanguageClient;

  /**
   *  Activate the MLIR context, and start the language client.
   */
  async activate(outputChannel: vscode.OutputChannel) {
    // Create the language clients for mlir and pdl.
    this.pdlClient =
      this.startLanguageClient(outputChannel, 'pdl_server_path', 'pdl');
    this.client =
      this.startLanguageClient(outputChannel, 'server_path', 'mlir');

    // Watch for configuration changes.
    configWatcher.activate(this);
  }

  /**
   *  Start a new language client for the given language.
   */
  startLanguageClient(outputChannel: vscode.OutputChannel,
    serverSettingName: string,
    languageName: string): vscodelc.LanguageClient {
    // Get the path of the lsp-server that is used to provide language
    // functionality.
    const userDefinedServerPath = config.get<string>(serverSettingName);
    const serverPath = (userDefinedServerPath === '')
                           ? languageName + "-lsp-server"
                           : userDefinedServerPath;

    // Configure the server options.
    const serverOptions: vscodelc.ServerOptions = {
      run : {
        command : serverPath,
        transport : vscodelc.TransportKind.stdio,
        args : []
      },
      debug : {
        command : serverPath,
        transport : vscodelc.TransportKind.stdio,
        args : []
      }
    };

    // Configure the client options.
    const clientOptions: vscodelc.LanguageClientOptions = {
      documentSelector : [ {scheme : 'file', language : languageName} ],
      synchronize : {
        // Notify the server about file changes to language files contained in the
        // workspace.
        fileEvents :
            vscode.workspace.createFileSystemWatcher('**/*.' + languageName)
      },
      outputChannel : outputChannel,
    };

    // Create the language client and start the client.
    let languageClient = new vscodelc.LanguageClient(
        languageName + '-lsp', languageName.toUpperCase() + ' Language Client',
        serverOptions, clientOptions);
    this.subscriptions.push(languageClient.start());
    return languageClient;
  }

  dispose() {
    this.subscriptions.forEach((d) => { d.dispose(); });
    this.subscriptions = [];
  }
}
