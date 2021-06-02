/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License

	No warranty of merchantability or fitness of any kind.
	Use this software at your own risk.
 */

package moonshine.lsp;

import haxe.Json;
import moonshine.lsp.events.LspNotificationEvent;
import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import openfl.utils.ByteArray;
import openfl.utils.IDataInput;
import openfl.utils.IDataOutput;

/**
	An implementation of the language server protocol for Moonshine IDE.
	@see https://microsoft.github.io/language-server-protocol/specification Language Server Protocol Specification
**/
class LanguageClient extends EventDispatcher {
	private static final HELPER_BYTES:ByteArray = new ByteArray();
	private static final PROTOCOL_HEADER_FIELD_CONTENT_LENGTH:String = "Content-Length: ";
	private static final PROTOCOL_HEADER_DELIMITER:String = "\r\n";
	private static final PROTOCOL_END_OF_HEADER:String = "\r\n\r\n";
	private static final WRITE_BUFFER_SIZE:Int = 512;
	private static final URI_SCHEME_FILE:String = "file";
	private static final FIELD_METHOD:String = "method";
	private static final FIELD_RESULT:String = "result";
	private static final FIELD_ERROR:String = "error";
	private static final FIELD_ID:String = "id";
	private static final FIELD_CHANGES:String = "changes";
	private static final FIELD_DOCUMENT_CHANGES:String = "documentChanges";
	private static final FIELD_CONTENTS:String = "contents";
	private static final FIELD_SIGNATURES:String = "signatures";
	private static final FIELD_ITEMS:String = "items";
	private static final FIELD_LOCATION:String = "location";
	private static final FIELD_IS_INCOMPLETE:String = "isIncomplete";
	private static final FIELD_COMMAND:String = "command";
	private static final FIELD_TARGET_URI:String = "targetUri";
	private static final JSON_RPC_VERSION:String = "2.0";
	private static final METHOD_INITIALIZE:String = "initialize";
	private static final METHOD_INITIALIZED:String = "initialized";
	private static final METHOD_SHUTDOWN:String = "shutdown";
	private static final METHOD_EXIT:String = "exit";
	private static final METHOD_DOLLAR__CANCEL_REQUEST:String = "$/cancelRequest";
	private static final METHOD_DOLLAR__PROGRESS:String = "$/progress";
	private static final METHOD_TEXT_DOCUMENT__DID_CHANGE:String = "textDocument/didChange";
	private static final METHOD_TEXT_DOCUMENT__DID_OPEN:String = "textDocument/didOpen";
	private static final METHOD_TEXT_DOCUMENT__DID_CLOSE:String = "textDocument/didClose";
	private static final METHOD_TEXT_DOCUMENT__WILL_SAVE:String = "textDocument/willSave";
	private static final METHOD_TEXT_DOCUMENT__DID_SAVE:String = "textDocument/didSave";
	private static final METHOD_TEXT_DOCUMENT__PUBLISH_DIAGNOSTICS:String = "textDocument/publishDiagnostics";
	private static final METHOD_TEXT_DOCUMENT__COMPLETION:String = "textDocument/completion";
	private static final METHOD_TEXT_DOCUMENT__SIGNATURE_HELP:String = "textDocument/signatureHelp";
	private static final METHOD_TEXT_DOCUMENT__HOVER:String = "textDocument/hover";
	private static final METHOD_TEXT_DOCUMENT__DEFINITION:String = "textDocument/definition";
	private static final METHOD_TEXT_DOCUMENT__TYPE_DEFINITION:String = "textDocument/typeDefinition";
	private static final METHOD_TEXT_DOCUMENT__DOCUMENT_SYMBOL:String = "textDocument/documentSymbol";
	private static final METHOD_TEXT_DOCUMENT__REFERENCES:String = "textDocument/references";
	private static final METHOD_TEXT_DOCUMENT__RENAME:String = "textDocument/rename";
	private static final METHOD_TEXT_DOCUMENT__CODE_ACTION:String = "textDocument/codeAction";
	private static final METHOD_TEXT_DOCUMENT__CODE_LENS:String = "textDocument/codeLens";
	private static final METHOD_TEXT_DOCUMENT__IMPLEMENTATION:String = "textDocument/implementation";
	private static final METHOD_WORKSPACE__APPLY_EDIT:String = "workspace/applyEdit";
	private static final METHOD_WORKSPACE__SYMBOL:String = "workspace/symbol";
	private static final METHOD_WORKSPACE__EXECUTE_COMMAND:String = "workspace/executeCommand";
	private static final METHOD_WORKSPACE__DID_CHANGE_CONFIGURATION:String = "workspace/didChangeConfiguration";
	private static final METHOD_WORKSPACE__DID_CHANGE_WORKSPACE_FOLDERS:String = "workspace/didChangeWorkspaceFolders";
	private static final METHOD_WINDOW__LOG_MESSAGE:String = "window/logMessage";
	private static final METHOD_WINDOW__SHOW_MESSAGE:String = "window/showMessage";
	private static final METHOD_WINDOW__WORK_DONE_PROGRESS__CREATE:String = "window/workDoneProgress/create";
	private static final METHOD_WINDOW__WORK_DONE_PROGRESS__CANCEL:String = "window/workDoneProgress/cancel";
	private static final METHOD_CLIENT__REGISTER_CAPABILITY:String = "client/registerCapability";
	private static final METHOD_CLIENT__UNREGISTER_CAPABILITY:String = "client/unregisterCapability";
	private static final METHOD_TELEMETRY__EVENT:String = "telemetry/event";
	private static final METHOD_COMPLETION_ITEM__RESOLVE:String = "completionItem/resolve";

	public function new(languageId:String, initializationOptions:Any, input:IDataInput, inputDispatcher:IEventDispatcher, inputEventType:String,
			output:IDataOutput, outputFlushCallback:() -> Void) {
		super();
		_languageId = languageId;
		_initializationOptions = initializationOptions;
		_input = input;
		_inputDispatcher = inputDispatcher;
		_inputEventType = inputEventType;
		_output = output;
		_outputFlushCallback = outputFlushCallback;
	}

	public var debugMode:Bool = false;

	private var _languageId:String;

	@:flash.property
	public var languageId(get, never):String;

	private function get_languageId():String {
		return _languageId;
	}

	private var _initialized:Bool = false;

	@:flash.property
	public var initialized(get, never):Bool;

	private function get_initialized():Bool {
		return _initialized;
	}

	private var _initializeID:Int = -1;

	@:flash.property
	public var initializing(get, never):Bool;

	private function get_initializing():Bool {
		return _initializeID != -1;
	}

	private var _stopped:Bool = false;

	@:flash.property
	public var stopped(get, never):Bool;

	private function get_stopped():Bool {
		return _stopped;
	}

	private var _shutdownID:Int = -1;

	@:flash.property
	public var stopping(get, never):Bool;

	private function get_stopping():Bool {
		return _shutdownID != -1;
	}

	private var _serverCapabilities:ServerCapabilities;

	public var serverCapabilities(get, never):ServerCapabilities;

	private function get_serverCapabilities():ServerCapabilities {
		return _serverCapabilities;
	}

	private var _initializationOptions:Any;

	private var _input:IDataInput;
	private var _inputDispatcher:IEventDispatcher;
	private var _inputEventType:String;
	private var _output:IDataOutput;
	private var _outputFlushCallback:() -> Void;

	private var _calledStart:Bool = false;
	private var _requestID:Int = 0;
	private var _documentVersion:Int = 1;
	private var _contentLength:Int = -1;
	private var _socketBuffer:String = "";
	private var _socketBytes:ByteArray = new ByteArray();
	private var _idToRequest:Map<Int, RequestMessage> = [];

	private var _completionLookup:Map<Int, ParamsAndCallback<CompletionParams, Null<CompletionList>>> = [];
	private var _resolveCompletionLookup:Map<Int, ParamsAndCallback<CompletionItem, CompletionItem>> = [];
	private var _signatureHelpLookup:Map<Int, ParamsAndCallback<SignatureHelpParams, Null<SignatureHelp>>> = [];
	private var _hoverLookup:Map<Int, ParamsAndCallback<HoverParams, Null<Hover>>> = [];
	private var _renameLookup:Map<Int, ParamsAndCallback<RenameParams, Null<WorkspaceEdit>>> = [];
	private var _definitionLookup:Map<Int, ParamsAndCallback<DefinitionParams, Null<Array<Any /* Array<Location | LocationLink> */>>>> = [];
	private var _typeDefinitionLookup:Map<Int, ParamsAndCallback<TypeDefinitionParams, Null<Array<Any /* Array<Location | LocationLink> */>>>> = [];
	private var _implementationLookup:Map<Int, ParamsAndCallback<ImplementationParams, Null<Array<Any /* Array<Location | LocationLink> */>>>> = [];
	private var _referencesLookup:Map<Int, ParamsAndCallback<ReferenceParams, Null<Array<Location>>>> = [];
	private var _codeActionLookup:Map<Int, ParamsAndCallback<CodeActionParams, Null<Array<CodeAction>>>> = [];
	private var _documentSymbolsLookup:Map<Int,
		ParamsAndCallback<DocumentSymbolParams, Null<Array<Any>> /* Array<DocumentSymbol> | Array<SymbolInformation> */>> = [];
	private var _workspaceSymbolsLookup:Map<Int, ParamsAndCallback<WorkspaceSymbolParams, Null<Array<SymbolInformation>>>> = [];
	private var _executeCommandLookup:Map<Int, ParamsAndCallback<ExecuteCommandParams, Null<Any>>> = [];

	private var _previousCompletionID:Int = -1;
	private var _previousResolveCompletionID:Int = -1;
	private var _previousSignatureHelpID:Int = -1;
	private var _previousHoverID:Int = -1;
	private var _previousDefinitionLinkID:Int = -1;
	private var _previousFindReferencesID:Int = -1;
	private var _previousCodeActionID:Int = -1;
	private var _previousDocumentSymbolsID:Int = -1;
	private var _previousDocumentSymbolsURI:String;
	private var _previousWorkspaceSymbolsID:Int = -1;

	private var supportsCompletion:Bool = false;
	private var resolveCompletion:Bool = false;
	private var supportsHover:Bool = false;
	private var supportsSignatureHelp:Bool = false;
	private var supportsDefinition:Bool = false;
	private var supportsTypeDefinition:Bool = false;
	private var supportsReferences:Bool = false;
	private var supportsDocumentSymbols:Bool = false;
	private var supportsWorkspaceSymbols:Bool = false;
	private var supportsImplementation:Bool = false;
	private var supportedCommands:Array<String> = [];
	private var supportsRename:Bool = false;
	private var supportsCodeAction:Bool = false;
	private var supportsCodeLens:Bool = false;
	private var supportsExecuteCommand:Bool = false;

	private var _registeredCommands:Map<String, Any> = [];
	private var _notificationListeners:Map<String, Array<(message:NotificationMessage) -> Void>> = [];
	private var _uriSchemes:Array<String> = [];
	private var _workspaceFolders:Array<WorkspaceFolder> = [];

	public function start():Void {
		if (_calledStart) {
			return;
		}
		_calledStart = true;

		_inputDispatcher.addEventListener(_inputEventType, languageClient_input_onData);

		sendInitialize();
	}

	public function addWorkspaceFolder(workspaceFolder:WorkspaceFolder):Void {
		var index = _workspaceFolders.indexOf(workspaceFolder);
		if (index != -1) {
			return;
		}
		_workspaceFolders.push(workspaceFolder);

		var params:DidChangeWorkspaceFoldersParams = {
			event: {
				added: [workspaceFolder],
				removed: []
			}
		};
		sendNotification(METHOD_WORKSPACE__DID_CHANGE_WORKSPACE_FOLDERS, params);
	}

	public function removeWorkspaceFolder(workspaceFolder:WorkspaceFolder):Void {
		var index = _workspaceFolders.indexOf(workspaceFolder);
		if (index == -1) {
			return;
		}
		_workspaceFolders.splice(index, 1);

		var params:DidChangeWorkspaceFoldersParams = {
			event: {
				added: [],
				removed: [workspaceFolder]
			}
		};
		sendNotification(METHOD_WORKSPACE__DID_CHANGE_WORKSPACE_FOLDERS, params);
	}

	public function stop():Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}

		_shutdownID = sendRequest(METHOD_SHUTDOWN, null);
	}

	public function registerUriScheme(uriScheme:String):Void {
		_uriSchemes.push(uriScheme);
	}

	public function didOpen(params:DidOpenTextDocumentParams):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		sendNotification(METHOD_TEXT_DOCUMENT__DID_OPEN, params);
	}

	public function didClose(params:DidCloseTextDocumentParams):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		sendNotification(METHOD_TEXT_DOCUMENT__DID_CLOSE, params);
	}

	public function didChange(params:DidChangeTextDocumentParams):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		sendNotification(METHOD_TEXT_DOCUMENT__DID_CHANGE, params);
	}

	public function willSave(params:WillSaveTextDocumentParams):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		sendNotification(METHOD_TEXT_DOCUMENT__WILL_SAVE, params);
	}

	public function didSave(params:DidSaveTextDocumentParams):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		sendNotification(METHOD_TEXT_DOCUMENT__DID_SAVE, params);
	}

	public function completion(params:CompletionParams, callback:(Null<CompletionList>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsCompletion) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__COMPLETION, params);
		_completionLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function resolveCompletionHandler(item:CompletionItem, callback:(CompletionItem) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!resolveCompletion) {
			callback(item);
			return;
		}

		var id = sendRequest(METHOD_COMPLETION_ITEM__RESOLVE, item);
		_resolveCompletionLookup[id] = new ParamsAndCallback(item, callback);
	}

	public function signatureHelp(params:SignatureHelpParams, callback:(Null<SignatureHelp>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsSignatureHelp) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__SIGNATURE_HELP, params);
		_signatureHelpLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function hover(params:HoverParams, callback:(Null<Hover>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsHover) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__HOVER, params);
		_hoverLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function definition(params:DefinitionParams, callback:(Null<Array<Any>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsDefinition) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__DEFINITION, params);
		_definitionLookup[id] = new ParamsAndCallback(params, callback);
	}

	private function typeDefinitionHandler(params:TypeDefinitionParams, callback:(Null<Array<Any>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsTypeDefinition) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__TYPE_DEFINITION, params);
		_typeDefinitionLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function implementation(params:ImplementationParams, callback:(Null<Array<Any>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsImplementation) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__IMPLEMENTATION, params);
		_implementationLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function references(params:ReferenceParams, callback:(Null<Array<Location>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsReferences) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__REFERENCES, params);
		_referencesLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function documentSymbols(params:DocumentSymbolParams, callback:(Null<Array<Any>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsDocumentSymbols) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__DOCUMENT_SYMBOL, params);
		_documentSymbolsLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function workspaceSymbols(params:WorkspaceSymbolParams, callback:(Null<Array<SymbolInformation>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsWorkspaceSymbols) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_WORKSPACE__SYMBOL, params);
		_workspaceSymbolsLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function codeAction(params:CodeActionParams, callback:(Null<Array<CodeAction>>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsCodeAction) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__CODE_ACTION, params);
		_codeActionLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function rename(params:RenameParams, callback:(Null<WorkspaceEdit>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		if (!supportsRename) {
			callback(null);
			return;
		}

		var id = sendRequest(METHOD_TEXT_DOCUMENT__RENAME, params);
		_renameLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function executeCommand(params:ExecuteCommandParams, callback:(Null<Any>) -> Void):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		var command = params.command;
		if (_registeredCommands.exists(command)) {
			var commandMethod = _registeredCommands.get(command);
			var result = Reflect.callMethod(null, commandMethod, params.arguments);
			callback(result);
			return;
		}
		if (supportedCommands.indexOf(command) == -1) {
			return;
		}

		var id = sendRequest(METHOD_WORKSPACE__EXECUTE_COMMAND, params);
		_executeCommandLookup[id] = new ParamsAndCallback(params, callback);
	}

	public function registerCommand(command:String, listener:Any):Void {
		if (_registeredCommands.exists(command)) {
			throw new ArgumentError('Command "${command}" is already registered');
		}
		_registeredCommands.set(command, listener);
	}

	public function unregisterCommand(command:String):Void {
		if (!_registeredCommands.exists(command)) {
			return;
		}
		_registeredCommands.remove(command);
	}

	public function addNotificationListener(method:String, listener:(NotificationMessage) -> Void):Void {
		if (!_notificationListeners.exists(method)) {
			_notificationListeners.set(method, []);
		}
		var listeners = _notificationListeners.get(method);
		var index = listeners.indexOf(listener);
		if (index != -1) {
			// already added
			return;
		}
		listeners.push(listener);
	}

	public function removeNotificationListener(method:String, listener:(NotificationMessage) -> Void):Void {
		if (!_notificationListeners.exists(method)) {
			// nothing to remove
			return;
		}
		var listeners = _notificationListeners.get(method);
		var index = listeners.indexOf(listener);
		if (index == -1) {
			// nothing to remove
			return;
		}
		listeners.splice(index, 1);
	}

	public function sendNotification(method:String, params:Any):Void {
		if (!_initialized && method != METHOD_INITIALIZE && method != METHOD_EXIT) {
			throw new IllegalOperationError("Notification failed. Language server is not initialized. Unexpected method: " + method);
		}
		if (_stopped) {
			throw new IllegalOperationError("Notification failed. Language server is stopped. Unexpected method: " + method);
		}

		var contentPart:NotificationMessage = {
			jsonrpc: JSON_RPC_VERSION,
			method: method,
			params: params,
		};
		var contentJSON:String = Json.stringify(contentPart);

		HELPER_BYTES.clear();
		HELPER_BYTES.writeUTFBytes(contentJSON);
		var contentLength = HELPER_BYTES.length;
		HELPER_BYTES.clear();

		var headerPart:String = PROTOCOL_HEADER_FIELD_CONTENT_LENGTH + contentLength + PROTOCOL_HEADER_DELIMITER;
		var message:String = headerPart + PROTOCOL_HEADER_DELIMITER + contentJSON;

		if (debugMode) {
			trace(">>> (NOTIFICATION)", contentJSON);
		}

		try {
			var remaining = message;
			var remainingSize = remaining.length;
			while (remainingSize > 0) {
				// we break this up into smaller messages because the
				// IDataOutput can be overwhelmed by larger messages and
				// throw an error
				var currentSize = WRITE_BUFFER_SIZE;
				if (currentSize > remainingSize) {
					currentSize = remainingSize;
				}
				var current = remaining.substr(0, currentSize);
				remaining = remaining.substr(currentSize);
				remainingSize -= currentSize;
				_output.writeUTFBytes(current);
			}
		} catch (e:Any) {
			// if there's something wrong with the IDataOutput, we can't
			// send a final shutdown request
			stop();
			return;
		}
		if (_outputFlushCallback != null) {
			_outputFlushCallback();
		}
	}

	private function sendRequest(method:String, params:Any):Int {
		if (!_initialized && method != METHOD_INITIALIZE) {
			throw new IllegalOperationError("Request failed. Language server is not initialized. Unexpected method: " + method);
		}

		var id = getNextRequestID();
		var contentPart:RequestMessage = {
			jsonrpc: JSON_RPC_VERSION,
			id: id,
			method: method,
		};
		if (params != null) {
			// omit it completely to avoid errors in servers that try to
			// parse an object
			contentPart.params = params;
		}
		var contentJSON = Json.stringify(contentPart);

		_idToRequest.set(id, contentPart);

		HELPER_BYTES.clear();
		HELPER_BYTES.writeUTFBytes(contentJSON);
		var contentLength = HELPER_BYTES.length;
		HELPER_BYTES.clear();

		var headerPart = PROTOCOL_HEADER_FIELD_CONTENT_LENGTH + contentLength + PROTOCOL_HEADER_DELIMITER;
		var message = headerPart + PROTOCOL_HEADER_DELIMITER + contentJSON;

		if (debugMode) {
			trace(">>> (REQUEST)", contentJSON);
		}

		try {
			_output.writeUTFBytes(message);
		} catch (e:Any) {
			// if we're already trying to shut down, don't do it again
			if (method != METHOD_SHUTDOWN) {
				// if there's something wrong with the IDataOutput, we can't
				// send a final shutdown request
				stop();
			} else {
				// something went wrong while sending the shutdown request
				// there's nothing that we can do about that, so notify
				// any listeners that we've stopped
				_stopped = true;
				dispatchEvent(new Event(Event.CLOSE));
			}
			return id;
		}
		if (_outputFlushCallback != null) {
			_outputFlushCallback();
		}

		return id;
	}

	private function sendResponse(id:Any, result:Any = null, error:Any = null):Void {
		if (!_initialized) {
			throw new IllegalOperationError("Response failed. Language server is not initialized.");
		}

		var contentPart:ResponseMessage = {
			jsonrpc: JSON_RPC_VERSION,
			id: id,
		}
		if (result != null) {
			contentPart.result = result;
		}
		if (error != null) {
			contentPart.error = error;
		}
		var contentJSON = Json.stringify(contentPart);

		HELPER_BYTES.clear();
		HELPER_BYTES.writeUTFBytes(contentJSON);
		var contentLength = HELPER_BYTES.length;
		HELPER_BYTES.clear();

		var headerPart = PROTOCOL_HEADER_FIELD_CONTENT_LENGTH + contentLength + PROTOCOL_HEADER_DELIMITER;
		var message = headerPart + PROTOCOL_HEADER_DELIMITER + contentJSON;

		if (debugMode) {
			trace(">>> (RESPONSE)", contentJSON);
		}

		try {
			_output.writeUTFBytes(message);
		} catch (e:Any) {
			// if there's something wrong with the IDataOutput, we can't
			// send a final shutdown request
			stop();
			return;
		}
		if (_outputFlushCallback != null) {
			_outputFlushCallback();
		}
	}

	private function getNextRequestID():Int {
		_requestID++;
		return _requestID;
	}

	private function uriToFilePath(uri:String):String {
		#if air
		var file = new flash.filesystem.File();
		file.url = uri;
		return file.nativePath;
		#else
		return null;
		#end
	}

	private function sendInitialize():Void {
		var mainWorkspaceFolder = _workspaceFolders.length > 0 ? _workspaceFolders[0] : null;
		var params = {
			rootUri: (mainWorkspaceFolder != null) ? mainWorkspaceFolder.uri : null,
			rootPath: (mainWorkspaceFolder != null) ? uriToFilePath(mainWorkspaceFolder.uri) : null,
			workspaceFolders: _workspaceFolders.map(workspaceFolder -> workspaceFolder.serialize()),
			initializationOptions: _initializationOptions,
			capabilities: {
				workspace: {
					applyEdit: true,
					workspaceEdit: {
						documentChanges: false
					},
					didChangeConfiguration: {
						dynamicRegistration: false
					},
					didChangeWatchedFiles: {
						dynamicRegistration: false
					},
					symbol: {
						dynamicRegistration: true
					},
					executeCommand: {
						dynamicRegistration: true
					},
					workspaceFolders: false,
					configuration: false
				},
				textDocument: {
					synchronization: {
						dynamicRegistration: false,
						willSave: true,
						willSaveWaitUntil: false,
						didSave: true
					},
					completion: {
						dynamicRegistration: true,
						completionItem: {
							snippetSupport: false,
							commitCharactersSupport: false,
							documentationFormat: ["plaintext"],
							deprecatedSupport: false
						},
						completionItemKind: {
							// valueSet: []
						},
						contextSupport: false
					},
					hover: {
						dynamicRegistration: true,
						contentFormat: ["plaintext"]
					},
					signatureHelp: {
						dynamicRegistration: true,
						signatureInformation: {
							documentationFormat: ["plaintext"]
						}
					},
					references: {
						dynamicRegistration: true
					},
					documentHighlight: {
						dynamicRegistration: false
					},
					documentSymbol: {
						dynamicRegistration: true,
						hierarchicalDocumentSymbolSupport: true,
						symbolKind: {
							// valueSet: []
						}
					},
					formatting: {
						dynamicRegistration: false
					},
					rangeFormatting: {
						dynamicRegistration: false
					},
					onTypeFormatting: {
						dynamicRegistration: false
					},
					definition: {
						dynamicRegistration: true
					},
					typeDefinition: {
						dynamicRegistration: true
					},
					implementation: {
						dynamicRegistration: false
					},
					codeAction: {
						dynamicRegistration: true,
						codeActionLiteralSupport: {
							codeActionKind: {
								// valueSet: []
							}
						}
					},
					codeLens: {
						dynamicRegistration: false
					},
					documentLink: {
						dynamicRegistration: false
					},
					colorProvider: {
						dynamicRegistration: false
					},
					rename: {
						dynamicRegistration: true
					},
					publishDiagnostics: {
						relatedInformation: false
					}
				}
			}
		};
		_initializeID = sendRequest(METHOD_INITIALIZE, params);
	}

	private function sendInitialized():Void {
		if (_initializeID != -1) {
			throw new IllegalOperationError("Cannot send initialized notification until initialize request completes.");
		}
		if (_initialized) {
			throw new IllegalOperationError("Cannot send initialized notification multiple times.");
		}
		_initialized = true;

		var params:Any = {};
		sendNotification(METHOD_INITIALIZED, params);

		dispatchEvent(new Event(Event.INIT));

		sendNotification(METHOD_WORKSPACE__DID_CHANGE_CONFIGURATION, {settings: {}});
	}

	private function sendExit():Void {
		_inputDispatcher.removeEventListener(_inputEventType, languageClient_input_onData);
		sendNotification(METHOD_EXIT, null);
		_stopped = true;
		dispatchEvent(new Event(Event.CLOSE));
	}

	private function parseMessageBuffer():Void {
		var object:Any = null;
		try {
			var needsHeaderPart = _contentLength == -1;
			if (needsHeaderPart && _socketBuffer.indexOf(PROTOCOL_END_OF_HEADER) == -1) {
				// not enough data for the header yet
				return;
			}
			while (needsHeaderPart) {
				var index = _socketBuffer.indexOf(PROTOCOL_HEADER_DELIMITER);
				var headerField = _socketBuffer.substr(0, index);
				_socketBuffer = _socketBuffer.substr(index + PROTOCOL_HEADER_DELIMITER.length);
				if (index == 0) {
					// this is the end of the header
					needsHeaderPart = false;
				} else if (headerField.indexOf(PROTOCOL_HEADER_FIELD_CONTENT_LENGTH) == 0) {
					var contentLengthAsString = headerField.substr(PROTOCOL_HEADER_FIELD_CONTENT_LENGTH.length);
					_contentLength = Std.parseInt(contentLengthAsString);
				}
			}
			if (_contentLength == -1) {
				trace("Error: Language client failed to parse Content-Length header");
				return;
			}
			// keep adding to the byte array until we have the full content
			_socketBytes.writeUTFBytes(_socketBuffer);
			_socketBuffer = "";
			if (Std.int(_socketBytes.length) < _contentLength) {
				// we don't have the full content part of the message yet,
				// so we'll try again the next time we have new data
				return;
			}
			_socketBytes.position = 0;
			var message = _socketBytes.readUTFBytes(_contentLength);
			// add any remaining bytes back into the buffer because they are
			// the beginning of the next message
			_socketBuffer = _socketBytes.readUTFBytes(_socketBytes.length - _contentLength);
			_socketBytes.clear();
			_contentLength = -1;
			if (debugMode) {
				trace("<<<", message);
			}
			object = Json.parse(message);
		} catch (e:Any) {
			trace("Error: Language client failed to parse JSON.");
			return;
		}
		parseMessage(object);

		// check if there's another message in the buffer
		parseMessageBuffer();
	}

	private function parseMessage(object:Any):Void {
		if (Reflect.hasField(object, FIELD_METHOD)) {
			if (Reflect.hasField(object, FIELD_ID)) {
				parseRequestMessage((object : RequestMessage));
			} else {
				parseNotificationMessage((object : NotificationMessage));
			}
		} else if (Reflect.hasField(object, FIELD_ID)) {
			parseResponseMessage((object : ResponseMessage));
		} else {
			trace("Cannot parse language server message. Missing method or id. Full message:", Json.stringify(object));
		}
	}

	private function parseResponseMessage(object:ResponseMessage):Void {
		var result = object.result;
		var requestID = getResponseMessageId(object);
		var originalRequest = _idToRequest.get(requestID);
		_idToRequest.remove(requestID);
		if (_initializeID != -1 && _initializeID == requestID) {
			_initializeID = -1;
			if (object.error != null) {
				trace("Error: Language server request failed. Method: " + originalRequest.method + ", Error Code: " + object.error.code + ", Message: "
					+ object.error.message);
				if (debugMode) {
					trace("Failed Request: " + Json.stringify(originalRequest));
				}
				sendExit();
				return;
			}
			handleInitializeResponse(result);
			sendInitialized();
		} else if (_shutdownID != -1 && _shutdownID == requestID) {
			_shutdownID = -1;
			sendExit();
		} else if (object.error != null) {
			trace("Error: Language server request failed. Method: " + originalRequest.method + ", Error Code: " + object.error.code + ", Message: "
				+ object.error.message);
			if (debugMode) {
				trace("Failed Request: " + Json.stringify(originalRequest));
			}
		} else {
			if (_completionLookup.exists(requestID)) {
				var paramsAndCallback = _completionLookup.get(requestID);
				_completionLookup.remove(requestID);
				if (_previousCompletionID > requestID) {
					// we already handled a newer completion response
					return;
				}
				_previousCompletionID = requestID;
				if ((result is Array)) {
					handleCompletionItemArrayResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
				} else {
					handleCompletionListResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
				}
			} else if (_resolveCompletionLookup.exists(requestID)) {
				var paramsAndCallback = _resolveCompletionLookup.get(requestID);
				_resolveCompletionLookup.remove(requestID);
				if (_previousResolveCompletionID > requestID) {
					// we already handled a newer resolve completion response
					return;
				}
				_previousResolveCompletionID = requestID;
				handleCompletionResolveResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_signatureHelpLookup.exists(requestID)) {
				var paramsAndCallback = _signatureHelpLookup.get(requestID);
				_signatureHelpLookup.remove(requestID);
				if (_previousSignatureHelpID > requestID) {
					// we already handled a newer signature help response
					return;
				}
				_previousSignatureHelpID = requestID;
				handleSignatureHelpResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_hoverLookup.exists(requestID)) {
				var paramsAndCallback = _hoverLookup.get(requestID);
				_hoverLookup.remove(requestID);
				if (_previousHoverID > requestID) {
					// we already handled a newer hover response
					return;
				}
				_previousHoverID = requestID;
				handleHoverResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_definitionLookup.exists(requestID)) {
				var paramsAndCallback = _definitionLookup.get(requestID);
				_definitionLookup.remove(requestID);
				handleDefinitionResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_typeDefinitionLookup.exists(requestID)) {
				var paramsAndCallback = _typeDefinitionLookup.get(requestID);
				_typeDefinitionLookup.remove(requestID);
				handleTypeDefinitionResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_implementationLookup.exists(requestID)) {
				var paramsAndCallback = _implementationLookup.get(requestID);
				_implementationLookup.remove(requestID);
				handleImplementationResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_referencesLookup.exists(requestID)) {
				var paramsAndCallback = _referencesLookup.get(requestID);
				_referencesLookup.get(requestID);
				if (_previousFindReferencesID > requestID) {
					// we already handled a newer find references response
					return;
				}
				_previousFindReferencesID = requestID;
				handleReferencesResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_renameLookup.exists(requestID)) {
				var paramsAndCallback = _renameLookup.get(requestID);
				_renameLookup.remove(requestID);
				handleRenameResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_codeActionLookup.exists(requestID)) {
				var paramsAndCallback = _codeActionLookup.get(requestID);
				_codeActionLookup.remove(requestID);
				if (_previousCodeActionID > requestID) {
					// we already handled a newer code action response
					return;
				}
				_previousCodeActionID = requestID;
				handleCodeActionResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_documentSymbolsLookup.exists(requestID)) {
				var paramsAndCallback = _documentSymbolsLookup.get(requestID);
				var params = paramsAndCallback.params;
				_documentSymbolsLookup.remove(requestID);
				if (_previousDocumentSymbolsID > requestID && _previousDocumentSymbolsURI == params.textDocument.uri) {
					// we already handled a newer document symbol response
					return;
				}
				_previousDocumentSymbolsID = requestID;
				_previousDocumentSymbolsURI = params.textDocument.uri;
				handleDocumentSymbolsResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else if (_workspaceSymbolsLookup.exists(requestID)) {
				var paramsAndCallback = _workspaceSymbolsLookup.get(requestID);
				_workspaceSymbolsLookup.remove(requestID);
				if (_previousWorkspaceSymbolsID > requestID) {
					// we already handled a newer workspace symbol response
					return;
				}
				_previousWorkspaceSymbolsID = requestID;
				handleWorkspaceSymbolsResponse(result, paramsAndCallback.params, paramsAndCallback.callback);
			} else {
				trace("Unknown language server response: " + Json.stringify(object));
			}
		}
	}

	private function getResponseMessageId(message:ResponseMessage):Int {
		var untypedID:Any = message.id;
		if (untypedID == null) {
			return -1;
		}
		if ((untypedID is String)) {
			return Std.parseInt(untypedID);
		}
		return message.id;
	}

	private function parseRequestMessage(object:RequestMessage):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		var found = true;
		var method = object.method;
		switch (method) {
			case METHOD_WORKSPACE__APPLY_EDIT:
				workspace__applyEdit(object);
				sendResponse(object.id, {applied: true});
			case METHOD_CLIENT__REGISTER_CAPABILITY:
				client__registerCapability(object);
				sendResponse(object.id, {});
			case METHOD_CLIENT__UNREGISTER_CAPABILITY:
				client__unregisterCapability(object);
				sendResponse(object.id, {});
			default:
				found = false;
		}
		if (!found) {
			trace("Error: Unknown method requested by language server. Method: " + method);
		}
	}

	private function parseNotificationMessage(object:NotificationMessage):Void {
		if (!_initialized || _stopped || _shutdownID != -1) {
			return;
		}
		var found = true;
		var canHandleNotification = false;
		var method = object.method;
		// NOTE: these are notifications, and they do not require a response
		switch (method) {
			case METHOD_DOLLAR__PROGRESS:
				dollar__progress(object);
				canHandleNotification = true;
			case METHOD_DOLLAR__CANCEL_REQUEST:
				dollar__cancelRequest(object);
				canHandleNotification = true;
			case METHOD_TEXT_DOCUMENT__PUBLISH_DIAGNOSTICS:
				textDocument__publishDiagnostics(object);
				canHandleNotification = true;
			case METHOD_WINDOW__LOG_MESSAGE:
				window__logMessage(object);
				canHandleNotification = true;
			case METHOD_WINDOW__SHOW_MESSAGE:
				window__showMessage(object);
				canHandleNotification = true;
			case METHOD_WINDOW__WORK_DONE_PROGRESS__CREATE:
				window__workDoneProgress__create(object);
				canHandleNotification = true;
			case METHOD_TELEMETRY__EVENT:
				canHandleNotification = true;
			default:
				found = false;
		}
		if (!found || canHandleNotification) {
			found = handleNotification(object) || found;
		}
		if (!found) {
			trace("Error: Unknown method requested by language server. Method: " + method);
		}
	}

	private function handleNotification(object:NotificationMessage):Bool {
		var method = object.method;
		if (!_notificationListeners.exists(method)) {
			return false;
		}
		var listeners = _notificationListeners.get(method);
		var listenerCount = listeners.length;
		if (listenerCount == 0) {
			return false;
		}
		for (listener in listeners) {
			listener(object);
		}
		return true;
	}

	private function handleInitializeResponse(result:Dynamic):Void {
		_serverCapabilities = (result.capabilities : ServerCapabilities);
		supportsCompletion = _serverCapabilities != null
			&& _serverCapabilities.completionProvider != null; // unlike others, this one can't simply be true
		resolveCompletion = supportsCompletion
			&& Reflect.hasField(_serverCapabilities.completionProvider, "resolveProvider")
			&& Reflect.field(_serverCapabilities.completionProvider, "resolveProvider") != null
			&& Reflect.field(_serverCapabilities.completionProvider, "resolveProvider") != false;
		supportsHover = _serverCapabilities != null
			&& _serverCapabilities.hoverProvider != null
			&& _serverCapabilities.hoverProvider != false;
		supportsSignatureHelp = _serverCapabilities != null
			&& _serverCapabilities.signatureHelpProvider != null; // unlike others, this one can't simply be true
		supportsDefinition = _serverCapabilities != null
			&& _serverCapabilities.definitionProvider != null
			&& _serverCapabilities.definitionProvider != false;
		supportsTypeDefinition = _serverCapabilities != null
			&& _serverCapabilities.typeDefinitionProvider != null
			&& _serverCapabilities.typeDefinitionProvider != false;
		supportsImplementation = _serverCapabilities != null
			&& _serverCapabilities.implementationProvider != null
			&& _serverCapabilities.implementationProvider != false;
		supportsReferences = _serverCapabilities != null
			&& _serverCapabilities.referencesProvider != null
			&& _serverCapabilities.referencesProvider != false;
		supportsDocumentSymbols = _serverCapabilities != null
			&& _serverCapabilities.documentSymbolProvider != null
			&& _serverCapabilities.documentSymbolProvider != false;
		supportsWorkspaceSymbols = _serverCapabilities != null
			&& _serverCapabilities.workspaceSymbolProvider != null
			&& _serverCapabilities.workspaceSymbolProvider != false;
		supportsRename = _serverCapabilities != null
			&& _serverCapabilities.renameProvider != null
			&& _serverCapabilities.renameProvider != false;
		supportsCodeAction = _serverCapabilities != null
			&& _serverCapabilities.codeActionProvider != null
			&& _serverCapabilities.codeActionProvider != false;
		supportsCodeLens = _serverCapabilities != null
			&& _serverCapabilities.codeLensProvider != null; // unlike others, this one can't simply be true
		supportedCommands = (_serverCapabilities != null
			&& _serverCapabilities.executeCommandProvider != null
			&& Reflect.hasField(_serverCapabilities.executeCommandProvider,
				"commands")) ? Reflect.field(_serverCapabilities.executeCommandProvider, "commands") : [];
	}

	private function isValidUriScheme(uri:String):Bool {
		var schemeEndIndex = uri.indexOf(":");
		var scheme:String = null;
		if (schemeEndIndex != -1) {
			scheme = uri.substr(0, schemeEndIndex);
		}
		return scheme == URI_SCHEME_FILE || _uriSchemes.indexOf(scheme) != -1;
	}

	private function parseLocationOrLocationLink(result:Any):Any /* Location | LocationLink */ {
		if (Reflect.hasField(result, FIELD_TARGET_URI)) {
			var locationLink = LocationLink.parse(result);
			if (!isValidUriScheme(locationLink.targetUri)) {
				return null;
			}
			return locationLink;
		}
		var location = Location.parse(result);
		if (!isValidUriScheme(location.uri)) {
			return null;
		}
		return location;
	}

	private function parseLocations(result:Any):Array<Any> {
		var locations:Array<Any> = null;

		if ((result is Array)) {
			var resultArray = (result : Array<Any>);
			locations = resultArray.map(jsonLocation -> parseLocationOrLocationLink(jsonLocation)).filter(location -> location != null);
		} else {
			locations = [];
			var location = parseLocationOrLocationLink(result);
			if (location != null) {
				locations.push(location);
			}
		}
		return locations;
	}

	private function handleCompletionItemArrayResponse(result:Any, params:CompletionParams, callback:(Null<CompletionList>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var resultItems = (result : Array<Any>);
		var items = resultItems.map(item -> CompletionItem.parse(item));
		var completionList = new CompletionList(items, false);
		callback(completionList);
	}

	private function handleCompletionListResponse(result:Any, params:CompletionParams, callback:(Null<CompletionList>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var completionList:CompletionList = null;
		if ((result is Array)) {
			var resultItems = (result : Array<Any>);
			var items = resultItems.map(item -> CompletionItem.parse(item));
			completionList = new CompletionList(items, false);
		} else {
			completionList = CompletionList.parse(result);
		}
		callback(completionList);
	}

	private function handleCompletionResolveResponse(result:Any, params:CompletionItem, callback:(CompletionItem) -> Void):Void {
		var resolved = CompletionItem.resolve(params, result);
		callback(resolved);
	}

	private function handleSignatureHelpResponse(result:Any, params:SignatureHelpParams, callback:(Null<SignatureHelp>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var signatureHelp = SignatureHelp.parse(result);
		callback(signatureHelp);
	}

	private function handleHoverResponse(result:Any, params:HoverParams, callback:(Null<Hover>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var hover = Hover.parse(result);
		callback(hover);
	}

	private function handleRenameResponse(result:Any, params:RenameParams, callback:(Null<WorkspaceEdit>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var workspaceEdit = WorkspaceEdit.parse(result);
		callback(workspaceEdit);
	}

	private function handleDefinitionResponse(result:Any, params:DefinitionParams,
			callback:(Null<Array<Any>> /* Array<Location | LocationLink> */) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var locations = parseLocations(result);
		callback(locations);
	}

	private function handleTypeDefinitionResponse(result:Any, params:TypeDefinitionParams,
			callback:(Null<Array<Any>> /* Array<Location | LocationLink> */) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var locations = parseLocations(result);
		callback(locations);
	}

	private function handleImplementationResponse(result:Any, params:ImplementationParams,
			callback:(Null<Array<Any>> /* Array<Location | LocationLink> */) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var locations = parseLocations(result);
		callback(locations);
	}

	private function handleReferencesResponse(result:Any, params:ReferenceParams, callback:(Null<Array<Location>>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var resultArray = (result : Array<Any>);
		var locations = resultArray.map(jsonResult -> Location.parse(jsonResult)).filter(location -> location != null);
		callback(locations);
	}

	private function handleCodeActionResponse(result:Any, params:CodeActionParams, callback:(Null<Array<CodeAction>>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var resultArray = (result : Array<Any>);
		var codeActions = resultArray.map(jsonResult -> {
			if (Reflect.hasField(jsonResult, FIELD_COMMAND)) {
				var jsonCommand = Reflect.field(jsonResult, FIELD_COMMAND);
				if ((jsonCommand is String)) {
					// this is a Command instead of a CodeAction
					// for simplicity, we'll convert it to a CodeAction
					var command = Command.parse(jsonResult);
					var codeAction = new CodeAction();
					codeAction.title = command.title;
					codeAction.command = command;
					return codeAction;
				}
			}
			return CodeAction.parse(jsonResult);
		});
		callback(codeActions);
	}

	private function handleDocumentSymbolsResponse(result:Any, params:DocumentSymbolParams,
			callback:(Null<Array<Any>> /* Array<SymbolInformation | DocumentSymbol> */) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var resultArray = (result : Array<Any>);
		if (resultArray.length == 0) {
			callback(resultArray);
			return;
		}
		var firstItem = resultArray[0];
		if (Reflect.hasField(firstItem, FIELD_LOCATION)) {
			var symbolInformation = resultArray.map(jsonResult -> SymbolInformation.parse(jsonResult));
			callback(cast symbolInformation);
			return;
		}
		var documentSymbols = resultArray.map(jsonResult -> DocumentSymbol.parse(jsonResult));
		callback(cast documentSymbols);
	}

	private function handleWorkspaceSymbolsResponse(result:Any, params:WorkspaceSymbolParams, callback:(Null<Array<SymbolInformation>>) -> Void):Void {
		if (result == null) {
			callback(null);
			return;
		}
		var resultArray = (result : Array<Any>);
		var symbolInformation = resultArray.map(jsonResult -> SymbolInformation.parse(jsonResult));
		callback(symbolInformation);
	}

	private function updateRegisteredCapability(registration:Registration, enable:Bool):Void {
		var method:String = registration.method;
		switch (method) {
			case METHOD_WORKSPACE__SYMBOL:
				supportsWorkspaceSymbols = enable;
			case METHOD_WORKSPACE__EXECUTE_COMMAND:
				if (enable) {
					var registerOptions = registration.registerOptions;
					if (registerOptions != null && Reflect.hasField(registerOptions, "commands")) {
						var commands = Reflect.field(registerOptions, "commands");
						supportedCommands = (commands : Array<String>);
					} else {
						supportedCommands = [];
					}
				} else {
					supportedCommands = [];
				}
			case METHOD_TEXT_DOCUMENT__CODE_ACTION:
				supportsCodeAction = enable;
			case METHOD_TEXT_DOCUMENT__CODE_LENS:
				supportsCodeLens = enable;
			case METHOD_TEXT_DOCUMENT__COMPLETION:
				supportsCompletion = enable;
			case METHOD_TEXT_DOCUMENT__DEFINITION:
				supportsDefinition = enable;
			case METHOD_TEXT_DOCUMENT__TYPE_DEFINITION:
				supportsTypeDefinition = enable;
			case METHOD_TEXT_DOCUMENT__IMPLEMENTATION:
				supportsImplementation = enable;
			case METHOD_TEXT_DOCUMENT__DOCUMENT_SYMBOL:
				supportsDocumentSymbols = enable;
			case METHOD_TEXT_DOCUMENT__HOVER:
				supportsHover = enable;
			case METHOD_TEXT_DOCUMENT__REFERENCES:
				supportsReferences = enable;
			case METHOD_TEXT_DOCUMENT__RENAME:
				supportsRename = enable;
			case METHOD_TEXT_DOCUMENT__SIGNATURE_HELP:
				supportsSignatureHelp = enable;
			default:
				trace("Error: Failed to update language server capability. Unknown method: " + method);
		}
	}

	private function workspace__applyEdit(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : ApplyWorkspaceEditParams);
		var workspaceEdit = WorkspaceEdit.parse(params.edit);
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.APPLY_EDIT, workspaceEdit));
	}

	private function textDocument__publishDiagnostics(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : PublishDiagnosticsParams);
		var uri = params.uri;
		var diagnostics = params.diagnostics.map(jsonResult -> Diagnostic.parse(jsonResult));
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.PUBLISH_DIAGNOSTICS, [uri => diagnostics]));
	}

	private function client__registerCapability(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : RegistrationParams);
		for (registration in params.registrations) {
			updateRegisteredCapability(registration, true);
		}
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.REGISTER_CAPABILITY, params));
	}

	private function client__unregisterCapability(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : RegistrationParams);
		for (registration in params.registrations) {
			updateRegisteredCapability(registration, false);
		}
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.UNREGISTER_CAPABILITY, params));
	}

	private function dollar__progress(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : ProgressParams);
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.PROGRESS, params));
	}

	private function dollar__cancelRequest(jsonObject:Dynamic):Void {
		// notifications that start with $/ may be safely ignored
	}

	private function window__logMessage(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : LogMessageParams);
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.LOG_MESSAGE, params));
	}

	private function window__showMessage(jsonObject:Dynamic):Void {
		var params = (jsonObject.params : ShowMessageParams);
		dispatchEvent(new LspNotificationEvent(LspNotificationEvent.SHOW_MESSAGE, params));
	}

	private function window__workDoneProgress__create(jsonObject:Dynamic):Void {}

	private function languageClient_input_onData(event:Event):Void {
		_socketBuffer += _input.readUTFBytes(_input.bytesAvailable);
		parseMessageBuffer();
	}
}

private class ParamsAndCallback<ParamsType, ResultType> {
	public var params:ParamsType;
	public var callback:(ResultType) -> Void;

	public function new(params:ParamsType, callback:(ResultType) -> Void) {
		this.params = params;
		this.callback = callback;
	}
}
